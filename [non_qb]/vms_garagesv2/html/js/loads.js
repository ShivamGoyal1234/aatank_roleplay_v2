const formatDate = (timestamp) => {
    const date = new Date((Number(timestamp) * 1000));
    let hour = date.getHours();
    let minute = date.getMinutes();
    let day = date.getDate();
    let month = date.getMonth() + 1;
    let year = date.getFullYear();
    if (hour < 10) hour = '0' + hour
    if (minute < 10) minute = '0' + minute
    if (day < 10) day = '0' + day
    if (month < 10) month = '0' + month
    
    return day + '.' + month + '.' + year + ' ' + hour + ':' + minute
}

const ParkingCreator = {
    selectedParkingType: null,
    selectedVehicleType: null,
    vehicleTypes: [],

    OpenMainMenu: function(item) {
        this.selectedParkingType = null;
        this.selectedVehicleType = null;
        this.vehicleTypes = item.vehicleTypes;
        
        $('.parking-creator > .center > div > div').hide();
        
        $('.parking-creator > .center > div > .header > .title').html(translation.creator_menu.main_header);
        $('.parking-creator > .center > div > .header').show();
        
        $('.parking-creator > .center > div > #main-menu > div').removeClass('selected');
        $('.parking-creator > .center > div > #main-menu').show();

        $('.parking-creator').fadeIn(120);
    },

    OpenGarageCreator: function() {
        $('.parking-creator > .center > div > div').hide();

        $('.parking-creator > .center > div > .header > .title').html(translation.creator_menu.arage_menu_header);
        $('.parking-creator > .center > div > .header').show();

        $('.parking-creator > .center > div > #garage-menu').show();

        let vehicleTypesData = ''
        for (const [k, v] of Object.entries(this.vehicleTypes)) vehicleTypesData += `<option value="${v}">${v}</option>`
        $('.parking-creator>.center>div>#garage-menu>.settings>#main-settings-section div[data-name="type"] select').html(vehicleTypesData);

        // $(`.parking-creator > .center > div > #garage-menu > .settings #company-section .tagify`).attr('disabled', true);
        // $(`.parking-creator > .center > div > #garage-menu > .settings #gang-section .tagify`).attr('disabled', true);
        if ($(`.parking-creator > .center > div > #garage-menu > .settings #company-section`).hasClass('active')) {
            $(`.parking-creator > .center > div > #garage-menu > .settings #company-section .tagify`).attr('disabled', true);
        }

        if ($(`.parking-creator > .center > div > #garage-menu > .settings #gang-section`).hasClass('active')) {
            $(`.parking-creator > .center > div > #garage-menu > .settings #gang-section .tagify`).attr('disabled', true);
        }

        $(`.parking-creator > .center > div > #garage-menu > .settings > #predefined-models-section .tagify`).attr('disabled', true);
        $(`.parking-creator > .center > div > #garage-menu > .settings > #garage-allowed-models-section .tagify`).attr('disabled', true);

        $('.parking-creator').fadeIn(120);
    },
    
    OpenParkingCreator: function() {
        $('.parking-creator > .center > div > div').hide();

        $('.parking-creator > .center > div > .header > .title').html(translation.creator_menu.parking_menu_header);
        $('.parking-creator > .center > div > .header').show();

        $('.parking-creator > .center > div > #parking-menu').show();

        let vehicleTypesData = ''
        for (const [k, v] of Object.entries(this.vehicleTypes)) vehicleTypesData += `<option value="${v}" ${v == this.selectedVehicleType ? 'selected' : ''}>${v}</option>`
        $('.parking-creator>.center>div>#parking-menu>.settings>#main-settings-section div[data-name="type"] select').html(vehicleTypesData);

        $(`.parking-creator > .center > div > #parking-menu > .settings > #parkingmeter-section input`).prop('disabled', true);
        $(`.parking-creator > .center > div > #parking-menu > .settings > #rent-section input`).prop('disabled', true);
        $(`.parking-creator > .center > div > #parking-menu > .settings > #rent-section .tagify`).attr('disabled', true);
        $(`.parking-creator > .center > div > #parking-menu > .settings > #npc-section input`).prop('disabled', true);
        
        if ($(`.parking-creator > .center > div > #parking-menu > .settings #company-section`).hasClass('active')) {
            $(`.parking-creator > .center > div > #parking-menu > .settings #company-section .tagify`).attr('disabled', true);
        }

        if ($(`.parking-creator > .center > div > #parking-menu > .settings #gang-section`).hasClass('active')) {
            $(`.parking-creator > .center > div > #parking-menu > .settings #gang-section .tagify`).attr('disabled', true);
        }
        
        
        $(`.parking-creator > .center > div > #parking-menu > .settings > #allowed-models-section .tagify`).attr('disabled', true);

        $('.parking-creator').fadeIn(120);
    },

    OpenHouseGarageCreator: function() {
        $('.parking-creator > .center > div > div').hide();

        $('.parking-creator > .center > div > .header > .title').html(translation.creator_menu.house_garage_menu_header);
        $('.parking-creator > .center > div > .header').show();

        $('.parking-creator > .center > div > #house-garage-menu').show();

        $('.parking-creator').fadeIn(120);
    },

    OpenHouseGarageMenuCreator: function() {
        $('.parking-creator > .center > div > div').hide();

        $('.parking-creator > .center > div > .header > .title').html(translation.creator_menu.house_garage_menu_header);
        $('.parking-creator > .center > div > .header').show();

        $('.parking-creator > .center > div > #house-garage-menu-menu').show();

        let vehicleTypesData = ''
        for (const [k, v] of Object.entries(this.vehicleTypes)) vehicleTypesData += `<option value="${v}">${v}</option>`
        $('.parking-creator>.center>div>#house-garage-menu-menu>.settings>#main-settings-section div[data-name="type"] select').html(vehicleTypesData);

        $('.parking-creator').fadeIn(120);
    },

    OpenGarageInteriorCreator: function() {
        $('.parking-creator > .center > div > div').hide();

        $('.parking-creator > .center > div > .header > .title').html(translation.creator_menu.garage_interior_menu_header);
        $('.parking-creator > .center > div > .header').show();

        $('.parking-creator > .center > div > #garage-interior-menu').show();
        
        let vehicleTypesData = ''
        for (const [k, v] of Object.entries(this.vehicleTypes)) vehicleTypesData += `<option value="${v}">${v}</option>`
        $('.parking-creator>.center>div>#garage-interior-menu>.settings>#main-settings-section div[data-name="type"] select').html(vehicleTypesData);

        $('.parking-creator').fadeIn(120);
    }
}

