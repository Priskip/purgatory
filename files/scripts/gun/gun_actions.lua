dofile("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")
dofile_once("mods/purgatory/files/scripts/gun/gun_actions_list.lua")

--Blacklisted Spells for Random Spells
random_spells_blacklist = {
	"OMEGA_NUKE"
}

--Remove Spells
function remove_spell(spell_name)
	local key_to_spell = nil
	for key, perk in pairs(actions) do
		if (perk.id == spell_name) then
			key_to_spell = key
		end
	end

	if (key_to_spell ~= nil) then
		table.remove(actions, key_to_spell)
	end
end

remove_spell("LASER_LUMINOUS_DRILL") --Replacing with spell called "LUMINOUS_DRILL_TIMER" to match trigger naming conventions
remove_spell("LIGHT_BULLET_TRIGGER_2") --Replacing with spell called "LIGHT_BULLET_TRIGGER_TRIGGER" to match trigger naming conventions
remove_spell("MANA_REDUCE") -- Removing to replace with other mana increasing spells

--Function for modifying existing spells
function modify_existing_spell(spell_id, parameter_to_modify, new_value)
	for i, spell in ipairs(actions) do
		if spell.id == spell_id then
			spell[parameter_to_modify] = new_value
			break
		end
	end
end

--Modify existing spells
modify_existing_spell("MATTER_EATER", "max_uses", 20)
modify_existing_spell("MATTER_EATER", "mana", 50)
modify_existing_spell("MATTER_EATER", "never_unlimited", false)

modify_existing_spell("BLACK_HOLE_DEATH_TRIGGER", "sprite", "mods/purgatory/files/ui_gfx/gun_actions/black_hole_death_trigger.png")
modify_existing_spell("BLACK_HOLE_DEATH_TRIGGER", "name", "$action_black_hole_death_trigger_new")

modify_existing_spell("MINE_DEATH_TRIGGER", "sprite", "mods/purgatory/files/ui_gfx/gun_actions/mine_with_death_trigger.png")
modify_existing_spell("MINE_DEATH_TRIGGER", "name", "$action_mine_death_trigger_new")

modify_existing_spell("PIPE_BOMB_DEATH_TRIGGER", "sprite", "mods/purgatory/files/ui_gfx/gun_actions/pipe_bomb_with_death_trigger.png")
modify_existing_spell("PIPE_BOMB_DEATH_TRIGGER", "name", "$action_pipe_bomb_death_trigger_new")

modify_existing_spell("SUMMON_HOLLOW_EGG", "sprite", "mods/purgatory/files/ui_gfx/gun_actions/hollow_egg.png")

modify_existing_spell("ALL_NUKES", "never_unlimited", false)
modify_existing_spell("ALL_ROCKETS", "never_unlimited", false)
modify_existing_spell("ALL_DEATHCROSSES", "never_unlimited", false)
modify_existing_spell("ALL_BLACKHOLES", "never_unlimited", false)

