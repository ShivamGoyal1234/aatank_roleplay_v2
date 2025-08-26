# 0R-IDCARD

#Step 1

put items to your inventory

#Step 2 

put resource to your resources files and go to server.cfg after that type ensure 0r_idcard

#First Note

for new update we removed all databases, if you want to work your script correctly you need to get your cards again.

if you want to give id card, driver license or weapons license on first created character you can use this triggers:

for id card : 

local shot = exports['0r_idcard']:GetBase64(PlayerPedId())
TriggerServerEvent("0r_idcard:server:createCard", shot, "citizen")

for driver license : 

local shot = exports['0r_idcard']:GetBase64(PlayerPedId())
TriggerServerEvent("0r_idcard:server:createCard", shot, "driver") 

for weapons license : 

local shot = exports['0r_idcard']:GetBase64(PlayerPedId())
TriggerServerEvent("0r_idcard:server:createCard", shot, "weapon") 

#Second Note

- change your weapon_license item name from your items like this: weapons_license

- Script will work for only if you and your players get the cards from peds.

## QB Items

```lua
id_card  = { name  =  'id_card', label  =  'ID Card', weight  =  0, type  =  'item', image  =  'id_card.png', unique  =  true, useable  =  true, shouldClose  =  true, description  =  'A card containing all your information to identify yourself' },
job_card  = { name  =  'job_card', label  =  'Job ID Card', weight  =  0, type  =  'item', image  =  'id_card.png', unique  =  true, useable  =  true, shouldClose  =  true, description  =  'A card containing all your information to identify yourself' },
fake_id_card  = { name  =  'fake_id_card', label  =  'Fake ID Card', weight  =  0, type  =  'item', image  =  'id_card.png', unique  =  true, useable  =  true, shouldClose  =  true, description  =  'A card containing all your information to identify yourself' },
fake_job_card  = { name  =  'fake_job_card', label  =  'Fake Job ID Card', weight  =  0, type  =  'item', image  =  'id_card.png', unique  =  true, useable  =  true, shouldClose  =  true, description  =  'A card containing all your information to identify yourself' },
driver_license  = { name  =  'driver_license', label  =  'Drivers License', weight  =  0, type  =  'item', image  =  'driver_license.png', unique  =  true, useable  =  true, shouldClose  =  true, description  =  'Permit to show you can drive a vehicle' },
weapons_license  = { name  =  'weapons_license', label  =  'Weapon License', weight  =  0, type  =  'item', image  =  'weapon_license.png', unique  =  true, useable  =  true, shouldClose  =  true, description  =  'Permit to show you can use weapon' },
```

## OX Items

```lua
['id_card'] = {
    label = 'ID Card',
    weight = 1,
    stack = false,
    close = true
},
['job_card'] = {
    label = 'Job Card',
    weight = 1,
    stack = false,
    close = true
},
['fake_id_card'] = {
    label = 'Fake ID Card',
    weight = 1,
    stack = false,
    close = true
},
['fake_job_card'] = {
    label = 'Fake Job Card',
    weight = 1,
    stack = false,
    close = true
},
['driver_license'] = {
    label = 'Drivers License',
    weight = 1,
    stack = false,
    close = true
},
['weapons_license'] = {
    label = 'Weapon License',
    weight = 1,
    stack = false,
    close = true
},
```
