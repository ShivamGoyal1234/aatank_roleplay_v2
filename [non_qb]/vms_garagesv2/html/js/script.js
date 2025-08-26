let translation = {};

var number = Intl.NumberFormat('en-US', { minimumFractionDigits: 0 });
String.prototype.format = function () {
    var formatted = this;
    for (var i = 0; i < arguments.length; i++) {
        var regexp = new RegExp('\\{' + i + '\\}', 'gi');
        formatted = formatted.replace(regexp, arguments[i]);
    }
    return formatted;
};

// Main Variables:
let vehicleTypes = [];

// Rent Space Variables:
let selectedDays = null;
let rentPrice = 0;
let rentPriceForInfinity = 0;

// Impound Variables:
let allowJobImpoundsTakeVehWithoutPaying = null;

// Garage Variables:
let garageJobGrades = null;
let vehiclesToOrder = [];
let allowTransferBetweenGarages = false;
let transferBetweenGaragesPrice = false;
let currentGarage = null;
let transfersGaragesList = null;

// Garage Management Variables:
let employees = [];

// Agreement Variables:
let agreementPaymentMethods = [];
let selectedVehicleType = null;
let currentDate = null;
let playerName = null;

// Locator Variables:
let impoundLocator = false;
let priceOfLocation = 0;

// Management Variables:
let garageData = {};
let garageCfg = {};

// UI Variables:
let canSelectNewVehicle = true;
let canPressAgain = true;
let currentMenu = null;
let currentSubMenu = null;
let managementMenu = null;
var isMenuOpened = false;
let selectedOption = null;


var rentDaysInput = document.querySelector('input[name="rent-days"]');
var rentDaysTags = new Tagify(rentDaysInput);

var companyJobsInput = document.querySelector('input[name="company-jobs"]');
var companyJobsTags = new Tagify(companyJobsInput);

var gangJobsInput = document.querySelector('input[name="gang-jobs"]');
var gangJobsTags = new Tagify(gangJobsInput);

var allowedModelsInput = document.querySelector('input[name="allowed-models"]');
var allowedModelsTags = new Tagify(allowedModelsInput);

var companyInput = document.querySelector('input[name="company"]');
var companyTags = new Tagify(companyInput);

var gangInput = document.querySelector('input[name="gang"]');
var gangTags = new Tagify(gangInput);

var predefinedModelsInput = document.querySelector('input[name="predefined-models"]');
var predefinedModelsTags = new Tagify(predefinedModelsInput);

var garageAllowedModelsInput = document.querySelector('input[name="garage-allowed-models"]');
var garageAllowedModelsTags = new Tagify(garageAllowedModelsInput);


window.addEventListener("load", function () {
    $.post(`https://${GetParentResourceName()}/loaded`)
})

