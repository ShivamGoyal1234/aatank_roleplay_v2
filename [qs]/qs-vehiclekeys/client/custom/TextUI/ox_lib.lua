local lastTextDisplayed = nil

if Config.TextUI ~= "ox_lib" then
    return
end

function TextShow(msg)
    if lib.isTextUIOpen() then
        return
    else
        local icon = Config.CustomIcon or ''

        if Config.CustomDesignTextUI then
            lib.showTextUI(msg, {
                icon = icon,
                style = {
                    borderRadius = 0,
                    backgroundColor = '#141517',
                    color = '#d6d6d6'
                }
            })
        else
            lib.showTextUI(msg, { icon = icon })
        end

        lastTextDisplayed = msg
    end
end

function TextClose(textToClose)
    local isOpen, currentText = lib.isTextUIOpen()

    if isOpen then
        if currentText == textToClose or textToClose == true then
            lib.hideTextUI()
            lastTextDisplayed = nil
            return true
        elseif lastTextDisplayed and currentText == lastTextDisplayed then
            lib.hideTextUI()
            lastTextDisplayed = nil
            return true
        end
    end

    return false
end
