dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/gun/gun_enums.lua")
dofile_once("data/scripts/gun/gun_actions.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")

local spell_lists = {triggers = {}, timers = {}, death_triggers = {}, draw_2s = {}, draw_3s = {}, draw_4s = {}}
local bool_list = {false, false, false, false, false, false}

--Globals needed to mimic gun simulation
c = {
    action_id = "",
    action_name = "",
    action_description = "",
    action_sprite_filename = "",
    action_type = ACTION_TYPE_OTHER,
    action_recursive = false,
    action_spawn_level = "",
    action_spawn_probability = "",
    action_spawn_requires_flag = "",
    action_spawn_manual_unlock = false,
    action_max_uses = 0,
    custom_xml_file = "",
    action_ai_never_uses = false,
    action_never_unlimited = false,
    action_is_dangerous_blast = false,
    sound_loop_tag = "",
    action_mana_drain = 0,
    action_type = 3,
    pattern_degrees = 0,
    state_cards_drawn = 0,
    damage_melee_add = 0,
    damage_curse_add = 0,
    screenshake = 0,
    damage_explosion_add = 0,
    damage_slice_add = 0,
    material = "",
    state_shuffled = false,
    lightning_count = 0,
    action_id = TEST_SPELL,
    damage_healing_add = 0,
    extra_entities = "",
    action_mana_drain = 0,
    damage_projectile_add = 0,
    action_ai_never_uses = false,
    action_never_unlimited = false,
    recoil = 0,
    friendly_fire = false,
    action_name = "",
    light = 0,
    damage_ice_add = 0,
    damage_electricity_add = 0,
    fire_rate_wait = 0,
    spread_degrees = 0,
    sprite = "",
    reload_time = 0,
    explosion_damage_to_materials = 0,
    trail_material_amount = 0,
    knockback_force = 0,
    physics_impulse_coeff = 0,
    ragdoll_fx = 0,
    speed_multiplier = 1,
    projectile_file = "",
    damage_critical_chance = 0,
    dampening = 1,
    child_speed_multiplier = 1,
    trail_material = "",
    damage_drill_add = 0,
    action_unidentified_sprite_filename = "",
    action_draw_many_count = 1,
    state_destroyed_action = false,
    damage_fire_add = 0,
    lifetime_add = 0,
    bounces = 0,
    gravity = 0,
    blood_count_multiplier = 1,
    damage_critical_multiplier = 0,
    action_spawn_manual_unlock = false,
    state_discarded_action = false,
    material_amount = 0,
    gore_particles = 0,
    explosion_radius = 0,
    game_effect_entities = ""
}
shot_effects = {recoil_knockback = 0}
current_reload_time = 0

function add_projectile(entity_filename)
    --do nothing
end

function add_projectile_trigger_hit_world(entity_filename, action_draw_count)
    bool_list[1] = true
end

function add_projectile_trigger_timer(entity_filename, delay_frames, action_draw_count)
    bool_list[2] = true
end

function add_projectile_trigger_death(entity_filename, action_draw_count)
    bool_list[3] = true
end

function draw_actions(how_many, instant_reload_if_empty)
    if 2 <= how_many and how_many <= 4 then
        bool_list[2 + how_many] = true --draw 2 = bool[4], draw 3 = bool[5], draw 4 = bool[6]
    end
end

--Do the magic
--Note this is a pretty intensive function - call sparingly
function get_spell_types()
    for i, v in ipairs(actions) do
        if v.type == ACTION_TYPE_PROJECTILE or v.type == ACTION_TYPE_DRAW_MANY then
            bool_list = {false, false, false, false, false, false} --reset bool list

            --find out what the spell does
            pcall(v.action)

            --count number of positive hits
            local number_of_positives = 0
            for _, bool_value in ipairs(bool_list) do
                if bool_value then
                    number_of_positives = number_of_positives + 1
                end
            end

            --Catergorize spell type
            --Note Priskip: I count the number of positives in the bool list in case a modder adds a spell that does multiple functions.
            if bool_list[1] and number_of_positives == 1 then
                --spell is a trigger
                spell_lists.triggers[#spell_lists.triggers + 1] = v.id
            end

            if bool_list[2] and number_of_positives == 1 then
                --spell is a timer
                spell_lists.timers[#spell_lists.timers + 1] = v.id
            end

            if bool_list[3] and number_of_positives == 1 then
                --spell is a death trigger
                spell_lists.death_triggers[#spell_lists.death_triggers + 1] = v.id
            end

            if bool_list[4] and number_of_positives == 1 then
                --spell is a draw 2
                spell_lists.draw_2s[#spell_lists.draw_2s + 1] = v.id
            end

            if bool_list[5] and number_of_positives == 1 then
                --spell is a draw 3
                spell_lists.draw_3s[#spell_lists.draw_3s + 1] = v.id
            end

            if bool_list[6] and number_of_positives == 1 then
                --spell is a draw 4
                spell_lists.draw_4s[#spell_lists.draw_4s + 1] = v.id
            end
        end
    end

    return spell_lists
end
--[[

for param, value in pairs(spell_lists) do
    print(tostring(param))

    for i, v in ipairs(value) do
        print(v)
    end

    print("")
end

triggers
LIGHT_BULLET_TRIGGER
BULLET_TRIGGER
HEAVY_BULLET_TRIGGER
SLOW_BULLET_TRIGGER
BUBBLESHOT_TRIGGER
GRENADE_TRIGGER

timers
LIGHT_BULLET_TIMER
BULLET_TIMER
HEAVY_BULLET_TIMER
SLOW_BULLET_TIMER
SPITTER_TIMER
SPITTER_TIER_2_TIMER
SPITTER_TIER_3_TIMER
BOUNCY_ORB_TIMER
LUMINOUS_DRILL_TIMER
TENTACLE_TIMER

death_triggers
LIGHT_BULLET_DEATH_TRIGGER
BLACK_HOLE_DEATH_TRIGGER
BUBBLESHOT_DEATH_TRIGGER
POLLEN_DEATH_TRIGGER
MINE_DEATH_TRIGGER
PIPE_BOMB_DEATH_TRIGGER
SUMMON_HOLLOW_EGG

draw_2s
BURST_2
SCATTER_2
I_SHAPE
Y_SHAPE

draw_3s
BURST_3
SCATTER_3
T_SHAPE
W_SHAPE

draw_4s
BURST_4
SCATTER_4
CROSS_SHAPE

]]