window.addEventListener('message', function (event) {
    var item = event.data;
    if (item.action == "loaded") {
        let lang = item.lang;

        agreementPaymentMethods = item.agreementPaymentMethods;

        impoundLocator = item.impoundLocator;
        priceOfLocation = item.priceOfLocation;

        vehicleTypes = item.vehicleTypes;

        sellPercentage = item.sellPercentage;

        allowJobImpoundsTakeVehWithoutPaying = item.allowJobImpoundsTakeVehWithoutPaying;

        allowTransferBetweenGarages = item.allowTransferBetweenGarages;
        transferBetweenGaragesPrice = item.transferBetweenGaragesPrice;

        $.ajax({
            url: '../config/translation.json',
            type: 'GET',
            dataType: 'json',
            success: function (code, statut) {
                if (!code[lang]) {
                    translation = code["EN"];
                    console.warn(`^7Selected language ^1"${lang}"^7 not found, changed to ^2"EN"^7, configure your language in translation.json.`);
                } else {
                    translation = code[lang];
                }

                // Purchase Business Translation:
                $('.buy-business .header-name span').text(translation.buy_business.header);

                let purchaseMenuData = `<span>${translation.buy_business.important_infos}</span>`;
                for (const [key, value] of Object.entries(config.purchaseInformations)) {
                    purchaseMenuData += `
                        <div>
                            <span>${value.title}</span>
                            <div>${value.description}</div>
                        </div>
                    `
                }
                $('.buy-business .info-business > .informations').html(purchaseMenuData);


                // Management Translation:
                $('.management-menu .side-bar div[data-href="main"] .title').text(translation.bossmenu.sidebar.main_title);
                $('.management-menu .side-bar div[data-href="main"] .description').text(translation.bossmenu.sidebar.main_description);

                // Main:
                $('.management-menu div[data-type="main"] div[data-type="balance"] .header').text(translation.bossmenu.main.menu_balance_header);
                $('.management-menu div[data-type="main"] div[data-type="balance"] div[data-option="withdraw"] p').text(translation.bossmenu.main.menu_balance_btn_withdraw);
                $('.management-menu div[data-type="main"] div[data-type="balance"] div[data-option="deposit"] p').text(translation.bossmenu.main.menu_balance_btn_deposit);

                $('.management-menu div[data-type="main"] div[data-type="total-earned"] .header').text(translation.bossmenu.main.menu_total_earned_header);
                $('.management-menu div[data-type="main"] div[data-type="prices"] .header').text(translation.bossmenu.main.menu_prices_header);
                $('.management-menu div[data-type="main"] div[data-type="prices"] .price-per-day>div>div').text(translation.bossmenu.main.update_price)
                $('.management-menu div[data-type="main"] div[data-type="prices"] .price-for-infinity>div>div').text(translation.bossmenu.main.update_price)
                
                $('.management-menu div[data-type="main"] div[data-type="free-spaces"] .header').text(translation.bossmenu.main.menu_free_parking_spaces_header);
                $('.management-menu div[data-type="main"] div[data-type="occupied-spaces"] .header').text(translation.bossmenu.main.menu_occupied_parking_spaces_header);

                $('.management-menu div[data-type="main"] .parking-spaces-list .header').text(translation.bossmenu.main.menu_parking_spaces_header);
                $('.management-menu div[data-type="main"] .parking-spaces-list .title').text(translation.bossmenu.main.menu_parking_spaces_title);

                $('.management-menu div[data-type="main"] .parking-spaces-list #parking-spaces-table > thead > tr > th #parking_id').text(translation.bossmenu.main.table_parking_id);
                $('.management-menu div[data-type="main"] .parking-spaces-list #parking-spaces-table > thead > tr > th #owner').text(translation.bossmenu.main.table_owner);
                $('.management-menu div[data-type="main"] .parking-spaces-list #parking-spaces-table > thead > tr > th #vehicle').text(translation.bossmenu.main.table_vehicle);
                $('.management-menu div[data-type="main"] .parking-spaces-list #parking-spaces-table > thead > tr > th #parking_date').text(translation.bossmenu.main.table_parking_date);
                $('.management-menu div[data-type="main"] .parking-spaces-list #parking-spaces-table > thead > tr > th #rent_end_date').text(translation.bossmenu.main.table_rent_end_date);

                $('.management-menu div[data-type="main"] div[data-type="sell"] .header').text(translation.bossmenu.main.menu_sell_header);
                $('.management-menu div[data-type="main"] div[data-type="sell"] .title').text(translation.bossmenu.main.menu_sell_title);
                $('.management-menu div[data-type="main"] div[data-type="resell"] .header').text(translation.bossmenu.main.menu_resell_header);
                $('.management-menu div[data-type="main"] div[data-type="resell"] .title').text(translation.bossmenu.main.menu_resell_title);
                $('.management-menu div[data-type="main"] div[data-type="resell"] .btn > p').text(translation.bossmenu.main.menu_resell_btn);

                // Pay Station:
                $('.paystation > .center > .menu > .header > .title').text(translation.paystation.title);
                $('.paystation > .center > .menu > .data > .license-plate > .text').text(translation.paystation.provide_license_plate)
                $('.paystation > .center > .menu > .data > .find-by-plate').text(translation.paystation.find_vehicle);

                $('.paystation > .center > .parking-ticket .data > #title').text(translation.paystation.ticket.title)
                $('.paystation > .center > .menu > .data > .description > .cost').html(`${translation.paystation.parking_cost} <div></div>`);

                $('.paystation > .center > .parking-ticket .buttons > .pay_cash').text(translation.paystation.ticket.pay_cash);
                $('.paystation > .center > .parking-ticket .buttons > .pay_bank').text(translation.paystation.ticket.pay_bank);
                $('.paystation > .center > .parking-ticket .buttons > .cancel').text(translation.paystation.ticket.cancel);


                // Parking Rent:
                $('.parking-rent > .center > .menu > .header > .title').text(translation.parking_rent.title);

                $('.parking-rent .menu > #yours').text(translation.parking_rent.bar_yours)
                $('.parking-rent .menu > #rented').text(translation.parking_rent.bar_rented)
                $('.parking-rent .menu > #free').text(translation.parking_rent.bar_free)

                $('.parking-rent .menu > .data > .description > .cost').html(`${translation.parking_rent.parking_cost} <div></div>`);
                $('.parking-rent .menu > .data > .rent-data > .name').html(translation.parking_rent.select_time_title);
                $('.parking-rent .menu > .data > .rent-data > .description').html(translation.parking_rent.select_time_description);
                $('.parking-rent .menu > .data > .description > .name > #space').html(`${translation.parking_rent.selected_space} <span id="current"></span>/<span id="max"></span>`);

                $('.parking-rent .menu > .data > .rent-data.your-space-info > .name').text(translation.parking_rent.notice_period)


                // Agreement:
                $(".agreement .card #title").text(translation.agreement.title);
                $(".agreement .card #date > p").text(translation.agreement.date);
                $(".agreement .card .signatures .seller .signature-text").text(translation.agreement.seller_signature);
                $(".agreement .card .signatures .buyer .signature-text").text(translation.agreement.buyer_signature);


                // Garages:
                $('.garage > .center > .menu > .header > #manage > span').text(translation.garage.manage_btn);

                $('.garage > .center > .menu-transfer > .header > .title').text(translation.garage.transfer);
                $('.garage > .center > .menu-transfer > #transfer-vehicle').text(transferBetweenGaragesPrice >= 1 ? (translation.garage.transfer_for).format(translation.currency, transferBetweenGaragesPrice) : translation.garage.transfer);

                $('.garage > .center > .menu-manage > .header > .title').text(translation.garage.manage_btn);
                $('.garage > .center > .menu-manage > .management > .owner-title').text(translation.garage.management.select_owners);
                $('.garage > .center > .menu-manage > .management > .vehicles-title').text(translation.garage.management.select_vehicle);
                $('.garage > .center > .menu-manage > .management > #buy-vehicle').text(translation.garage.management.buy_vehicle);

                $('.garage > .center > .menu-manage > .header > #manage-vehicles > span').text(translation.garage.management.manage_vehicles_btn);
                $('.garage > .center > .menu-manage-vehicles > .header > .title').text(translation.garage.management.manage_vehicles_btn);

                $('.garage > .center > .menu-manage-transfer-vehicles > .data > .owner-title').text(translation.garage.management.select_owners);
                $('.garage > .center > .menu-manage-transfer-vehicles > .data > #transfer-company-vehicle').text(translation.garage.management_transfer.transfer_btn);

                $('.garage > .center > .menu > .header > #locate-vehicles > span').text(translation.impound.locate_by_plate_btn);
                $('.garage > .center > .menu-locate-vehicles > .header > .title').text(translation.impound.locate_by_plate.title);
                $('.garage > .center > .menu-locate-vehicles > .data > #locate-vehicle').text(translation.impound.locate_by_plate.locate_btn);

                // Tow Menu:
                $('.tow-menu .menu > .header > .title').text(translation.tow.title)
                $('.tow-menu .menu > .data > .plate-title').text(translation.tow.plate_label)
                $('.tow-menu .menu > .data > .impound-title').text(translation.tow.impound_label)
                $('.tow-menu .menu > .data > .fine-title').text(translation.tow.fine_label)
                $('.tow-menu .menu > .data > .fine-amount-title').text(translation.tow.fine_amount_label)
                $('.tow-menu > .center .menu .submit-tow').text(translation.tow.submit_tow)



                $('.parking-creator #main-menu > div[data-type="house_garage"] > .info > span').html(translation.creator_menu.label_house_garage);
                $('.parking-creator #main-menu > div[data-type="house_garage_menu"] > .info > span').html(translation.creator_menu.label_house_garage_menu);
                $('.parking-creator #main-menu > div[data-type="garage"] > .info > span').html(translation.creator_menu.label_garage);
                $('.parking-creator #main-menu > div[data-type="garage_interior"] > .info > span').html(translation.creator_menu.label_garage_interior);
                $('.parking-creator #main-menu > div[data-type="parking"] > .info > span').html(translation.creator_menu.label_parking);
                $('.parking-creator #main-menu > div.button > p').html(translation.creator_menu.next_btn);

                $('.parking-creator #house-garage-menu > .settings > .routingbucket-label > span.label').html(translation.creator_menu.routing_bucket.section_routingbucket);
                $('.parking-creator #house-garage-menu > .settings > #routingbucket-section > div[data-name="routingbucket"] > p').html(translation.creator_menu.routing_bucket.title_routingbucket);
                $('.parking-creator #house-garage-menu > .settings > #routingbucket-section > div[data-name="routingbucket"] .help > div').html(translation.creator_menu.routing_bucket.help_routingbucket);
                $('.parking-creator #house-garage-menu > .settings > #routingbucket-section > div[data-name="routingbucket"] > span').html(translation.creator_menu.routing_bucket.description_routingbucket);

                $('.parking-creator #garage-interior-menu > .settings > .main-settings-label > span.label').html(translation.creator_menu.main_settings.section_title);
                $('.parking-creator #garage-interior-menu > .settings > #main-settings-section > div[data-name="label"] > p').html(translation.creator_menu.main_settings.title_label);
                $('.parking-creator #garage-interior-menu > .settings > #main-settings-section > div[data-name="label"] > span').html(translation.creator_menu.main_settings.description_label);
                $('.parking-creator #garage-interior-menu > .settings > #main-settings-section > div[data-name="type"] > p').html(translation.creator_menu.main_settings.title_type);
                $('.parking-creator #garage-interior-menu > .settings > #main-settings-section > div[data-name="type"] > span').html(translation.creator_menu.main_settings.description_type);

                $('.parking-creator #garage-interior-menu > .settings > .routingbucket-label > span.label').html(translation.creator_menu.routing_bucket.section_routingbucket);
                $('.parking-creator #garage-interior-menu > .settings > #routingbucket-section > div[data-name="routingbucket"] > p').html(translation.creator_menu.routing_bucket.title_routingbucket);
                $('.parking-creator #garage-interior-menu > .settings > #routingbucket-section > div[data-name="routingbucket"] .help > div').html(translation.creator_menu.routing_bucket.help_routingbucket);
                $('.parking-creator #garage-interior-menu > .settings > #routingbucket-section > div[data-name="routingbucket"] > span').html(translation.creator_menu.routing_bucket.description_routingbucket);

                $('.parking-creator #garage-menu > .settings > .main-settings-label > span.label').html(translation.creator_menu.main_settings.section_title);
                $('.parking-creator #garage-menu > .settings > #main-settings-section > div[data-name="label"] > p').html(translation.creator_menu.main_settings.title_label);
                $('.parking-creator #garage-menu > .settings > #main-settings-section > div[data-name="label"] > span').html(translation.creator_menu.main_settings.description_label);
                $('.parking-creator #garage-menu > .settings > #main-settings-section > div[data-name="type"] > p').html(translation.creator_menu.main_settings.title_type);
                $('.parking-creator #garage-menu > .settings > #main-settings-section > div[data-name="type"] > span').html(translation.creator_menu.main_settings.description_type);
                $('.parking-creator #garage-menu > .settings > #main-settings-section > div[data-name="menu-point"] > p').html(translation.creator_menu.main_settings.title_menu_point);
                $('.parking-creator #garage-menu > .settings > #main-settings-section > div[data-name="menu-point"] > span').html(translation.creator_menu.main_settings.description_menu_point);
                $('.parking-creator #garage-menu > .settings > #main-settings-section > div[data-name="menu-point"] > div').html(translation.creator_menu.main_settings.button_menu_point);
                
                $('.parking-creator #garage-menu > .settings > .garage-settings-label > span.label').html(translation.creator_menu.garage_settings.section_title);
                $('.parking-creator #garage-menu > .settings > #garage-settings-section > div[data-name="ped-coords"] > p').html(translation.creator_menu.garage_settings.title_ped_coords);
                $('.parking-creator #garage-menu > .settings > #garage-settings-section > div[data-name="ped-coords"] > span').html(translation.creator_menu.garage_settings.description_ped_coords);
                $('.parking-creator #garage-menu > .settings > #garage-settings-section > div[data-name="ped-coords"] > div').html(translation.creator_menu.garage_settings.button_ped_coords);
                $('.parking-creator #garage-menu > .settings > #garage-settings-section > div[data-name="vehicle-coords"] > p').html(translation.creator_menu.garage_settings.title_vehicle_coords);
                $('.parking-creator #garage-menu > .settings > #garage-settings-section > div[data-name="vehicle-coords"] > span').html(translation.creator_menu.garage_settings.description_vehicle_coords);
                $('.parking-creator #garage-menu > .settings > #garage-settings-section > div[data-name="vehicle-coords"] > div').html(translation.creator_menu.garage_settings.button_vehicle_coords);
                $('.parking-creator #garage-menu > .settings > #garage-settings-section > div[data-name="camera-coords"] > p').html(translation.creator_menu.garage_settings.title_camera_coords);
                $('.parking-creator #garage-menu > .settings > #garage-settings-section > div[data-name="camera-coords"] > span').html(translation.creator_menu.garage_settings.description_camera_coords);
                $('.parking-creator #garage-menu > .settings > #garage-settings-section > div[data-name="camera-coords"] > div').html(translation.creator_menu.garage_settings.button_camera_coords);
                
                $('.parking-creator #garage-menu > .settings > #garage2-settings-section > div[data-name="spawnpoint"] > p').html(translation.creator_menu.garage2_settings.title_spawn_point);
                $('.parking-creator #garage-menu > .settings > #garage2-settings-section > div[data-name="spawnpoint"] > span').html(translation.creator_menu.garage2_settings.description_spawn_point);
                $('.parking-creator #garage-menu > .settings > #garage2-settings-section > div[data-name="spawnpoint"] > div').html(translation.creator_menu.garage2_settings.button_spawn_point);
                $('.parking-creator #garage-menu > .settings > #garage2-settings-section > div[data-name="returnpoint"] > p').html(translation.creator_menu.garage2_settings.title_return_point);
                $('.parking-creator #garage-menu > .settings > #garage2-settings-section > div[data-name="returnpoint"] > span').html(translation.creator_menu.garage2_settings.description_return_point);
                $('.parking-creator #garage-menu > .settings > #garage2-settings-section > div[data-name="returnpoint"] > div').html(translation.creator_menu.garage2_settings.button_return_point);

                $('.parking-creator #garage-menu > .settings > .check-area-occupied-settings-label > span.label').html(translation.creator_menu.check_area_occupied_settings.section_title);

                
                
                
                
                
                $('.parking-creator #house-garage-menu-menu > .settings > .main-settings-label > span.label').html(translation.creator_menu.main_settings.section_title);
                $('.parking-creator #house-garage-menu-menu > .settings > #main-settings-section > div[data-name="label"] > p').html(translation.creator_menu.main_settings.title_label);
                $('.parking-creator #house-garage-menu-menu > .settings > #main-settings-section > div[data-name="label"] > span').html(translation.creator_menu.main_settings.description_label);
                $('.parking-creator #house-garage-menu-menu > .settings > #main-settings-section > div[data-name="type"] > p').html(translation.creator_menu.main_settings.title_type);
                $('.parking-creator #house-garage-menu-menu > .settings > #main-settings-section > div[data-name="type"] > span').html(translation.creator_menu.main_settings.description_type);
                $('.parking-creator #house-garage-menu-menu > .settings > #main-settings-section > #vehicles-limit-section .vehicles-limit-section-label > span.label').html(translation.creator_menu.main_settings.title_vehicles_limit);
                $('.parking-creator #house-garage-menu-menu > .settings > #main-settings-section > #vehicles-limit-section > div > span').html(translation.creator_menu.main_settings.description_vehicles_limit);

                $('.parking-creator #house-garage-menu-menu > .settings > .garage-settings-label > span.label').html(translation.creator_menu.garage_settings.section_title);
                $('.parking-creator #house-garage-menu-menu > .settings > #garage-settings-section > div[data-name="ped-coords-house-menu"] > p').html(translation.creator_menu.garage_settings.title_ped_coords);
                $('.parking-creator #house-garage-menu-menu > .settings > #garage-settings-section > div[data-name="ped-coords-house-menu"] > span').html(translation.creator_menu.garage_settings.description_ped_coords);
                $('.parking-creator #house-garage-menu-menu > .settings > #garage-settings-section > div[data-name="ped-coords-house-menu"] > div').html(translation.creator_menu.garage_settings.button_ped_coords);
                $('.parking-creator #house-garage-menu-menu > .settings > #garage-settings-section > div[data-name="vehicle-coords-house-menu"] > p').html(translation.creator_menu.garage_settings.title_vehicle_coords);
                $('.parking-creator #house-garage-menu-menu > .settings > #garage-settings-section > div[data-name="vehicle-coords-house-menu"] > span').html(translation.creator_menu.garage_settings.description_vehicle_coords);
                $('.parking-creator #house-garage-menu-menu > .settings > #garage-settings-section > div[data-name="vehicle-coords-house-menu"] > div').html(translation.creator_menu.garage_settings.button_vehicle_coords);
                $('.parking-creator #house-garage-menu-menu > .settings > #garage-settings-section > div[data-name="camera-coords-house-menu"] > p').html(translation.creator_menu.garage_settings.title_camera_coords);
                $('.parking-creator #house-garage-menu-menu > .settings > #garage-settings-section > div[data-name="camera-coords-house-menu"] > span').html(translation.creator_menu.garage_settings.description_camera_coords);
                $('.parking-creator #house-garage-menu-menu > .settings > #garage-settings-section > div[data-name="camera-coords-house-menu"] > div').html(translation.creator_menu.garage_settings.button_camera_coords);
                
                $('.parking-creator #house-garage-menu-menu > .settings > .check-area-occupied-settings-label > span.label').html(translation.creator_menu.check_area_occupied_settings.section_title);
                
                





                $('.parking-creator #parking-menu > .settings > .main-settings-label > span.label').html(translation.creator_menu.main_settings.section_title);
                $('.parking-creator #parking-menu > .settings > #main-settings-section > div[data-name="label"] > p').html(translation.creator_menu.main_settings.title_label);
                $('.parking-creator #parking-menu > .settings > #main-settings-section > div[data-name="label"] > span').html(translation.creator_menu.main_settings.description_label);
                $('.parking-creator #parking-menu > .settings > #main-settings-section > div[data-name="type"] > p').html(translation.creator_menu.main_settings.title_type);
                $('.parking-creator #parking-menu > .settings > #main-settings-section > div[data-name="type"] > span').html(translation.creator_menu.main_settings.description_type);
                $('.parking-creator #parking-menu > .settings > #main-settings-section > div[data-name="spaces"] > p').html(translation.creator_menu.main_settings.title_spaces);
                $('.parking-creator #parking-menu > .settings > #main-settings-section > div[data-name="spaces"] > span').html(translation.creator_menu.main_settings.description_spaces);
                $('.parking-creator #parking-menu > .settings > #main-settings-section > div[data-name="spaces"] > div').html(translation.creator_menu.main_settings.button_spaces);

                $('.parking-creator #parking-menu > .settings > .parkingmeter-section-label > span.label').html(translation.creator_menu.parkingmeter.section_title);
                $('.parking-creator #parking-menu > .settings > #parkingmeter-section > div[data-name="price"] > p').html(translation.creator_menu.parkingmeter.title_price);
                $('.parking-creator #parking-menu > .settings > #parkingmeter-section > div[data-name="price"] > span').html(translation.creator_menu.parkingmeter.description_price);
                $('.parking-creator #parking-menu > .settings > #parkingmeter-section > div[data-name="paystations"] > p').html(translation.creator_menu.parkingmeter.title_paystations);
                $('.parking-creator #parking-menu > .settings > #parkingmeter-section > div[data-name="paystations"] > span').html(translation.creator_menu.parkingmeter.description_paystations);
                $('.parking-creator #parking-menu > .settings > #parkingmeter-section > div[data-name="paystations"] > div').html(translation.creator_menu.parkingmeter.button_paystations);
                
                $('.parking-creator #parking-menu > .settings > .rent-section-label > span.label').html(translation.creator_menu.rent.section_title);
                $('.parking-creator #parking-menu > .settings > #rent-section > div[data-name="price"] > p').html(translation.creator_menu.rent.title_price);
                $('.parking-creator #parking-menu > .settings > #rent-section > div[data-name="price"] > span').html(translation.creator_menu.rent.description_price);
                $('.parking-creator #parking-menu > .settings > #rent-section > div[data-name="days"] > p').html(translation.creator_menu.rent.title_days);
                $('.parking-creator #parking-menu > .settings > #rent-section > div[data-name="days"] > span').html(translation.creator_menu.rent.description_days);
                $('.parking-creator #parking-menu > .settings > #rent-section > div[data-name="point"] > p').html(translation.creator_menu.rent.title_coords);
                $('.parking-creator #parking-menu > .settings > #rent-section > div[data-name="point"] > span').html(translation.creator_menu.rent.description_coords);
                $('.parking-creator #parking-menu > .settings > #rent-section > div[data-name="point"] > div').html(translation.creator_menu.rent.button_coords);

                $('.parking-creator #parking-menu > .settings > .npc-section-label > span.label').html(translation.creator_menu.npc.section_title);
                $('.parking-creator #parking-menu > .settings > #npc-section > div[data-name="npc-model"] > p').html(translation.creator_menu.npc.title_model);
                $('.parking-creator #parking-menu > .settings > #npc-section > div[data-name="npc-model"] > span').html(translation.creator_menu.npc.description_model);
                $('.parking-creator #parking-menu > .settings > #npc-section > div[data-name="npc-animation"] > p').html(translation.creator_menu.npc.title_animation);
                $('.parking-creator #parking-menu > .settings > #npc-section > div[data-name="npc-animation"] > label.anim-dict-label').html(translation.creator_menu.npc.label_anim_dict);
                $('.parking-creator #parking-menu > .settings > #npc-section > div[data-name="npc-animation"] > label.anim-name-label').html(translation.creator_menu.npc.label_anim_name);
                $('.parking-creator #parking-menu > .settings > #npc-section > div[data-name="npc-coords"] > p').html(translation.creator_menu.npc.title_coords);
                $('.parking-creator #parking-menu > .settings > #npc-section > div[data-name="npc-coords"] > span').html(translation.creator_menu.npc.description_coords);
                $('.parking-creator #parking-menu > .settings > #npc-section > div[data-name="npc-coords"] > div').html(translation.creator_menu.npc.button_coords);
                
                $('.parking-creator #parking-menu > .settings .company-section-label > span.label').html(translation.creator_menu.company.section_title);
                $('.parking-creator #parking-menu > .settings #company-section > div > .help > div').html(translation.creator_menu.company.help_company);

                $('.parking-creator #parking-menu > .settings .gang-section-label > span.label').html(translation.creator_menu.gang.section_title);
                $('.parking-creator #parking-menu > .settings #gang-section > div > .help > div').html(translation.creator_menu.gang.help_gang);

                $('.parking-creator #parking-menu > .settings > .allowed-models-section-label > span.label').html(translation.creator_menu.allowed.section_title);
                $('.parking-creator #parking-menu > .settings > #allowed-models-section > div > p').html(translation.creator_menu.allowed.title_models);
                $('.parking-creator #parking-menu > .settings > #allowed-models-section > div > span').html(translation.creator_menu.allowed.description_models);
                
                $('.parking-creator #garage-menu > .settings .company-section-label > span.label').html(translation.creator_menu.company.section_title);
                $('.parking-creator #garage-menu > .settings #company-section > div > .help > div').html(translation.creator_menu.company.help_company);

                $('.parking-creator #garage-menu > .settings .gang-section-label > span.label').html(translation.creator_menu.gang.section_title);
                $('.parking-creator #garage-menu > .settings #gang-section > div > .help > div').html(translation.creator_menu.gang.help_gang);
                
                $('.parking-creator #garage-menu > .settings > #predefined-models-section > div > p').html(translation.creator_menu.predefined.title_models);
                $('.parking-creator #garage-menu > .settings > #predefined-models-section > div > span').html(translation.creator_menu.predefined.description_models);
                
                $('.parking-creator #garage-menu > .settings > #garage-allowed-models-section > div > p').html(translation.creator_menu.allowed.title_models);
                $('.parking-creator #garage-menu > .settings > #garage-allowed-models-section > div > span').html(translation.creator_menu.allowed.description_models);


                $(`
                    .parking-creator #parking-menu > .save > p,
                    .parking-creator #house-garage-menu > .save > p,
                    .parking-creator #house-garage-menu-menu > .save > p,
                    .parking-creator #garage-interior-menu > .save > p,
                    .parking-creator #garage-menu > .save > p
                `).html(translation.creator_menu.save_btn);
            }
        });
    }

    if (item.action == "clearUI") {
        if (currentMenu == 'garage') {
            $.post(`https://${GetParentResourceName()}/removeViewVehicle`);
            $('.garage > .center > .menu-manage > .management .vehicles .check').removeClass('checked');
            $('.garage > .center > .menu-manage > .management .owner .check').removeClass('checked');
            manageSelectedModel = null;
            manageSelectedPlayer = null;
            manageSelectedGrade = null;

        }
    }

    if (item.action == "openPayStation") {
        isMenuOpened = true;
        currentMenu = 'payStation';

        $('.paystation .menu .data > .license-plate > .plate > input.license-plate').val('');
        $('.paystation > .center > .menu > .data > .description > .name').text(item.label);
        $('.paystation > .center > .menu > .data > .description > .cost > div').html(`${translation.currency}${item.pricePerHour}.00`);
        $('.paystation .parking-ticket > .header > span').text(item.label);
        $('.paystation > .center > .menu').show();

        $('.paystation').fadeIn(120);
        $('body').fadeIn(150);

    } else if (item.action == "closePayStation") {
        $('.paystation').fadeOut(120);
        $('.paystation > .center > .menu').fadeOut(120);
        $('.paystation .parking-ticket').fadeOut(120);
        isMenuOpened = false;
        currentMenu = null;
    }

    if (item.action == "openParkingTicket") {
        isMenuOpened = true;
        currentMenu = 'parkingTicket';

        let licensePlate = item.licensePlate;
        let hoursCount = item.hoursCount;
        let price = item.price;

        let timestamp = item.timestamp * 1000;
        let parkingDate = new Date(timestamp);
        let dateString = parkingDate.toLocaleDateString(config.timeZone);
        let timeString = parkingDate.toLocaleTimeString(config.timeZone);

        let currentTimestamp = item.currentTime * 1000;
        let currentDate = new Date(currentTimestamp);
        let currentDateString = currentDate.toLocaleDateString(config.timeZone);
        let currentTimeString = currentDate.toLocaleTimeString(config.timeZone);

        $('.paystation > .center > .parking-ticket .data > #date').html(`${translation.paystation.ticket.date} <span>${currentDateString}</span>`);
        $('.paystation > .center > .parking-ticket .data > #vehicle').html(`${(translation.paystation.ticket.vehicle).format('"' + licensePlate + '"')}`);
        $('.paystation > .center > .parking-ticket .data > #hours').html(`${(translation.paystation.ticket.hours).format(hoursCount)}`);
        $('.paystation > .center > .parking-ticket .data > #from').html(`${translation.paystation.ticket.from} <span>${dateString}<span>${timeString}</span><span>`);
        $('.paystation > .center > .parking-ticket .data > #to').html(`${translation.paystation.ticket.to} <span>${currentDateString}<span>${currentTimeString}</span><span>`);
        $('.paystation > .center > .parking-ticket .data > #to-paid').text(`${translation.paystation.ticket.to_paid} : ${translation.currency}${price}.00`);

        $('.paystation > .center > .menu').hide();
        $('.paystation > .center > .parking-ticket').show();

    }

    if (item.action == "openParkingRent") {
        isMenuOpened = true;
        currentMenu = 'parkingRent';
        selectedDays = null;

        rentPrice = item.pricePerDay;
        rentPriceForInfinity = item.priceForInfinity;
        rentDays = item.rentDays;

        $('.parking-rent .menu > .data > .description > .name > #label').html(item.garageLabel);
        $('.parking-rent .menu > .data > .description > .cost > div').html(`${translation.currency}${rentPrice}.00`);

        $('.parking-rent>.center>.menu>#rented').hide();
        $('.parking-rent>.center>.menu>#yours').hide();
        $('.parking-rent>.center>.menu>#free').hide();

        let daysElements = ''
        if (rentDays) {
            (rentDays).forEach(function (key) {
                daysElements += `<div id="rent-day-pick" data-days="${key}">${key == 1 && (translation.parking_rent.day_to_select).format(key) || key == -1 && translation.parking_rent.permanent_space || (translation.parking_rent.days_to_select).format(key)}</div>`
            });
        }
        $('.parking-rent .menu > .data > .rent-data > .rent-days').html(daysElements);

        if (!item.isMySpace && item.isRented) $('.parking-rent>.center>.menu>#rented').show();
        if (item.isMySpace && item.isRented) {
            $('.parking-rent>.center>.menu>#yours').show();
            $('.parking-rent .menu').addClass('your-space-info');
            if (item.rentTime) {
                if (item.rentTime == -1) {
                    $('.parking-rent .menu > .data > .rent-data.your-space-info > .description').html(translation.parking_rent.permanent_space);
                } else {
                    $('.parking-rent .menu > .data > .rent-data.your-space-info > .description').text(formatDate(item.rentTime));
                }
            }
        }
        if (!item.isMySpace && !item.isRented) $('.parking-rent>.center>.menu>#free').show();

        $('.parking-rent .menu > .data > .description > .name > #space > span#current').html(item.parkingId);
        $('.parking-rent .menu > .data > .description > .name > #space > span#max').html(item.maxParkingSpaces);


        $('.parking-rent .menu > .data .buttons > #rent').html(translation.parking_rent.select_days);
        $('.parking-rent').fadeIn(350);

    } else if (item.action == "updateParkingRent") {
        if (item.changedPrice) {
            if (item.pricePerDay != undefined) {
                rentPrice = item.pricePerDay;
                $('.parking-rent .menu > .data > .description > .cost > div').html(`${translation.currency}${rentPrice}.00`);
            }

            if (item.priceForInfinity != undefined) rentPriceForInfinity = item.priceForInfinity;
            
            if (selectedDays) {
                let daysCount = $(selectedDays).data('days');
                if (daysCount == -1) {
                    $('.parking-rent .menu > .data > .buttons > #rent').html((translation.parking_rent.rent_for).format(translation.currency, rentPriceForInfinity));
                } else if (daysCount != null && daysCount >= 1) {
                    $('.parking-rent .menu > .data > .buttons > #rent').html((translation.parking_rent.rent_for).format(translation.currency, Number(daysCount) * rentPrice));
                }
            }
            return;
        }
        
        if (!item.isMySpace && item.isRented) {
            $('.parking-rent>.center>.menu>#rented').fadeIn(265);
            $('.parking-rent>.center>.menu>#yours').fadeOut(265);
            $('.parking-rent>.center>.menu>#free').fadeOut(265);

            $('.parking-rent .menu').removeClass('your-space-info');
        }
        if (item.isMySpace && item.isRented) {
            $('.parking-rent>.center>.menu>#rented').fadeOut(265);
            $('.parking-rent>.center>.menu>#yours').fadeIn(265);
            $('.parking-rent>.center>.menu>#free').fadeOut(265);

            $('.parking-rent .menu').addClass('your-space-info');
            if (item.rentTime) {
                if (item.rentTime == -1) {
                    $('.parking-rent .menu > .data > .rent-data.your-space-info > .description').html(translation.parking_rent.permanent_space);
                } else {
                    $('.parking-rent .menu > .data > .rent-data.your-space-info > .description').text(formatDate(item.rentTime));
                }
            }
        }
        if (!item.isMySpace && !item.isRented) {
            $('.parking-rent>.center>.menu>#rented').fadeOut(265);
            $('.parking-rent>.center>.menu>#yours').fadeOut(265);
            $('.parking-rent>.center>.menu>#free').fadeIn(265);

            $('.parking-rent .menu').removeClass('your-space-info');
        }

        $('.parking-rent .menu > .data > .description > .name > #space > span#current').html(item.parkingId);

    } else if (item.action == "closeParkingRent") {
        $('.parking-rent').fadeOut(350);
        selectedDays = null;
        rentPrice = 0;
        isMenuOpened = false;
        currentMenu = null;
    }

    if (item.action == "openAgreement") {
        isMenuOpened = true;
        currentMenu = 'agreement';
        playerName = item.characterName;
        openAgreement(item);
    } else if (item.action == "closeAgreement") {
        $('.agreement').fadeOut(120);
        isMenuOpened = false;
        currentMenu = null;
    }

    if (item.action == "openImpound") {
        isMenuOpened = true;
        currentMenu = 'impound';

        $('.garage > .center > .menu > .header > .tag').html(translation.impound.tag);
        $('.garage > .center > .menu > .header > .title').html(item.impoundLabel);

        loadImpound(item.vehiclesList, item.requiredJob);

        $('.garage .menu').show();
        $('.garage .menu-transfer').hide();
        $('.garage .menu-manage').hide();
        $('.garage .menu-manage-vehicles').hide();
        $('.garage .menu-manage-transfer-vehicles').hide();
        $('.garage .menu-locate-vehicles').hide();

        if (item.allowLocateByPlate) {
            $('.garage > .center > .menu > .header > #locate-vehicles').show();
        } else {
            $('.garage > .center > .menu > .header > #locate-vehicles').hide();
        }

        $('.garage').fadeIn(120);
    } else if (item.action == "closeImpound") {
        $('.garage').fadeOut(120);
        isMenuOpened = false;
        currentMenu = null;
    }

    if (item.action == "openGarage") {
        isMenuOpened = true;
        currentMenu = 'garage';

        manageSelectedModel = null;
        manageSelectedPlayer = null;
        manageSelectedGrade = null;
        
        $('.garage > .center > .menu > .header > .tag').html(item.isGangGarage && translation.garage.tag_gang_garage || item.isJobGarage && translation.garage.tag_job_garage || translation.garage.tag_garage);
        $('.garage > .center > .menu > .header > .title').html(item.garageLabel);

        currentGarage = item.currentGarage;
        transfersGaragesList = item.transfersGaragesList;

        loadGarage(item.vehiclesList, item.jobGrades, item.isJobGarage, item.isHousing);

        vehiclesToOrder = item.vehiclesToOrder;

        $('.garage .menu').show();
        $('.garage .menu-transfer').hide();
        $('.garage .menu-manage').hide();
        $('.garage .menu-manage-vehicles').hide();
        $('.garage .menu-manage-transfer-vehicles').hide();
        $('.garage .menu-locate-vehicles').hide();

        $('.garage > .center > .menu > .header > #locate-vehicles').hide();

        $('.garage').fadeIn(120);
    } else if (item.action == "closeGarage") {
        $('.garage').fadeOut(120);
        isMenuOpened = false;
        currentMenu = null;
    }

    if (item.action == "openPurchaseMenu") {
        isMenuOpened = true;
        currentMenu = 'purchase';
        $('.buy-business').show(120);
        $('.buy-business .info-business > .name').html(`${translation.buy_business.name} <span>${item.label}</span>`);
        $('.buy-business .info-business > .parking_spaces').html(`${translation.buy_business.parking_spaces} <span>${item.parking_spaces}</span>`);
        $('.buy-business .info-business > .price').html(`${translation.buy_business.price} <span>${translation.currency}${number.format(item.price)}</span>`);
        $('.buy-business .purchase-business > span').text(`${translation.buy_business.buy_btn} ${translation.currency}${number.format(item.price)}`);

    } else if (item.action == "closePurchaseMenu") {
        $('.buy-business').hide(120)
        isMenuOpened = false;
        currentMenu = null;
    }

    if (item.action == "openManagementMenu") {
        playerName = item.playerName;
        garageCfg = item.garageCfg
        garageData = item.garageData

        if (!garageCfg.allowedChangePricePerDay && !garageCfg.allowedChangePriceForInfinity) {
            $('.management-menu').addClass('noPricesManagement')
        } else {
            $('.management-menu').removeClass('noPricesManagement')
        }
        
        // Main Menu - loader:
        $('.management-menu .header .store-name').html(`${translation.bossmenu.title} <span>${garageCfg.label}</span>`);

        // Total Earned - loader:
        $('.management-menu div[data-type="main"] div[data-type="total-earned"] .title').html(`${translation.currency} ${number.format(garageData.data.totalEarned)}`)
        
        // Prices - loader:
        $('.management-menu div[data-type="main"] div[data-type="prices"] .price-per-day').hide();
        if (garageCfg.allowedChangePricePerDay) {
            $('.management-menu div[data-type="main"] div[data-type="prices"] .price-per-day > label').html(`${translation.bossmenu.main.price_per_day_label} <span>${(translation.bossmenu.main.prices_recommended).format(translation.currency, number.format(garageCfg.pricePerDay))}</span>`)
            $('.management-menu div[data-type="main"] div[data-type="prices"] .price-per-day input').val(garageData.data.pricePerDay || garageCfg.pricePerDay);
            $('.management-menu div[data-type="main"] div[data-type="prices"] .price-per-day').show();
        }
        $('.management-menu div[data-type="main"] div[data-type="prices"] .price-for-infinity').hide();
        if (garageCfg.allowedChangePriceForInfinity) {
            $('.management-menu div[data-type="main"] div[data-type="prices"] .price-for-infinity > label').html(`${translation.bossmenu.main.price_for_infinity_label} <span>${(translation.bossmenu.main.prices_recommended).format(translation.currency, number.format(garageCfg.priceForInfinity))}</span>`)
            $('.management-menu div[data-type="main"] div[data-type="prices"] .price-for-infinity input').val(garageData.data.priceForInfinity || garageCfg.priceForInfinity);
            $('.management-menu div[data-type="main"] div[data-type="prices"] .price-for-infinity').show();
        }

        // Free Parking Spaces - loader:
        $('.management-menu div[data-type="main"] div[data-type="free-spaces"] .title').html(`${item.freeParkingSpaces}`)

        // Occupied Parking Spaces - loader:
        $('.management-menu div[data-type="main"] div[data-type="occupied-spaces"] .title').html(`${item.occupiedParkingSpaces}`)

        // Parking Spaces - Loader:
        let parkingSpaces = BossMenu.loadParkingSpaces(garageCfg.parkingSpaces);
        $('.management-menu div[data-type="main"] .parking-spaces-list tbody').html(parkingSpaces)

        // Balance - loader:
        BossMenu.loadBalance(garageData.data.balance);

        // Sell price - loader:
        $('.management-menu div[data-type="main"] div[data-type="sell"] .btn > p').text((translation.bossmenu.main.menu_sell_btn).format(number.format((sellPercentage / 100) * garageCfg.purchasePrice), translation.currency))

        currentMenu = 'management';
        updateManagement('main', `.management-menu .side-bar div[data-href="main"]`)
        $('.management-menu').fadeIn(120);

    } else if (item.action == "closeManagementMenu") {
        $('.management-menu').fadeOut(120);
        $(`div[data-type="main"]`).fadeOut(120);
        $(`div[data-type="history-sales"]`).fadeOut(120);
        $('.btn[data-option="deposit"]').show();
        $('.btn[data-option="withdraw"]').show();
        $('input[data-input="withdraw"]').val('').hide();
        $('input[data-input="deposit"]').val('').hide();
        $('.box[data-type="balance"] .close-balance').removeClass('isAnyVal').removeClass('isVisible');
        $('.box[data-type="balance"] .close-balance > i').removeClass('fa-check').addClass('fa-close');
        $('.resell').fadeOut(120);
        managementMenu = null;
        isMenuOpened = false;
        currentMenu = null;

    } else if (item.action == "updateManagementMenu") {
        if (currentMenu && managementMenu) {
            if (item.garageData) {
                garageData = item.garageData
                BossMenu.loadBalance(garageData.data.balance);
            }
        }
    }

    if (item.action == "openResell") {
        isMenuOpened = true;
        currentMenu = 'resell';
        playerName = item.characterName;
        openResell(item);
    } else if (item.action == "closeResell") {
        $('.resell').fadeOut(120);
        isMenuOpened = false;
        currentMenu = null;
    }

    if (item.action == "openTowMenu") {
        isMenuOpened = true;
        currentMenu = 'tow';

        loadTowMenu(item.vehiclePlate, item.impounds, item.impoundsLabels)

        $('.tow-menu').fadeIn(120);
    } else if (item.action == "closeTowMenu") {
        $('.tow-menu').fadeOut(120);
        isMenuOpened = false;
        currentMenu = null;
    }

    if (item.action == "openReceipt") {
        currentMenu = 'receipt';
        isMenuOpened = true;

        $('.receipt > .receipt-texts > .header-label').text(translation.impound.bill.title)

        $('.receipt > .receipt-texts > .list').html(`
            ${item.billData.plate ? `
                <div class="plate">
                    <div>${translation.impound.bill.plate}</div>
                    <div>
                        <span>${item.billData.plate}</span>
                    </div>
                </div>    
            ` : ``}
            ${item.billData.impoundedBy ? `
                <div class="impounded_by">
                    <div>${translation.impound.bill.impounded_by}</div>
                    <div>
                        <span>${item.billData.impoundedBy}</span>
                    </div>
                </div>    
            ` : ``}
            ${item.billData.fineTitle ? `
                <div class="fine">
                    <div>${translation.impound.bill.fine_title}</div>
                    <span>${item.billData.fineTitle}</span>
                </div>    
            ` : ``}
        `)

        $('.receipt > .receipt-texts .total > div:first-child').text(translation.impound.bill.total)
        $('.receipt > .receipt-texts .total > div:nth-child(2)').html(`<span>${translation.currency}${item.billData.fineAmount}</span>`)
        $('.receipt > .receipt-texts .pay_cash').text(translation.impound.bill.pay_cash)
        $('.receipt > .receipt-texts .pay_bank').text(translation.impound.bill.pay_bank)
        $('.receipt > .receipt-texts .cancel').text(translation.impound.bill.cancel)

        $('.receipt').fadeIn(120);
    } else if (item.action == "closeReceipt") {
        $('.receipt').fadeOut(120);
        isMenuOpened = false;
        currentMenu = null;
    }

    if (item.action == "openParkingCreator") {
        if (item.menu == "main") {
            ParkingCreator.OpenMainMenu(item)
        } else if (item.menu == "parking-menu") {
            ParkingCreator.OpenParkingCreator()
        } else if (item.menu == "house-garage-menu") {
            ParkingCreator.OpenHouseGarageCreator()
        } else if (item.menu == "house-garage-menu-menu") {
            ParkingCreator.OpenHouseGarageMenuCreator()
        } else if (item.menu == "garage-interior-menu") {
            ParkingCreator.OpenGarageInteriorCreator()
        } else if (item.menu == "garage-menu") {
            ParkingCreator.OpenGarageCreator()
        } else if (!item.menu) {
            if (ParkingCreator.selectedParkingType) {
                ParkingCreator.OpenParkingCreator()
            }
        }
    } else if (item.action == "hideParkingCreator") {
        $('.parking-creator').fadeOut(120);

    } else if (item.action == "closeParkingCreator") {
        $('.parking-creator').fadeOut(120);
        $.post(`https://${GetParentResourceName()}/closed`);

    }
});

