--Image Utility Functions


function xRGBA_To_xABGR(xRGBA_str)
    return string.sub(xRGBA_str, 7, 8) ..
    string.sub(xRGBA_str, 5, 6) .. string.sub(xRGBA_str, 3, 4) .. string.sub(xRGBA_str, 1, 2)
end

function xABGR_To_xRGBA(xABGR_str)
    return string.sub(xABGR_str, 7, 8) ..
    string.sub(xABGR_str, 5, 6) .. string.sub(xABGR_str, 3, 4) .. string.sub(xABGR_str, 1, 2)
    --huh - it's the same thing lul
end

function xARGB_TO_xABGR(xARGB_str)
    return string.sub(xARGB_str, 1, 2) ..
    string.sub(xARGB_str, 7, 8) .. string.sub(xARGB_str, 5, 6) .. string.sub(xARGB_str, 3, 4)
end

function WangColorToImageColor(wang_color_str)
    wang_color_str = xARGB_TO_xABGR(wang_color_str)
    wang_color_str = "FF" .. string.sub(wang_color_str, 3, 8)
    local number = tonumber(wang_color_str, 16)
    if (number > 0x7FFFFFFF) then
        number = number - 0xFFFFFFFF - 1
    end
    return number
end

--[[


-11774672
-16670224
]]