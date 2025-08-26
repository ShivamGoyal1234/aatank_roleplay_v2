function getPlayerJob()
    -- QBX

    if GetResourceState('qbx_core'):find('start') and GetResourceState('qb-core'):find('start') then
        return {job = QBX.PlayerData.job.name, grade = QBX.PlayerData.job.grade.level}
    end

    -- QB 

    if not GetResourceState('qbx_core'):find('start') and GetResourceState('qb-core'):find('start') then
        local PlayerData = QBCore.Functions.GetPlayerData()
        return {job = PlayerData.job.name, grade = PlayerData.job.grade.level}  
    end

    -- Esx 

    if GetResourceState('es_extended'):find('start') then
        return {job = ESX.GetPlayerData().job.name, grade = ESX.GetPlayerData().job.grade}  
    end

    return false  
end