$(".back").click(() => {
    if (currentSubMenu) {
        if (currentSubMenu == "management-transfer-vehicles") {
            $('.garage .menu').hide();
            $('.garage .menu-transfer').hide();
            $('.garage .menu-manage').show();
            $('.garage .menu-manage-vehicles').hide();
            $('.garage .menu-manage-transfer-vehicles').hide();
            $('.garage .menu-locate-vehicles').hide();
            $.post(`https://${GetParentResourceName()}/removeViewVehicle`, JSON.stringify({ clearCompany: true }));
            currentSubMenu = null;
            return;
        }
        if (currentSubMenu == "management-vehicles") {
            $('.garage .menu').hide();
            $('.garage .menu-transfer').hide();
            $('.garage .menu-manage').show();
            $('.garage .menu-manage-vehicles').hide();
            $('.garage .menu-manage-transfer-vehicles').hide();
            $('.garage .menu-locate-vehicles').hide();
            $.post(`https://${GetParentResourceName()}/removeViewVehicle`, JSON.stringify({ clearCompany: true }));
            currentSubMenu = null;
            return;
        }
        if (currentSubMenu == 'impound-locate-vehicles') {
            $('.garage .menu').show();
            $('.garage .menu-transfer').hide();
            $('.garage .menu-manage').hide();
            $('.garage .menu-manage-vehicles').hide();
            $('.garage .menu-manage-transfer-vehicles').hide();
            $('.garage .menu-locate-vehicles').hide();
            currentSubMenu = null;
        }
    }

    if (currentMenu == 'garage') {
        $('.garage .menu').show();
        $('.garage .menu-transfer').hide();
        $('.garage .menu-manage').hide();
        $('.garage .menu-manage-vehicles').hide();
        $('.garage .menu-locate-vehicles').hide();
        $.post(`https://${GetParentResourceName()}/removeViewVehicle`);
    }
})