const BossMenu = {
    loadParkingSpaces: (parkingSpaces) => {
        let parkingData = ''
        for (const [k, v] of Object.entries(parkingSpaces)) {
            if (v && v.data) {
                parkingData = parkingData + `
                    <tr>
                        <td class="table-first">#${Number(k)+1}</td>
                        <td>${v.data.ownerName || translation.bossmenu.main.no_owner_of_parking_space}</td>
                        <td>${v.data.plate || ``}</td>
                        <td>${v.data.parking_date ? formatDate(v.data.parking_date) : ``}</td>
                        <td class="table-last">${v.data.time ? (v.data.time == -1 ? translation.parking_rent.permanent_space : formatDate(v.data.time)) : translation.bossmenu.main.no_rent_date}</td>
                    </tr>
                `
            }
        }
        return parkingData;
    },

    loadSalesHistory: () => {
        // let salesHistoryData = '';
        // for (const [k, v] of Object.entries(historySales)) {
        //     salesHistoryData = salesHistoryData + `
        //         <tr>
        //             <td class="table-first">${v.date}</td>
        //             <td>${v.seller}</td>
        //             <td>${v.buyer}</td>
        //             <td>${v.vehicle}</td>
        //             <td>${v.price}${translation.currency}</td>
        //         </tr>
        //     `
        // }
        // return salesHistoryData;
    },

    loadBalance: (balance) => {
        $('.management-menu div[data-type="main"] div[data-type="balance"] .title').html(`${translation.currency} ${number.format(balance)}`);
    }
}

