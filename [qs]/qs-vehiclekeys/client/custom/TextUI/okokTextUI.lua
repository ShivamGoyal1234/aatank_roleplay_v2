if Config.TextUI ~= "okokTextUI" then
    return
end

function TextShow(msg)
    exports['okokTextUI']:Open(msg, 'lightblue', 'right')
end

function TextClose()
  exports['okokTextUI']:Close()
end