$(".close").click(() => {
    $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({ menu: currentMenu }));
    isMenuOpened = false;
    currentMenu = null;
    currentSubMenu = null;
})


findVehicle = () => {
    if (canPressAgain) {
        canPressAgain = false;
        let licensePlate = $('.paystation .menu .data > .license-plate > .plate > input.license-plate').val();
        $.post(`https://${GetParentResourceName()}/findVehicle`, JSON.stringify({ licensePlate: licensePlate }));
        setTimeout(() => {
            canPressAgain = true;
        }, 500);
    }
}
$(".paystation .data > .find-by-plate").click(() => {
    findVehicle();
})

payStation = (type) => {
    if (!type) {
        $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({ menu: currentMenu }));
    } else {
        $.post(`https://${GetParentResourceName()}/payStation`, JSON.stringify({ type: type }));
    }
}

$('input.license-plate').on('input', function () {
    $(this).val($(this).val().replace(/[^a-z0-9 ]/gi, ''));
});

$('.garage>.center>.menu-locate-vehicles>.data>#locate-vehicle').click(() => {
    let plate = $('.garage>.center>.menu-locate-vehicles>.data>.plate>input.license-plate').val();
    if (!plate) return;

    $.post(`https://${GetParentResourceName()}/locateVehicle`, JSON.stringify({
        vehPlate: plate,
        isByLocationMenu: true
    }));

})

