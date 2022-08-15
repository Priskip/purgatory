dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

local entity_id = GetUpdatedEntityID()
entity_id = EntityGetRootEntity(entity_id)

local player_id = getPlayerEntity()

if entity_id ~= player_id then
    local pos_x, pos_y = EntityGetTransform(entity_id)

    local found_greed_multiplier_variable_storage_comp = false

    local greed_spell_multiplier_amount = 1.2 --how much gold value is increased per hit of this on an enemy
    local greed_spell_mutliplier_maximum = 2048 --how big can the multiplier go

    local var_storage_comp = EntityGetComponent(entity_id, "VariableStorageComponent")
    if (var_storage_comp ~= nil) then
        for i, v in ipairs(var_storage_comp) do
            local n = ComponentGetValue2(v, "name")
            if (n == "greed_multiplier_enemy") then
                found_greed_multiplier_variable_storage_comp = true

                local multiplier_value = ComponentGetValue2(v, "value_float")
                local new_multiplier = multiplier_value * greed_spell_multiplier_amount

                if new_multiplier >= greed_spell_mutliplier_maximum then
                    new_multiplier = greed_spell_mutliplier_maximum
                end

                ComponentSetValue2(v, "value_float", new_multiplier)
            end
        end
    end

    if found_greed_multiplier_variable_storage_comp == false then
        EntityAddComponent(
            entity_id,
            "VariableStorageComponent",
            {
                name = "greed_multiplier_enemy",
                value_float = greed_spell_multiplier_amount
            }
        )
    end
end
