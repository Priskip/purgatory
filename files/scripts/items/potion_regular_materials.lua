dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/potion_appends.lua")

--Get list of regular materials from potion_appends.lua]
local material_list = materials_standard

--Init the Potion
function init(entity_id)
    local x, y = EntityGetTransform(entity_id)
    SetRandomSeed(x, y) -- so that all the potions will be the same in every position with the same seed

    local potion_material = "water"

    potion_material = random_from_array(material_list)
    potion_material = potion_material.material

    local components = EntityGetComponent(entity_id, "VariableStorageComponent")

    if (components ~= nil) then
        for key, comp_id in pairs(components) do
            local var_name = ComponentGetValue(comp_id, "name")
            if (var_name == "potion_material") then
                potion_material = ComponentGetValue(comp_id, "value_string")
            end
        end
    end

    AddMaterialInventoryMaterial(entity_id, potion_material, 1000)

    --Make description reflect barrel size.
	EntityAddComponent2(
		entity_id,
		"LuaComponent",
		{
			_tags="enabled_in_hand,enabled_in_world,enabled_in_inventory",
			execute_on_added = false,
			execute_every_n_frame = 5,
			remove_after_executed = true,
			script_source_file = "mods/purgatory/files/scripts/items/barrel_size_displayer.lua"
		}
	)
end