$('.tow-menu > .center > .menu .submit-tow').click(() => {
    let impound = null

    const element = document.getElementById('impound');
    if (element) {
        impound = $('#impound').select2('data');
        if (!impound || !impound[0] || !impound[0].id) return;
        impound = impound[0].id
    } else {
        impound = $('.tow-menu .data .impound > input').val();
        if (!impound) return;
    }

    let fine = $('.tow-menu .data .fine > textarea').val();
    let fine_amount = $('.tow-menu .data #fine-amount').val();

    $.post(`https://${GetParentResourceName()}/tow`, JSON.stringify({
        impound: impound,
        fine: fine,
        fine_amount: fine_amount,
    }));

})

$('.garage > .center > .menu > .header > #manage').click(() => {
    if (!garageJobGrades) return;

    manageSelectedModel = null;
    manageSelectedPlayer = null;
    manageSelectedGrade = null;
    $.post(`https://${GetParentResourceName()}/getEmployees`, JSON.stringify({}), function (employees) {
        $.post(`https://${GetParentResourceName()}/removeViewVehicle`);
        $('.garage .menu').hide();
        $('.garage .menu-transfer').hide();
        $('.garage .menu-manage').show();
        $('.garage .menu-manage-vehicles').hide();
        $('.garage .menu-locate-vehicles').hide();
        loadGarageManage(employees)
    });

});

$('.garage > .center > .menu > .header > #locate-vehicles').click(() => {
    currentSubMenu = 'impound-locate-vehicles';
    $('.garage .menu').hide();
    $('.garage .menu-locate-vehicles').show();
});

$('.garage > .center > .menu-manage > .header > #manage-vehicles').click(() => {
    $.post(`https://${GetParentResourceName()}/getCompanyVehicles`, JSON.stringify({}), function (vehiclesList) {
        currentSubMenu = "management-vehicles";

        manageSelectedModel = null;
        manageSelectedPlayer = null;
        manageSelectedGrade = null;

        $('.garage > .center > .menu-manage > .management .vehicles .check').removeClass('checked');
        $('.garage > .center > .menu-manage > .management .owner .check').removeClass('checked');

        $('.garage .menu').hide();
        $('.garage .menu-transfer').hide();
        $('.garage .menu-manage').hide();
        $('.garage .menu-manage-vehicles').show();
        loadGarageVehiclesManage(vehiclesList)
    });

});

// GARAGES TRANSFER:
$(document).on('click', '.garage > .center > .menu-transfer > .data .check', function (e) {
    $('.garage > .center > .menu-transfer > .data .check').removeClass('checked');
    $(this).addClass('checked');
})

$('.garage > .center > .menu-transfer #transfer-vehicle').click(() => {
    if (canPressAgain) {
        canPressAgain = false;

        let selectedGarage = $('.garage > .center > .menu-transfer > .data .checked').data('garage');
        let selectedPlate = $('.garage > .center > .menu-transfer > .data .checked').data('plate');
        $.post(`https://${GetParentResourceName()}/transferBetweenGarages`, JSON.stringify({
            newGarage: selectedGarage,
            plate: selectedPlate,
        }));

        setTimeout(() => {
            canPressAgain = true;
        }, 800);
    }
})

// 

$(document).on('click', '.garage > .center > .menu-manage > .management .check', function (e) {
    if (!canSelectNewVehicle) return;
    canSelectNewVehicle = false
    
    let selectedPlayerId = $(this).data('playerid');
    let selectedGradeId = $(this).data('gradeid');
    let selectedVehicleModel = $(this).data('model');

    let isVisible = !$(this).hasClass('checked');

    if (selectedVehicleModel != undefined) {
        $('.garage > .center > .menu-manage > .management .vehicles .check').removeClass('checked');
        if (isVisible) {
            $(this).addClass('checked');
            $.post(`https://${GetParentResourceName()}/viewVehicle`, JSON.stringify({
                model: selectedVehicleModel
            }), function (canChoose) {
                canSelectNewVehicle = canChoose;
            });
            manageSelectedModel = selectedVehicleModel;
        } else {
            $.post(`https://${GetParentResourceName()}/removeViewVehicle`);
            manageSelectedModel = null;
            canSelectNewVehicle = true;
        }

    } else if (selectedPlayerId != undefined || selectedGradeId != undefined) {
        $('.garage > .center > .menu-manage > .management .owner .check').removeClass('checked');
        manageSelectedPlayer = null;
        manageSelectedGrade = null;
        canSelectNewVehicle = true;
        if (isVisible) {
            $(this).addClass('checked');
            if (selectedPlayerId) {
                manageSelectedPlayer = selectedPlayerId;
            } else if (selectedGradeId) {
                manageSelectedGrade = selectedGradeId;
            }
        }

    }
})

$(document).on('click', '.garage > .center > .menu-manage-transfer-vehicles > .data .check', function (e) {
    let selectedPlayerId = $(this).data('playerid');
    let selectedGradeId = $(this).data('gradeid');

    let isVisible = !$(this).hasClass('checked');

    $('.garage > .center > .menu-manage-transfer-vehicles > .data .owner .check').removeClass('checked');

    manageSelectedPlayer = null;
    manageSelectedGrade = null;

    if (isVisible) {
        $(this).addClass('checked');
        if (selectedPlayerId) {
            manageSelectedPlayer = selectedPlayerId;
        } else if (selectedGradeId != undefined) {
            manageSelectedGrade = selectedGradeId;
        }
    }
})

$(document).on('click', '.garage > .center > .menu-manage > .management > #buy-vehicle', function (e) {
    if (canPressAgain) {
        canPressAgain = false;
        $.post(`https://${GetParentResourceName()}/buyCompanyVehicle`, JSON.stringify({
            model: manageSelectedModel,
            player: manageSelectedPlayer,
            grade: manageSelectedGrade
        }))
        setTimeout(() => {
            canPressAgain = true;
        }, 800);
    }
})

$(document).on('click', '.garage > .center > .menu-manage-vehicles > .data .vehicle', function (e) {
    if (!canSelectNewVehicle) return;
    canSelectNewVehicle = false
    
    let parentDiv = $(this).parent();
    let isVisible = !parentDiv.hasClass('visible');

    $('.garage .center .menu-manage-vehicles .data > div').removeClass('visible');

    if (isVisible) {
        parentDiv.addClass('visible');
        let vehPlate = $(this).data('plate');
        $.post(`https://${GetParentResourceName()}/viewVehicle`, JSON.stringify({
            plate: vehPlate
        }), function (canChoose) {
            canSelectNewVehicle = canChoose;
        });
    } else {
        $.post(`https://${GetParentResourceName()}/removeViewVehicle`);
        canSelectNewVehicle = true;
    }
})

$(document).on('click', '.garage > .center > .menu > .data .vehicle', function (e) {
    if (!canSelectNewVehicle) return;
    canSelectNewVehicle = false
    let parentDiv = $(this).parent();
    let isVisible = !parentDiv.hasClass('visible');
    $('.garage .center .menu .data > div').removeClass('visible');

    if (isVisible) {
        parentDiv.addClass('visible');
        let vehId = $(this).data('id');
        $.post(`https://${GetParentResourceName()}/viewVehicle`, JSON.stringify({
            id: vehId
        }), function (canChoose) {
            canSelectNewVehicle = canChoose;
        });
    } else {
        $.post(`https://${GetParentResourceName()}/removeViewVehicle`);
        canSelectNewVehicle = true;
    }
})

$(document).on('click', '.garage > .center > .menu > .data #take-impound', function (e) {
    if (canPressAgain) {
        canPressAgain = false;
        let vehPlate = $(this).data('plate');
        $.post(`https://${GetParentResourceName()}/takeImpoundVehicle`, JSON.stringify({
            vehPlate: vehPlate
        }));
        setTimeout(() => {
            canPressAgain = true;
        }, 800);
    }
})

$(document).on('click', '.garage > .center > .menu > .data #give-impound-bill', function (e) {
    if (canPressAgain) {
        canPressAgain = false;
        let vehPlate = $(this).data('plate');
        $.post(`https://${GetParentResourceName()}/giveBillForImpound`, JSON.stringify({
            vehPlate: vehPlate
        }));
        setTimeout(() => {
            canPressAgain = true;
        }, 800);
    }
})

$(document).on('click', '.garage > .center > .menu > .data #pay-for-impound', function (e) {
    if (canPressAgain) {
        canPressAgain = false;
        let vehPlate = $(this).data('plate');
        let paymentMethod = $(this).data('payment');
        $.post(`https://${GetParentResourceName()}/payForImpound`, JSON.stringify({
            paymentMethod: paymentMethod,
            vehPlate: vehPlate
        }));
        setTimeout(() => {
            canPressAgain = true;
        }, 800);
    }
})

$(document).on('click', '.garage > .center > .menu > .data #locate', function (e) {
    if (canPressAgain) {
        canPressAgain = false;
        let vehPlate = $(this).data('plate');
        let paymentMethod = $(this).data('payment');
        $.post(`https://${GetParentResourceName()}/locateVehicle`, JSON.stringify({
            paymentMethod: paymentMethod,
            vehPlate: vehPlate
        }));
        setTimeout(() => {
            canPressAgain = true;
        }, 800);
    }
})

$(document).on('click', '.garage > .center > .menu > .data #take-out', function (e) {
    if (canPressAgain) {
        canPressAgain = false;
        let vehPlate = $(this).data('plate');
        let vehModel = $(this).data('model');
        $.post(`https://${GetParentResourceName()}/takeOutVehicle`, JSON.stringify({
            vehPlate: vehPlate,
            vehModel: vehModel
        }));
        setTimeout(() => {
            canPressAgain = true;
        }, 800);
    }
})

$(document).on('click', '.garage > .center > .menu-manage-vehicles #manage-transfer', function (e) {
    let vehPlate = $(this).data('plate');
    let playerOwner = $(this).data('player');
    let gradeOwner = $(this).data('grade');

    $('.garage>.center>.menu-manage-transfer-vehicles>.header>.title').html((translation.garage.management_transfer.transfer_title).format(vehPlate));

    $('.garage > .center > .menu-manage-transfer-vehicles>.data .owner .check').removeClass('checked');

    if (playerOwner != undefined) {
        $(`.garage > .center > .menu-manage-transfer-vehicles>.data .owner>.citizens .check[data-playerid="${playerOwner}"]`).addClass('checked');
        manageSelectedPlayer = playerOwner;
    } else if (gradeOwner != undefined) {
        $(`.garage > .center > .menu-manage-transfer-vehicles>.data .owner>.job-grades .check[data-gradeid="${gradeOwner}"]`).addClass('checked');
        manageSelectedGrade = gradeOwner;
    }

    $(".garage>.center>.menu-manage-transfer-vehicles>.data>#transfer-company-vehicle").attr("data-plate", vehPlate);

    $('.garage .menu-transfer').hide();
    $('.garage .menu-manage-vehicles').hide();
    $('.garage .menu-manage-transfer-vehicles').show();
    $('.garage .menu-locate-vehicles').hide();
})

$(document).on('click', '.garage > .center > .menu-manage-transfer-vehicles > .data > #transfer-company-vehicle', function (e) {
    let vehPlate = $(this).attr('data-plate');
    if (!vehPlate) return;

    let selectedPlayerName = null;
    if (manageSelectedPlayer) {
        selectedPlayerName = $(`.garage > .center > .menu-manage-transfer-vehicles>.data .owner>.citizens .check[data-playerid="${manageSelectedPlayer}"]`).data('playername')
    }

    $.post(`https://${GetParentResourceName()}/transferCompanyVehicle`, JSON.stringify({
        plate: vehPlate,
        player: manageSelectedPlayer,
        playerName: selectedPlayerName,
        grade: manageSelectedGrade
    }));

    manageSelectedPlayer = null;
    manageSelectedGrade = null;

    $('.garage .menu').show();
    $('.garage .menu-transfer').hide();
    $('.garage .menu-manage').hide();
    $('.garage .menu-manage-vehicles').hide();
    $('.garage .menu-manage-transfer-vehicles').hide();
    $('.garage .menu-locate-vehicles').hide();
})


$(document).on('click', '.receipt .buttons .pay_cash', function (e) {
    $.post(`https://${GetParentResourceName()}/bill`, JSON.stringify({
        action: 'pay',
        type: 'cash',
    }));
})

$(document).on('click', '.receipt .buttons .pay_bank', function (e) {
    $.post(`https://${GetParentResourceName()}/bill`, JSON.stringify({
        action: 'pay',
        type: 'bank',
    }));
})

$(document).on('click', '.receipt .buttons .cancel', function (e) {
    $.post(`https://${GetParentResourceName()}/bill`, JSON.stringify({
        action: 'cancel'
    }));
})


$('.purchase-business[data-type="purchase"]').click(function () {
    $.post(`https://${GetParentResourceName()}/purchaseBusiness`)
})



