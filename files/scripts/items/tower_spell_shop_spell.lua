dofile_once("data/scripts/lib/utilities.lua")
dofile("data/scripts/gun/gun_actions.lua")

--List of what spells to generate in the tower.
tower_spells = {
    {
        name = "HEAL_BULLET",
        weight = 5
    },
    {
        name = "REGENERATION_FIELD",
        weight = 1
    },
    {
        name = "LEVITATION_FIELD",
        weight = 6
    },
    {
        name = "BOMB_DETONATOR",
        weight = 10
    },
    {
        name = "PROJECTILE_TRANSMUTATION_FIELD",
        weight = 6
    },
    {
        name = "VACUUM_ENTITIES",
        weight = 6
    },
    {
        name = "VACUUM_LIQUID",
        weight = 6
    },
    {
        name = "VACUUM_POWDER",
        weight = 6
    },
    {
        name = "LONG_DISTANCE_CAST",
        weight = 10
    },
    {
        name = "TELEPORT_CAST",
        weight = 10
    },
    {
        name = "SUPER_TELEPORT_CAST",
        weight = 10
    },
    {
        name = "SUMMON_WANDGHOST",
        weight = 1
    },
    {
        name = "TEMPORARY_PLATFORM",
        weight = 5
    },
    {
        name = "TEMPORARY_WALL",
        weight = 5
    },
    {
        name = "HITFX_CRITICAL_BLOOD",
        weight = 16
    },
    {
        name = "HITFX_CRITICAL_OIL",
        weight = 16
    },
    {
        name = "HITFX_CRITICAL_WATER",
        weight = 16
    },
    {
        name = "DAMAGE",
        weight = 20
    },
    {
        name = "HEAVY_SHOT",
        weight = 20
    },
    {
        name = "LIFETIME_DOWN",
        weight = 20
    },
    {
        name = "LIFETIME",
        weight = 20
    },
    {
        name = "CURSE_WITHER_ELECTRICITY",
        weight = 6
    },
    {
        name = "CURSE_WITHER_MELEE",
        weight = 6
    },
    {
        name = "CURSE_WITHER_EXPLOSION",
        weight = 6
    },
    {
        name = "CURSE_WITHER_PROJECTILE",
        weight = 6
    },
    {
        name = "MATERIAL_BLOOD",
        weight = 10
    },
    {
        name = "MATERIAL_OIL",
        weight = 10
    },
    {
        name = "MATERIAL_WATER",
        weight = 10
    },
    {
        name = "LIGHT_BULLET_TRIGGER_TIMER",
        weight = 20
    },
    {
        name = "LIGHT_BULLET_TRIGGER_DEATH_TRIGGER",
        weight = 20
    },
    {
        name = "LIGHT_BULLET_TIMER_DEATH_TRIGGER",
        weight = 20
    },
    {
        name = "WORLD_EATER",
        weight = 1
    },
    {
        name = "VACUUM_GOLD",
        weight = 4
    },
    {
        name = "GOLD_MULTIPLIER",
        weight = 6
    },
    {
        name = "OMEGA_PROPANE_TANK",
        weight = 2
    },
    {
        name = "RECOIL_DAMPER",
        weight = 10
    },
    {
        name = "BLACKHOLE_SHOT",
        weight = 8
    },
    {
        name = "SUMMON_HAMIS",
        weight = 7
    }
}

function in_range(num, lower_bound, upper_bound)
    if lower_bound <= num and num <= upper_bound then
        return true
    else
        return false
    end
end

function get_spell_id_from_tower_spell_table()
    local total_weights = 0
    for i, v in ipairs(tower_spells) do
        total_weights = total_weights + v.weight
        table[i] = 0
    end

    local num = Random(1, total_weights)

    local range_bottom = 0
    local spell_id = ""

    for i, v in ipairs(tower_spells) do
        local range_top = range_bottom + v.weight
        if in_range(num, range_bottom, range_top) then
            spell_id = v.name
            break
        else
            range_bottom = range_top
        end
    end

    return spell_id
end

function create_tower_spell_for_sale(x, y)
    --Set Seed for consistancy
    SetRandomSeed(x, y)

    --Get Spell ID from weighted table
    local spell_id = get_spell_id_from_tower_spell_table()

    --Create Spell for Sale
    local eid = CreateItemActionEntity(spell_id, x, y)

    --Create cost for item
    local cost_delta = Random(-20, 20)
    local cardcost = 10000 + 50 * cost_delta --Cost is 10000 +/- 1000 in increments of 50

    --Text for Cost
    local offsetx = 6
    local text = tostring(cardcost)
    local textwidth = 0

    for i = 1, #text do
        local l = string.sub(text, i, i)

        if (l ~= "1") then
            textwidth = textwidth + 6
        else
            textwidth = textwidth + 3
        end
    end

    offsetx = textwidth * 0.5 - 0.5

    --Card Cost Text
    EntityAddComponent(
        eid,
        "SpriteComponent",
        {
            _tags = "shop_cost,enabled_in_world",
            image_file = "data/fonts/font_pixel_white.xml",
            is_text_sprite = "1",
            offset_x = tostring(offsetx),
            offset_y = "25",
            update_transform = "1",
            update_transform_rotation = "0",
            text = tostring(cardcost),
            z_index = "-1"
        }
    )

    --Not Stealable
    EntityAddComponent(
        eid,
        "ItemCostComponent",
        {
            _tags = "shop_cost,enabled_in_world",
            cost = cardcost,
            stealable = "0"
        }
    )

    --Cha Ching!
    EntityAddComponent(
        eid,
        "LuaComponent",
        {
            script_item_picked_up = "data/scripts/items/shop_effect.lua"
        }
    )
end


--Get Entity Location and Make Spell at it.
local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
create_tower_spell_for_sale(x, y)
EntityKill(entity_id)