const loadTowMenu = (plate, impounds, impoundsLabels) => {

    $('.tow-menu .data .plate').html(`
        <input id="plate" value="${plate}" disabled>
    `);
    
    if (typeof impounds == 'string') {
        $('.tow-menu .data .impound').html(`
            <input value="${impounds}" disabled>
        `);
    } else {
        let impoundsList = `
            <select id="impound">
                <option value="">${translation.agreement.select_option}</option>
        `

        for (const [k, v] of Object.entries(impounds)) {
            impoundsList += `<option value="${v}">${impoundsLabels[v]}</option>`
        }

        impoundsList += `</select>`
        
        $('.tow-menu .data .impound').html(impoundsList);
        $('.tow-menu .data .impound > select').select2({
            minimumResultsForSearch: Infinity,
            placeholder: translation.tow.select_impound,
            allowClear: false
        })
    }

    $('.tow-menu .data .fine').html(`
        <textarea rows="3" cols="30"></textarea>
    `);
    
    $('.tow-menu .data .fine-amount').html(`
        <input id="fine-amount" value="0" type="number">
        <div>
            <i class="fa-solid fa-dollar-sign"></i>
        </div>
    `);
}

const loadImpound = (vehicles, requiredJob) => {
    let data = ''

    for (const [id, veh] of Object.entries(vehicles)) {
        data += `
            <div>
                <div class="vehicle" data-id="${Number(id)+1}">
                    <div class="main-data">
                        <div id="label">${veh.label}</div>
                        <div id="plate">${veh.plate}</div>
                    </div>
                </div>
                <div class="informations">
                    <div class="infos">
                        ${veh.impound_data ? `
                            ${veh.impound_data.impounded_by ? `
                                <div>
                                    <span>
                                        <i class="fa-solid fa-user"></i>
                                        ${translation.impound.impounded_by}
                                    </span>
                                    ${veh.impound_data.impounded_by}
                                </div>
                            ` : ``}

                            ${veh.impound_date ? `
                                <div>
                                    <span>
                                        <i class="fa-solid fa-calendar-days"></i>
                                        ${translation.impound.impound_date}
                                    </span>
                                    ${formatDate(veh.impound_date)}
                                </div>
                            ` : ``}

                            ${veh.impound_data.fine_amount ? `
                                <div>
                                    <span>
                                        <i class="fa-solid fa-file-invoice-dollar"></i>
                                        ${translation.impound.fine}
                                    </span>
                                    ${veh.impound_data.fine_title} (${translation.currency}${veh.impound_data.fine_amount})
                                </div>
                            ` : ``}
                        ` : ``}
                    </div>
                    <div class="buttons">
                        ${requiredJob ? `
                            ${(allowJobImpoundsTakeVehWithoutPaying && veh.impound_data && veh.impound_data.fine_amount != null) && `
                                <div id="take-impound" data-plate="${veh.plate}"><i class="fa-solid fa-warehouse"></i> ${translation.impound.take_free}</div>
                                ` || ((!veh.impound_data || veh.impound_data.fine_amount == null) && 
                                `<div id="take-impound" data-plate="${veh.plate}"><i class="fa-solid fa-warehouse"></i> ${translation.impound.take_free}</div>`
                            || ``)}
                            
                            ${veh.impound_data && veh.impound_data.fine_amount && `
                                <div id="give-impound-bill" data-plate="${veh.plate}"><i class="fa-solid fa-receipt"></i> ${translation.impound.give_bill}</div>
                            ` || ``}
                        ` : `
                            ${!veh.netid && `
                                <div id="pay-for-impound" data-payment="cash" data-plate="${veh.plate}"><i class="fa-solid fa-money-bill"></i> ${(translation.impound.pay_cash).format(translation.currency, veh.price)}</div>
                                <div id="pay-for-impound" data-payment="bank" data-plate="${veh.plate}"><i class="fa-solid fa-credit-card"></i> ${(translation.impound.pay_bank).format(translation.currency, veh.price)}</div>    
                            ` || `
                                ${impoundLocator ? 
                                    `${priceOfLocation >= 1 ? `
                                        <div id="locate" data-payment="cash" data-plate="${veh.plate}"><i class="fa-solid fa-location-dot"></i> ${(translation.impound.locate_by_cash).format(translation.currency, priceOfLocation)}</div>
                                        <div id="locate" data-payment="bank" data-plate="${veh.plate}"><i class="fa-solid fa-location-dot"></i> ${(translation.impound.locate_by_bank).format(translation.currency, priceOfLocation)}</div>
                                    `: `
                                        <div id="locate" data-plate="${veh.plate}"><i class="fa-solid fa-location-dot"></i> ${translation.impound.locate}</div>
                                    `}`
                                : ``}
                            ` || ``}
                        `}
                    </div>
                </div>
            </div>
        `
    }
    
    $('.garage > .center > .menu > .header > #manage').hide();
    
    $('.garage .menu > .data').html(data);
}

