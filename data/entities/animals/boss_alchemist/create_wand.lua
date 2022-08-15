dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(GetUpdatedEntityID())
local radius = 260

SetRandomSeed(x, y)

local proj = ""

local s = EntityGetComponent(entity_id, "VariableStorageComponent")
if (s ~= nil) then
	for i, v in ipairs(s) do
		local name = ComponentGetValue2(v, "name")

		if (name == "type") then
			proj = ComponentGetValue2(v, "value_string")
		end
	end
end

local targets = EntityGetInRadiusWithTag(x, y, radius, "player_unit")

if (string.len(proj) > 0) and (#targets > 0) then
	for i, v in ipairs(targets) do
		local px, py = EntityGetTransform(v)
		local vel_x = math.cos(0 - math.atan2(py - y, px - x)) * 2.0
		local vel_y = 0 - math.sin(0 - math.atan2(py - y, px - x)) * 2.0

		local projectile_ent_id = shoot_projectile_from_projectile(entity_id, proj, x, y, vel_x, vel_y)

		local common_mats = {
			"magic_liquid_charm",
			"magic_liquid_berserk",
			"magic_liquid_mana_regeneration",
			"magic_liquid_teleportation",
			"material_confusion",
			"alcohol",
			"oil"
		}
		local rare_mats = {
			"magic_liquid_protection_all",
			"magic_liquid_unstable_polymorph"
		}
		local transmute_target_materials = {
			"water",
			"oil",
			"lava",
			"acid",
			"radioactive_liquid",
			"slime",
			"sand",
			"alcohol",
			"blood",
			"snow",
			"blood_worm",
			"blood_fungi",
			"burning_powder",
			"honey",
			"fungi",
			"diamond",
			"brass",
			"silver",
			"magic_liquid_teleportation",
			"magic_liquid_polymorph",
			"magic_liquid_random_polymorph",
			"magic_liquid_berserk",
			"magic_liquid_charm",
			"magic_liquid_invisibility",
			"magic_liquid_mana_regeneration",
			"material_confusion",
			"magic_liquid_protection_all",
			"magic_liquid_unstable_polymorph"
		}

		local rand_num = Random(1, 100)
		local material = ""
		if rand_num >= 95 then
			material = random_from_array(rare_mats)
		else
			material = random_from_array(common_mats)
		end

		--Get Material ID from name
		material = CellFactory_GetType(material)

		for i, v in ipairs(transmute_target_materials) do
			local magic_convert_materials_component = EntityAddComponent(projectile_ent_id, "MagicConvertMaterialComponent")
			ComponentSetValue(magic_convert_materials_component, "kill_when_finished", "0")
			ComponentSetValue(magic_convert_materials_component, "from_material", CellFactory_GetType(v))
			ComponentSetValue(magic_convert_materials_component, "steps_per_frame", "48")
			ComponentSetValue(magic_convert_materials_component, "to_material", material)
			ComponentSetValue(magic_convert_materials_component, "clean_stains", "0")
			ComponentSetValue(magic_convert_materials_component, "is_circle", "1")
			ComponentSetValue(magic_convert_materials_component, "radius", "32")
			ComponentSetValue(magic_convert_materials_component, "loop", "1")
		end

		EntityAddTag(eid, "boss_alchemist")
	end
end
