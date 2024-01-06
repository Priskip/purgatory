dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local ent_x, ent_y = EntityGetTransform(entity_id)

local player_id = getPlayerEntity()
local pit_boss_id = EntityGetWithTag("boss_pit")[1]

--get status affects on wand
local status_effect_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "StatusEffectDataComponent")
local stain_effects = ComponentGetValue2(status_effect_comp, "stain_effects")
local charm_stain_level = stain_effects[16]

--if wand is charmed, help player
--if wand is not charmed, help pit boss
local target_id
if charm_stain_level >= 0.01 then
	target_id = player_id
else
	target_id = pit_boss_id
end

local target_x, target_y = EntityGetTransform(target_id)

local facing = 0

if target_x - ent_x <= 0 then
    facing = -1
else
    facing = 1
end

local spawn_offset = facing * 14 --this offset makes it look like the shoot is coming from the tip of the wand

vel_x = 7 * (target_x - ent_x)
vel_y = 7 * (target_y - ent_y)

local projectile_ent_id = shoot_projectile(entity_id, "data/entities/projectiles/deck/heal_bullet.xml", ent_x + spawn_offset, ent_y, vel_x, vel_y, true)

local proj_comp = EntityGetFirstComponentIncludingDisabled(projectile_ent_id, "ProjectileComponent")
ComponentObjectSetValue2(proj_comp, "damage_by_type", "healing", -276.0)