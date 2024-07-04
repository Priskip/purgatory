dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()

--Read Who Shot
local pcomp = EntityGetFirstComponent(entity_id, "ProjectileComponent")
local whoshot
if (pcomp ~= nil) then
    whoshot = ComponentGetValue2(pcomp, "mWhoShot")
end

if whoshot ~= nil then
    --Get damage model of entity who shot and get current and max hp values
    local damage_model_comp = EntityGetFirstComponentIncludingDisabled(whoshot, "DamageModelComponent")
    local current_hp = nil
    local max_hp = nil

    if damage_model_comp ~= nil then
        current_hp = ComponentGetValue2(damage_model_comp, "hp")
        max_hp = ComponentGetValue2(damage_model_comp, "max_hp")
    end

    --Get ingestion component and blood heal speed.
    local ingestion_comp = EntityGetFirstComponentIncludingDisabled(whoshot, "IngestionComponent")
    local blood_healing_speed = nil
    if ingestion_comp ~= nil then
        blood_healing_speed = ComponentGetValue2(ingestion_comp, "blood_healing_speed")
    end


    --If above parameters have successfully been gotten, continue calulations
    if current_hp ~= nil and max_hp ~= nil and blood_healing_speed ~= nil then
        --Amount of blood needed to fully heal the caster
        local amount_for_full_heal = math.ceil((max_hp - current_hp) / blood_healing_speed)

        --Read Material Inventory
        local mat_inv_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "MaterialInventoryComponent")
        local count_per_material_type = nil
        if mat_inv_comp ~= nil then
            count_per_material_type = ComponentGetValue2(mat_inv_comp, "count_per_material_type")
        end

        if count_per_material_type ~= nil then
            local material = ""
            local amount_in_vacuum = 0

            for i, v in ipairs(count_per_material_type) do
                if v ~= 0 then
                    material = CellFactory_GetName(i - 1)
                    amount_in_vacuum = v

                    --If the vacuum holds more than the caster needs for a full heal, have them only eat the amount needed to fully heal.
                    --Else have them eat all the blood.
                    if (amount_in_vacuum >= amount_for_full_heal) then
                        EntityIngestMaterial(whoshot, CellFactory_GetType(material), amount_for_full_heal)       --makes caster eat the blood
                        AddMaterialInventoryMaterial(entity_id, material, amount_in_vacuum - amount_for_full_heal) --removes material from the field's inventory comp
                        GamePrint("True")
                    else
                        EntityIngestMaterial(whoshot, CellFactory_GetType(material), amount_in_vacuum)       --makes player eat the blood
                        AddMaterialInventoryMaterial(entity_id, material, 0) --removes material from the field's inventory comp
                        GamePrint("False")
                    end
                    
                    --Note Priskip 04/07/2024: If Nolla added more materials to the game that vampirism works with,
                    --and I added the [vampire_food] tag them, I would need to recheck the caster's hp after every ingestion.
                    --Might as well just add it now.
                    current_hp = ComponentGetValue2(damage_model_comp, "hp")
                    amount_for_full_heal = (max_hp - current_hp) / blood_healing_speed

                end
            end
        end
    end
end

--Kill blood vacuum entity to make leftovers drop
local comp = EntityGetFirstComponent(entity_id, "DamageModelComponent")
if (comp ~= nil) then
    ComponentSetValue2(comp, "kill_now", true)
end

EntityInflictDamage(entity_id, 1000, "DAMAGE_PROJECTILE", "", "NONE", 0, 0)