const loadGarage = (vehicles, jobGrades, isJobGarage, isHousing) => {
    $('.garage .menu > .data').html('');
    let isPredefinedGarage = false;
    let data = ''
    for (const [id, veh] of Object.entries(vehicles)) {
        if (veh.plate || veh.model) {
            if (veh.model) isPredefinedGarage = true;
            if (!veh.model || veh.model && veh.hasAccess) {
                data += `
                    <div>
                        <div class="vehicle" data-id="${typeof(Number(id)) == 'number' && Number(id) != NaN && Number(id)+1 || id}">
                            <div class="main-data">
                                <div id="label">${veh.label}</div>
                                ${veh.plate ? `<div id="plate">${veh.plate}</div>` : ``}
                            </div>
                        </div>
                        <div class="informations">
                            <div class="infos">
        
                            </div>
                            <div class="buttons">
                                ${!isHousing && !isJobGarage && allowTransferBetweenGarages && veh.plate && `
                                    <div id="transfer" onclick="garageTransfer('${veh.plate}', '${veh.garage}')"><i class="fa-solid fa-shuffle"></i> ${translation.garage.transfer}</div>
                                ` || ``}
                                ${(currentGarage == veh.garage || veh.model) ? `
                                    <div id="take-out" ${veh.plate ? `data-plate="${veh.plate}"` : `data-model="${veh.model}"`}><i class="fa-solid fa-warehouse"></i> ${translation.garage.take_out}</div>
                                ` : ``}
                            </div>
                        </div>
                    </div>
                `
            } 
        }
    }
    $('.garage .menu > .data').html(data);

    if (jobGrades != undefined) {
        garageJobGrades = jobGrades;
        $('.garage > .center > .menu > .header > #manage').show();
    } else {
        $('.garage > .center > .menu > .header > #manage').hide();
    }

    if (isPredefinedGarage) $('.garage > .center > .menu > .header > #manage').hide();
}

const garageTransfer = (plate, vehGarage) => {
    let transferData = '';
    
    let currentType = transfersGaragesList[currentGarage].type
    for (const [k, v] of Object.entries(transfersGaragesList)) {
        if (currentType == v.type) {
            let isCurrentGarage = k == vehGarage
            transferData += `
                <div>
                    <div>${v.label}</div>
                    <div data-garage="${k}" data-plate="${plate}" class="check ${isCurrentGarage ? `checked` : ``}"></div>
                </div>
                <hr>
            `
        }
    }
    
    $('.garage > .center > .menu-transfer > .data').html(transferData);

    $('.garage .menu').hide();
    $('.garage .menu-transfer').show();
    $('.garage .menu-manage').hide();
    $('.garage .menu-manage-vehicles').hide();
    $('.garage .menu-manage-transfer-vehicles').hide();
    $('.garage .menu-locate-vehicles').hide();
}

