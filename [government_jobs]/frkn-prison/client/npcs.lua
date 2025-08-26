local npcList = FRKN.General.PrisonNPCs
local spawnedNPCs = {}


PrisonDialog = {}

for i = 1, 12 do
    local npcData = FRKN.General.PrisonNPCs[i]
    local status = npcData and npcData.status or 0
    local isGood = status == 1

    local dialogSet = isGood and FRKN.General.PrisonDialogs.goodNpc or FRKN.General.PrisonDialogs.badNpc

    PrisonDialog[i] = {
        npcId = i,
        status = status,
        dialogs = {
            greeting = dialogSet.greeting,
            options = {
                dialogSet.firstOption,
                {
                    label = dialogSet.escapeOption.label,
                    playerText = dialogSet.escapeOption.playerText,
                    npcReply = dialogSet.escapeOption.npcReply,
                    revealsEscapePlan = dialogSet.escapeOption.revealsEscapePlan,
                    alertsGuards = dialogSet.escapeOption.alertsGuards
                }
            }
        }
    }
end

RegisterCommand("npcped", function()
    local model = `s_m_y_prisoner_01`

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end

    SetPlayerModel(PlayerId(), model)
    SetModelAsNoLongerNeeded(model)

    print("Karakter s_m_y_prisoner_01 ped modeline dönüştü.")
end)



Citizen.CreateThread(function()

    for i, data in ipairs(npcList) do
        local success, err = pcall(function()
            RequestModel(data.npc)
            while not HasModelLoaded(data.npc) do Wait(0) end

            local ped = CreatePed(4, data.npc, data.coords.x, data.coords.y, data.coords.z - 1.0, data.coords.w, false, true)

            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)

            TaskPlayAnim(ped, data.animDict, data.animName, 8.0, -8.0, -1, 1, 0, false, false, false)

            table.insert(spawnedNPCs, ped)

            local dialogInfo = PrisonDialog[i]
            if not dialogInfo then
                return
            end

            local buttons = {}
            local greeting = dialogInfo.dialogs.greeting or "..."

            for _, option in ipairs(dialogInfo.dialogs.options) do
                local replyList = type(option.npcReply) == "table" and option.npcReply or { option.npcReply }

                table.insert(buttons, {
                    label = option.label,
                    playerAnswer = {
                        text = option.playerText,
                        type = "message",
                        enable = true
                    },
                    systemAnswer = {
                        text = getRandomMessage(replyList),
                        type = "text",
                        enable = true
                    },
                    maxClick = 5,
                    onClick = function()
                        if option.type == "item_delivery" then
                            TriggerCallback("frkn-prison:deliveredItems", function(success, data)
                                if success then
                                    Notify(Lang:t('success.items_delivered'), 'success')
                                else
                                    local function getLabel(itemName)
                                        for _, task in pairs(FRKN.General.Tasks) do
                                            for _, reward in ipairs(task.rewardItems) do
                                                if reward.name == itemName then
                                                    return reward.label or itemName
                                                end
                                            end
                                        end
                                        return itemName
                                    end
                                
                                    if data.shovel and #data.shovel.missing > 0 then
                                        local names = {}
                                        for _, item in ipairs(data.shovel.missing) do
                                            table.insert(names, getLabel(item))
                                        end
                                        Notify(Lang:t('error.missing_shovel_items', { items = table.concat(names, ", ") }), 'error')
                                    end
                                
                                    if data.cutter and #data.cutter.missing > 0 then
                                        local names = {}
                                        for _, item in ipairs(data.cutter.missing) do
                                            table.insert(names, getLabel(item))
                                        end
                                        Notify(Lang:t('error.missing_cutter_items', { items = table.concat(names, ", ") }), 'error')
                                    end
                                end
                            end)

                        end 

                        -- if option.revealsEscapePlan then
                        --     TriggerEvent("prison:revealEscapePlan", ped)
                        -- elseif option.alertsGuards then
                        --     TriggerEvent("prison:alertGuards", ped)
                        -- end
                    end
                })
            end

            local dialogData = {
                Ped = {
                    Enable = true,
                    hash = GetEntityModel(ped),
                    coords = GetEntityCoords(ped),
                    heading = GetEntityHeading(ped),
                    ped = ped
                },
                Menu = {
                    Label = Lang:t("general.npc_name"),
                    Description = data.status == 1 and Lang:t("general.npc_relax") or Lang:t("general.npc_angry"),
                    Icon = "fas fa-user"
                },
                AutoMessage = {
                    Enable = true,
                    AutoMessages = {
                        { type = "question", text = greeting }
                    }
                },
                Interaction = {
                    Text = {
                        Enable = true,
                        Distance = 3.0,
                        Label = Lang:t("general.npc_text")
                    },
                    Target = {
                        Enable = false
                    },
                    DrawText = {
                        Enable = false
                    }
                },
                Buttons = buttons
            }

            exports['0r-npcdialog']:addDialog(dialogData)
        end)
    end
end)

function getRandomMessage(messages)
    return messages[math.random(1, #messages)]
end


-- RegisterNetEvent('prison:revealEscapePlan', function(ped)
--     print("Escape plan revealed by NPC: " .. ped)
-- end)


-- RegisterNetEvent('prison:alertGuards', function(ped)
--     print("Guards alerted by NPC: " .. ped)
-- end)