modify_existing_spell(
	"RANDOM_SPELL",
	"action",
	function(recursion_level, iteration)
		local is_blacklisted = true
		local count = 0
		local rnd = 0
		local data = {}
		local safety = 0
		local rec = 0

		while is_blacklisted == true do
			count = count + 1
			is_blacklisted = false

			SetRandomSeed(GameGetFrameNum() + #deck, GameGetFrameNum() + count - 69)
			rnd = Random(1, #actions)
			data = actions[rnd]

			safety = 0
			rec = check_recursion(data, recursion_level)

			while (safety < 100) and (rec == -1) do
				rnd = Random(1, #actions)
				data = actions[rnd]
				rec = check_recursion(data, recursion_level)
				safety = safety + 1
			end

			for i, v in ipairs(random_spells_blacklist) do
				if data.id == v then
					is_blacklisted = true
					break
				end
			end
		end

		data.action(rec)
	end
)

modify_existing_spell(
	"RANDOM_PROJECTILE",
	"action",
	function(recursion_level, iteration)
		local is_blacklisted = true
		local count = 0
		local rnd = 0
		local data = {}
		local safety = 0
		local rec = 0

		while is_blacklisted == true do
			count = count + 1
			is_blacklisted = false

			SetRandomSeed(GameGetFrameNum() + #deck, GameGetFrameNum() + count - 420)
			rnd = Random(1, #actions)
			data = actions[rnd]

			safety = 0
			rec = check_recursion(data, recursion_level)

			while (safety < 100) and ((data.type ~= 0) or (rec == -1)) do
				rnd = Random(1, #actions)
				data = actions[rnd]
				rec = check_recursion(data, recursion_level)
				safety = safety + 1
			end

			for i, v in ipairs(random_spells_blacklist) do
				if data.id == v then
					is_blacklisted = true
					break
				end
			end
		end

		data.action(rec)
	end
)

modify_existing_spell(
	"HOMING",
	"action",
	function()
		c.extra_entities = c.extra_entities .. "mods/purgatory/files/entities/misc/homing_spells/homing.xml,data/entities/particles/tinyspark_white.xml,"
		draw_actions(1, true)
	end
)

modify_existing_spell(
	"HOMING_SHORT",
	"action",
	function()
		c.extra_entities = c.extra_entities .. "mods/purgatory/files/entities/misc/homing_spells/homing_short.xml,data/entities/particles/tinyspark_white_weak.xml,"
		draw_actions(1, true)
	end
)

modify_existing_spell(
	"HOMING_ROTATE",
	"action",
	function()
		c.extra_entities = c.extra_entities .. "mods/purgatory/files/entities/misc/homing_spells/homing_rotate.xml,data/entities/particles/tinyspark_white_weak.xml,"
		draw_actions(1, true)
	end
)

modify_existing_spell(
	"HOMING_ACCELERATING",
	"action",
	function()
		c.extra_entities = c.extra_entities .. "mods/purgatory/files/entities/misc/homing_spells/homing_accelerating.xml,data/entities/particles/tinyspark_white_small.xml,"
		draw_actions(1, true)
	end
)

modify_existing_spell(
	"HOMING_AREA",
	"action",
	function()
		c.extra_entities = c.extra_entities .. "mods/purgatory/files/entities/misc/homing_spells/homing_area.xml,data/entities/particles/tinyspark_white.xml,"
		c.fire_rate_wait = c.fire_rate_wait + 8
		c.spread_degrees = c.spread_degrees + 6
		c.speed_multiplier = c.speed_multiplier * 0.75

		if (c.speed_multiplier >= 20) then
			c.speed_multiplier = math.min(c.speed_multiplier, 20)
		elseif (c.speed_multiplier < 0) then
			c.speed_multiplier = 0
		end

		draw_actions(1, true)
	end
)

modify_existing_spell("COLOUR_RAINBOW", "description", "$actiondesc_colour_rainbow_new")
modify_existing_spell("CHAOS_POLYMORPH_FIELD", "name", "$action_chaos_polymorph_field_new")
modify_existing_spell("CHAOS_POLYMORPH_FIELD", "description", "$actiondesc_chaos_polymorph_field_new")

--new bombs materialized stuff
modify_existing_spell("MINE", "custom_xml_file", "mods/purgatory/files/entities/misc/custom_cards/mine.xml") --unstable crystal
modify_existing_spell("MINE_DEATH_TRIGGER", "custom_xml_file", "mods/purgatory/files/entities/misc/custom_cards/mine_death_trigger.xml") --unstable crystal death trigger
modify_existing_spell("LIGHTNING", "custom_xml_file", "mods/purgatory/files/entities/misc/custom_cards/lightning.xml") --lightning
modify_existing_spell("GRENADE_LARGE", "custom_xml_file", "mods/purgatory/files/entities/misc/custom_cards/grenade_large.xml") --dropper bolt
modify_existing_spell("BALL_LIGHTNING", "custom_xml_file", "mods/purgatory/files/entities/misc/custom_cards/ball_lightning.xml") --ball_lightning
modify_existing_spell("THUNDERBALL", "custom_xml_file", "mods/purgatory/files/entities/misc/custom_cards/thunderball.xml") --thundercharge
modify_existing_spell("METEOR", "custom_xml_file", "mods/purgatory/files/entities/misc/custom_cards/meteor.xml") --meteor
modify_existing_spell("GRENADE", "custom_xml_file", "mods/purgatory/files/entities/misc/custom_cards/grenade.xml") --firebolt
modify_existing_spell("GRENADE_ANTI", "custom_xml_file", "mods/purgatory/files/entities/misc/custom_cards/grenade_anti.xml") --odd firebolt
modify_existing_spell("GRENADE_TRIGGER", "custom_xml_file", "mods/purgatory/files/entities/misc/custom_cards/grenade_trigger.xml") --firebolt w trigger
modify_existing_spell("GRENADE_TIER_2", "custom_xml_file", "mods/purgatory/files/entities/misc/custom_cards/grenade_tier_2.xml") --firebolt large (green)
modify_existing_spell("GRENADE_TIER_3", "custom_xml_file", "mods/purgatory/files/entities/misc/custom_cards/grenade_tier_3.xml") --firebolt giant (purple)
modify_existing_spell("ROCKET", "custom_xml_file", "mods/purgatory/files/entities/misc/custom_cards/rocket.xml") --magic missile
modify_existing_spell("ROCKET_TIER_2", "custom_xml_file", "mods/purgatory/files/entities/misc/custom_cards/rocket_tier_2.xml") --magic missile (green)
modify_existing_spell("ROCKET_TIER_3", "custom_xml_file", "mods/purgatory/files/entities/misc/custom_cards/rocket_tier_3.xml") --magic missile (purple)
modify_existing_spell("PIPE_BOMB", "custom_xml_file", "mods/purgatory/files/entities/misc/custom_cards/pipe_bomb.xml") --dormant crystal
modify_existing_spell("PIPE_BOMB_DEATH_TRIGGER", "custom_xml_file", "mods/purgatory/files/entities/misc/custom_cards/pipe_bomb_death_trigger.xml") --dormant crystal death trigger

--balance changes
modify_existing_spell("LIGHT_BULLET", "mana", 10)
modify_existing_spell("LIGHT_BULLET_TRIGGER", "mana", 20)
modify_existing_spell("BULLET_TRIGGER", "mana", 25) --magic arrow
modify_existing_spell("BULLET_TIMER", "mana", 20)
modify_existing_spell("HEAVY_BULLET", "mana", 25) --magic bolt
modify_existing_spell("HEAVY_BULLET_TRIGGER", "mana", 30)
modify_existing_spell("HEAVY_BULLET_TIMER", "mana", 25)
modify_existing_spell("SLOW_BULLET_TRIGGER", "mana", 35) --energy orb
modify_existing_spell("SLOW_BULLET_TIMER", "mana", 30)
modify_existing_spell("SPITTER_TIMER", "mana", 5) --spitter bolt
modify_existing_spell("SPITTER_TIER_2", "mana", 15) --large spitter bolt
modify_existing_spell("SPITTER_TIER_2_TIMER", "mana", 15)
modify_existing_spell("SPITTER_TIER_3", "related_projectiles", {"mods/purgatory/files/entities/projectiles/deck/spitter_tier_3.xml"}) --giant spittle bolt
modify_existing_spell(
	"SPITTER_TIER_3",
	"action",
	function()
		add_projectile("mods/purgatory/files/entities/projectiles/deck/spitter_tier_3.xml")
		c.fire_rate_wait = c.fire_rate_wait - 4
		c.screenshake = c.screenshake + 3.1
		c.dampening = 0.3
		c.spread_degrees = c.spread_degrees + 9.0
	end
)
modify_existing_spell("SPITTER_TIER_3", "mana", 20)
modify_existing_spell("SPITTER_TIER_3_TIMER", "related_projectiles", {"mods/purgatory/files/entities/projectiles/deck/spitter_tier_3.xml"}) --giant spittle bolt
modify_existing_spell(
	"SPITTER_TIER_3_TIMER",
	"action",
	function()
		add_projectile_trigger_timer("mods/purgatory/files/entities/projectiles/deck/spitter_tier_3.xml", 40, 1)
		-- damage = 0.1
		c.fire_rate_wait = c.fire_rate_wait - 4
		c.screenshake = c.screenshake + 3.1
		c.dampening = 0.3
		c.spread_degrees = c.spread_degrees + 9.0
	end
)
modify_existing_spell("SPITTER_TIER_3_TIMER", "mana", 20)
modify_existing_spell("BUBBLESHOT_TRIGGER", "mana", 10) --bubble spark
modify_existing_spell("BOUNCY_ORB", "mana", 15) --energy sphere
modify_existing_spell("BOUNCY_ORB_TIMER", "mana", 15)
modify_existing_spell("RUBBER_BALL", "mana", 1) --bouncing burst
modify_existing_spell("ARROW", "mana", 5) --arrow
modify_existing_spell("POLLEN", "mana", 10) --pollen
modify_existing_spell("LANCE", "mana", 20) --glowing lance
modify_existing_spell("LASER", "mana", 25) --concentrated light
modify_existing_spell("MEGALASER", "mana", 50) --intense concentrated light
modify_existing_spell("CHAIN_BOLT", "mana", 20) --chainbolt
modify_existing_spell("FIREBALL", "mana", 30) --fireball
modify_existing_spell("FLAMETHROWER", "mana", 5) --flamethrower
modify_existing_spell("FLAMETHROWER", "max_uses", -1)
modify_existing_spell(
	"FLAMETHROWER",
	"action",
	function()
		add_projectile("data/entities/projectiles/deck/flamethrower.xml")
		c.spread_degrees = c.spread_degrees + 4.0
		current_reload_time = current_reload_time - 6
		c.fire_rate_wait = c.fire_rate_wait - 15
	end
)
modify_existing_spell("ICEBALL", "mana", 35) --iceball
modify_existing_spell("DARKFLAME", "mana", 50) --path of dark flame
modify_existing_spell("MISSILE", "mana", 50) --summon missile
modify_existing_spell("MISSILE", "related_projectiles", {"mods/purgatory/files/entities/projectiles/deck/rocket_player.xml"})
modify_existing_spell(
	"MISSILE",
	"action",
	function()
		add_projectile("mods/purgatory/files/entities/projectiles/deck/rocket_player.xml")
		current_reload_time = current_reload_time + 15
		c.spread_degrees = c.spread_degrees + 3.0
		shot_effects.recoil_knockback = shot_effects.recoil_knockback + 60.0
	end
)

modify_existing_spell("FREEZING_GAZE", "mana", 30) --freezing gaze
modify_existing_spell("GLOWING_BOLT", "mana", 45) --pinpoint of light
modify_existing_spell(
	"GLOWING_BOLT",
	"action",
	function()
		add_projectile("data/entities/projectiles/deck/glowing_bolt.xml")
		c.fire_rate_wait = c.fire_rate_wait + 40
		c.spread_degrees = c.spread_degrees - 6.0
	end
)
modify_existing_spell("EXPANDING_ORB", "mana", 45) --expanding orb
modify_existing_spell("EXPANDING_ORB", "related_projectiles", {"mods/purgatory/files/entities/projectiles/deck/orb_expanding.xml"})
modify_existing_spell(
	"EXPANDING_ORB",
	"action",
	function()
		add_projectile("mods/purgatory/files/entities/projectiles/deck/orb_expanding.xml")
		c.fire_rate_wait = c.fire_rate_wait + 30
		shot_effects.recoil_knockback = 20.0
	end
)
modify_existing_spell("DEATH_CROSS", "mana", 30) --death cross
modify_existing_spell("DEATH_CROSS_BIG", "mana", 80) --giga death cross
modify_existing_spell("PURPLE_EXPLOSION_FIELD", "mana", 50) --glittering field
modify_existing_spell("MIST_RADIOACTIVE", "mana", 25) --toxic mist
modify_existing_spell("MIST_ALCOHOL", "mana", 15) --mist of spirits
modify_existing_spell("MIST_SLIME", "mana", 30) --slime mist
modify_existing_spell("MIST_BLOOD", "mana", 30) --blood mist
modify_existing_spell("FIREWORK", "mana", 35) --fireworks
modify_existing_spell("RECHARGE", "mana", 8) --reduce recharge time
modify_existing_spell("LIFETIME", "mana", 20) --increase lifetime
modify_existing_spell("PHASING_ARC", "mana", 10) --phasing
modify_existing_spell("CLIPPING_SHOT", "mana", 30) --drilling
modify_existing_spell(
	"CLIPPING_SHOT",
	"action",
	function()
		c.extra_entities = c.extra_entities .. "data/entities/misc/clipping_shot.xml,"
		c.fire_rate_wait = c.fire_rate_wait + 15
		current_reload_time = current_reload_time + 6
		draw_actions(1, true)
	end
)
modify_existing_spell("AREA_DAMAGE", "mana", 15) --damage field
modify_existing_spell("HITFX_TOXIC_CHARM", "mana", 5) --charm on toxic sludge
modify_existing_spell("HITFX_EXPLOSION_SLIME_GIGA", "mana", 40) --giant explosion on slimy
modify_existing_spell("HITFX_EXPLOSION_ALCOHOL_GIGA", "mana", 40) --giant explosion on drunk
modify_existing_spell("BOUNCE_LARPA", "mana", 50) --larpa bounce
modify_existing_spell("FIREBALL_RAY", "mana", 20) --fireball thrower
modify_existing_spell("LIGHTNING_RAY", "mana", 20) --lightning thrower
modify_existing_spell("TENTACLE_RAY", "mana", 20) --tentacler
modify_existing_spell("LASER_EMITTER_RAY", "mana", 20) --plasma beam thrower
modify_existing_spell("FIREBALL_RAY_LINE", "mana", 25) --two way fireball thrower
modify_existing_spell("ORBIT_DISCS", "mana", 40) --sawblade orbit
modify_existing_spell("ORBIT_LARPA", "mana", 75) --orbit larpa
modify_existing_spell("CHAIN_SHOT", "mana", 35) --chain spell
modify_existing_spell("LARPA_CHAOS", "mana", 60) --chaos larpa
modify_existing_spell("LARPA_DOWNWARDS", "mana", 70) --dowwards larpa
modify_existing_spell("LARPA_UPWARDS", "mana", 70) --upwards larpa
modify_existing_spell("LARPA_CHAOS_2", "mana", 75) --copy trail
modify_existing_spell("LARPA_DEATH", "mana", 50) --larpa explosion

--Bug Fixes in vanilla spells
modify_existing_spell("VACUUM_ENTITIES", "related_projectiles", {"data/entities/projectiles/deck/vacuum_entities.xml"})

--ADD NEW SPELLS
spells_to_add = {
	--[[
	{
		id          = "LIGHT_BULLET_ENEMY_TRIGGER",
		name 		= "$action_light_bullet_enemy_trigger",
		description = "$actiondesc_light_bullet_enemy_trigger",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/light_bullet_enemy_trigger.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/light_bullet_trigger_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/light_bullet.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level = "0,1,2,4,5,6,10",
		spawn_probability = "0,0,0,0,0,0,0",
		price = 140,
		mana = 10,
		--max_uses = 100,
		action 		= function()
			--c.fire_rate_wait = c.fire_rate_wait + 3
			--c.screenshake = c.screenshake + 0.5
			--c.damage_critical_chance = c.damage_critical_chance + 5
			--add_projectile_trigger_hit_world("data/entities/projectiles/deck/light_bullet.xml", 1)
			--c.extra_entities = c.extra_entities .. "data/entities/misc/hitfx_fireball_ray_enemy.xml,"
			

			--So what I need to do is get the spells that would be in the trigger, make them into a modifier and tie them into the c.extra_entities enemy_trigger.xml
			c.extra_entities = c.extra_entities .. "mods/purgatory/files/entities/misc/enemy_trigger.xml"
			add_projectile("data/entities/projectiles/deck/light_bullet.xml")
		end,
	},

	{
		id = "TEST_SPELL",
		name = "$action_test_spell",
		description = "$actiondesc_test_spell",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/test_spell.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		type = ACTION_TYPE_UTILITY,
		spawn_level = "10",
		spawn_probability = "0",
		price = 420,
		mana = 0,
		action 		= function()
			add_projectile("mods/purgatory/files/entities/misc/test_projectile.xml")
			--c.extra_entities = c.extra_entities .. "mods/purgatory/files/entities/misc/test.xml,"
			--draw_actions( 1, true )
		end,
	},
]]
	{
		id = "LIGHT_BULLET_DEATH_TRIGGER",
		name = "$action_light_bullet_death_trigger",
		description = "$actiondesc_light_bullet_death_trigger",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/light_bullet_death_trigger.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		related_projectiles = {"data/entities/projectiles/deck/light_bullet.xml"},
		type = ACTION_TYPE_PROJECTILE,
		spawn_level = "0,1,2,3",
		spawn_probability = "0.75,0.3,0.3,0.3",
		price = 140,
		mana = 15,
		action = function()
			add_projectile_trigger_death("data/entities/projectiles/deck/light_bullet.xml", 1)
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.screenshake = c.screenshake + 0.5
			c.damage_critical_chance = c.damage_critical_chance + 5
		end
	},
	{
		id = "LIGHT_BULLET_TRIGGER_TIMER",
		name = "$action_light_bullet_trigger_timer",
		description = "$actiondesc_light_bullet_trigger_timer",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/light_bullet_trigger_timer.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		related_projectiles = {"mods/purgatory/files/entities/projectiles/deck/light_bullet_orange.xml"},
		type = ACTION_TYPE_PROJECTILE,
		spawn_level = "0,1,2,4,5,6,10",
		spawn_probability = "0,0,0,0,0,0,0.25",
		price = 140,
		mana = 20,
		action = function()
			add_projectile_trigger_and_timer("mods/purgatory/files/entities/projectiles/deck/light_bullet_orange.xml", 1, 10)
			c.fire_rate_wait = c.fire_rate_wait + 5
			c.screenshake = c.screenshake + 0.5
			c.damage_critical_chance = c.damage_critical_chance + 5
		end
	},
	{
		id = "LIGHT_BULLET_TRIGGER_DEATH_TRIGGER",
		name = "$action_light_bullet_trigger_death_trigger",
		description = "$actiondesc_light_bullet_trigger_death_trigger",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/light_bullet_trigger_death_trigger.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		related_projectiles = {"mods/purgatory/files/entities/projectiles/deck/light_bullet_orange.xml"},
		type = ACTION_TYPE_PROJECTILE,
		spawn_level = "0,1,2,4,5,6,10",
		spawn_probability = "0,0,0,0,0,0,0.25",
		price = 140,
		mana = 20,
		action = function()
			add_projectile_trigger_and_death_trigger("mods/purgatory/files/entities/projectiles/deck/light_bullet_orange.xml", 1)
			c.fire_rate_wait = c.fire_rate_wait + 5
			c.screenshake = c.screenshake + 0.5
			c.damage_critical_chance = c.damage_critical_chance + 5
		end
	},
	{
		id = "LIGHT_BULLET_TIMER_DEATH_TRIGGER",
		name = "$action_light_bullet_timer_death_trigger",
		description = "$actiondesc_light_bullet_timer_death_trigger",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/light_bullet_timer_death_trigger.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		related_projectiles = {"data/entities/projectiles/deck/light_bullet.xml"},
		type = ACTION_TYPE_PROJECTILE,
		spawn_level = "0,1,2,4,5,6,10",
		spawn_probability = "0,0,0,0,0,0,0.25",
		price = 140,
		mana = 20,
		action = function()
			add_projectile_timer_and_death_trigger("mods/purgatory/files/entities/projectiles/deck/light_bullet_orange.xml", 1, 10)
			c.fire_rate_wait = c.fire_rate_wait + 5
			c.screenshake = c.screenshake + 0.5
			c.damage_critical_chance = c.damage_critical_chance + 5
		end
	},
	{
		id = "LIGHT_BULLET_TRIGGER_TRIGGER",
		name = "$action_light_bullet_trigger_trigger",
		description = "$actiondesc_light_bullet_trigger_trigger",
		sprite = "data/ui_gfx/gun_actions/light_bullet_trigger_2.png",
		related_projectiles = {"data/entities/projectiles/deck/light_bullet_blue.xml"},
		type = ACTION_TYPE_PROJECTILE,
		spawn_level = "0,1,2,4,5,6,10",
		spawn_probability = "0,0,0,0,0,0,0.25",
		price = 250,
		mana = 20,
		--max_uses = 100,
		action = function()
			c.fire_rate_wait = c.fire_rate_wait + 4
			c.screenshake = c.screenshake + 1
			c.damage_critical_chance = c.damage_critical_chance + 5
			add_projectile_trigger_and_trigger("data/entities/projectiles/deck/light_bullet_blue.xml", 1)
		end
	},
	{
		id = "LIGHT_BULLET_TIMER_TIMER",
		name = "$action_light_bullet_timer_timer",
		description = "$actiondesc_light_bullet_timer_timer",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/light_bullet_timer_timer.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		related_projectiles = {"data/entities/projectiles/deck/light_bullet_blue.xml"},
		type = ACTION_TYPE_PROJECTILE,
		spawn_level = "0,1,2,4,5,6,10",
		spawn_probability = "0,0,0,0,0,0,0.25",
		price = 140,
		mana = 20,
		action = function()
			add_projectile_timer_and_timer("data/entities/projectiles/deck/light_bullet_blue.xml", 1, 10)
			c.fire_rate_wait = c.fire_rate_wait + 4
			c.screenshake = c.screenshake + 1
			c.damage_critical_chance = c.damage_critical_chance + 5
		end
	},
	{
		id = "LIGHT_BULLET_DEATH_TRIGGER_DEATH_TRIGGER",
		name = "$action_light_bullet_death_trigger_death_trigger",
		description = "$actiondesc_light_bullet_death_trigger_death_trigger",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/light_bullet_death_trigger_death_trigger.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		related_projectiles = {"data/entities/projectiles/deck/light_bullet_blue.xml"},
		type = ACTION_TYPE_PROJECTILE,
		spawn_level = "0,1,2,4,5,6,10",
		spawn_probability = "0,0,0,0,0,0,0.25",
		price = 140,
		mana = 20,
		action = function()
			add_projectile_death_trigger_and_death_trigger("data/entities/projectiles/deck/light_bullet_blue.xml", 1)
			c.fire_rate_wait = c.fire_rate_wait + 4
			c.screenshake = c.screenshake + 1
			c.damage_critical_chance = c.damage_critical_chance + 5
		end
	},
	{
		id = "WORLD_EATER",
		name = "$action_world_eater",
		description = "$actiondesc_world_eater",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/world_eater.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		related_projectiles = {"data/entities/animals/worm_big.xml"},
		type = ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level = "0,1,2,4,5,6,10",
		spawn_probability = "0,0,0,0,0,0,0",
		price = 600,
		mana = 200,
		action = function()
			add_projectile("mods/purgatory/files/entities/projectiles/deck/world_eater.xml")
			c.fire_rate_wait = c.fire_rate_wait + 60
			current_reload_time = current_reload_time + 60
		end
	},
	{
		id = "SUMMON_POTION_FLASK",
		name = "$action_summon_potion_flask",
		description = "$actiondesc_summon_potion_flask",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/summon_potion_flask.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		spawn_requires_flag = "purgatory_alchemist_spells",
		type = ACTION_TYPE_UTILITY,
		spawn_level = "10",
		spawn_probability = "0.5",
		price = 420,
		mana = 100,
		max_uses = 5,
		never_unlimited = true,
		action = function()
			add_projectile("data/entities/items/pickup/potion.xml")
		end
	},
	{
		id = "SUMMON_POWDER_SACK",
		name = "$action_summon_powder_sack",
		description = "$actiondesc_summon_powder_sack",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/summon_powder_sack.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		spawn_requires_flag = "purgatory_alchemist_spells",
		type = ACTION_TYPE_UTILITY,
		spawn_level = "10",
		spawn_probability = "0.5",
		price = 420,
		mana = 100,
		max_uses = 5,
		never_unlimited = true,
		action = function()
			add_projectile("data/entities/items/pickup/powder_stash.xml")
		end
	},
	{
		id = "CHAOTIC_TRAIL",
		name = "$action_chaotic_trail",
		description = "$actiondesc_chaotic_trail",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/chaotic_trail.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		spawn_requires_flag = "purgatory_alchemist_spells",
		type = ACTION_TYPE_MODIFIER,
		spawn_level = "1,2,3,4", -- WATER_TRAIL
		spawn_probability = "0.1,0.2,0.2,0.25", -- WATER_TRAIL
		price = 160,
		mana = 50,
		max_uses = 8,
		custom_xml_file = "data/entities/misc/custom_cards/water_trail.xml",
		action = function()
			local material_options = {
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
				"silver"
			}
			local material_options_rare = {
				"acid",
				"magic_liquid_teleportation",
				"magic_liquid_polymorph",
				"magic_liquid_random_polymorph",
				"magic_liquid_berserk",
				"magic_liquid_charm",
				"magic_liquid_invisibility"
			}
			local rare = false
			local rnd = Random(1, 100)

			if (rnd > 98) then
				rare = true
			end

			local material = "water"

			if (rare == false) then
				rnd = Random(1, #material_options)
				material = material_options[rnd]
			else
				rnd = Random(1, #material_options_rare)
				material = material_options_rare[rnd]
			end

			c.trail_material = c.trail_material .. material
			c.trail_material_amount = c.trail_material_amount + 20
			draw_actions(1, true)
		end
	},
	{
		id = "MATERIAL_LAVA",
		name = "$action_material_lava",
		description = "$actiondesc_material_lava",
		sprite = "data/ui_gfx/gun_actions/material_lava.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		type = ACTION_TYPE_MATERIAL,
		spawn_requires_flag = "purgatory_alchemist_spells",
		spawn_level = "2,3,4,5,6", -- MATERIAL_GUNPOWDER_EXPLOSIVE
		spawn_probability = "0.4,0.4,0.4,0.4,0.4", -- MATERIAL_GUNPOWDER_EXPLOSIVE
		price = 100,
		mana = 0,
		sound_loop_tag = "sound_spray",
		action = function()
			add_projectile("data/entities/projectiles/deck/material_lava.xml")
			c.fire_rate_wait = c.fire_rate_wait - 25
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 30 -- this is a hack to get the cement reload time back to 0
		end
	},
	{
		id = "MATERIAL_GUNPOWDER_EXPLOSIVE",
		name = "$action_material_gunpowder_explosive",
		description = "$actiondesc_material_gunpowder_explosive",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/material_gunpowder.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		type = ACTION_TYPE_MATERIAL,
		spawn_requires_flag = "purgatory_alchemist_spells",
		spawn_level = "2,3,4,5,6", -- MATERIAL_GUNPOWDER_EXPLOSIVE
		spawn_probability = "0.4,0.4,0.4,0.4,0.4", -- MATERIAL_GUNPOWDER_EXPLOSIVE
		price = 100,
		mana = 0,
		sound_loop_tag = "sound_spray",
		action = function()
			add_projectile("data/entities/projectiles/deck/material_gunpowder_explosive.xml")
			c.fire_rate_wait = c.fire_rate_wait - 5
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 15
		end
	},
	{
		id = "MATERIAL_DIRT",
		name = "$action_material_dirt",
		description = "$actiondesc_material_dirt",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/material_dirt.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		type = ACTION_TYPE_MATERIAL,
		spawn_requires_flag = "purgatory_alchemist_spells",
		spawn_level = "2,3,4,5,6", -- MATERIAL_DIRT
		spawn_probability = "0.4,0.4,0.4,0.4,0.4", -- MATERIAL_DIRT
		price = 100,
		mana = 0,
		sound_loop_tag = "sound_spray",
		action = function()
			add_projectile("data/entities/projectiles/deck/material_dirt.xml")
			c.fire_rate_wait = c.fire_rate_wait + 0
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10
		end
	},
	{
		id = "PERSONAL_PLASMA_BEAM",
		name = "$action_personal_plasma_beam",
		description = "$actiondesc_personal_plasma_beam",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/personal_plasma_beam.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		type = ACTION_TYPE_PASSIVE,
		spawn_level = "1,2,3,4,5,6", -- ENERGY_SHIELD
		spawn_probability = "0.05,0.6,0.6,0.6,0.6,0.6", -- ENERGY_SHIELD
		price = 220,
		mana = 0,
		custom_xml_file = "mods/purgatory/files/entities/projectiles/deck/personal_plasma_beam.xml",
		action = function()
			-- does nothing to the projectiles
			c.fire_rate_wait = c.fire_rate_wait + 33
			draw_actions(1, true)
		end
	},
	{
		id = "VACUUM_GOLD",
		name = "$action_vacuum_gold",
		description = "$actiondesc_vacuum_gold",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/gold_vacuum.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		related_projectiles = {"data/entities/projectiles/deck/vacuum_powder.xml"},
		type = ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level = "2,3,5,6", -- VACUUM_GOLD
		spawn_probability = "0.3,1,0.3,0.3", -- VACUUM_GOLD
		price = 150,
		mana = 80,
		max_uses = 10,
		action = function()
			add_projectile("mods/purgatory/files/entities/projectiles/deck/gold_vacuum.xml")
			c.fire_rate_wait = c.fire_rate_wait + 10
		end
	},
	{
		id = "GOLD_MULTIPLIER",
		name = "$action_gold_multiplier",
		description = "$actiondesc_gold_multiplier",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/gold_multiplier.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		type = ACTION_TYPE_MODIFIER,
		spawn_level = "2,3,4", -- GOLD_MULTIPLIER
		spawn_probability = "0.3,0.3,0.3", -- GOLD_MULTIPLIER
		price = 60,
		mana = 100,
		max_uses = 10,
		action = function()
			c.fire_rate_wait = c.fire_rate_wait + 20
			c.extra_entities = c.extra_entities .. "mods/purgatory/files/entities/misc/money_multiplier.xml,"
			draw_actions(1, true)
		end
	},
	{
		id = "GIGA_PROPANE_TANK",
		name = "$action_giga_propane_tank",
		description = "$actiondesc_giga_propane_tank",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/giga_propane_tank.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		type = ACTION_TYPE_PROJECTILE,
		spawn_level = "0,1,2,3,4,5,6,10", -- PROPANE_TANK
		spawn_probability = "0,0,0,0.5,0.7,0.8,0.9,0.2", -- PROPANE_TANK
		price = 300,
		mana = 100,
		max_uses = 5,
		custom_xml_file = "mods/purgatory/files/entities/misc/custom_cards/giga_propane_tank.xml", --used for bombs materilized
		related_projectiles = {"mods/purgatory/files/entities/projectiles/giga_propane_tank.xml"},
		action = function()
			add_projectile("mods/purgatory/files/entities/projectiles/giga_propane_tank.xml")
			c.fire_rate_wait = c.fire_rate_wait + 150
			c.extra_entities = c.extra_entities .. "data/entities/particles/freeze_charge.xml,"
		end
	},
	{
		id = "OMEGA_PROPANE_TANK",
		name = "$action_omega_propane_tank",
		description = "$actiondesc_omega_propane_tank",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/omega_propane_tank.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		type = ACTION_TYPE_PROJECTILE,
		spawn_level = "0,1,2,3,4,5,6,10", -- PROPANE_TANK
		spawn_probability = "0,0,0,0.0,0.0,0.0,0.0,0.1", -- PROPANE_TANK
		price = 300,
		mana = 500,
		max_uses = 1,
		custom_xml_file = "mods/purgatory/files/entities/misc/custom_cards/omega_propane_tank.xml", --used for bombs materilized
		related_projectiles = {"mods/purgatory/files/entities/projectiles/omega_propane_tank.xml"},
		action = function()
			add_projectile("mods/purgatory/files/entities/projectiles/omega_propane_tank.xml")
			c.fire_rate_wait = c.fire_rate_wait + 300
			current_reload_time = current_reload_time + 800
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 300.0
		end
	},
	{
		id = "SUMMON_HAMIS",
		name = "$action_summon_hamis",
		description = "$actiondesc_summon_hamis",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/summon_hamis.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		related_projectiles = {"mods/purgatory/files/entities/projectiles/summon_hamis.xml"},
		type = ACTION_TYPE_UTILITY,
		spawn_level = "0,1,2", -- SUMMON_HAMIS
		spawn_probability = "0.6,0.6,0.6", -- SUMMON_HAMIS
		price = 200,
		mana = 10,
		max_uses = 100,
		custom_xml_file = "mods/purgatory/files/entities/misc/custom_cards/summon_hamis.xml",
		action = function()
			add_projectile("mods/purgatory/files/entities/projectiles/summon_hamis.xml")
		end
	},
	{
		id = "CROSS_SHAPE",
		name = "$action_cross_shape",
		description = "$actiondesc_cross_shape",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/cross_shape.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		type = ACTION_TYPE_DRAW_MANY,
		spawn_level = "2,3,4,5,6", -- CROSS_SHAPE
		spawn_probability = "0.4,0.3,0.3,0.3,0.3", -- CROSS_SHAPE
		price = 120,
		mana = 2,
		--max_uses = 100,
		action = function()
			draw_actions(4, true)
			c.pattern_degrees = 180
		end
	},
	{
		id = "IF_MANA",
		name = "$action_if_mana",
		description = "$actiondesc_if_mana",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/if_mana.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		spawn_requires_flag = "card_unlocked_maths",
		type = ACTION_TYPE_OTHER,
		spawn_level = "10", -- IF_MANA
		spawn_probability = "1", -- IF_MANA
		ai_never_uses = true,
		price = 100,
		mana = 0,
		action = function(recursion_level, iteration)
			local endpoint = -1
			local elsepoint = -1
			local max_mana = get_held_wand_max_mana()
			local current_mana = get_held_wand_current_mana()
			local manadiff = current_mana / max_mana
			local doskip = false

			if (manadiff < 0.20) then
				doskip = true
			end

			if (#deck > 0) then
				for i, v in ipairs(deck) do
					if (v ~= nil) then
						if (string.sub(v.id, 1, 3) == "IF_") and (v.id ~= "IF_END") and (v.id ~= "IF_ELSE") then
							endpoint = -1
							break
						end

						if (v.id == "IF_ELSE") then
							endpoint = i
							elsepoint = i
						end

						if (v.id == "IF_END") then
							endpoint = i
							break
						end
					end
				end

				local envelope_min = 1
				local envelope_max = 1

				if doskip then
					if (elsepoint > 0) then
						envelope_max = elsepoint
					elseif (endpoint > 0) then
						envelope_max = endpoint
					end

					for i = envelope_min, envelope_max do
						local v = deck[envelope_min]

						if (v ~= nil) then
							table.insert(discarded, v)
							table.remove(deck, envelope_min)
						end
					end
				else
					if (elsepoint > 0) then
						envelope_min = elsepoint

						if (endpoint > 0) then
							envelope_max = endpoint
						else
							envelope_max = #deck
						end

						for i = envelope_min, envelope_max do
							local v = deck[envelope_min]

							if (v ~= nil) then
								table.insert(discarded, v)
								table.remove(deck, envelope_min)
							end
						end
					end
				end
			end

			draw_actions(1, true)
		end
	},
	{
		id = "ENLIGHTENED_LASER_DARKBEAM",
		name = "$action_enlightened_laser_darkbeam",
		description = "$actiondesc_enlightened_laser_darkbeam",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/enlightened_laser_darkbeam.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		related_projectiles = {"data/entities/projectiles/enlightened_laser_darkbeam.xml"},
		type = ACTION_TYPE_PROJECTILE,
		price = 280,
		mana = 60,
		action = function()
			add_projectile("data/entities/projectiles/enlightened_laser_darkbeam.xml")
			c.fire_rate_wait = c.fire_rate_wait - 40
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 30
			c.spread_degrees = c.spread_degrees - 6.0
		end
	},
	{
		id = "ALL_PROPANE",
		name = "$action_all_propane",
		description = "$actiondesc_all_propane",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/all_propane.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		spawn_requires_flag = "card_unlocked_alchemy",
		type = ACTION_TYPE_UTILITY,
		spawn_level = "6,10", -- ALL_PROPANE
		spawn_probability = "0.1,1", -- ALL_PROPANE
		price = 600,
		mana = 100,
		ai_never_uses = true,
		max_uses = 5,
		action = function()
			add_projectile("mods/purgatory/files/entities/projectiles/all_propane.xml")
			c.fire_rate_wait = c.fire_rate_wait + 100
			current_reload_time = current_reload_time + 100
		end
	},
	{
		id = "ALL_DUCKS",
		name = "$action_all_ducks",
		description = "$actiondesc_all_ducks",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/all_ducks.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		spawn_requires_flag = "card_unlocked_alchemy",
		type = ACTION_TYPE_UTILITY,
		spawn_level = "6,10", -- ALL_DUCKS
		spawn_probability = "0.1,1", -- ALL_DUCKS
		price = 600,
		mana = 100,
		ai_never_uses = true,
		max_uses = 5,
		action = function()
			add_projectile("mods/purgatory/files/entities/projectiles/all_ducks.xml")
			c.fire_rate_wait = c.fire_rate_wait + 100
			current_reload_time = current_reload_time + 100
		end
	},
	{
		id = "OMEGA_NUKE",
		name = "$action_omega_nuke",
		description = "$actiondesc_omega_nuke",
		spawn_requires_flag = "purgatory_omega_nuke",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/omega_nuke.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		type = ACTION_TYPE_PROJECTILE,
		spawn_level = "10", -- OMEGA_NUKE
		spawn_probability = "0.05", -- OMEGA_NUKE
		price = 1600,
		mana = 1000,
		max_uses = 1,
		ai_never_uses = true,
		never_unlimited = true,
		action = function()
			add_projectile("mods/purgatory/files/entities/projectiles/deck/omega_nuke.xml")
			c.speed_multiplier = c.speed_multiplier * 0.75
			c.material = "fire"
			c.material_amount = c.material_amount + 60
			c.ragdoll_fx = 2
			c.gore_particles = c.gore_particles + 10
			c.screenshake = c.screenshake + 10.5
			c.fire_rate_wait = c.fire_rate_wait + 120
			current_reload_time = current_reload_time + 1200
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 300.0

			if (c.speed_multiplier >= 20) then
				c.speed_multiplier = math.min(c.speed_multiplier, 20)
			elseif (c.speed_multiplier < 0) then
				c.speed_multiplier = 0
			end
		end
	},
	{
		id = "MATERIAL_URINE",
		name = "$action_material_urine",
		description = "$actiondesc_material_urine",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/material_urine.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		type = ACTION_TYPE_MATERIAL,
		spawn_requires_flag = "purgatory_alchemist_spells",
		spawn_level = "2,3,4,5,6", -- MATERIAL_URINE
		spawn_probability = "0.4,0.4,0.4,0.4,0.4", -- MATERIAL_URINE
		price = 100,
		mana = 0,
		sound_loop_tag = "sound_spray",
		action = function()
			add_projectile("mods/purgatory/files/entities/projectiles/deck/material_urine.xml")
			c.game_effect_entities = c.game_effect_entities .. "mods/purgatory/files/entities/misc/effect_apply_piss.xml,"
			c.fire_rate_wait = c.fire_rate_wait - 15
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the cement reload time back to 0
		end
	},
	{
		id = "COLOUR_RANDOM",
		name = "$action_colour_random",
		description = "$actiondesc_colour_random",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/colour_random.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		type = ACTION_TYPE_MODIFIER,
		spawn_level = "2,3,4", -- COLOUR_RANDOM
		spawn_probability = "0.1,0.1,0.1", -- COLOUR_RANDOM
		spawn_requires_flag = "card_unlocked_paint",
		price = 40,
		mana = 0,
		--max_uses = 100,
		action = function()
			c.extra_entities = c.extra_entities .. "data/entities/particles/tinyspark_red.xml,mods/purgatory/files/entities/misc/colour_random.xml,"
			c.fire_rate_wait = c.fire_rate_wait - 8
			c.screenshake = c.screenshake - 2.5
			if (c.screenshake < 0) then
				c.screenshake = 0
			end
			draw_actions(1, true)
		end
	},
	{
		id = "COLOUR_WHITE",
		name = "$action_colour_white",
		description = "$actiondesc_colour_white",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/colour_white.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		type = ACTION_TYPE_MODIFIER,
		spawn_level = "2,3,4", -- COLOUR_RANDOM
		spawn_probability = "0.1,0.1,0.1", -- COLOUR_RANDOM
		spawn_requires_flag = "card_unlocked_paint",
		price = 40,
		mana = 0,
		--max_uses = 100,
		action = function()
			c.extra_entities = c.extra_entities .. "data/entities/particles/tinyspark_red.xml,mods/purgatory/files/entities/misc/colour_white.xml,"
			c.fire_rate_wait = c.fire_rate_wait - 8
			c.screenshake = c.screenshake - 2.5
			if (c.screenshake < 0) then
				c.screenshake = 0
			end
			draw_actions(1, true)
		end
	},
	{
		id = "COLOUR_BLACK",
		name = "$action_colour_black",
		description = "$actiondesc_colour_black",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/colour_black.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		type = ACTION_TYPE_MODIFIER,
		spawn_level = "2,3,4", -- COLOUR_RANDOM
		spawn_probability = "0.1,0.1,0.1", -- COLOUR_RANDOM
		spawn_requires_flag = "card_unlocked_paint",
		price = 40,
		mana = 0,
		--max_uses = 100,
		action = function()
			c.extra_entities = c.extra_entities .. "data/entities/particles/tinyspark_red.xml,mods/purgatory/files/entities/misc/colour_black.xml,"
			c.fire_rate_wait = c.fire_rate_wait - 8
			c.screenshake = c.screenshake - 2.5
			if (c.screenshake < 0) then
				c.screenshake = 0
			end
			draw_actions(1, true)
		end
	},
	--[[
		Note Priskip: Modifier is applied 1 frame too late to remove audio components - May need Engine Modding to make feasable
	{
		id = "MUTE",
		name = "$action_mute",
		description = "$actiondesc_mute",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/mute.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		type = ACTION_TYPE_MODIFIER,
		spawn_level = "10", -- MUTE
		spawn_probability = "0.5", -- MUTE
		price = 20,
		mana = 0,
		action = function()
			c.extra_entities = c.extra_entities .. "mods/purgatory/files/entities/misc/mute.xml,"
			draw_actions(1, true)
		end
	}
	]]
	{
		id = "CLOUD_POLYMORPH",
		name = "$action_cloud_polymorph",
		description = "$actiondesc_cloud_polymorph",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/cloud_polymorph.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		related_projectiles = {"mods/purgatory/files/entities/projectiles/deck/cloud_polymorph.xml"},
		type = ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level = "0,1,2,3,4,5",
		spawn_probability = "0.1,0.1,0.1,0.1,0.1,0.1",
		price = 250,
		mana = 50,
		max_uses = 10,
		action = function()
			add_projectile("mods/purgatory/files/entities/projectiles/deck/cloud_polymorph.xml")
			c.fire_rate_wait = c.fire_rate_wait + 30
		end
	},
	{
		id = "MIST_FREEZING",
		name = "$action_mist_freezing",
		description = "$actiondesc_mist_freezing",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/mist_freezing.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		related_projectiles = {"mods/purgatory/files/entities/projectiles/deck/mist_freezing.xml"},
		type = ACTION_TYPE_PROJECTILE,
		spawn_level = "1,2,3,4",
		spawn_probability = "0.4,0.4,0.4,0.4",
		price = 160,
		mana = 80,
		max_uses = 5,
		action = function()
			add_projectile("mods/purgatory/files/entities/projectiles/deck/mist_freezing.xml")
			c.fire_rate_wait = c.fire_rate_wait + 10
		end
	},
	{
		id = "POLLEN_DEATH_TRIGGER",
		name = "$action_pollen_death_trigger",
		description = "$actiondesc_pollen_death_trigger",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/pollen_death_trigger.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		related_projectiles = {"data/entities/projectiles/deck/pollen.xml"},
		type = ACTION_TYPE_PROJECTILE,
		spawn_level = "0,1,3,4",
		spawn_probability = "0.6,1,1,0.8",
		price = 110,
		mana = 15,
		--max_uses = 40,
		action = function()
			add_projectile_trigger_death("data/entities/projectiles/deck/pollen.xml", 1)
			c.fire_rate_wait = c.fire_rate_wait + 2
			c.spread_degrees = c.spread_degrees + 20
		end
	},
	{
		id = "SOSIG",
		name = "$action_sosig",
		description = "$actiondesc_sosig",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/sosig.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		related_projectiles = {"data/entities/projectiles/deck/sausage.xml"},
		type = ACTION_TYPE_PROJECTILE,
		spawn_level = "10",
		spawn_probability = "0.0",
		price = 140,
		mana = 5,
		max_uses = 10,
		action = function()
			add_projectile("data/entities/projectiles/deck/sausage.xml")
		end
	},
	{
		id = "UNSTABLE_POLYMORPH_FIELD",
		name = "$action_unstable_polymorph_field",
		description = "$actiondesc_unstable_polymorph_field",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/unstable_polymorph_field.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		related_projectiles = {"mods/purgatory/files/entities/projectiles/deck/unstable_polymorph_field.xml"},
		type = ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level = "1,2,3,4,5,6",
		spawn_probability = "0.3,0.3,0.4,0.6,0.3,0.3",
		price = 200,
		mana = 35,
		max_uses = 10,
		action = function()
			add_projectile("mods/purgatory/files/entities/projectiles/deck/unstable_polymorph_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end
	},
	{
		id = "LUMINOUS_DRILL_TIMER",
		name = "$action_luminous_drill_timer",
		description = "$actiondesc_luminous_drill_timer",
		sprite = "data/ui_gfx/gun_actions/luminous_drill_timer.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/chainsaw_unidentified.png",
		related_projectiles = {"data/entities/projectiles/deck/luminous_drill.xml"},
		type = ACTION_TYPE_PROJECTILE,
		spawn_level = "0,2", -- LASER_LUMINOUS_DRILL
		spawn_probability = "1,1", -- LASER_LUMINOUS_DRILL
		price = 220,
		mana = 10,
		--max_uses = 1000,
		sound_loop_tag = "sound_digger",
		action = function()
			add_projectile_trigger_timer("data/entities/projectiles/deck/luminous_drill.xml", 4, 1)
			c.fire_rate_wait = c.fire_rate_wait - 35
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10 -- this is a hack to get the digger reload time back to 0
		end
	},
	{
		id = "POLLEN_BALL",
		name = "$action_pollen_ball",
		description = "$actiondesc_pollen_ball",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/pollen_ball.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		related_projectiles = {"mods/purgatory/files/entities/projectiles/deck/pollen_ball.xml"},
		type = ACTION_TYPE_PROJECTILE,
		spawn_level = "4,5",
		spawn_probability = "0.2,0.3",
		price = 150,
		mana = 50,
		action = function()
			add_projectile("mods/purgatory/files/entities/projectiles/deck/pollen_ball.xml")
		end
	},
	{
		id = "BUBBLESHOT_DEATH_TRIGGER",
		name = "$action_bubbleshot_death_trigger",
		description = "$actiondesc_bubbleshot_trigger",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/bubbleshot_death_trigger.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		related_projectiles = {"data/entities/projectiles/deck/bubbleshot.xml"},
		type = ACTION_TYPE_PROJECTILE,
		spawn_level = "1,2,3", -- BUBBLESHOT
		spawn_probability = "0.6,0.6,0.2", -- BUBBLESHOT
		price = 120,
		mana = 10,
		--max_uses = 120,
		action = function()
			add_projectile_trigger_death("data/entities/projectiles/deck/bubbleshot.xml", 1)
			-- damage = 0.1
			c.fire_rate_wait = c.fire_rate_wait - 5
			c.dampening = 0.1
		end
	},
	{
		id = "BLACKHOLE_SHOT",
		name = "$action_blackhole_shot",
		description = "$actiondesc_blackhole_shot",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/blackhole_shot.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		related_extra_entities = {"mods/purgatory/files/entities/misc/blackhole_shot.xml"},
		type = ACTION_TYPE_MODIFIER,
		spawn_level = "6,10", -- BLACKHOLE_SHOT
		spawn_probability = "0.2,0.2", -- BLACKHOLE_SHOT
		price = 300,
		mana = 100,
		max_uses = 20,
		action = function()
			c.extra_entities = c.extra_entities .. "mods/purgatory/files/entities/misc/blackhole_shot.xml,"
			draw_actions(1, true)
		end
	},
	{
		id = "REMOVE_GRAVITY",
		name = "$action_remove_gravity",
		description = "$actiondesc_remove_gravity",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/remove_gravity.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		related_extra_entities = {"mods/purgatory/files/entities/misc/remove_gravity.xml"},
		type = ACTION_TYPE_MODIFIER,
		spawn_level = "2,3,4", -- REMOVE_GRAVITY
		spawn_probability = "0.2,0.25,0.1", -- REMOVE_GRAVITY
		price = 300,
		mana = 2,
		action = function()
			c.extra_entities = c.extra_entities .. "mods/purgatory/files/entities/misc/remove_gravity.xml,"
			draw_actions(1, true)
		end
	},
	{
		id = "ADD_MANA_SMALL",
		name = "$action_add_mana_small",
		description = "$actiondesc_add_mana_small",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/mana_small.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		type = ACTION_TYPE_MODIFIER,
		spawn_level = "1,2,3,4", -- ADD_MANA_SMALL
		spawn_probability = "0.8,0.8,0.3,0.1", -- ADD_MANA_SMALL
		price = 250,
		mana = -10,
		custom_xml_file = "data/entities/misc/custom_cards/mana_reduce.xml",
		action = function()
			c.fire_rate_wait = c.fire_rate_wait + 5
			draw_actions(1, true)
		end
	},
	{
		id = "ADD_MANA_MEDIUM",
		name = "$action_add_mana_medium",
		description = "$actiondesc_add_mana_medium",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/mana_medium.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		type = ACTION_TYPE_MODIFIER,
		spawn_level = "1,2,3,4,5,6", -- ADD_MANA_MEDIUM
		spawn_probability = "0.1,0.3,0.8,0.8,0.3,0.1", -- ADD_MANA_MEDIUM
		price = 350,
		mana = -20,
		custom_xml_file = "data/entities/misc/custom_cards/mana_reduce.xml",
		action = function()
			c.fire_rate_wait = c.fire_rate_wait + 10
			current_reload_time = current_reload_time + 2
			draw_actions(1, true)
		end
	},
	{
		id = "ADD_MANA_LARGE",
		name = "$action_add_mana_large",
		description = "$actiondesc_add_mana_large",
		sprite = "mods/purgatory/files/ui_gfx/gun_actions/mana_large.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		type = ACTION_TYPE_MODIFIER,
		spawn_level = "3,4,5,6", -- ADD_MANA_LARGE
		spawn_probability = "0.2,0.4,0.8,0.8", -- ADD_MANA_LARGE
		price = 450,
		mana = -30,
		custom_xml_file = "data/entities/misc/custom_cards/mana_reduce.xml",
		action = function()
			c.fire_rate_wait = c.fire_rate_wait + 15
			current_reload_time = current_reload_time + 5
			draw_actions(1, true)
		end
	},
	{
		id          = "VACUUM_BLOOD",
		name 		= "$action_vacuum_blood",
		description = "$actiondesc_vacuum_blood",
		sprite 		= "mods/purgatory/files/ui_gfx/gun_actions/vacuum_blood.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		related_projectiles = {"mods/purgatory/files/entities/projectiles/deck/vacuum_blood.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,10", -- SPELL
		spawn_probability                 = "0,0,0,0,0,0,0,0", -- SPELL
		price = 500,
		mana = 50,
		max_uses = 5;
		action 		= function()
			add_projectile("mods/purgatory/files/entities/projectiles/deck/vacuum_blood.xml")
			c.fire_rate_wait = c.fire_rate_wait + 10
		end,
	},
	{
		id          = "DEATH_CROSS_BIGGER",
		name 		= "$action_death_cross_bigger",
		description = "$actiondesc_death_cross_bigger",
		sprite 		= "mods/purgatory/files/ui_gfx/gun_actions/death_cross_bigger.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		related_projectiles	= {"mods/purgatory/files/entities/projectiles/deck/death_cross_bigger/death_cross_bigger.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level       = "5,6,10", -- DEATH_CROSS_BIGGER
		spawn_probability = "0.1,0.4,0.2", -- DEATH_CROSS_BIGGER
		price = 600,
		mana = 450,
		max_uses = 3,
		custom_xml_file = "data/entities/misc/custom_cards/death_cross.xml",
		action 		= function()
			add_projectile("mods/purgatory/files/entities/projectiles/deck/death_cross_bigger/death_cross_bigger.xml")
			c.fire_rate_wait = c.fire_rate_wait + 120
			current_reload_time = current_reload_time + 60
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 60.0
		end, 
	},
	{
		id          = "RAT_CANNON",
		name 		= "$action_rat_cannon",
		description = "$actiondesc_rat_cannon",
		spawn_requires_flag = "card_unlocked_exploding_deer",
		sprite 		= "mods/purgatory/files/ui_gfx/gun_actions/rat_cannon.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		related_projectiles = {"mods/purgatory/files/entities/projectiles/deck/rat_cannon.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,10", -- SPELL
		spawn_probability                 = "0,0,0,0,0.1,0.1,0.1,0", -- SPELL
		price = 500,
		mana = 100,
		action 		= function()
			add_projectile("mods/purgatory/files/entities/projectiles/deck/rat_cannon.xml")
		end,
	},
	{
		id          = "RELOAD_BEEP",
		name 		= "$action_reload_beep",
		description = "$actiondesc_reload_beep",
		sprite 		= "mods/purgatory/files/ui_gfx/gun_actions/reload_beep.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "0,1,2", -- RELOAD_BEEP
		spawn_probability                 = "1,0.6,0.5", -- RELOAD_BEEP
		price = 100,
		mana = 0,
		--max_uses = 50,
		custom_xml_file = "mods/purgatory/files/entities/misc/custom_cards/reload_beep.xml",
		action 		= function()
			draw_actions( 1, true )
		end,
	},
	{
		id          = "SLOW_SHOT",
		name 		= "$action_slow_shot",
		description = "$actiondesc_slow_shot",
		sprite 		= "mods/purgatory/files/ui_gfx/gun_actions/slow_shot.png",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3", -- SLOW_SHOT
		spawn_probability                 = "1,0.5,0.5", -- SLOW_SHOT
		price = 100,
		mana = 0,
		action 		= function()
			c.speed_multiplier = c.speed_multiplier * 0.5
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 50
			
			if ( c.speed_multiplier >= 20 ) then
				c.speed_multiplier = math.min( c.speed_multiplier, 20 )
			elseif ( c.speed_multiplier < 0 ) then
				c.speed_multiplier = 0
			end

			draw_actions(1, true)
		end,
	},
}

--Add Spells
for i, spell in ipairs(spells_to_add) do
	table.insert(actions, #actions + 1, spell)
end

--Orders the spells according to mods/purgatory/files/scripts/gun/gun_actions_ordering/gun_actions_list.lua
local new_spell_list = {}

for i, spell in ipairs(gun_actions_order) do
	local spell_to_add

	for j, v in ipairs(actions) do
		if v.id == spell then
			new_spell_list[i] = v
			table.remove(actions, j)
			break
		end
	end
end

--if other mods added spells
if #actions > 0 then
	for i, v in ipairs(actions) do
		table.insert(new_spell_list, #new_spell_list + 1, v)
	end
end

--set list
actions = new_spell_list

--[[
	Spell Template
	{
		id          = "",
		name 		= "$action_",
		description = "$actiondesc_",
		sprite 		= "",
		sprite_unidentified = "mods/purgatory/files/ui_gfx/gun_actions/unidentified.png",
		type 		= ACTION_TYPE_,
		spawn_level                       = "0,1,2,3,4,5,6,10", -- SPELL
		spawn_probability                 = "1,1,1,1,1,1,1,1", -- SPELL
		price = 0,
		mana = 0,
		action 		= function()
		end,
	},


			spawn_level                       = "1,2,3,4,5,6", -- MANA_REDUCE
		spawn_probability                 = "1,1,1,1,1,1", -- MANA_REDUCE
]]


