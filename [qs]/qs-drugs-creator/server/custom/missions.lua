function CreateQuests(source)
    if GetResourceState('qs-inventory') ~= 'started' then
        Debug('qs-inventory not started, skipping drug quest creation.')
        return 
    end

    local quest1 = exports['qs-inventory']:createQuest(source, {
        name = 'buy_drug_lab',
        title = 'Start Cooking',
        description = 'Buy your first drug lab and begin your journey into production.',
        reward = 300,
        requiredLevel = 1
    })

    local quest2 = exports['qs-inventory']:createQuest(source, {
        name = 'harvest_drug_plants',
        title = 'Harvest Season',
        description = 'Collect 5 drug plants ready for processing.',
        reward = 250,
        requiredLevel = 1
    })

    local quest3 = exports['qs-inventory']:createQuest(source, {
        name = 'furnish_drug_lab',
        title = 'Lab Designer',
        description = 'Buy at least 5 furniture items for your drug lab.',
        reward = 200,
        requiredLevel = 1
    })

    local quest4 = exports['qs-inventory']:createQuest(source, {
        name = 'process_drug_batches',
        title = 'Production Run',
        description = 'Successfully complete the creation of 5 drug batches.',
        reward = 300,
        requiredLevel = 2
    })

    local quest5 = exports['qs-inventory']:createQuest(source, {
        name = 'cut_black_money',
        title = 'Dirty Money',
        description = 'Cut $1000 worth of black money through your lab or setup.',
        reward = 200,
        requiredLevel = 2
    })

    local quest6 = exports['qs-inventory']:createQuest(source, {
        name = 'sell_drugs_npc',
        title = 'Street Dealer',
        description = 'Find an NPC and successfully sell them drugs.',
        reward = 250,
        requiredLevel = 2
    })

    Debug('Drug quests assigned to player:', source, {
        buy_drug_lab = quest1,
        harvest_drug_plants = quest2,
        furnish_drug_lab = quest3,
        process_drug_batches = quest4,
        cut_black_money = quest5,
        sell_drugs_npc = quest6
    })
end
