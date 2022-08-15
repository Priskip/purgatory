dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local player_id = EntityGetRootEntity(entity_id)
local x, y = EntityGetTransform(entity_id)
y = y - 4 -- offset to middle of character

local pw, mx = check_parallel_pos(x)

local timer = 0
local timercomp
local comps = EntityGetComponent(entity_id, "VariableStorageComponent")
if (comps ~= nil) then
    for i, comp in ipairs(comps) do
        local n = ComponentGetValue2(comp, "name")
        if (n == "map_timer") then
            timer = ComponentGetValue2(comp, "value_int")
            timercomp = comp
            break
        end
    end
end

if (timercomp ~= nil) and (entity_id ~= player_id) then
    local is_moving = false
    component_read(
        EntityGetFirstComponent(player_id, "ControlsComponent"),
        {mButtonDownDown = false, mButtonDownUp = false, mButtonDownLeft = false, mButtonDownRight = false, mButtonDownJump = false, mButtonDownFire = false},
        function(controls_comp)
            is_moving =
                controls_comp.mButtonDownDown or controls_comp.mButtonDownUp or controls_comp.mButtonDownLeft or controls_comp.mButtonDownRight or controls_comp.mButtonDownJump or
                controls_comp.mButtonDownFire or
                false
        end
    )

    if (is_moving == false) then
        timer = math.min(timer + 1, 160)

        if (timer > 80) then
            local map_sprite = "fade_1"
            local map_x = 0 * 512
            local map_y = 10 * 512

            local mult_x = 512 / 6.0
            local mult_y = 512 / 6.0

            local dx = math.min(math.max((map_x - mx) / mult_x, -420), 420)
            local dy = math.min(math.max((map_y - y) / mult_y, -240), 240)

            local mi_x = x + dx * 0.5
            local mi_y = y + dy * 0.5

            local pi_x = x - dx * 0.5
            local pi_y = y - dy * 0.5

            --Fade in affect
            if (timer > 86) then
                map_sprite = "fade_4"
            elseif (timer > 84) then
                map_sprite = "fade_3"
            elseif (timer > 82) then
                map_sprite = "fade_2"
            end

            GameCreateSpriteForXFrames("mods/purgatory/files/particles/map/lvl_3/" .. map_sprite .. ".png", mi_x, mi_y, true, 0, 0, 1, true)

        end
    else
        timer = 0
    end

    ComponentSetValue2(timercomp, "value_int", timer)
end
