--[[
Image numbering filter - Numbering Images in caption
License:   MIT - see LICENSE file for details
adapted from: Albert Krewinkel implementation
original License: CC0
--]]

-- Image counter variable
figures = 0
--[[
Applies the filter to Image elements
--]]
function Image(el)
    figures = figures + 1
    -- Figure Numbering to be appended
    local label = "Figure " .. tostring(figures)
    -- original caption
    local caption = pandoc.utils.stringify(el.caption)
    if not caption then
      -- Figure has no caption, just add the label
      caption = label
    else 
      caption = label .. " " .. caption
    end
    el.caption = caption
    -- centering the figure
    local classes = el.classes
    print_r(classes)
    if not classes[1] then
        classes = {"center"}
    else
        classes = {"center"}
    end
    el.classes = classes
    print_r(classes)
    return el
end

function print_r(arr, indentLevel)
    local str = ""
    local indentStr = "#"

    if(indentLevel == nil) then
        print(print_r(arr, 0))
        return
    end

    for i = 0, indentLevel do
        indentStr = indentStr.."\t"
    end

    for index,value in pairs(arr) do
        if type(value) == "table" then
            str = str..indentStr..index..": \n"..print_r(value, (indentLevel + 1))
        else 
            str = str..indentStr..index..": "..value.."\n"
        end
    end
    return str
end