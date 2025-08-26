Locations = Locations or {}

--[[ LS CUSTOMS NEAR AIRPORT ]]--
--[[ Default Location ]]--

Locations["lscustoms_airport"] = {
    Enabled = false,
    autoClock = { enter = false, exit = false, },
    job = "mechanic",
    label = "BENNY'S",
    logo = "https://static.wikia.nocookie.net/gtawiki/images/f/f2/GTAV-LSCustoms-Logo.png",
    zones = {
        vec2(-958.68389892578, -2078.2495117188),
        vec2(-945.34881591797, -2078.3391113281),
        vec2(-889.09722900391, -2032.423828125),
        vec2(-931.94970703125, -1986.6008300781),
        vec2(-999.69293212891, -2054.0905761719)
    },
    blip = {
        coords = vec3(-920.65, -2044.60, 14.45),
        color = 81,
        sprite = 681,
        disp = 6,
        scale = 0.7,
        cat = nil,
        previewImg = "https://i.imgur.com/kKC2Mw2.png",
    },
    Stash = {
        {   coords = vec4(-933.58, -2036.95, 9.05, 133.81), width = 1.6, depth = 1.0,
            label = "Mech Stash: ", icon = "fas fa-cogs",
            slots = 50, maxWeight = 4000000,
        },
    },
    PersonalStash = {
        {   coords = vec4(-934.78, -2035.80, 9.05, 136.67), width = 0.2, depth = 1.2, minZ = 12.18, maxZ = 14.58,
            label = "Personal Stash",
            icon = "fas fa-box-open",
            stashName = "airportLSCustoms_Personal_",
        },
    },
    Shop = {
        {   coords = vec4(-929.20849609375, -2050.3393554688, 8.0500268936157, 315.0), width = 1.6, depth = 1.0,
            label = "Shop", icon = "fas fa-box-open",
        },
        {   coords = vec4(-933.82, -2051.94, 9.25, 134.73), width = 1.6, depth = 1.0,
            label = "Shop 2", icon = "fas fa-box-open",
        },
        {   coords = vec4(-957.18646240234, -2025.3118896484, 8.0500259399414, 44.999980926514), width = 1.6, depth = 1.0,
            label = "Shop 3", icon = "fas fa-box-open",
        },
        {   coords = vec4(-952.60, -2031.69, 9.05, 230.35), width = 1.6, depth = 1.0,
            label = "Shop 4", icon = "fas fa-box-open",
        },
        {   coords = vec4(-961.65411376953, -2034.5610351562, 8.0500259399414, 315.0), width = 1.6, depth = 1.0,
            label = "Shop 5", icon = "fas fa-box-open",
        },
        {   coords = vec4(-971.60717773438, -2044.4145507812, 8.0550260543823, 135.0), width = 1.6, depth = 1.0,
            label = "Shop 6", icon = "fas fa-box-open",
        },
        {   coords = vec4(-946.56, -2019.16, 9.51, 39.15), width = 1.6, depth = 1.0,
            label = "Shop 7", icon = "fas fa-box-open",
        },
       
    },
    Crafting = {
        {	coords = vec4(127.10, -3021.59, 7.04, 0.95), width = 0.6, depth = 1.0,
            label = "Mechanic Crafting", icon = "fas fa-screwdriver-wrench",
        },
    },
    Clockin = { },
    BossMenus = {
        {   prop = { model = "prop_laptop_01a", coords = vec4(-921.25408935547, -2044.216796875, 14.256464004517, 235.92007446289), },
            label = "Open Bossmenu", icon = "fas fa-list",
        },
    },
    BossStash = {
        {   prop = { model = "", coords = vec4(-921.76, -2046.60, 14.45, 311.73) },
            label = "Boss Stash", icon = "fas fa-vault",
            stashName = "airportLSCustoms_BossStorage", stashLabel = "Boss Stash",
            slots = 80, maxWeight = 1000000
        },
    },
    manualRepair = {
        { 	prop = { model = "xm3_prop_xm3_tool_draw_01d", coords = vec4(0, 0, 0, 0), },
            label = "Manual Repair", icon = "fas fa-cogs",
        },
    },
    nosRefill = {
		{   prop = { model = "prop_byard_gastank02", coords = vec4(123.98, -3035.37, 7.04, 122.20), },
			label = "Refill NOS", icon = "fas fa-list",
		},
    },
    Payments = {
        {   prop = { model = "", coords = vec4(-920.95, -2034.57, 10.30, 43.36), },
            label = "Charge", icon = "fas fa-credit-card",
        },
    },
    carLift = {
		{ coords = vec4(-1161.27, -2014.98, 13.18, 135.01) },
	},
    garage = { -- requires https://github.com/jimathy/jim-jobgarage
        spawn = vec4(0, 0, 0, 0),
        out = vec4(0, 0, 0, 0),
        list = { "towtruck", "panto", "slamtruck", "cheburek", "utillitruck3" },
        prop = true,
    },
    Restrictions = { -- Remove what you DON'T what the location to be able to edit
        Vehicle = { "Compacts", "Sedans", "SUVs", "Coupes", "Muscle", "Sports Classics", "Sports", "Super", "Motorcycles", "Off-road", "Industrial", "Utility", "Vans", "Cycles", "Service", "Emergency", "Commercial", "Boats", },
        Allow = { "tools", "cosmetics", "repairs", "nos", "perform", "chameleon", "paints" },
    },
    discord = {
        link = "",
        color = 2571775,
    },
}