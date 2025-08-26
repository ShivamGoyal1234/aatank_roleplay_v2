-- Function to draw 3D text based on the chosen method
local isTextVisible = true

-- Function to draw 3D text based on the chosen method
function Draw3DText(x, y, z, text)
    if isTextVisible then
        if Config.ReplaceDraw3D then
            if Config.TextUI == 'okokTextUI' then
                print("DEBUG: okokTextUI is currently bugged and will not display correctly.")
            end
            TextShow(text) -- Use the ox_lib function
        else
            DrawText3D(x, y, z, text)
        end
        isTextVisible = false
    end
end

function TextClose()
    return
end