document.getElementById('finder').addEventListener('input', function () {
    const searchTerm = this.value.toLowerCase();
    const dataDivs = document.querySelectorAll('.data > div');

    dataDivs.forEach(div => {
        const labelElement = div.querySelector('#label');
        const plateElement = div.querySelector('#plate');
        if (labelElement && plateElement) {
            const label = labelElement.textContent.toLowerCase();
            const plate = plateElement.textContent.toLowerCase();
            if (label.includes(searchTerm) || plate.includes(searchTerm)) {
                div.style.display = '';
            } else {
                div.style.display = 'none';
            }
        } else {
            div.style.display = 'none';
        }
    });
});



$(".management-menu .side-bar .button").click(function () {
    let newMenu = $(this).data('href')
    updateManagement(newMenu, this)
})

$(".management-menu .box .btn").click(function () {
    let option = $(this).data('option')
    if (option == "withdraw") {
        $('.box[data-type="balance"] .close-balance').addClass('isVisible');
        $('input[data-input="withdraw"]').show();
        $('.btn[data-option="deposit"]').hide();
        $('.btn[data-option="withdraw"]').hide();
    } else if (option == "deposit") {
        $('.box[data-type="balance"] .close-balance').addClass('isVisible');
        $('input[data-input="deposit"]').show();
        $('.btn[data-option="deposit"]').hide();
        $('.btn[data-option="withdraw"]').hide();
    } else if (option == "sell") {
        $.post(`https://${GetParentResourceName()}/sell`);
    } else if (option == "resell") {
        $.post(`https://${GetParentResourceName()}/resell`);
    } else if (option == "price-per-day") {
        let price = $('input[data-input="price-per-day"]').val();
        $.post(`https://${GetParentResourceName()}/changePricePerDay`, JSON.stringify({
            price: price
        }));
    } else if (option == "price-for-infinity") {
        let price = $('input[data-input="price-for-infinity"]').val();
        $.post(`https://${GetParentResourceName()}/changePriceInfinity`, JSON.stringify({
            price: price
        }));
    }
})

$(".btn").click(function () {
    let option = $(this).data('option')
    if (option == "withdraw") {
        $('.box[data-type="balance"] .close-balance').addClass('isVisible');
        $('input[data-input="withdraw"]').show();
        $('.btn[data-option="deposit"]').hide();
        $('.btn[data-option="withdraw"]').hide();
    } else if (option == "deposit") {
        $('.box[data-type="balance"] .close-balance').addClass('isVisible');
        $('input[data-input="deposit"]').show();
        $('.btn[data-option="deposit"]').hide();
        $('.btn[data-option="withdraw"]').hide();
    }
})


function balanceButton() {
    if ($('input[data-input="withdraw"]').val() >= 1) {
        let money = $('input[data-input="withdraw"]').val()
        $.post(`https://${GetParentResourceName()}/withdraw`, JSON.stringify({ money: money }));
        $('input[data-input="withdraw"]').val('').hide();
        $('.btn[data-option="deposit"]').show();
        $('.btn[data-option="withdraw"]').show();
        $('.box[data-type="balance"] .close-balance').removeClass('isAnyVal');
        $('.box[data-type="balance"] .close-balance > i').removeClass('fa-check').addClass('fa-close');
        $('.box[data-type="balance"] .close-balance').removeClass('isVisible');
    } else if ($('input[data-input="deposit"]').val() >= 1) {
        let money = $('input[data-input="deposit"]').val()
        $.post(`https://${GetParentResourceName()}/deposit`, JSON.stringify({ money: money }));
        $('input[data-input="deposit"]').val('').hide();
        $('.btn[data-option="deposit"]').show();
        $('.btn[data-option="withdraw"]').show();
        $('.box[data-type="balance"] .close-balance').removeClass('isAnyVal');
        $('.box[data-type="balance"] .close-balance > i').removeClass('fa-check').addClass('fa-close');
        $('.box[data-type="balance"] .close-balance').removeClass('isVisible');
    } else {
        $('.btn[data-option="deposit"]').show();
        $('.btn[data-option="withdraw"]').show();
        $('input[data-input="withdraw"]').val('').hide();
        $('input[data-input="deposit"]').val('').hide();
        $('.box[data-type="balance"] .close-balance').removeClass('isVisible');
    }
}

function onInputBalance(type) {
    let value = $(`input[data-input="${type}"]`).val();
    if (type == 'withdraw') {
        if (value >= 1) {
            $('.box[data-type="balance"] .close-balance').addClass('isAnyVal');
            $('.box[data-type="balance"] .close-balance > i').removeClass('fa-close').addClass('fa-check');

        } else {
            $('.box[data-type="balance"] .close-balance').removeClass('isAnyVal');
            $('.box[data-type="balance"] .close-balance > i').removeClass('fa-check').addClass('fa-close');

        }
    } else if (type == 'deposit') {
        if (value >= 1) {
            $('.box[data-type="balance"] .close-balance').addClass('isAnyVal');
            $('.box[data-type="balance"] .close-balance > i').removeClass('fa-close').addClass('fa-check');

        } else {
            $('.box[data-type="balance"] .close-balance').removeClass('isAnyVal');
            $('.box[data-type="balance"] .close-balance > i').removeClass('fa-check').addClass('fa-close');

        }
    }
}

function updateManagement(newMenu, _this) {
    if (newMenu == managementMenu) return;
    if (_this != selectedOption) {
        if (selectedOption) {
            $(selectedOption).removeClass("selected");
        }
        selectedOption = _this
        $(selectedOption).addClass("selected");
    }

    $(`div[data-type="${managementMenu}"]`).hide();
    managementMenu = newMenu
    $(`div[data-type="${managementMenu}"]`).show();
}


function sortTable(n) {
    var table, rows, switching, i, x, y, shouldSwitch, dir, switchcount = 0;
    table = document.getElementById("parking-spaces-table");
    switching = true;
    dir = "asc";

    var icons = document.getElementsByClassName("sort-icon");
    for (var i = 0; i < icons.length; i++) {
        icons[i].innerHTML = "";
    }

    var icon = document.getElementById("icon" + n);
    if (dir == "asc") {
        icon.innerHTML = "▲";
    } else {
        icon.innerHTML = "▼";
    }

    while (switching) {
        switching = false;
        rows = table.rows;
        for (i = 1; i < (rows.length - 1); i++) {
            shouldSwitch = false;
            x = rows[i].getElementsByTagName("TD")[n];
            y = rows[i + 1].getElementsByTagName("TD")[n];
            if (dir == "asc") {
                if (x.innerHTML.toLowerCase() > y.innerHTML.toLowerCase()) {
                    shouldSwitch = true;
                    break;
                }
            } else if (dir == "desc") {
                if (x.innerHTML.toLowerCase() < y.innerHTML.toLowerCase()) {
                    shouldSwitch = true;
                    break;
                }
            }
        }
        if (shouldSwitch) {
            rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
            switching = true;
            switchcount++;
        } else {
            if (switchcount == 0 && dir == "asc") {
                dir = "desc";
                switching = true;
                icon.innerHTML = "▼";
            }
        }
    }
}

let canSwitchRent = true;
$(document).on('keydown', 'body', function (e) {
    if (e.which == 27) {
        $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({ menu: currentMenu }));
        isMenuOpened = false;
    }
    if (currentMenu == 'parkingRent') {
        if (e.which == 8) { // Backspace
            $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({ menu: currentMenu }));
        }
        if (canSwitchRent && (e.which == 37 || e.which == 65)) { // Arrow Left & A
            canSwitchRent = false;
            $.post(`https://${GetParentResourceName()}/parkingRent`, JSON.stringify({ action: "switch", direction: 'left' }));
            setTimeout(() => {
                canSwitchRent = true;
            }, 475);
        }
        if (canSwitchRent && (e.which == 39 || e.which == 68)) { // Arrow Right & D
            canSwitchRent = false;
            $.post(`https://${GetParentResourceName()}/parkingRent`, JSON.stringify({ action: "switch", direction: 'right' }));
            setTimeout(() => {
                canSwitchRent = true;
            }, 475);
        }
    }
})

$(".parking-rent #left").click(function () {
    if (!canSwitchRent) return;
    canSwitchRent = false;
    $.post(`https://${GetParentResourceName()}/parkingRent`, JSON.stringify({ action: "switch", direction: 'left' }));
    setTimeout(() => {
        canSwitchRent = true;
    }, 475);
})

$(".parking-rent #right").click(function () {
    if (!canSwitchRent) return;
    canSwitchRent = false;
    $.post(`https://${GetParentResourceName()}/parkingRent`, JSON.stringify({ action: "switch", direction: 'right' }));
    setTimeout(() => {
        canSwitchRent = true;
    }, 475);
})


$(document).on('click', '#rent-day-pick', function (e) {
    if (selectedDays) {
        $(selectedDays).removeClass("selected");
    }

    selectedDays = $(this)
    $(selectedDays).addClass("selected");

    let daysCount = $(selectedDays).data('days')

    $('.parking-rent .menu > .data > .buttons > #rent').html((translation.parking_rent.rent_for).format(translation.currency, Number(daysCount) == -1 ? rentPriceForInfinity : Number(daysCount) * rentPrice));

})

$(".parking-rent .menu > .data > .buttons > #rent").click(function () {
    if (!selectedDays) return;
    if (!canPressAgain) return;

    canPressAgain = false;
    let daysCount = $(selectedDays).data('days')
    $.post(`https://${GetParentResourceName()}/rentParkingSpace`, JSON.stringify({
        days: daysCount
    }));

    setTimeout(() => {
        canPressAgain = true;
    }, 475);
})


function agreementChangedVehicle() {
    let vehicleData = $('#select-vehicle').select2('data')[0];

    var type = vehicleData.type;

    selectedVehicleType = null;
    if (type) {
        for (const [k, v] of Object.entries(vehicleTypes)) {
            if (v.name == type) selectedVehicleType = v.label
        }
    } else {
        selectedVehicleType = '<span>...........</span>';
    }

    $(".agreement .card .paragraph_text_1 > span#dots").html(selectedVehicleType);
    $(".agreement .card .paragraph_text_2 > span#dots").html(selectedVehicleType);
}

$(document).on('click', '#make_signature_buyer', function (e) {
    $(".agreement #make_signature_buyer").hide();
    let signature = playerName
    const signatureElement = document.getElementById('signature_buyer');
    let currentLetterIndex = 0;

    function stopLetter() {
        $.post(`https://${GetParentResourceName()}/agreementDone`);
        setTimeout(() => {
            $(".agreement").fadeOut(120);
            currentMenu = null;
        }, 1000);
    }

    function addNextLetter() {
        signatureElement.textContent += signature[currentLetterIndex];
        currentLetterIndex++;
        if (currentLetterIndex < signature.length) {
            setTimeout(addNextLetter, 100);
        } else {
            stopLetter()
        }
    }

    addNextLetter();
})

$(document).on('click', '#make_signature_seller', function (e) {
    $(".agreement #make_signature_seller").hide();
    let signature = playerName
    const signatureElement = document.getElementById('signature_seller');
    let currentLetterIndex = 0;
    function stopLetter() {
        $(".agreement #give_invoice").css({
            "z-index": 500,
            "opacity": 0.8
        });
    }
    function addNextLetter() {
        signatureElement.textContent += signature[currentLetterIndex];
        currentLetterIndex++;
        if (currentLetterIndex < signature.length) {
            setTimeout(addNextLetter, 100);
        } else {
            stopLetter()
        }
    }
    addNextLetter();
})

$(document).on('click', '.agreement #give_invoice', function (e) {
    let selectedBuyer = $('#select-buyer').select2('data')[0];
    let selectedVehicle = $('#select-vehicle').select2('data')[0];
    let paymentMethod = $('#select-payment-method').select2('data')[0];

    let price = $(".agreement #sell-price-input").val();

    if (!selectedBuyer || selectedBuyer.id == 0) {
        $(".agreement #select-buyer").addClass("required");
    } else {
        $(".agreement #select-buyer").removeClass("required");
    }
    if (!selectedVehicle || selectedVehicle.type == undefined) {
        $(".agreement #select-vehicle").addClass("required");
    } else {
        $(".agreement #select-vehicle").removeClass("required");
    }
    if (!price) {
        $(".agreement #sell-price-input").addClass("required");
    } else {
        $(".agreement #sell-price-input").removeClass("required");
    }
    if (!paymentMethod || paymentMethod.paymentmethod == undefined) {
        $(".agreement #select-payment-method").addClass("required");
    } else {
        $(".agreement #select-payment-method").removeClass("required");
    }

    if (selectedBuyer && selectedBuyer.id != 0 && selectedVehicle && selectedVehicle.type != undefined && selectedVehicleType && paymentMethod && paymentMethod.paymentmethod != undefined && price) {
        $(".agreement").fadeOut(150);
        $.post(`https://${GetParentResourceName()}/sendAgreement`, JSON.stringify({
            selectedBuyer: selectedBuyer.id,
            resellData: {
                sellerName: playerName,
                price: price,
                date: currentDate,
                vehiclePlate: selectedVehicle.text,
                vehicleType: selectedVehicleType,
                paymentMethod: paymentMethod.paymentmethod,
            }
        }));
    }
})