const loadGarageManage = (employeesList) => {
    employees = employeesList

    let citizensData = '';
    for (const [k, v] of Object.entries(employeesList)) {
        citizensData += `
            <div>
                <div>${v}</div>
                <div data-playerid="${k}" data-playername="${v}" class="check"></div>
            </div>
            <hr>
        `
    }

    let gradesData = '';
    for (const [k, v] of Object.entries(garageJobGrades)) {
        gradesData += `
            <div>
                <div>${v.label}</div>
                <div data-gradeid="${k}" class="check"></div>
            </div>
            <hr>
        `
    }

    let vehiclesData = ''
    if (vehiclesToOrder) {
        for (const [k, v] of Object.entries(vehiclesToOrder)) {
            vehiclesData += `
                <div>
                    <div>${v.label} (${translation.currency}${v.price})</div>
                    <div data-model="${v.model}" class="check"></div>
                </div>
            `
        }
    }
    
    $('.garage>.center>.menu-manage>.management>.owner>.citizens').html(citizensData);
    $('.garage>.center>.menu-manage>.management>.owner>.job-grades').html(gradesData);
    $('.garage>.center>.menu-manage>.management>.vehicles').html(vehiclesData);
    
    $('.garage>.center>.menu-manage-transfer-vehicles>.data>.owner>.citizens').html(citizensData);
    $('.garage>.center>.menu-manage-transfer-vehicles>.data>.owner>.job-grades').html(gradesData);
}

const loadGarageVehiclesManage = (vehiclesList) => {
    let data = ''
    for (const [id, veh] of Object.entries(vehiclesList)) {
        data += `
            <div>
                <div class="vehicle" data-plate="${veh.plate}">
                    <div class="main-data">
                        <div id="label">${veh.label}</div>
                        <div id="plate">${veh.plate}</div>
                    </div>
                </div>
                <div class="informations">
                    <div class="infos">
                        ${veh.playerName && `
                            <div>
                                <span>
                                    <i class="fa-solid fa-user"></i>
                                    ${translation.garage.management.info_employee_vehicle}
                                </span>
                                ${veh.playerName || 'UNKNOWN'}
                            </div>
                        ` || !veh[veh.ownerColumnName] && veh.grade && veh.grade.label && `
                            <div>
                                <span>
                                    <i class="fa-solid fa-user"></i>
                                    ${translation.garage.management.info_grade_vehicle}
                                </span>
                                ${veh.grade.label || 'UNKNOWN'}
                            </div>
                        ` || !veh[veh.ownerColumnName] && !veh.grade && `
                            <div>
                                <span>
                                    <i class="fa-solid fa-users"></i>
                                    ${translation.garage.management.info_eech_employee_vehicle}
                                </span>
                            </div>
                        ` || ``}
                    </div>
                    <div class="buttons">
                        <div
                            id="manage-transfer"
                            data-plate="${veh.plate}"
                            ${veh[veh.ownerColumnName] ? `data-player="${veh[veh.ownerColumnName]}"` : ``}
                            ${!veh[veh.ownerColumnName] && veh.grade && `data-grade="${veh.grade.id}"` || ``}
                        ><i class="fa-solid fa-shuffle"></i> ${translation.garage.transfer}</div>
                        <div id="take-out" data-plate="${veh.plate}"><i class="fa-solid fa-warehouse"></i> ${translation.garage.take_out}</div>
                    </div>
                </div>
            </div>
        `
    }
    $('.garage .menu-manage-vehicles > .data').html(data);
}


