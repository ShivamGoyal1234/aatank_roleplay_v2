local _resourceName = GetCurrentResourceName()
local defaultLocale = json.decode(LoadResourceFile(_resourceName, 'locales/en.json')) or {}
local locale = LoadResourceFile(_resourceName, ('locales/%s.json'):format(Config.Locale))
if not locale then
    locale = defaultLocale
    print(('^3[RACING]^1 WARNING: ^7Locale %s does not exist, falling back to default (en).'):format(Config.Locale))
end
_T = locale and json.decode(locale) or nil
for k, v in pairs(defaultLocale) do
    if not _T[k] then
        _T[k] = v
        CreateThread(function()
            Wait(5000) --  Wait 5 seconds so people can see the warning
            print(('^3[RACING]^1 WARNING: ^7Locale %s is missing key `%s`, falling back to default (en). Please add this key to your locale file.'):format(Config.Locale, k))
        end)
    end
end
LocaleInitialized = true
if not _T then
    error(('^3[RACING]^1 ERROR: ^7Failed to load locale file. Please make sure that the file %s exists and is valid JSON.'):format(('locales/%s.json'):format(Config.Locale)), 2)
end

function _U(key, params)
    if _T[key] then
        local text = _T[key]
        if params then
            for k, v in pairs(params) do
                text = text:gsub("{" .. k .. "}", tostring(v))
            end
        end
        return text
    else
        return key
    end
end
