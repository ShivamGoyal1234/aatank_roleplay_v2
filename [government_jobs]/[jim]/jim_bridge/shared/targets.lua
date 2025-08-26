--[[
    Experimental GTA In-World Text Prompts Targets Module
    -------------------------------------------------------
    This module handles the creation, removal, and management of in-world text targets
    for interacting with entities and zones using GTA text prompts. It supports multiple
    targeting systems: OX Target, QB Target, or a fallback using DrawText3D.

    Available functionalities:
      • createEntityTarget   - Creates a target for a specific entity.
      • createBoxTarget      - Creates a box-shaped zone target.
      • createCircleTarget   - Creates a circular zone target.
      • createModelTarget    - Creates a target for specified models.
      • removeEntityTarget   - Removes a target from an entity.
      • removeZoneTarget     - Removes a zone target.

    Fallback: If no targeting system is detected (or if disabled via Config.System.DontUseTarget),
              the module uses DrawText3D prompts. This is experimental and may not work as expected.
]]

-------------------------------------------------------------
-- Utility Data & Tables
-------------------------------------------------------------


-- Tables for storing created targets for the fallback system and zone management.
local TextTargets    = {}   -- For fallback DrawText3D targets.
local targetEntities = {}   -- For entity targets.
local boxTargets     = {}   -- For box-shaped zone targets.
local circleTargets  = {}   -- For circular zone targets.

-------------------------------------------------------------
-- Entity Target Creation
-------------------------------------------------------------

