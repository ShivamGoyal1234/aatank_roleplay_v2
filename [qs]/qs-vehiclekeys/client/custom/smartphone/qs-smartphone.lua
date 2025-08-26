if Config.Smartphone ~= 'qs-smartphone' then
    return
end

function GetBattery()
    return exports["qs-smartphone"]:getBattery()
end

function SetBattery(battery)
    
end

function ToggleCharging(bool)
    
end

function IsPhoneDead()
    
end

function IsCharging()
    
end