const openAgreement = (data) => {
    let isSeller = data.type == "seller"

    const dateNow = new Date();
    let timestamp = (dateNow.getTime() / 1000);
    currentDate = formatDate(timestamp)

    $(".agreement #give_invoice").css({
        "z-index": -500,
        "opacity": 0.0
    });

    if (isSeller) {
        const closestPlayersData = [];
        const licensePlatesData = [];
        const paymentMethodsData = [];

        $(".agreement .card .signatures .seller #give_invoice").text(translation.agreement.give_contract_btn);

        $(".agreement #signature_seller").text("");
        $(".agreement #signature_buyer").text("");
        
        $(".agreement #make_signature_seller").show();
        $(".agreement #make_signature_buyer").hide();

        let playersList = `<select id="select-buyer" name="select-buyer" style="width: 8em;">`
        closestPlayersData.push({
            id: 0,
            text: translation.agreement.select_option,
            disabled: true,
            selected: true
        })
        
        if (data.companies) {
            closestPlayersData.push(
                {
                    "id": 1,
                    "text": translation.agreement.companies_group,
                    "children": [
                        {
                            "id": data.companies.name,
                            "text": data.companies.label,
                            "name": data.companies.name
                        }
                    ]
                }
            )
        }

        closestPlayersData.push(
            {
                "id": 2,
                "text": translation.agreement.citizens_group,
                "children": []
            }
        )

        let closestPlayersID = closestPlayersData[2] && 2 || 1
            
        for (const [k, v] of Object.entries(data.players)) {
            closestPlayersData[closestPlayersID].children.push(
                {
                    "id": v,
                    "text": (translation.agreement.citizen).format(v)
                }
            )
        };

        playersList += `</select>`

        let licensePlate = `
            <select id="select-vehicle" name="select-vehicle" onchange="agreementChangedVehicle(this)" style="width: 8em;">
        `
        licensePlatesData.push({
            id: 0,
            text: translation.agreement.select_option,
            disabled: true,
            selected: true
        })
        for (const [k, v] of Object.entries(data.myVehiclesList)) {
            licensePlatesData.push({
                id: k,
                text: v.plate,
                type: v.type
            })
        };
        licensePlate += `</select>`
        

        $(".agreement .card .paragraph_text_1").html(`
            ${(translation.agreement.paragraph_1_text).format(playersList, `<span id="dots">...........</span>`, licensePlate)}
        `);
        
        $(".agreement .card .paragraph_text_2").html(`
            ${(translation.agreement.paragraph_2_text).format(`<span id="dots">...........</span>`, `<span id="dots">...........</span>`)}
        `);

        let paymentMethod = `
            <select id="select-payment-method" name="select-payment-method" style="width: 9em;">
        `
        paymentMethodsData.push({
            id: 0,
            text: translation.agreement.select_option,
            disabled: true,
            selected: true
        })
        if (agreementPaymentMethods) {
            (agreementPaymentMethods).forEach(element => {
                paymentMethodsData.push({
                    id: element,
                    text: translation.agreement[element],
                    paymentmethod: element
                })
            });
        }
        paymentMethod += `</select>`
        $(".agreement .card .paragraph_text_3").html(`
            ${(translation.agreement.paragraph_3_text).format(`<input id="sell-price-input" type="number" style="width: 10em">`, translation.currency, paymentMethod)}
            ${translation.agreement.paragraph_3_text_2}
        `);
        
        $('#select-buyer').select2({
            minimumResultsForSearch: Infinity,
            allowClear: false,
            data: closestPlayersData
            // data: 
        });

        $('#select-vehicle').select2({
            allowClear: false,
            data: licensePlatesData
        });

        $('#select-payment-method').select2({
            minimumResultsForSearch: Infinity,
            allowClear: false,
            data: paymentMethodsData
        });
    } else {

        $(".agreement #make_signature_seller").hide();
        $(".agreement #make_signature_buyer").show();

        $(".agreement #signature_seller").text(data.data.resellData.sellerName)
        $(".agreement #signature_buyer").text("");

        $(".agreement .card .paragraph_text_1").html(`
            ${(translation.agreement.paragraph_1_text).format(playerName, data.data.resellData.vehicleType, data.data.resellData.vehiclePlate)}
        `);
        
        $(".agreement .card .paragraph_text_2").html(`
            ${(translation.agreement.paragraph_2_text).format(data.data.resellData.vehicleType, data.data.resellData.vehicleType)}
        `);
        
        $(".agreement .card .paragraph_text_3").html(`
            ${(translation.agreement.paragraph_3_text).format(data.data.resellData.price, translation.currency, data.data.resellData.paymentMethod)}
            ${translation.agreement.paragraph_3_text_2}
        `);
    }

    $(".agreement .card #date > div").text(`${isSeller ? currentDate : data.data.resellData.date} - ${translation.agreement.town}`);

    $(".agreement").fadeIn(120);
}

