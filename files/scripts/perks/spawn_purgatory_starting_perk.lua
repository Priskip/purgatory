dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/perks/perk_list.lua")

local custom_starting_perk_descriptions = {
	PERKS_LOTTERY = "$perkdesc_perks_lottery_start"
}

--Used to spawn the starting perks in purgatory mode
function spawn_purgatory_starting_perk(x, y, perk_id, dont_remove_other_perks_, perk_type)
	local perk_data = get_perk_with_id(perk_list, perk_id)
	if (perk_data == nil) then
		print_error("spawn_perk( perk_id ) called with'" .. perk_id .. "' - no perk with such id exists.")
		return
	end

	print("spawn_perk " .. tostring(perk_id) .. " " .. tostring(x) .. " " .. tostring(y))

	---
	local entity_id = EntityLoad("data/entities/items/pickup/perk.xml", x, y)
	if (entity_id == nil) then
		return
	end

	local dont_remove_other_perks = dont_remove_other_perks_ or false

	-- init perk item
	EntityAddComponent(
		entity_id,
		"SpriteComponent",
		{
			image_file = perk_data.perk_icon or "data/items_gfx/perk.xml",
			offset_x = "8",
			offset_y = "8",
			update_transform = "1",
			update_transform_rotation = "0"
		}
	)

	EntityAddComponent(
		entity_id,
		"UIInfoComponent",
		{
			name = perk_data.ui_name
		}
	)

	--Custom Descriptions for Certain Starting Perks
	local perk_description = perk_data.ui_description
	if custom_starting_perk_descriptions[perk_id] ~= nil then
		perk_description = custom_starting_perk_descriptions[perk_id]
	end

	EntityAddComponent(
		entity_id,
		"ItemComponent",
		{
			item_name = perk_data.ui_name,
			ui_description = perk_description,
			ui_display_description_on_pick_up_hint = "1",
			play_spinning_animation = "0",
			play_hover_animation = "0",
			play_pick_sound = "0"
		}
	)

	EntityAddComponent(
		entity_id,
		"SpriteOffsetAnimatorComponent",
		{
			sprite_id = "-1",
			x_amount = "0",
			x_phase = "0",
			x_phase_offset = "0",
			x_speed = "0",
			y_amount = "2",
			y_speed = "3"
		}
	)

	EntityAddComponent(
		entity_id,
		"VariableStorageComponent",
		{
			name = "perk_id",
			value_string = perk_data.id
		}
	)

	if dont_remove_other_perks then
		EntityAddComponent(
			entity_id,
			"VariableStorageComponent",
			{
				name = "perk_dont_remove_others",
				value_bool = "1"
			}
		)
	end

	--Add Component for perk type
	--Add LuaComponent for Item Pickup (Used for deleting other perks of same tag after one is picked up)

	EntityAddComponent(
		entity_id,
		"VariableStorageComponent",
		{
			name = "perk_type",
			value_string = perk_type
		}
	)

	local lua_comp = EntityAddComponent(entity_id, "LuaComponent")
	ComponentSetValue(lua_comp, "script_item_picked_up", "mods/purgatory/files/scripts/perks/starting_perks_despawn.lua")

	EntityAddTag(entity_id, perk_type)

	return entity_id
end
