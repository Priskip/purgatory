dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/entities/animals/boss_pit/clear_projectiles.lua")

function damage_received(damage)
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform(GetUpdatedEntityID())

	edit_component( entity_id, "HitboxComponent", function(comp,vars)
		ComponentSetValue2( comp, "damage_multiplier", 0.05 )
	end)

	SetRandomSeed(x, y * GameGetFrameNum())

	--Gets VariableStorageComponents "phase", "memory", "max_wands_allowed"
	local phase = 0
	local p = ""
	local max_wands_allowed = 0
	local comps = EntityGetComponent(entity_id, "VariableStorageComponent")
	if (comps ~= nil) then
		for i, v in ipairs(comps) do
			local n = ComponentGetValue2(v, "name")
			if (n == "phase") then
				phase = ComponentGetValue2(v, "value_int")
			elseif (n == "memory") then
				p = ComponentGetValue2(v, "value_string")

				if (#p == 0) then
					p = "data/entities/projectiles/enlightened_laser_darkbeam.xml"
					ComponentSetValue2(v, "value_string", p)
				end
			elseif (n == "max_wands_allowed") then
				max_wands_allowed = ComponentGetValue2(v, "value_int")
			end
		end
	end

	--Get HP values
	local damagemodels = EntityGetComponent(entity_id, "DamageModelComponent")
	local cur_hp = 0
	local max_hp = 0

	if damagemodels ~= nil then
		for i, dm in ipairs(damagemodels) do
			cur_hp = ComponentGetValue2(dm, "hp")
			max_hp = ComponentGetValue2(dm, "max_hp")
		end
	end

	--Phase 1
	--Spawns 1 wand upon being damaged that have the projectile stored in VariableStorageComponent "memory"
	--Pit Boss will not spawn wands if there are too many of them nearby to prevent performance issues and/or crashes
	if phase == 1 then
		if (#p > 0) then
			local wand_ids = EntityGetInRadiusWithTag(x, y, 150, "pit_boss_wand")
			if #wand_ids < max_wands_allowed then
				local angle = Random(1, 200) * math.pi
				local vel_x = math.cos(angle) * 100
				local vel_y = 0 - math.cos(angle) * 100

				local wid = shoot_projectile(entity_id, "data/entities/animals/boss_pit/wand.xml", x, y, vel_x, vel_y)
				edit_component(
					wid,
					"VariableStorageComponent",
					function(comp, vars)
						ComponentSetValue2(comp, "value_string", p)
					end
				)
			end
		end
	end
	--end Phase 1

	--Begin Phase 2
	if phase == 1 and cur_hp <= max_hp / 2 then
		--Print (debug testing)
		--GamePrint("Being Phase 2")
		print("Begin Phase 2")

		--Set VariableStorageComponent "phase" to 2
		local components = EntityGetComponent(entity_id, "VariableStorageComponent")
		if (components ~= nil) then
			for i, v in ipairs(components) do
				if (ComponentGetValue2(v, "name") == "phase") then
					ComponentSetValue2(v, "value_int", 2)
				end
			end
		end

		--Clear Projectiles in Area
		clear_projectiles_in_radius(x, y, 200)

		--Set Pitboss to invulnerable by disabling his hitbox so you can't hit him with plasma like spells
		local hit_box_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "HitboxComponent")
		EntitySetComponentIsEnabled(entity_id, hit_box_comp, false)

		--Note Priskip (20/1/2024): Disabling path finding crashes the game now... *shrug*

		--Disable path finding comp so he just sits there during his wand spawning animation
		-- local path_finding_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "PathFindingComponent")
		-- EntitySetComponentIsEnabled(entity_id, path_finding_comp, false)

		--Set his current position in var storage and lock him in place for a while
		local ent_x, ent_y = EntityGetTransform(entity_id)
		variable_storage_set_value(entity_id, "FLOAT", "rest_position_x", ent_x)
		variable_storage_set_value(entity_id, "FLOAT", "rest_position_y", ent_y)
		EntityAddComponent2(
			entity_id,
			"LuaComponent",
			{
				execute_on_added = true,
				script_source_file = "mods/purgatory/files/entities/animals/boss_pit/lock_in_place.lua",
				execute_every_n_frame = 1,
				execute_times = 270
			}
		)


		--Summon Minion Wands
		EntityAddComponent2(
			entity_id,
			"LuaComponent",
			{
				execute_on_added = false,
				script_source_file = "mods/purgatory/files/entities/animals/boss_pit/wand_of_healing/summon.lua",
				execute_every_n_frame = 120,
				remove_after_executed = true
			}
		)

		EntityAddComponent2(
			entity_id,
			"LuaComponent",
			{
				execute_on_added = false,
				script_source_file = "mods/purgatory/files/entities/animals/boss_pit/wand_of_shielding/summon.lua",
				execute_every_n_frame = 240,
				remove_after_executed = true
			}
		)

		--Re-enable hitbox after summoning wands
		EntityAddComponent2(
			entity_id,
			"LuaComponent",
			{
				execute_on_added = false,
				script_source_file = "mods/purgatory/files/entities/animals/boss_pit/reenable_hitbox.lua",
				execute_every_n_frame = 270,
				remove_after_executed = true
			}
		)

		-- --Re-enable pathfinding after summoning wands
		-- EntityAddComponent2(
		-- 	entity_id,
		-- 	"LuaComponent",
		-- 	{
		-- 		execute_on_added = false,
		-- 		script_source_file = "mods/purgatory/files/entities/animals/boss_pit/reenable_pathfinding.lua",
		-- 		execute_every_n_frame = 270,
		-- 		remove_after_executed = true
		-- 	}
		-- )

		--Set Max Wands Allowed to 5
		local var_stor_comps = EntityGetComponent(entity_id, "VariableStorageComponent")
		if (var_stor_comps ~= nil) then
			for i, v in ipairs(var_stor_comps) do
				local n = ComponentGetValue2(v, "name")
				if (n == "max_wands_allowed") then
					ComponentSetValue2(v, "value_int", 5)
				end
			end
		end
	end
	--end Begin Phase 2

	--Phase 2
	if phase == 2 then
		--Retalitory wands are summoned at the player
		if (#p > 0 and p ~= "data/entities/projectiles/deck/heal_bullet.xml" and p ~= "mods/purgatory/files/entities/animals/boss_pit/wand_of_shielding/shield_shot_large.xml") then
			local player_id = getPlayerEntity()
			local player_x, player_y = EntityGetTransform(player_id)

			local wand_ids = EntityGetInRadiusWithTag(player_x, player_y, 150, "pit_boss_wand")

			if #wand_ids < max_wands_allowed then
				local angle = Random(1, 200) * math.pi
				local vel_x = math.cos(angle) * 100
				local vel_y = 0 - math.cos(angle) * 100

				local wid = shoot_projectile(entity_id, "data/entities/animals/boss_pit/wand.xml", player_x, player_y, 2 * vel_x, 2 * vel_y)
				edit_component(
					wid,
					"VariableStorageComponent",
					function(comp, vars)
						ComponentSetValue2(comp, "value_string", p)
					end
				)
			end
		end
	end

	--Begin Phase 3
	if phase == 2 and cur_hp <= max_hp / 4 then
		--GamePrint("Begin Phase 3")

		--Set VariableStorageComponent "phase" to 2
		local components = EntityGetComponent(entity_id, "VariableStorageComponent")
		if (components ~= nil) then
			for i, v in ipairs(components) do
				if (ComponentGetValue2(v, "name") == "phase") then
					ComponentSetValue2(v, "value_int", 3)
				end
			end
		end

		--Clear Projectiles in Area
		clear_projectiles_in_radius(x, y, 200)

		--Set Pitboss to invulnerable (by disabling his hitbox so you can't hit him with plasma like spells)
		local hit_box_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "HitboxComponent")
		EntitySetComponentIsEnabled(entity_id, hit_box_comp, false)

		--Note Priskip (22-1-2024): I forgot to disable this part too
		-- --Disable path finding comp so he just sits there during his wand spawning animation
		-- local path_finding_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "PathFindingComponent")
		-- EntitySetComponentIsEnabled(entity_id, path_finding_comp, false)

		--Set his current position in var storage and lock him in place for a while
		local ent_x, ent_y = EntityGetTransform(entity_id)
		variable_storage_set_value(entity_id, "FLOAT", "rest_position_x", ent_x)
		variable_storage_set_value(entity_id, "FLOAT", "rest_position_y", ent_y)
		EntityAddComponent2(
			entity_id,
			"LuaComponent",
			{
				execute_on_added = true,
				script_source_file = "mods/purgatory/files/entities/animals/boss_pit/lock_in_place.lua",
				execute_every_n_frame = 1,
				execute_times = 270
			}
		)

		--Re-enable hitbox after summoning wands
		EntityAddComponent2(
			entity_id,
			"LuaComponent",
			{
				execute_on_added = false,
				script_source_file = "mods/purgatory/files/entities/animals/boss_pit/reenable_hitbox.lua",
				execute_every_n_frame = 270,
				remove_after_executed = true
			}
		)

		-- --Re-enable pathfinding after summoning wands
		-- EntityAddComponent2(
		-- 	entity_id,
		-- 	"LuaComponent",
		-- 	{
		-- 		execute_on_added = false,
		-- 		script_source_file = "mods/purgatory/files/entities/animals/boss_pit/reenable_pathfinding.lua",
		-- 		execute_every_n_frame = 270,
		-- 		remove_after_executed = true
		-- 	}
		-- )

		--Summon Wandghost with player's wand
		EntityLoad("mods/purgatory/files/entities/animals/boss_pit/wand_ghost_mimic/wand_ghost_mimic.xml", x, y - 30)

		--Set Max Wands Allowed to 3
		local var_stor_comps = EntityGetComponent(entity_id, "VariableStorageComponent")
		if (var_stor_comps ~= nil) then
			for i, v in ipairs(var_stor_comps) do
				local n = ComponentGetValue2(v, "name")
				if (n == "max_wands_allowed") then
					ComponentSetValue2(v, "value_int", 3)
				end
			end
		end
	end
end