const openResell = (data) => {
    let isSeller = data.type == "seller"
    
    const dateNow = new Date();
    let timestamp = (dateNow.getTime() / 1000);
    currentDate = formatDate(timestamp)

    
    $(".resell #give_invoice").css({
        "z-index": -500,
        "opacity": 0.0
    });

    if (isSeller) {
        const closestPlayersData = [];

        $(".resell .card #title").html((translation.resell.title).format(garageCfg.label));
        $(".resell .card #date").text((translation.resell.date).format(currentDate));
        
        $(".resell .card #seller").html((translation.resell.seller).format(playerName));

        $(".resell .card #buyer").html((translation.resell.buyer).format(`<select id="select-buyer-resell" name="select-buyer" style="width: 8em;"></select>`, translation.currency, `<input id="resell-price-input" type="number" style="width: 10em">`));

        closestPlayersData.push({
            id: 0,
            text: translation.agreement.select_option,
            disabled: true,
            selected: true
        })

        closestPlayersData.push(
            {
                "id": 1,
                "text": translation.agreement.citizens_group,
                "children": []
            }
        )

        for (const [k, v] of Object.entries(data.players)) {
            closestPlayersData[1].children.push(
                {
                    "id": v,
                    "text": (translation.agreement.citizen).format(v)
                }
            )
        };

        
        $('#select-buyer-resell').select2({
            minimumResultsForSearch: Infinity,
            allowClear: false,
            data: closestPlayersData
        });

        $(".resell .card ol li#first").html((translation.resell.contract_first_point).format(garageCfg.label));
        $(".resell .card ol li#second").html((translation.resell.contract_second_point).format(garageCfg.label));

        $(".resell .card .signatures .seller #give_invoice").text(translation.resell.give_contract_btn);

        $(".resell .card .signatures .seller .signature-text").text(translation.resell.seller_signature);
        $(".resell .card .signatures .buyer .signature-text").text(translation.resell.buyer_signature);

        $(".resell #resell_signature_seller").text("");
        $(".resell #resell_signature_buyer").text("");
        
        $(".resell #resell_make_signature_seller").show();
        $(".resell #resell_make_signature_buyer").hide();
    } else {
        let resellData = data.resellData;

        $(".resell .card #title").html((translation.resell.title).format(resellData.label));
        $(".resell .card #date").text((translation.resell.date).format(resellData.date));
        
        $(".resell .card #seller").html((translation.resell.seller).format(resellData.sellerName));
        $(".resell .card #buyer").html((translation.resell.buyer).format(playerName, translation.currency, resellData.price));

        $(".resell .card ol li#first").html((translation.resell.contract_first_point).format(resellData.label));
        $(".resell .card ol li#second").html((translation.resell.contract_second_point).format(resellData.label));

        $(".resell .card .signatures .seller .signature-text").text(translation.resell.seller_signature);
        $(".resell .card .signatures .buyer .signature-text").text(translation.resell.buyer_signature); 
        
        $(".resell #resell_signature_seller").text(resellData.sellerName)
        $(".resell #resell_signature_buyer").text("");
        
        $(".resell #resell_make_signature_seller").hide();
        $(".resell #resell_make_signature_buyer").show();
    }

    $(".management-menu").hide();
    $(".resell").show();
}