if Config.TextUI ~= "qb" then
    return
end

function TextShow(msg)
    exports['qb-core']:DrawText(msg, 'left')
end

function TextClose()
    exports['qb-core']:HideText()
end
