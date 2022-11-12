dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

local boss = {}
boss.id = GetUpdatedEntityID()
boss.x, boss.y = EntityGetTransform(boss.id)

--Get Variables
local state = variable_storage_get_value(boss.id, "INT", "state")
local lcomps = EntityGetComponent(boss.id, "LaserEmitterComponent")
local dead_turrets = EntityGetInRadiusWithTag(boss.x, boss.y, 1000, "roboroom_mecha_turret_dead")
local damage_model_comp = EntityGetFirstComponentIncludingDisabled(boss.id, "DamageModelComponent")
local hp, max_hp = ComponentGetValue2(damage_model_comp, "hp"), ComponentGetValue2(damage_model_comp, "max_hp")
state = state + 1

--Set Randomness
SetRandomSeed(boss.x + GameGetFrameNum(), boss.y + boss.id)

if state == 2 then
	--Rocket Barrage
	local players = EntityGetInRadiusWithTag(boss.x, boss.y, 300, "player_unit")

	if (#players > 0) then
		for i = 1, 15 do
			local a = 3.1415 * (Random(0, 100) * 0.01)
			local length = Random(100, 250)
			local vx = math.cos(a) * length
			local vy = 0 - math.sin(a) * length

			shoot_projectile(boss.id, "data/entities/animals/boss_robot/rocket_roll.xml", boss.x, boss.y, vx, vy)
		end
	end
end

if state == 4 then
	--Fire Activation Bolts to nearby turret
	local alive_turret_hotspots = EntityGetInRadiusWithTag(boss.x, boss.y, 1000, "mecha_turret_laser_spot")
	local targets = {}

	if #alive_turret_hotspots > 0 then
		local number_of_bolts = Random(1, math.min(#alive_turret_hotspots, 3))

		for i = 1, number_of_bolts, 1 do
			local num = Random(1, #alive_turret_hotspots)
			targets[i] = alive_turret_hotspots[num]
			table.remove(alive_turret_hotspots, num)
		end

		for i, target in ipairs(targets) do
			local target_x, target_y = EntityGetTransform(target)
			local vx, vy = vec_normalize(target_x - boss.x, target_y - boss.y)
			local num = 300
			shoot_projectile(boss.id, "mods/purgatory/files/entities/animals/boss_robot/activation_bolt.xml", boss.x, boss.y, num * vx, num * vy)
		end
	end
end

if state == 6 then
	--Start the Laser Beam Tracking
	if (lcomps ~= nil) then
		for a, lcomp in ipairs(lcomps) do
			local players = EntityGetWithTag("player_unit")
			local p = players[1]

			if (p ~= nil) then
				local px, py = EntityGetTransform(p)

				local a = math.atan2(py - boss.y, px - boss.x)
				ComponentSetValue2(lcomp, "laser_angle_add_rad", a)
				ComponentObjectSetValue2(lcomp, "laser", "beam_radius", 1.5)
				ComponentObjectSetValue2(lcomp, "laser", "damage_to_entities", 0)
				ComponentObjectSetValue2(lcomp, "laser", "damage_to_cells", 10)
				ComponentObjectSetValue2(lcomp, "laser", "max_cell_durability_to_destroy", 2)
				ComponentObjectSetValue2(lcomp, "laser", "audio_enabled", false)
				ComponentSetValue2(lcomp, "is_emitting", true)
			end
		end
	end
end

if state == 8 then
	--Fire Death Laser
	if (lcomps ~= nil) then
		for a, lcomp in ipairs(lcomps) do
			ComponentObjectSetValue2(lcomp, "laser", "beam_radius", 10.5)
			ComponentObjectSetValue2(lcomp, "laser", "damage_to_entities", 0.6)
			ComponentObjectSetValue2(lcomp, "laser", "damage_to_cells", 700000)
			ComponentObjectSetValue2(lcomp, "laser", "max_cell_durability_to_destroy", 14)

			if (a == 1) then
				ComponentObjectSetValue2(lcomp, "laser", "audio_enabled", true)
			end
		end
	end
end

if state == 10 then
	--Stop Firing Death Laser
	if (lcomps ~= nil) then
		for a, lcomp in ipairs(lcomps) do
			ComponentSetValue2(lcomp, "is_emitting", false)
			ComponentObjectSetValue2(lcomp, "laser", "beam_radius", 1.5)
			ComponentObjectSetValue2(lcomp, "laser", "damage_to_entities", 0)
			ComponentObjectSetValue2(lcomp, "laser", "damage_to_cells", 10)
			ComponentObjectSetValue2(lcomp, "laser", "max_cell_durability_to_destroy", 2)
			ComponentObjectSetValue2(lcomp, "laser", "audio_enabled", false)
		end
	end
end

if state == 13 then
	--Summon a Drone if a turret is dead or if mecha is injured & reset state
	if #dead_turrets > 0 or hp ~= max_hp then
		local h = EntityGetWithTag("healer")
		if (#h < 3) then
			EntityLoad("mods/purgatory/files/entities/animals/boss_robot/healerdrone_physics.xml", boss.x, boss.y)
		end
	end
	state = 0
end

--Write new state value to storage
variable_storage_set_value(boss.id, "INT", "state", state)

--[[
Vanilla Behaviour
State executes every 40 frames

State = 2
	Rocket Barrage

State = 4
	Shield UP
	
State = 6
	Shield DOWN
	Start Laser Beam Tracking

State = 8
	Stop Laser Beam Tracking
	Fire Death Laser

State = 10
	Stop Firing Death Laser
	Shield UP

State = 13
	Summon a Drone
	Set State back to 0

============================================================

Purgatory Behaviour

State = 2
	Rocket Barrage

State = 4
	Fire an Activation Bullet if there is a turret alive

State = 6
	Start the Laser Beam Tracking

State = 8
	Stop the Laser Beam Tracking
	Fire Death Laser

State = 10
	Stop Firing Death Laser

State = 13
	Summon a Drone if a turret is dead or if mecha is injured
	Reset State to 0

Note:  	Shield is always active in Purgatory fight
		The way to de-activate the shield is to destroy the laser turrets 

]]