$(document).on('click', '#resell_make_signature_buyer', function (e) {
    $(".resell #resell_make_signature_buyer").hide();
    let signature = playerName
    const signatureElement = document.getElementById('resell_signature_buyer');
    let currentLetterIndex = 0;

    function stopLetter() {
        $.post(`https://${GetParentResourceName()}/resellDone`);
        setTimeout(() => {
            $(".resell").fadeOut(120);
            currentMenu = null;
        }, 1000);
    }

    function addNextLetter() {
        signatureElement.textContent += signature[currentLetterIndex];
        currentLetterIndex++;
        if (currentLetterIndex < signature.length) {
            setTimeout(addNextLetter, 100);
        } else {
            stopLetter()
        }
    }

    addNextLetter();
})

$(document).on('click', '#resell_make_signature_seller', function (e) {
    $(".resell #resell_make_signature_seller").hide();
    let signature = playerName
    const signatureElement = document.getElementById('resell_signature_seller');
    let currentLetterIndex = 0;
    function stopLetter() {
        $(".resell #give_invoice").css({
            "z-index": 500,
            "opacity": 0.8
        });
    }
    function addNextLetter() {
        signatureElement.textContent += signature[currentLetterIndex];
        currentLetterIndex++;
        if (currentLetterIndex < signature.length) {
            setTimeout(addNextLetter, 100);
        } else {
            stopLetter()
        }
    }
    addNextLetter();
})

$(document).on('click', '.resell #give_invoice', function (e) {
    let selectedBuyer = $('#select-buyer-resell').select2('data')[0];
    let resellPrice = $("#resell-price-input").val();

    if (!selectedBuyer || selectedBuyer.id == 0) {
        $(".resell #select-buyer").addClass("required");
    } else {
        $(".resell #select-buyer").removeClass("required");
    }

    if (!resellPrice) $(".resell #resell-price-input").addClass("required");

    if (selectedBuyer && selectedBuyer.id != 0 && resellPrice) {
        $(".resell").fadeOut(120);
        $.post(`https://${GetParentResourceName()}/resellSend`, JSON.stringify({
            selectedBuyer: selectedBuyer.id,
            resellData: {
                sellerName: playerName,
                price: resellPrice,
                date: currentDate,
                label: garageCfg.label,
            }
        }));
    }
})




// Parking Creator
$(document).on('click', '.parking-creator > .center > div > #main-menu > div', function (e) {
    let inIncorrect = $(this).hasClass('button');
    if (inIncorrect) return;

    let type = $(this).data('type');

    $('.parking-creator > .center > div > #main-menu > div').removeClass('selected');
    $(this).addClass('selected');
    ParkingCreator.selectedParkingType = type
})

$(document).on('click', `.parking-creator > .center > div > #main-menu > .button`, function (e) {
    $.post(`https://${GetParentResourceName()}/creatorAction`, JSON.stringify({
        action: "start",
        type: ParkingCreator.selectedParkingType,
    }));
})

$(document).on('click', `
    .parking-creator>.center>div>#parking-menu>.settings>#main-settings-section>div>div,
    .parking-creator>.center>div>#parking-menu>.settings>#parkingmeter-section>div>div,
    .parking-creator>.center>div>#parking-menu>.settings>#rent-section>div>div,
    .parking-creator>.center>div>#parking-menu>.settings>#npc-section>div>div,
    .parking-creator>.center>div>#parking-menu>.settings>#company-section>div>div,
    .parking-creator>.center>div>#parking-menu>.settings>#gang-section>div>div,
    .parking-creator>.center>div>#parking-menu>.settings>#allowed-models-section>div>div,

    .parking-creator>.center>div>#house-garage-menu-menu>.settings>#garage-settings-section>div>div,

    .parking-creator>.center>div>#garage-menu>.settings>#main-settings-section>div>div,
    .parking-creator>.center>div>#garage-menu>.settings>#garage-settings-section>div>div,
    .parking-creator>.center>div>#garage-menu>.settings>#garage2-settings-section>div>div
`, function (e) {
    let option = $(this).data('option');
    if (!option) return;

    if (option == "parking-spaces") {
        let vehicleType = $('.parking-creator>.center>div>#parking-menu>.settings>#main-settings-section div[data-name="type"] select').val();
        $.post(`https://${GetParentResourceName()}/creatorAction`, JSON.stringify({
            action: "parking_spaces",
            type: vehicleType
        }));

    } else if (option == "paystations") {
        let useParkingmeter = $('.parking-creator > .center > div > #parking-menu > .settings > .section-label input[data-section="parkingmeter-section"]').is(':checked');
        if (!useParkingmeter) return;
        $.post(`https://${GetParentResourceName()}/creatorAction`, JSON.stringify({
            action: "paystations",
        }));

    } else if (option == "rent") {
        let useRent = $('.parking-creator > .center > div > #parking-menu > .settings > .section-label input[data-section="rent-section"]').is(':checked');
        if (!useRent) return;
        $.post(`https://${GetParentResourceName()}/creatorAction`, JSON.stringify({
            action: "paystations",
        }));

    } else if (option == "npc") {
        let useNPC = $('.parking-creator > .center > div > #parking-menu > .settings > .section-label input[data-section="npc-section"]').is(':checked');
        if (!useNPC) return;
        let npcModel = $('.parking-creator > .center > div > #parking-menu > .settings > #npc-section input#npc-model').val();
        let npcAnimName = $('.parking-creator > .center > div > #parking-menu > .settings > #npc-section input#anim-name').val();
        let npcAnimDict = $('.parking-creator > .center > div > #parking-menu > .settings > #npc-section input#anim-dict').val();

        $.post(`https://${GetParentResourceName()}/creatorAction`, JSON.stringify({
            action: "npc",
            model: npcModel,
            animName: npcAnimName,
            animDict: npcAnimDict
        }));

    } else if (option == "menu-point") {
        $.post(`https://${GetParentResourceName()}/creatorAction`, JSON.stringify({
            action: "menu-point",
        }));

    } else if (option == "ped-coords") {
        $.post(`https://${GetParentResourceName()}/creatorAction`, JSON.stringify({
            action: "ped-coords",
        }));

    } else if (option == "vehicle-coords") {
        let vehicleType = $('.parking-creator>.center>div>#garage-menu>.settings>#main-settings-section div[data-name="type"] select').val();

        $.post(`https://${GetParentResourceName()}/creatorAction`, JSON.stringify({
            action: "vehicle-coords",
            type: vehicleType
        }));
        
    } else if (option == "vehicle-coords-house-menu") {
        let vehicleType = $('.parking-creator>.center>div>#house-garage-menu-menu>.settings>#main-settings-section div[data-name="type"] select').val();

        $.post(`https://${GetParentResourceName()}/creatorAction`, JSON.stringify({
            action: "vehicle-coords",
            type: vehicleType
        }));

    } else if (option == "camera-coords") {
        $.post(`https://${GetParentResourceName()}/creatorAction`, JSON.stringify({
            action: "camera-coords",
        }));

    } else if (option == "spawnpoint") {
        let vehicleType = $('.parking-creator>.center>div>#garage-menu>.settings>#main-settings-section div[data-name="type"] select').val();
        
        $.post(`https://${GetParentResourceName()}/creatorAction`, JSON.stringify({
            action: "spawnpoint",
            type: vehicleType
        }));

    } else if (option == "returnpoint") {
        $.post(`https://${GetParentResourceName()}/creatorAction`, JSON.stringify({
            action: "returnpoint",
        }));

    }
})

$(document).on('change', `
    .parking-creator #parking-menu #main-settings-section > div[data-name="type"] > select,
    .parking-creator #garage-menu #main-settings-section > div[data-name="type"] > select,
    .parking-creator #house-garage-menu-menu #main-settings-section > div[data-name="type"] > select,
    .parking-creator #garage-interior-menu #main-settings-section > div[data-name="type"] > select
`, function (e) {
    let value = $(this).val();
    ParkingCreator.selectedVehicleType = value
})

$('.parking-creator > .center > div > #parking-menu > .settings .section-label input[type="checkbox"]').change(function () {
    let isChecked = $(this).is(':checked');
    let section = $(this).data('section');
    if (isChecked) {
        $(`.parking-creator > .center > div > #parking-menu > .settings #${section}`).addClass('active');
        $(`.parking-creator > .center > div > #parking-menu > .settings > #${section} input`).prop('disabled', false);
        $(`.parking-creator > .center > div > #parking-menu > .settings > #${section} select`).prop('disabled', false);

        if (section == "parkingmeter-section") {
            $(`.parking-creator > .center > div > #parking-menu > .settings > .section-label input[type="checkbox"][data-section="rent-section"]`).prop("checked", false);
            $(`.parking-creator > .center > div > #parking-menu > .settings > #rent-section`).removeClass('active');
            $(`.parking-creator > .center > div > #parking-menu > .settings > #rent-section input`).prop('disabled', true);
            $(`.parking-creator > .center > div > #parking-menu > .settings > #rent-section select`).prop('disabled', true);
            $(`.parking-creator > .center > div > #parking-menu > .settings > #rent-section .tagify`).attr('disabled', true);
        }
        if (section == "rent-section") {
            $(`.parking-creator > .center > div > #parking-menu > .settings > .section-label input[type="checkbox"][data-section="parkingmeter-section"]`).prop("checked", false);
            $(`.parking-creator > .center > div > #parking-menu > .settings > #parkingmeter-section`).removeClass('active');
            $(`.parking-creator > .center > div > #parking-menu > .settings > #parkingmeter-section input`).prop('disabled', true);
            $(`.parking-creator > .center > div > #parking-menu > .settings > #parkingmeter-section select`).prop('disabled', true);
            $(`.parking-creator > .center > div > #parking-menu > .settings > #rent-section .tagify`).attr('disabled', false);
        }
        if (section == "company-section") {
            $(`.parking-creator > .center > div > #parking-menu > .settings #company-section .tagify`).attr('disabled', false);
            $(`.parking-creator > .center > div > #parking-menu > .settings #gang-section .tagify`).attr('disabled', true);
            $(`.parking-creator > .center > div > #parking-menu > .settings #gang-section`).removeClass('active');
            $(`.parking-creator > .center > div > #parking-menu > .settings #gang-section select`).prop('disabled', true);
            $(`.parking-creator > .center > div > #parking-menu > .settings .section-label input[type="checkbox"][data-section="gang-section"]`).prop('checked', false);
        }
        if (section == "gang-section") {
            $(`.parking-creator > .center > div > #parking-menu > .settings #gang-section .tagify`).attr('disabled', false);
            $(`.parking-creator > .center > div > #parking-menu > .settings #company-section .tagify`).attr('disabled', true);
            $(`.parking-creator > .center > div > #parking-menu > .settings #company-section`).removeClass('active');
            $(`.parking-creator > .center > div > #parking-menu > .settings #company-section select`).prop('disabled', true);
            $(`.parking-creator > .center > div > #parking-menu > .settings .section-label input[type="checkbox"][data-section="company-section"]`).prop('checked', false);
        }
        if (section == "allowed-models-section") {
            $(`.parking-creator > .center > div > #parking-menu > .settings > #allowed-models-section .tagify`).attr('disabled', false);
        }
    } else {
        $(`.parking-creator > .center > div > #parking-menu > .settings #${section}`).removeClass('active');
        $(`.parking-creator > .center > div > #parking-menu > .settings > #${section} input`).prop('disabled', true);
        $(`.parking-creator > .center > div > #parking-menu > .settings > #${section} select`).prop('disabled', true);

        if (section == "rent-section") $(`.parking-creator > .center > div > #parking-menu > .settings > #rent-section .tagify`).attr('disabled', true);

        if (section == "company-section") $(`.parking-creator > .center > div > #parking-menu > .settings #company-section .tagify`).attr('disabled', true);

        if (section == "gang-section") $(`.parking-creator > .center > div > #parking-menu > .settings #gang-section .tagify`).attr('disabled', true);

        if (section == "allowed-models-section") $(`.parking-creator > .center > div > #parking-menu > .settings > #allowed-models-section .tagify`).attr('disabled', true);
    }
});

