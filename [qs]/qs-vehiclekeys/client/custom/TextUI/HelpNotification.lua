if Config.TextUI ~= "HelpNotification" then
    return
end

function TextShow(msg)
    	SetTextComponentFormat("STRING")
	AddTextComponentString(msg)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function TextClose()
	return
end
