if Config.Smartphone ~= 'lb-phone' then
    return
end

function GetBattery()
    return exports["lb-phone"]:GetBattery()
end

function SetBattery(battery)
    exports["lb-phone"]:SetBattery(battery)
end

function ToggleCharging(bool)
    exports["lb-phone"]:ToggleCharging(bool)
end

function IsPhoneDead()
    return exports["lb-phone"]:IsPhoneDead()
end

function IsCharging()
    return exports["lb-phone"]:IsCharging()
end