$('.parking-creator > .center > div > #garage-menu > .settings .section-label input[type="checkbox"]').change(function () {
    let isChecked = $(this).is(':checked');
    let section = $(this).data('section');
    
    if (isChecked) {
        if (section == "company-section") {
            if ($(`.parking-creator > .center > div > #garage-menu > .settings #gang-section`).hasClass('active')) {
                $(`.parking-creator > .center > div > #garage-menu > .settings #gang-section`).removeClass('active');
                $(`.parking-creator > .center > div > #garage-menu > .settings #gang-section .tagify`).attr('disabled', true);
                $(`.parking-creator > .center > div > #garage-menu > .settings .section-label input[type="checkbox"][data-section="gang-section"]`).prop("checked", false);
            }

            $(`.parking-creator > .center > div > #garage-menu > .settings #company-section`).addClass('active');
            $(`.parking-creator > .center > div > #garage-menu > .settings > #predefined-models-section`).addClass('active');
            $(`.parking-creator > .center > div > #garage-menu > .settings > #garage-allowed-models-section`).addClass('active');

            $(`.parking-creator > .center > div > #garage-menu > .settings #company-section .tagify`).attr('disabled', false);
            $(`.parking-creator > .center > div > #garage-menu > .settings > #predefined-models-section .tagify`).attr('disabled', false);
            $(`.parking-creator > .center > div > #garage-menu > .settings > #garage-allowed-models-section .tagify`).attr('disabled', false);
        }
        if (section == "gang-section") {
            if ($(`.parking-creator > .center > div > #garage-menu > .settings #company-section`).hasClass('active')) {
                $(`.parking-creator > .center > div > #garage-menu > .settings #company-section`).removeClass('active');
                $(`.parking-creator > .center > div > #garage-menu > .settings #company-section .tagify`).attr('disabled', true);
                $(`.parking-creator > .center > div > #garage-menu > .settings .section-label input[type="checkbox"][data-section="company-section"]`).prop("checked", false);
            }

            $(`.parking-creator > .center > div > #garage-menu > .settings #gang-section`).addClass('active');
            $(`.parking-creator > .center > div > #garage-menu > .settings > #predefined-models-section`).addClass('active');
            $(`.parking-creator > .center > div > #garage-menu > .settings > #garage-allowed-models-section`).addClass('active');

            $(`.parking-creator > .center > div > #garage-menu > .settings #gang-section .tagify`).attr('disabled', false);
            $(`.parking-creator > .center > div > #garage-menu > .settings > #predefined-models-section .tagify`).attr('disabled', false);
            $(`.parking-creator > .center > div > #garage-menu > .settings > #garage-allowed-models-section .tagify`).attr('disabled', false);
        }
    } else {
        if (section == "company-section") {
            $(`.parking-creator > .center > div > #garage-menu > .settings #company-section`).removeClass('active');
            $(`.parking-creator > .center > div > #garage-menu > .settings > #predefined-models-section`).removeClass('active');
            $(`.parking-creator > .center > div > #garage-menu > .settings > #garage-allowed-models-section`).removeClass('active');

            $(`.parking-creator > .center > div > #garage-menu > .settings #company-section .tagify`).attr('disabled', true);
            $(`.parking-creator > .center > div > #garage-menu > .settings > #predefined-models-section .tagify`).attr('disabled', true);
            $(`.parking-creator > .center > div > #garage-menu > .settings > #garage-allowed-models-section .tagify`).attr('disabled', true);
        }
        if (section == "gang-section") {
            $(`.parking-creator > .center > div > #garage-menu > .settings #gang-section`).removeClass('active');
            $(`.parking-creator > .center > div > #garage-menu > .settings > #predefined-models-section`).removeClass('active');
            $(`.parking-creator > .center > div > #garage-menu > .settings > #garage-allowed-models-section`).removeClass('active');

            $(`.parking-creator > .center > div > #garage-menu > .settings #gang-section .tagify`).attr('disabled', true);
            $(`.parking-creator > .center > div > #garage-menu > .settings > #predefined-models-section .tagify`).attr('disabled', true);
            $(`.parking-creator > .center > div > #garage-menu > .settings > #garage-allowed-models-section .tagify`).attr('disabled', true);
        }
    }
});

$('.parking-creator > .center > div > #house-garage-menu-menu > .settings .section-label input[type="checkbox"]').change(function () {
    let isChecked = $(this).is(':checked');
    let section = $(this).data('section');
    if (isChecked) {
        $(`.parking-creator > .center > div > #house-garage-menu-menu > .settings #${section}`).addClass('active');
        $(`.parking-creator > .center > div > #house-garage-menu-menu > .settings #${section} > div > input`).prop('disabled', false);
        $(`.parking-creator > .center > div > #house-garage-menu-menu > .settings > #${section} select`).prop('disabled', false);
    } else {
        $(`.parking-creator > .center > div > #house-garage-menu-menu > .settings #${section}`).removeClass('active');
        $(`.parking-creator > .center > div > #house-garage-menu-menu > .settings #${section} > div > input`).prop('disabled', true);
    }
});


$(document).on('click', '.parking-creator > .center > div > #parking-menu .save', function (e) {
    // Main Settings:
    let parkingLabel = $('.parking-creator > .center > div > #parking-menu > .settings > #main-settings-section > div[data-name="label"] > input').val();
    let vehicleType = $('.parking-creator>.center>div>#parking-menu>.settings>#main-settings-section div[data-name="type"] select').val();

    // Parking meter:
    let useParkingmeter = $('.parking-creator > .center > div > #parking-menu > .settings > .section-label input[data-section="parkingmeter-section"]').is(':checked');
    let parkingmeterPrice = $('.parking-creator > .center > div > #parking-menu > .settings > #parkingmeter-section > div[data-name="price"] > input').val();

    // Rent:
    let useRent = $('.parking-creator > .center > div > #parking-menu > .settings > .section-label input[data-section="rent-section"]').is(':checked');
    let rentPrice = $('.parking-creator > .center > div > #parking-menu > .settings > #rent-section > div[data-name="price"] > input').val();
    let rentDays = [];
    if (useRent) {
        for (const [k, v] of Object.entries(rentDaysTags.value)) {
            rentDays.push(v.value)
        }
    }

    // NPC:
    let useNPC = $('.parking-creator > .center > div > #parking-menu > .settings > .section-label input[data-section="npc-section"]').is(':checked');
    let npcModel = $('.parking-creator > .center > div > #parking-menu > .settings > #npc-section > div[data-name="npc-model"] > input#npc-model').val();
    let npcAnimName = $('.parking-creator > .center > div > #parking-menu > .settings > #npc-section > div[data-name="npc-animation"] > input#anim-name').val();
    let npcAnimDict = $('.parking-creator > .center > div > #parking-menu > .settings > #npc-section > div[data-name="npc-animation"] > input#anim-dict').val();

    // Company:
    let useCompany = $('.parking-creator > .center > div > #parking-menu > .settings  .section-label input[data-section="company-section"]').is(':checked');
    let company = [];
    if (useCompany) {
        for (const [k, v] of Object.entries(companyJobsTags.value)) {
            company.push(v.value)
        }
    }

    // Gang:
    let useGang = $('.parking-creator > .center > div > #parking-menu > .settings .section-label input[data-section="gang-section"]').is(':checked');
    let gangs = [];
    if (useGang) {
        for (const [k, v] of Object.entries(gangJobsTags.value)) {
            gangs.push(v.value)
        }
    }

    // Allowed Models:
    let useAllowedModels = $('.parking-creator > .center > div > #parking-menu > .settings > .section-label input[data-section="allowed-models-section"]').is(':checked');
    let allowedModels = [];
    if (useAllowedModels) {
        for (const [k, v] of Object.entries(allowedModelsTags.value)) {
            allowedModels.push(v.value)
        }
    }

    $.post(`https://${GetParentResourceName()}/creatorAction`, JSON.stringify({
        action: "save",

        type: ParkingCreator.selectedParkingType,

        label: parkingLabel,
        vehType: vehicleType,
        
        useParkingmeter: useParkingmeter,
        parkingmeterPrice: useParkingmeter && parkingmeterPrice,
        
        useRent: useRent,
        rentPrice: useRent && rentPrice,
        rentDays: useRent && rentDays,

        useNPC: useNPC,
        npcModel: useNPC && npcModel,
        npcAnimName: useNPC && npcAnimName,
        npcAnimDict: useNPC && npcAnimDict,

        useCompany: useCompany,
        company: useCompany && company,

        useGang: useGang,
        gangs: useGang && gangs,

        useAllowedModels: useAllowedModels,
        allowedModels: useAllowedModels && allowedModels,
        
    }));
})

$(document).on('click', '.parking-creator > .center > div > #garage-menu .save', function (e) {
    // Main Settings:
    let parkingLabel = $('.parking-creator > .center > div > #garage-menu > .settings > #main-settings-section > div[data-name="label"] > input').val();
    let vehicleType = $('.parking-creator>.center>div>#garage-menu>.settings>#main-settings-section div[data-name="type"] select').val();

    let useCheckAreaOccupied = $('.parking-creator > .center > div > #garage-menu > .settings > .section-label input[data-section="check-area-occupied-settings"]').is(':checked');
    
    let useCompany = $('.parking-creator > .center > div > #garage-menu > .settings .section-label input[data-section="company-section"]').is(':checked');
    let useGang = $('.parking-creator > .center > div > #garage-menu > .settings .section-label input[data-section="gang-section"]').is(':checked');
    let companies = [];
    let gangs = [];
    let predefinedModels = [];
    let allowedModels = [];
    if (useCompany) {
        for (const [k, v] of Object.entries(companyTags.value)) {
            companies.push(v.value)
        }
        for (const [k, v] of Object.entries(predefinedModelsTags.value)) {
            predefinedModels.push(v.value)
        }
        for (const [k, v] of Object.entries(garageAllowedModelsTags.value)) {
            allowedModels.push(v.value)
        }
    }
    if (useGang) {
        for (const [k, v] of Object.entries(gangTags.value)) {
            gangs.push(v.value)
        }
        for (const [k, v] of Object.entries(predefinedModelsTags.value)) {
            predefinedModels.push(v.value)
        }
        for (const [k, v] of Object.entries(garageAllowedModelsTags.value)) {
            allowedModels.push(v.value)
        }
    }

    $.post(`https://${GetParentResourceName()}/creatorAction`, JSON.stringify({
        action: "save",

        type: ParkingCreator.selectedParkingType,

        label: parkingLabel,
        vehType: vehicleType,
        
        useCheckAreaOccupied: useCheckAreaOccupied,

        useCompany: useCompany,
        useGang: useGang,
        companies: useCompany && companies,
        gangs: useGang && gangs,
        predefinedModels: (useCompany || useGang) && predefinedModels,
        allowedModels: (useCompany || useGang) && allowedModels,
    }));
})

$(document).on('click', '.parking-creator > .center > div > #house-garage-menu .save', function (e) {
    let routingBucket = $('.parking-creator > .center > div > #house-garage-menu > .settings > #routingbucket-section > div[data-name="routingbucket"] > input').val();
    
    $.post(`https://${GetParentResourceName()}/creatorAction`, JSON.stringify({
        action: "save",
        type: ParkingCreator.selectedParkingType,
        routingBucket: routingBucket,
    }));
})

$(document).on('click', '.parking-creator > .center > div > #house-garage-menu-menu .save', function (e) {
    // Main Settings:
    let parkingLabel = $('.parking-creator > .center > div > #house-garage-menu-menu > .settings > #main-settings-section > div[data-name="label"] > input').val();
    let vehicleType = $('.parking-creator>.center>div>#house-garage-menu-menu>.settings>#main-settings-section div[data-name="type"] select').val();

    let useVehiclesLimit = $('.parking-creator>.center>div>#house-garage-menu-menu>.settings>#main-settings-section input[type="checkbox"]').is(':checked');
    let vehiclesLimit = $('.parking-creator>.center>div>#house-garage-menu-menu>.settings>#main-settings-section #vehicles-limit-section>div>input').val();

    let useCheckAreaOccupied = $('.parking-creator > .center > div > #house-garage-menu-menu > .settings > .section-label input[data-section="check-area-occupied-settings"]').is(':checked');
    
    $.post(`https://${GetParentResourceName()}/creatorAction`, JSON.stringify({
        action: "save",

        type: ParkingCreator.selectedParkingType,

        label: parkingLabel,
        vehType: vehicleType,
        vehiclesLimit: useVehiclesLimit && vehiclesLimit,
        
        useCheckAreaOccupied: useCheckAreaOccupied,
    }));
})


$(document).on('click', '.parking-creator > .center > div > #garage-interior-menu .save', function (e) {
    // Main Settings:
    let parkingLabel = $('.parking-creator > .center > div > #garage-interior-menu > .settings > #main-settings-section > div[data-name="label"] > input').val();
    let vehicleType = $('.parking-creator>.center>div>#garage-interior-menu>.settings>#main-settings-section div[data-name="type"] select').val();
    
    let routingBucket = $('.parking-creator > .center > div > #garage-interior-menu > .settings > #routingbucket-section > div[data-name="routingbucket"] > input').val();
    
    $.post(`https://${GetParentResourceName()}/creatorAction`, JSON.stringify({
        action: "save",

        type: ParkingCreator.selectedParkingType,
        
        label: parkingLabel,
        vehType: vehicleType,
        
        routingBucket: routingBucket,
    }));
})

