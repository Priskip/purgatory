dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/debug/keycodes.lua")

--Get Comically Large Flask Entity
local entity_id = GetUpdatedEntityID()
local ent_x, ent_y = EntityGetTransform(entity_id)

--Seed Randomness from position and game time
local game_time = GameGetFrameNum()
SetRandomSeed(ent_x + game_time, ent_y)

--Potion Sprayer Configs
local spray_velocity_coefficient = 100 --multiplies spray velocity magnitude by this amount
local throw_amount = 25                --how many pixels to throw in one frame of spraying
local throw_position_offset = 3        --how many pixels in x and y off from the center of the flask can we spawn pixels from
local pressure_multiplier = 1.5        --Bonus spray velocity multiplier based off how full the flask is. Will be linearly interpretted from 1 to pressire_multiplier based on how full the flask is.

--Function for spraying materials
local function sprayMaterial(material, amount_to_spray, amount_in_flask, speed_x, speed_y)
    --Clamp spray amount to amount in flask
    if(amount_to_spray > amount_in_flask) then
        amount_to_spray = amount_in_flask
    end

    --Remove material from inventory
    AddMaterialInventoryMaterial(entity_id, material, amount_in_flask - amount_to_spray)

    --Spray
    for i = 1, amount_to_spray do
        local offset_x = Random(-throw_position_offset, throw_position_offset)
        local offset_y = Random(-throw_position_offset, throw_position_offset)

        GameCreateParticle(material, ent_x + offset_x, ent_y + offset_y, 1, speed_x, speed_y, false, false, false)
    end
    
end

--Poll player input to spray potion contents with cusotm logic.
--Note Priskip (2/Nov/23): As of now it is impossible to get the player's keybinds in the safe api.
--  Assume defaults and do something if Petri or Olli add functions for this.
--  I could make a mod setting for this but that'd probably confuse people.
local spray_from_controller = InputIsJoystickButtonDown(0, JOY_BUTTON_ANALOG_01_DOWN)
local spray_from_mouse = InputIsMouseButtonDown(Mouse_left)

--If we are to be spraying spray_from_controller or spray_from_mouse
if spray_from_controller or spray_from_mouse then
    --First check to see if we have any amount of material in the flask.
    local amount_of_material = 0
    local mats_and_amounts = {}
    local mat_inv_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "MaterialInventoryComponent")
    local count_per_material_type = ComponentGetValue2(mat_inv_comp, "count_per_material_type")

    for i, v in ipairs(count_per_material_type) do
        if v ~= 0 then
            mats_and_amounts[#mats_and_amounts + 1] =
            {
                material = CellFactory_GetName(i - 1),
                amount = v
            }

            amount_of_material = amount_of_material + v
        end
    end

    --If we have material that needs spraying
    if (amount_of_material > 0) then
        --Calculate how full the potion is.
        local material_sucker_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "MaterialSuckerComponent")
        local barrel_size = ComponentGetValue2(material_sucker_comp, "barrel_size")
        local percent_full = amount_of_material / barrel_size
        local lerped_pressure_multiplier = lerp(pressure_multiplier, 1, percent_full)

        --Calulate velocity to throw materials
        local cursor_x, cursor_y = DEBUG_GetMouseWorld()
        local direction = get_direction(ent_x, ent_y, cursor_x, cursor_y)
        local vel_x = -1 * lerped_pressure_multiplier * spray_velocity_coefficient * math.cos(direction)
        local vel_y = lerped_pressure_multiplier * spray_velocity_coefficient * math.sin(direction)

        --Clamp throw_amount min to be # of different materials in flask to emulate vanilla potion spraying behaviour
        throw_amount = math.max(throw_amount, #mats_and_amounts)

        --Divide throw_amount to equal parts for each material
        --Note: Taking the floor here will sometimes make the flask not throw EXACTLY throw_amount...
        local div = math.floor(throw_amount / #mats_and_amounts)

        --Spray
        for i = 1, #mats_and_amounts do
            sprayMaterial(mats_and_amounts[i].material, div, mats_and_amounts[i].amount, vel_x, vel_y)
        end

    end
end
