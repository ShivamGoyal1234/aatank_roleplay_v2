CurrentTime = function(kayitli_zaman, latest, Lang)
    local simdiki_zaman = latest
    local fark = simdiki_zaman - kayitli_zaman
    local fark_saniye = fark / 1000
    local fark_dakika = fark_saniye / 60
    local fark_saat = fark_dakika / 60

    if fark_saat >= 1 then
        return string.format(Lang.hourago, math.floor(fark_saat))
    elseif fark_dakika >= 1 then
        return string.format(Lang.minuteago, math.floor(fark_dakika))
    else
        return string.format(Lang.secondago, math.floor(fark_saniye))
    end
end

Shared.GetDispatches = function(ctime, langData, job)
    local allDispatches = {}

    if Shared.DispatchSystem == 'kibra-dispatch' then
        local success, result = pcall(function()
            return exports["kibra-dispatch"]:GetSelectedAlerts(job)
        end)

        if success and result then
            allDispatches = result
            for k, v in pairs(allDispatches) do
                v.timestring = CurrentTime(v.time, ctime, langData)
                if v.coords then
                    v.coordsdecode = { x = v.coords.x, y = v.coords.y, z = v.coords.z }
                else
                    v.coordsdecode = { x = 0, y = 0, z = 0 }
                end
            end
            table.sort(allDispatches, function(a, b)
                return a.time > b.time
            end)
        else
            allDispatches = {} -- export başarısızsa boş dön
        end

    elseif Shared.DispatchSystem == 'ps-dispatch' then
        allDispatches = lib.callback.await('ps-dispatch:callback:getCalls', false)
        for k, v in pairs(allDispatches) do
            v.timestring = CurrentTime(v.time, ctime, langData)
            if v.coords then
                v.coordsdecode = { x = v.coords.x, y = v.coords.y, z = v.coords.z }
            else
                v.coordsdecode = { x = 0, y = 0, z = 0 }
            end
            v.title = v.message
            v.address = v.street
        end
        table.sort(allDispatches, function(a, b)
            return a.time > b.time
        end)
    end

    return allDispatches
end


Shared.SendPrison = function()
end

Shared.GetEmsDispatches = function(ctime, langData)
    local job = 'ems'
    local allDispatches = {}

    if Shared.DispatchSystem == 'kibra-dispatch' then
        local success, result = pcall(function()
            return exports["kibra-dispatch"]:GetSelectedEmsAlerts(job)
        end)

        if success and result then
            allDispatches = result
            for k, v in pairs(allDispatches) do
                v.timestring = CurrentTime(v.time, ctime, langData)
            end

            table.sort(allDispatches, function(a, b)
                return a.time > b.time
            end)
        else
            allDispatches = {} -- export hatalıysa boş dön
        end

    elseif Shared.DispatchSystem == 'ps-dispatch' then
        local tempCache = lib.callback.await('ps-dispatch:callback:getCalls', false)
        for k, v in pairs(tempCache) do
            v.title = v.message
            v.timestring = CurrentTime(v.time, ctime, langData)
            v.address = v.street
            for q, s in pairs(v.jobs) do
                if s == job then
                    allDispatches[#allDispatches + 1] = v
                end
            end
        end

        table.sort(allDispatches, function(a, b)
            return a.time > b.time
        end)
    end

    return allDispatches
end