--- Creates a target for an entity with specified options and interaction distance.
--- Supports different targeting systems (OX Target, QB Target, or custom DrawText3D)
--- based on the server configuration.
---
--- @param entity number The entity ID for which the target is created.
--- @param opts table Array of option tables. Each option should include:
---        - icon (string): The icon to display.
---        - label (string): The text label for the option.
---        - item (string|nil): (Optional) An associated item.
---        - job (string|nil): (Optional) The job required to interact.
---        - gang (string|nil): (Optional) The gang required to interact.
---        - action (function|nil): (Optional) The function executed on selection.
--- @param dist number The interaction distance for the target.
---
--- @usage
--- ```lua
---createEntityTarget(entityId, {
---   {
---       action = function()
---           openStorage()
---       end,
---       icon = "fas fa-box",
---       job = "police",
---       label = "Open Storage",
---   },
---}, 2.0)
--- ```
function createEntityTarget(entity, opts, dist)
    -- Store the target entity for later cleanup.
    targetEntities[#targetEntities + 1] = entity

    -- Fallback: Use DrawText3D if targeting systems are disabled or unavailable.
    if Config.System.DontUseTarget or (not isStarted(OXTargetExport) and not isStarted(QBTargetExport)) then
        debugPrint("^6Bridge^7: ^2Creating new ^3Entity ^2target with ^6"..OXTargetExport.." ^2for entity ^7"..entity)
        exports.jim_bridge:createEntityTarget(entity, opts, dist)

    elseif isStarted(OXTargetExport) then
        debugPrint("^6Bridge^7: ^2Creating new ^3Entity ^2target with ^6"..OXTargetExport.." ^2for entity ^7"..entity)
        local options = {}
        for i = 1, #opts do
            options[i] = {
                icon = opts[i].icon,
                label = opts[i].label,
                items = opts[i].item or nil,
                groups = opts[i].job or opts[i].gang,
                onSelect = opts[i].action,
                distance = dist,
                canInteract = opts[i].canInteract or nil,
            }
        end
        exports[OXTargetExport]:addLocalEntity(entity, options)

    elseif isStarted(QBTargetExport) then
        debugPrint("^6Bridge^7: ^2Creating new ^3Entity ^2target with ^6"..QBTargetExport.." ^2for entity ^7"..entity)
        local options = { options = opts, distance = dist }
        exports[QBTargetExport]:AddTargetEntity(entity, options)

    end
end

-------------------------------------------------------------
-- Box Zone Target Creation
-------------------------------------------------------------

--- Creates a box-shaped target zone with specified options and interaction distance.
--- Supports different targeting systems based on the server configuration.
---@param data table A table containing the box zone configuration.
---     - name (`string`): The name identifier for the zone.
---     - coords (`vector3`): The center coordinates of the box.
---     - width (`number`): The width of the box.
---     - height (`number`): The height of the box.
---     - options (`table`): A table with additional options:
---     - heading (`number`): The rotation angle of the box.
---     - debugPoly (`boolean`): Whether to enable debug mode for the zone.
---
---@param opts table A table of option configurations for the target.
---     - icon (`string`): The icon to display for the option.
---     - label (`string`): The label text for the option.
---     - item (`string|nil`): (Optional) The item associated with the option.
---     - job (`string|nil`): (Optional) The job required to interact with the option.
---     - gang (`string|nil`): (Optional) The gang required to interact with the option.
---     - onSelect (`function|nil`): (Optional) The function to execute when the option is selected.
---@param dist number The interaction distance for the target.
---
---@return string|table name identifier or target object of the created zone.
---
---@usage
---```lua
---createBoxTarget(
---   {
---       'storageBox',
---       vector3(100.0, 200.0, 30.0),
---       2.0,
---       2.0,
---       {
---           name = 'storageBox',
---           heading = 100.0,
---           debugPoly = true,
---           minZ = 27.0,
---           maxZ = 32.0,
---       },
---   },
---{
---   {
---       action = function()
---           openStorage()
---       end,
---       icon = "fas fa-box",
---       job = "police",
---       label = "Open Storage",
---   },
---}, 2.0)
---```
function createBoxTarget(data, opts, dist)
    if Config.System.DontUseTarget or (not isStarted(OXTargetExport) and not isStarted(QBTargetExport)) then
        debugPrint("^6Bridge^7: ^2Creating new ^3Box^2 target with ^6DrawText ^2 for zone ^7"..data[1])
        return exports.jim_bridge:createZoneTarget(data, opts, dist)

    elseif isStarted(OXTargetExport) then
        debugPrint("^6Bridge^7: ^2Creating new ^3Box^2 target with ^6"..OXTargetExport.." ^2for zone ^7"..data[1])
        local options = {}
        for i = 1, #opts do
            options[i] = {
                icon = opts[i].icon,
                label = opts[i].label,
                items = opts[i].item or nil,
                groups = opts[i].groups or opts[i].job or opts[i].gang,
                onSelect = opts[i].onSelect or opts[i].action,
                distance = dist,
                canInteract = opts[i].canInteract or nil,
            }
        end

        data[5].maxZ = data[5].maxZ or (data[2].z + 0.80)
        data[5].minZ = data[5].minZ or data[2].z - 1.05
        local thickness = ((data[5].maxZ / 2) - (data[5].minZ / 2)) * 2
        local mid = data[5].maxZ - ((data[5].maxZ / 2) - (data[5].minZ / 2))

        --if not data[5].useZ then
        --    local z = data[2].z + math.abs(data[5].maxZ - data[5].minZ) / 2
            data[2] = vec3(data[2].x, data[2].y, mid) -- force the coord to middle of the minZ and maxZ
        --end
        local target = exports[OXTargetExport]:addBoxZone({
            coords = data[2],
            size = vec3(data[4], data[3], thickness), -- size uses the math to determine how high it needs to be
            rotation = data[5].heading,
            debug = data[5].debugPoly,
            options = options
        })
        boxTargets[#boxTargets + 1] = target
        return target

    elseif isStarted(QBTargetExport) then
        debugPrint("^6Bridge^7: ^2Creating new ^3Box^2 target with ^6"..QBTargetExport.." ^2for zone ^7"..data[1])
        local options = { options = opts, distance = dist }
        local target = exports[QBTargetExport]:AddBoxZone(data[1], data[2], data[3], data[4], data[5], options)
        boxTargets[#boxTargets + 1] = target
        return data[1]

    end
end

-------------------------------------------------------------
-- Circle Zone Target Creation
-------------------------------------------------------------

--- Creates a circular target zone with specified options and interaction distance.
--- Supports different targeting systems based on server configuration.
---
---@param data table A table containing the circle zone configuration.
---     - name (`string`): The name identifier for the zone.
---     - coords (`vector3`): The center coordinates of the circle.
---     - radius (`number`): The radius of the circle.
---     - options (`table`): A table with additional options:
---     - debugPoly (`boolean`): Whether to enable debug mode for the zone.
---
---@param opts table A table of option configurations for the target.
---     - icon (`string`): The icon to display for the option.
---     - label (`string`): The label text for the option.
---     - item (`string|nil`): (Optional) The item associated with the option.
---     - job (`string|nil`): (Optional) The job required to interact with the option.
---     - gang (`string|nil`): (Optional) The gang required to interact with the option.
---     - onSelect (`function|nil`): (Optional) The function to execute when the option is selected.
---@param dist number The interaction distance for the target.
---
---@return string|table name identifier or target object of the created zone.
---
---@usage
--- ```lua
--- createCircleTarget({
---     name = 'centralPark',
---     coords = vector3(200.0, 300.0, 40.0),
---     radius = 50.0,
---     options = { debugPoly = false }
--- }, {
---     { icon = "fas fa-tree", label = "Relax", action = relaxAction }
--- }, 2.0)
--- ```
function createCircleTarget(data, opts, dist)
    if Config.System.DontUseTarget then
        debugPrint("^6Bridge^7: ^2Creating new ^3Circle ^2target with ^6DrawText ^2for zone ^7"..data[1])
        return exports.jim_bridge:createZoneTarget(data, opts, dist)

    elseif isStarted(OXTargetExport) then
        debugPrint("^6Bridge^7: ^2Creating new ^3Circle ^2target with ^6"..OXTargetExport.." ^2for zone ^7"..data[1])
        local options = {}
        for i = 1, #opts do
            options[i] = {
                icon = opts[i].icon,
                label = opts[i].label,
                items = opts[i].item or nil,
                groups = opts[i].job or opts[i].gang,
                onSelect = opts[i].onSelect or opts[i].action,
                distance = dist,
                canInteract = opts[i].canInteract or nil,
            }
        end
        local target = exports[OXTargetExport]:addSphereZone({
            coords = data[2],
            radius = data[3],
            debug = data[4].debugPoly,
            options = options
        })
        circleTargets[#circleTargets + 1] = target
        return target
    elseif isStarted(QBTargetExport) then
        debugPrint("^6Bridge^7: ^2Creating new ^3Circle ^2target with ^6"..QBTargetExport.." ^2for zone ^7"..data[1])
        local options = { options = opts, distance = dist }
        local target = exports[QBTargetExport]:AddCircleZone(data[1], data[2], data[3], data[4], options)
        circleTargets[#circleTargets + 1] = target
        return data[1]
    end
end

-------------------------------------------------------------
-- Model Target Creation
-------------------------------------------------------------

--- Creates a target for models with specified options and interaction distance.
--- Supports different targeting systems (OX Target, QB Target) based on server configuration.
---
--- @param models table Array of model identifiers.
--- @param opts table Array of option tables (same structure as in createEntityTarget).
--- @param dist number The interaction distance for the target.
---
--- @usage
--- ```lua
---createModelTarget({ model1, model2 },
---{
---   {
---       action = function()
---           openStorage()
---       end,
---       icon = "fas fa-box",
---       job = "police",
---       label = "Open Storage",
---   },
---}, 2.0)
---```
function createModelTarget(models, opts, dist)
    if Config.System.DontUseTarget or (not isStarted(OXTargetExport) and not isStarted(QBTargetExport)) then
        return exports.jim_bridge:createModelTarget(models, opts, dist)

    elseif isStarted(OXTargetExport) then
        debugPrint("^6Bridge^7: ^2Creating new ^3Model^2 target with ^6"..OXTargetExport)
        local options = {}
        for i = 1, #opts do
            options[i] = {
                icon = opts[i].icon,
                label = opts[i].label,
                items = opts[i].item or nil,
                groups = opts[i].job or opts[i].gang,
                onSelect = opts[i].action,
                distance = dist,
                canInteract = opts[i].canInteract or nil,
            }
        end
        exports[OXTargetExport]:addModel(models, options)
    elseif isStarted(QBTargetExport) then
        debugPrint("^6Bridge^7: ^2Creating new ^3Model^2 target with ^6"..QBTargetExport)
        local options = { options = opts, distance = dist }
        exports[QBTargetExport]:AddTargetModel(models, options)
    end
end

-------------------------------------------------------------
-- Target Removal Functions
-------------------------------------------------------------

--- Removes a previously created entity target.
---
--- @param entity number The entity ID whose target should be removed.
---
--- @usage
--- ```lua
--- removeEntityTarget(entityId)
--- ```
function removeEntityTarget(entity)
    if isStarted(QBTargetExport) then
        exports[QBTargetExport]:RemoveTargetEntity(entity)
    end
    if isStarted(OXTargetExport) then
        exports[OXTargetExport]:removeLocalEntity(entity, nil)
    end
    if Config.System.DontUseTarget or (not isStarted(OXTargetExport) and not isStarted(QBTargetExport)) then
        exports.jim_bridge:removeEntityTarget(entity)
    end
end

--- Removes a previously created zone target.
---
--- @param target string|table The name identifier or target object of the zone to remove.
---
--- @usage
--- ```lua
--- removeZoneTarget('centralPark')
--- removeZoneTarget(targetObject)
--- ```
function removeZoneTarget(target)
    if isStarted(QBTargetExport) then
        exports[QBTargetExport]:RemoveZone(target)
    end
    if isStarted(OXTargetExport) then
        exports[OXTargetExport]:removeZone(target, true)
    end
    if Config.System.DontUseTarget or (not isStarted(OXTargetExport) and not isStarted(QBTargetExport)) then
        exports.jim_bridge:removeZoneTarget(target)
    end
end

--- Removes a previously created model target.
---
--- @param model table The model ID whose target should be removed.
---
--- @usage
--- ```lua
--- removeModelTarget(model)
--- ```
function removeModelTarget(model)
    if isStarted(QBTargetExport) then
        exports[QBTargetExport]:RemoveTargetModel(model, "Test")
    end
    if isStarted(OXTargetExport) then
        exports[OXTargetExport]:removeModel(model, nil)
    end
    if Config.System.DontUseTarget or (not isStarted(OXTargetExport) and not isStarted(QBTargetExport)) then
        exports.jim_bridge:removeZoneTarget(target)
    end
end
-------------------------------------------------------------
-- Fallback: DrawText3D Targets (Experimental)
-------------------------------------------------------------

-- If no targeting system is detected and this is a client script, use DrawText3D for targets.
if (Config.System.DontUseTarget or (not isStarted(OXTargetExport) and not isStarted(QBTargetExport))) and not isServer() then
    CreateThread(function()
        while true do
            local ped = PlayerPedId()
            local pedCoords = GetEntityCoords(ped)
            local camCoords = GetGameplayCamCoord()
            local camRot = GetGameplayCamRot(2)
            local camForward = RotationToDirection(camRot)

            local closestTarget = nil
            local closestDist = math.huge
            local targetEntity = nil

            -- Shallow copy for safety
            local targetsCopy = {}
            for k, v in pairs(TextTargets) do
                targetsCopy[k] = v
            end

            -- Detect models and update coords
            for _, target in pairs(targetsCopy) do
                if target.models then
                    if not target.entity or not DoesEntityExist(target.entity) then
                        for _, model in ipairs(target.models) do
                            local entity = GetClosestObjectOfType(pedCoords.x, pedCoords.y, pedCoords.z, target.dist, model, false, false, false)
                            if entity and entity ~= 0 then
                                target.entity = entity
                                target.coords = GetEntityCoords(entity)
                                break
                            end
                        end
                    else
                        target.coords = GetEntityCoords(target.entity)
                    end
                end
            end

            -- Identify closest visible target
            for _, target in pairs(targetsCopy) do
                if target.coords then
                    local dist = #(pedCoords - target.coords)
                    local vecToTarget = target.coords - camCoords
                    local normVec = normalizeVector(vecToTarget)
                    local dot = camForward.x * normVec.x + camForward.y * normVec.y + camForward.z * normVec.z
                    local isFacing = dot > 0.5

                    if dist <= target.dist and isFacing then
                        if dist < closestDist then
                            closestDist = dist
                            closestTarget = target
                            targetEntity = target.entity
                        end
                    end
                end
            end

            -- Render + handle input
            for _, target in pairs(targetsCopy) do
                if target.coords and #(pedCoords - target.coords) <= target.dist then
                    local isClosest = (target == closestTarget)

                    for _, opt in ipairs(target.options) do
                        if IsControlJustPressed(0, opt.key) and isClosest then
                            local canInteract = (not target.canInteract or target.canInteract())
                            local hasItem = (not opt.item or hasItem(opt.item))
                            local hasJob = (not opt.job or hasJob(opt.job, nil))

                            if canInteract and hasItem and hasJob then
                                if opt.onSelect then opt.onSelect(targetEntity) end
                                if opt.action then opt.action(targetEntity) end
                            end
                        end
                    end

                    -- Draw each eligible text line
                    local baseZ = target.coords.z + 1.0
                    local lineHeight = -0.16
                    local lineOffset = 0

                    for i, opt in ipairs(target.options) do
                        local canInteract = (not target.canInteract or target.canInteract())
                        local hasItem = (not opt.item or hasItem(opt.item))
                        local hasJob = (not opt.job or hasJob(opt.job, nil))

                        if canInteract and hasItem and hasJob then
                            local text = target.buttontext[i]
                            local zOffset = lineOffset * lineHeight
                            DrawText3D(vec3(target.coords.x, target.coords.y, baseZ + zOffset), text, isClosest)
                            lineOffset += 1
                        end
                    end
                end
            end


            Wait(0)
        end
    end)
end


function ShowFloatingHelpNotification(coord, text, highlight)
    AddTextEntry("FloatingText", text)
    SetFloatingHelpTextWorldPosition(1, coord.x, coord.y, coord.z)
    SetFloatingHelpTextStyle(1, 1, 62, -1, 3, 0)
    BeginTextCommandDisplayHelp("FloatingText")
    EndTextCommandDisplayHelp(2, false, false, -1)
end

function updateCachedText(target)
    target.text = table.concat(target.buttontext, "\n")
end

-------------------------------------------------------------
-- Cleanup on Resource Stop
-------------------------------------------------------------

-- When the current resource stops, remove all targets.
onResourceStop(function()
    -- Remove entity targets.
    for i = 1, #targetEntities do
        if isStarted(OXTargetExport) then
            exports[OXTargetExport]:removeLocalEntity(targetEntities[i], nil)
        elseif isStarted(QBTargetExport) then
            exports[QBTargetExport]:RemoveTargetEntity(targetEntities[i])
        end
    end
    -- Remove box zone targets.
    for i = 1, #boxTargets do
        if isStarted(OXTargetExport) then
            exports[OXTargetExport]:removeZone(boxTargets[i], true)
        elseif isStarted(QBTargetExport) then
            exports[QBTargetExport]:RemoveZone(boxTargets[i].name)
        end
    end
    -- Remove circle zone targets.
    for i = 1, #circleTargets do
        if isStarted(OXTargetExport) then
            exports[OXTargetExport]:removeZone(circleTargets[i], true)
        elseif isStarted(QBTargetExport) then
            exports[QBTargetExport]:RemoveZone(circleTargets[i].name)
        end
    end
end, true)