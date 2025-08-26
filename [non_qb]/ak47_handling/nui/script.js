$(() => {
    let tuningConfig = [];
    let originalConfig = [];

    const $sidebarList = $('#sidebar ul');
    const $tuningContent = $('#tuning-content');

    function createSliderOption(option) {
        const { name, min, max, step, value, description } = option;
        return `
            <div class="mb-4">
                <label for="${name}" class="block text-m font-medium text-gray-300">${name}</label>
                <p class="text-s text-gray-500 mb-2">${description}</p>
                <div class="flex items-center space-x-4">
                    <input type="range" id="${name}-range" data-name="${name}" min="${min}" max="${max}" step="${step}" value="${value}" class="w-full">
                    <input type="number" id="${name}-number" data-name="${name}" min="${min}" max="${max}" step="${step}" value="${value}" class="w-[15rem] bg-gray-700 text-white rounded-md p-2 text-center focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>
            </div>
        `;
    }

    function createVectorOption(option) {
        const { name, value, step, description } = option;
        return `
            <div class="mb-4">
                <label class="block text-m font-medium text-gray-300">${name}</label>
                 <p class="text-s text-gray-500 mb-2">${description}</p>
                <div class="grid grid-cols-3 gap-4">
                    ${['x', 'y', 'z'].map(axis => `
                        <div>
                            <label class="block text-m font-mono text-gray-400">${axis.toUpperCase()}</label>
                            <input type="number" data-name="${name}" data-axis="${axis}" step="${step}" value="${value[axis]}" class="w-full bg-gray-700 text-white rounded-md p-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                        </div>
                    `).join('')}
                </div>
            </div>
        `;
    }

    function renderCategories() {
        $sidebarList.html(tuningConfig.map((categoryData, index) => {
            return `
                <li>
                    <a href="#" data-category="${categoryData.category}" class="flex items-center px-3 py-2 text-gray-300 rounded-md hover:bg-gray-700 transition-colors duration-200 ${index === 0 ? 'bg-blue-600 text-white font-semibold' : ''}">
                        ${categoryData.icon}
                        <span class="capitalize">${categoryData.category}</span>
                    </a>
                </li>
            `;
        }).join(''));
    }

    function renderCategoryContent(categoryKey) {
        const category = tuningConfig.find(c => c.category === categoryKey);
        if (!category) return;
        $tuningContent.html(category.fields.map(field => {
            return field.type === 'vector' ? createVectorOption(field) : createSliderOption(field);
        }).join(''));
    }

    function applyPreset(preset) {
        $.each(preset, (fieldName, fieldValue) => {
            let fieldFound = false;
            $.each(tuningConfig, (index, categoryData) => {
                const targetField = categoryData.fields.find(f => f.name === fieldName);
                if (targetField) {
                    targetField.value = fieldValue;
                    fieldFound = true;
                    return false;
                }
            });
            if (!fieldFound) {
                console.warn(`Preset field "${fieldName}" was not found in the configuration.`);
            }
        });

        const activeCategoryKey = $('#sidebar a.bg-blue-600').data('category');
        renderCategoryContent(activeCategoryKey);
    }

    function toggleTablet(show) {
        if (show) {
            $('#tablet').fadeIn(300);
        } else {
            $('#tablet').fadeOut(300);
        }
    }

    $sidebarList.on('click', 'a', function(e) {
        e.preventDefault();
        const $link = $(this);
        const categoryKey = $link.data('category');

        $('#sidebar a').removeClass('bg-blue-600 text-white font-semibold');
        $link.addClass('bg-blue-600 text-white font-semibold');

        renderCategoryContent(categoryKey);
    });

    // Use 'change' for number inputs, 'input' for range
    $tuningContent.on('change', 'input[type="number"]', function() {
        const $input = $(this);
        const { name, axis } = $input.data();
        const value = parseFloat($input.val());
        const categoryKey = $('#sidebar a.bg-blue-600').data('category');

        const category = tuningConfig.find(c => c.category === categoryKey);
        if(!category) return;
        const field = category.fields.find(f => f.name === name);
        if(!field) return;

        if (axis) {
            field.value[axis] = value;
        } else {
            field.value = value;
            $(`#${name}-range`).val(value); // Sync the range slider
        }

        $.post("https://ak47_handling/oninput", JSON.stringify({field}));
    });

    $tuningContent.on('input', 'input[type="range"]', function() {
        const $input = $(this);
        const name = $input.data('name');
        const value = parseFloat($input.val());

        // Update the number input in real-time
        $(`#${name}-number`).val(value);

        // This part can be debounced if you send updates for range sliders too frequently
        const categoryKey = $('#sidebar a.bg-blue-600').data('category');
        const category = tuningConfig.find(c => c.category === categoryKey);
        if(!category) return;
        const field = category.fields.find(f => f.name === name);
        if(!field) return;
        field.value = value;

        $.post("https://ak47_handling/oninput", JSON.stringify({field}));
    });


    $('#save-btn').on('click', () => {
        let mods = {};
        tuningConfig.forEach(category => {
            category.fields.forEach(field => {
                mods[field.name] = field.value;
            });
        });
        $.post("https://ak47_handling/save", JSON.stringify({mods}));
        toggleTablet(false);
        $.post("https://ak47_handling/close", JSON.stringify({}));
    });

    $('#reset-btn').on('click', () => {
         $.post("https://ak47_handling/reset", JSON.stringify());
    });

    window.addEventListener('message', (event) => {
        const data = event.data;
        switch (data.type) {
            case 'setconf':
                tuningConfig = data.config;
                originalConfig = JSON.parse(JSON.stringify(tuningConfig));
                init();
                break;
            case 'open':
                applyPreset(data.current);
                toggleTablet(true);
                break;
            case 'reset':
                applyPreset(data.mods);
                break;
        }
    });

    function init() {
        if (tuningConfig.length === 0) return;
        renderCategories();
        const firstCategoryKey = tuningConfig[0].category;
        renderCategoryContent(firstCategoryKey);
    }

    $(document).on("keydown", function (event) {
        if (event.keyCode === 27) { // ESC
            toggleTablet(false);
            $.post("https://ak47_handling/close", JSON.stringify({}));
        }
    });

    if (!window.invokeNative) {
        init()
        toggleTablet(true);
    }else {
        $('#tablet').fadeOut(0);
        $.post("https://ak47_handling/loaded", JSON.stringify({}));
    }
});