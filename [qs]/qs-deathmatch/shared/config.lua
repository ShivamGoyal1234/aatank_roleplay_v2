--[[
    Welcome to the qb-deathmatch configuration!
    To start configuring your new asset, please read carefully
    each step in the documentation that we will attach at the end of this message.

    Each important part of the configuration will be highlighted with a box.
    like this one you are reading now, where I will explain step by step each
    configuration available within this file.

    This is not all, most of the settings, you are free to modify it
    as you wish and adapt it to your framework in the most comfortable way possible.
    The configurable files you will find all inside client/custom/*
    or inside server/custom/*.

    Direct link to the resource documentation, read it before you start:
    https://docs.quasar-store.com/
]]

Config = Config or {}
Locales = Locales or {}

--[[
    The first thing will be to choose our main language, here you can choose
    between the default languages that you will find within locales/*,
    if yours is not there, feel free to create it!

	Languages available by default:
        'ar'
        'bg'
        'ca'
        'cs'
        'da'
        'de'
        'el'
    	'en'
    	'es'
        'fa'
        'fr'
        'he'
        'hi'
        'hu'
        'it'
        'jp'
        'ko'
        'nl'
        'no'
        'pl'
        'pt'
        'ro'
        'ru'
        'sl'
        'sv'
        'th'
        'tk'
        'tr'
        'zh'
]]

Config.Language = 'en'

--[[
    The current system will detect if you use qb-core or es_extended,
    but if you rename it, you can remove the value from Config.Framework
    and add it yourself after you have modified the framework files inside
    this script.

    Please keep in mind that this code is automatic, do not edit if
    you do not know how to do it.
]]

local frameworks = {
    ['es_extended'] = 'esx',
    ['qb-core'] = 'qb',
    ['qbx_core'] = 'qb'
}

local function dependencyCheck(data)
    for k, v in pairs(data) do
        if GetResourceState(k) == 'started' then
            return v
        end
    end
    return false
end

Config.Framework = dependencyCheck(frameworks) or 'standalone'

--[[  
	Automatic ambulance system check!
]]

local ambulances = {
	['qb-ambulancejob'] = 'qb',
	['esx_ambulancejob'] = 'esx',
	['wasabi_ambulance'] = 'wasabi',
	['ars_ambulancejob'] = 'ars',
	['qbx_medical'] = 'qbx'
}

Config.Ambulance = dependencyCheck(ambulances)

--[[  
    This section is configurable for inventory locking during Deathmatch. It depends on your inventory system, as it requires multiple events from it.
    To configure another inventory system, simply replicate these steps in client/custom/inventory/* and you're done!

	Only recomended edit in ox, nothing more.
]]

local inventories = {
	['ox_inventory'] = 'ox',
}

Config.Inventory = dependencyCheck(inventories)

--[[  
    This section allows customization of the Deathmatch entrance spot, including coordinates and the blip on the map.
    If you prefer not to use a static entrance spot, you can disable `Config.SpotEnable` and instead use the `dmopen` command with `ExecuteCommand`.
    
    Example:
    
    -- Disabling the spot
    Config.SpotEnable = false
    

    -- You can then bind this command to a key or trigger it from another event
]]


Config.SpotEnable = true

Config.Marker = {
	DrawDistance = 10,
	Pos = vector3(-264.70, -2017.30, 30.15),
	Type = 1,
	Size = vector3(5.5, 5.5, 1.5),
	Color = { r = 255, g = 255, b = 255 }
}

Config.Blip = {
	Enable = true,
	SetBlipSprite = 437,
	SetBlipScale = 0.5,
	SetBlipColour = 36,
}

--[[  
    This section defines the coordinates and settings for the characters that will be displayed before the match starts, including their posing animations and cinematic camera.
    
    - `Config.InvisibleSpawnCoords`: This is where the player will be spawned but remain invisible while the cinematic camera focuses on the characters.
    
    - `Config.PedSpawnLocs`: These are the coordinates where each character will spawn and pose before the match. Each entry consists of a `vec4` format with x, y, z coordinates and a heading to determine the direction the character will face.

    - `Config.CamPos`: This defines the position of the cinematic camera that will focus on the characters. The camera will be set up here to create a dynamic pre-match scene.

    - `Config.Anims`: A list of animations that the characters will perform while posing. Each animation includes:
      - `dict`: The animation dictionary.
      - `name`: The specific animation name.

    These settings allow for a cinematic presentation of the characters before the match begins. You can customize the camera, character positions, and animations to create the desired pre-match atmosphere.
]]

Config.InvisibleSpawnCoords = vec3(1170.10, -1264.40, 20.25)
Config.PedSpawnLocs = {
	[1] = vec4(1127.20, -1263.80, 19.60, 44.13),
	[2] = vec4(1129.10, -1263.40, 19.65, 44.13),
	[3] = vec4(1127.10, -1264.90, 19.60, 44.13),
	[4] = vec4(1128.30, -1263.70, 19.75, 44.13),
	[5] = vec4(1126.80, -1265.90, 19.60, 44.13),
}

Config.CamPos = vec3(1126.08, -1262.42, 21.0)
Config.Anims = {
	{
		dict = 'anim@amb@nightclub@peds@',
		name = 'rcmme_amanda1_stand_loop_cop'
	},
	{
		dict = 'mp_player_int_uppergang_sign_a',
		name = 'mp_player_int_gang_sign_a'
	},
	{
		dict = 'amb@world_human_leaning@male@wall@back@foot_up@idle_a',
		name = 'idle_a'
	},
	{
		dict = 'amb@world_human_stupor@male@idle_a',
		name = 'idle_a'
	},
	{
		dict = 'anim@mp_player_intupperslow_clap',
		name = 'idle_a'
	},
	{
		dict = 'rcmbarry',
		name = 'base'
	},
	{
		dict = 'anim@mp_player_intupperthumbs_up',
		name = 'idle_a'
	},
	{
		dict = 'rcmnigel1a',
		name = 'base'
	},
}

--[[  
    This section configures the maps that are eligible for Deathmatch. It defines the spawn points for both teams, the enemy teams, and the playable areas for each map.
    
    - `Config.MapData`: Contains the data for each map, including:
        - `team1` and `team2`: These are the spawn coordinates for each team at the start of the match.
        - `eteam1` and `eteam2`: Coordinates for the enemy team spawns.
        - `area`: Defines the playable area for the map, including its position and size, using `Pos` and `Size`.
    
    To customize or add more maps, you can edit this Lua file and define the new map coordinates as shown in the examples.

    **HTML/JS Configuration:**
    
    To add new maps visually, go to `html/js/config/*`. There, the `maps` array lists the available maps with their names and images. 
    Each map has:
    - `name`: The name of the map that will be displayed in the selection UI.
    - `img`: The image file representing the map in the UI.

    Example JS structure:
    ```javascript
    const maps = [
      { name: "All", img: "all.png" },
      { name: "Cargo", img: "cargo.png" },
      { name: "Bank", img: "bank.png" },
      { name: "1v1", img: "1v1.png" },
      // Add new maps here by following this format.
    ];

    export default maps;
    ```

    To add a new map:
    1. Add its configuration in this Lua file (`Config.MapData`).
    2. Update the `maps` array in the JS file to include the new map name and image.
    3. Ensure the image file is present in the correct folder for the UI.

    This will allow the new map to be selectable in the Deathmatch menu, with all necessary settings for spawn points and playable areas.
]]

Config.Timer = 420 -- Game duration time (default 420 seconds)

Config.MapData = {
	['bank'] = {
		['team1'] = { x = 244.43, y = 202.98, z = 105.21, h = 73.86 },
		['team2'] = { x = 254.34, y = 225.39, z = 106.29, h = 163.04 },
		['eteam1'] = { x = 222.06, y = 210.99, z = 105.55, h = 158.26 },
		['eteam2'] = { x = 220.76, y = 206.79, z = 105.47, h = 340.43 },
		['area'] =
		{
			['Pos'] = { x = 249.33, y = 217.76, z = 100.29 },
			['Size'] = { x = 80.0, y = 80.0, z = 10.0 },
		},
	},
	['bimeh'] = {
		['team1'] = { x = -1085.06, y = -256.12, z = 37.76, h = 301.06 },
		['team2'] = { x = -1057.03, y = -239.54, z = 44.02, h = 115.0 },
		['eteam1'] = { x = -1088.07, y = -257.55, z = 37.76, h = 301.6 },
		['eteam2'] = { x = -1077.77, y = -247.37, z = 37.76, h = 112.74 },
		['area'] =
		{
			['Pos'] = { x = -1075.87, y = -243.6, z = 30.02 },
			['Size'] = { x = 90.0, y = 90.0, z = 20.0 },
		},
	},
	['cargo'] = {
		['team1'] = { x = -1022.21, y = 4937.08, z = 200.93, h = 143.32 },
		['team2'] = { x = -1093.72, y = 4942.15, z = 218.33, h = 158.38 },
		['eteam1'] = { x = -1096.51, y = 4906.76, z = 215.31, h = 331.95 },
		['eteam2'] = { x = -1093.16, y = 4914.79, z = 215.2, h = 156.72 },
		['area'] =
		{
			['Pos'] = { x = -1076.06, y = 4912.23, z = 150.97 },
			['Size'] = { x = 135.0, y = 135.0, z = 200.0 },
		},
	},
	['skyscraper'] = {
		['team1'] = { x = -168.86, y = -1011.97, z = 254.13, h = 341.67 },
		['team2'] = { x = -139.52, y = -952.93, z = 254.13, h = 159.49 },
		['eteam1'] = { x = -161.05, y = -995.09, z = 254.13, h = 340.75 },
		['eteam2'] = { x = -158.08, y = -988.08, z = 254.13, h = 157.8 },
	},
	['vangelico'] = {
		['team1'] = { x = -657.12, y = -224.75, z = 37.73, h = 239.59 },
		['team2'] = { x = -624.62, y = -232.57, z = 38.06, h = 127.25 },
		['eteam1'] = { x = -642.56, y = -234.65, z = 37.86, h = 214.79 },
		['eteam2'] = { x = -634.0, y = -244.53, z = 38.28, h = 41.4 },
		['area'] =
		{
			['Pos'] = { x = -623.36, y = -231.63, z = 30.06 },
			['Size'] = { x = 80.0, y = 80.0, z = 40.0 },
		},
	},
	['shop1'] = {
		['team1'] = { x = 15.45, y = -1337.38, z = 30.28, h = 184.14 },
		['team2'] = { x = 26.56, y = -1344.42, z = 30.5, h = 176.61 },
		['eteam1'] = { x = 21.08, y = -1359.66, z = 30.34, h = 266.82 },
		['eteam2'] = { x = 36.08, y = -1359.75, z = 30.32, h = 88.62 },
		['area'] =
		{
			['Pos'] = { x = 28.88, y = -1345.42, z = 20.5 },
			['Size'] = { x = 32.0, y = 32.0, z = 50.0 },
		},
	},
	['shop2'] = {
		['team1'] = { x = -1212.56, y = -889.79, z = 13.86, h = 122.04 },
		['team2'] = { x = -1224.69, y = -906.18, z = 12.33, h = 30.27 },
		['eteam1'] = { x = -1224.24, y = -891.71, z = 13.43, h = 119.16 },
		['eteam2'] = { x = -1236.63, y = -898.79, z = 13.02, h = 300.62 },
		['area'] =
		{
			['Pos'] = { x = -1221.6, y = -911.33, z = 5.33 },
			['Size'] = { x = 70.0, y = 70.0, z = 50.0 },
		},
	},
	['1v1'] = {
		['team1'] = { x = -2100.9, y = 3095.54, z = 32.81, h = 332.33 },
		['team2'] = { x = -2074.5, y = 3141.4, z = 32.81, h = 148.7 },
		['eteam1'] = { x = -2100.78, y = 3095.96, z = 33.81, h = 327.91 },
		['eteam2'] = { x = -2096.8, y = 3102.9, z = 33.81, h = 158.88 },
		['area'] =
		{
			['Pos'] = { x = -2087.34, y = 3118.99, z = 15.71 },
			['Size'] = { x = 70.0, y = 70.0, z = 60.0 },
		},
	},
}

--[[  
    Do not use `Config.Debug` unless you are an administrator.
    This setting is only for displaying helpful debug messages and should not be enabled for regular players.
    It provides additional information that is useful for testing and troubleshooting, but could clutter the gameplay experience.
]]

Config.Debug = false