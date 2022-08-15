dofile_once("data/scripts/lib/utilities.lua")

--these are the materials you find in ancient lab
materials = {
    "magic_liquid_charm",
    "magic_liquid_berserk",
    "magic_liquid_mana_regeneration",
    "magic_liquid_teleportation",
    "material_confusion",
    "magic_liquid_protection_all",
    "alcohol",
    "oil"
}

function init(entity_id)
    local x, y = EntityGetTransform(entity_id)
    SetRandomSeed(x, y) -- so that all the potions will be the same in every position with the same seed
    local potion_material = "water"
    potion_material = random_from_array(materials)

    local num = Random(1,100)
    if num == 99 then
        potion_material = "magic_liquid_unstable_polymorph"
    end

    if num == 100 then
        potion_material = "gold"
    end

    local total_capacity = 5000
    local components = EntityGetComponent(entity_id, "VariableStorageComponent")

    if (components ~= nil) then
        for key, comp_id in pairs(components) do
            local var_name = ComponentGetValue(comp_id, "name")
            if (var_name == "potion_material") then
                potion_material = ComponentGetValue(comp_id, "value_string")
            end
        end
    end

    AddMaterialInventoryMaterial(entity_id, potion_material, total_capacity)
end
