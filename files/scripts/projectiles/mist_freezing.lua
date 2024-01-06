dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform(entity_id)

local entities_in_area = EntityGetInRadius(pos_x, pos_y, 260)

if entities_in_area ~= nil then
    for _, ent in ipairs(entities_in_area) do
        --Get Component Id and Component Values
        local dmc_id = EntityGetFirstComponentIncludingDisabled(ent, "DamageModelComponent")
        if dmc_id ~= nil then
            local materials = ComponentGetValue2(dmc_id, "materials_that_damage")
            local how_much = ComponentGetValue2(dmc_id, "materials_how_much_damage")

            --Split strings into arrays
            local damaging_material_list = {}
            local damaging_material_amount_list = {}
            local count = 0
            for word in string.gmatch(materials, "([^,]+)") do
                count = count + 1
                damaging_material_list[count] = word
            end

            count = 0
            for word in string.gmatch(how_much, "([^,]+)") do
                count = count + 1
                damaging_material_amount_list[count] = word
            end

            --Check if entity takes damage to freezing vapours
            local takes_blood_cold_vapour_damage = false
            local blood_cold_vapour_damage_amount = 0
            for i, v in ipairs(damaging_material_list) do
                if v == "blood_cold_vapour" then
                    if damaging_material_amount_list[i] ~= 0 then
                        takes_blood_cold_vapour_damage = true
                        blood_cold_vapour_damage_amount = damaging_material_amount_list[i]
                    end
                end
            end

            --If entity takes damage to freezing vapours, then set entity to take equal damage to freezing vapour mists
            if takes_blood_cold_vapour_damage then
                EntitySetDamageFromMaterial(ent, "cloud_blood_cold_vapour", blood_cold_vapour_damage_amount)
            end
        end
    end
end
