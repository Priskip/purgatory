dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")

local lerp_amount = 0.975
local bob_h = 18
local bob_w = 60
local bob_speed_y = 0.065
local bob_speed_x = 0.01421

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

--if wand cannot resolve its own pos, use player's
if ent_x == 0 and ent_y == 0 then
	-- get position from wand when starting
	ent_x, ent_y = EntityGetTransform(EntityGetParent(entity_id))
end

-- ghost continously lerps towards a target that floats around the parent
local target_x, target_y = EntityGetTransform(target_id)
if target_x == nil then
	return
end
target_y = target_y - 10

local time = GameGetFrameNum()
local r = ProceduralRandomf(entity_id, 0, -1, 1)

-- randomize times and speeds slightly so that multiple ghosts don't fly identically
time = time + r * 10000
bob_speed_y = bob_speed_y + (r * bob_speed_y * 0.1)
bob_speed_x = bob_speed_x + (r * bob_speed_x * 0.1)
lerp_amount = lerp_amount - (r * lerp_amount * 0.01)

-- bob
target_y = target_y + math.sin(time * bob_speed_y) * bob_h
target_x = target_x + math.sin(time * bob_speed_x) * bob_w

local dist_x = ent_x - target_x

-- move towards target
ent_x, ent_y = vec_lerp(ent_x, ent_y, target_x, target_y, lerp_amount)
EntitySetTransform(entity_id, ent_x, ent_y, 0, 1, 1)

-- animation state
edit_component(
	entity_id,
	"SpriteComponent",
	function(comp, vars)
		local current_anim = ComponentGetValue(comp, "rect_animation")

		-- float when nearby and fly when further away
		local mode = "float_"
		if math.abs(dist_x) > 28 then
			mode = "fly_"
		end

		-- check if changing the animation is needed based on current animation and heading
		if dist_x < 2 and current_anim ~= mode .. "right" then
			ComponentSetValue(comp, "rect_animation", mode .. "right")
		elseif dist_x > 2 and current_anim ~= mode .. "left" then
			ComponentSetValue(comp, "rect_animation", mode .. "left")
		end
	end
)
