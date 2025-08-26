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