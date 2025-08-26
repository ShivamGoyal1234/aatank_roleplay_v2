# fd-megaphones

This is a simple optimized FiveM megaphone script, which adds a handheld megaphone, a vehicle megaphone and static megaphones to objects which are specified in the config file.

This script alters the voice range and adds a megaphone effect.

For support just join our [Discord](https://discord.gg/VV6vX2EYW7).

![fd-megaphone](https://cdn.p6n.lol/i/fd-megaphone.png)

# Dependencies
- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_target](https://github.com/overextended/ox_target)
- [pma-voice](https://github.com/AvarianKnight/pma-voice)
- [PolyZone](https://github.com/mkafrin/PolyZone)

# Installation - Standalone
1. Download latest release
2. Drag folder into server resources
3. Edit the config as you please.

# Installation - Framework
1. Download latest release
2. Drag folder into server resources
3. In shared/config.lua specify either QB or QBox as instructed
4. Add item-assets/megaphone.png to your inventorys item icons.
5. Add items to framework.

QB -
Add to your qb-core/shared/items.lua
```lua
 megaphone                     = { name = 'megaphone', label = 'Megaphone', weight = 500, type = 'item', image = 'megaphone.png', unique = true, useable = true, shouldClose = true, description = 'A usable megaphone' },
```

QBox / ox_inventory -
Add to your ox_inventory/data/items.lua
```lua
["megaphone"] = {
    label = "Megaphone",
    weight = 500,
    stack = false,
    close = true,
    description = "A usable megaphone"
},
```

To use qb-target replace client/microphones.lua with the below code

```lua
local models = Config.models

Citizen.CreateThread(function()
    exports['qb-target']:AddTargetModel(models, { 
    options = { 
        { 
            icon = 'fa-solid fa-microphone', 
            label = 'Use Microphone', 
            action = function(entity)
                createMicPoly(GetEntityModel(entity))
            end,
        }
    },
    distance = 1,
    })
end)
```
