dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")

--HELPER FUNCTIONS

--Takes the damage types from ProjectileComponent's object "damage_by_type" and turns them into a single string that can be written to a variable storage component
local function stringifyDamageTypesTable(dmg_by_type_table)
    local output_string = ""

    for damage_type, amount_of_damage in pairs(dmg_by_type_table) do
        output_string = output_string .. damage_type .. "=" .. amount_of_damage .. ","
    end

    output_string = string.sub(output_string, 1, -2)

    return output_string
end

--Takes a string generated by stringifyDamageTypesTable(dmg_by_type_table) and turns it back into a string indexed table akin to what you would get from ComponentObjectGetMembers(comp, obj)
local function destringifyDamageTypesString(dmg_by_type_string)
    local output_table = {}
    local list = split_string_on_char_into_table(dmg_by_type_string, ",")

    --list should now be something like { "ice=0", "electricity=0", ... }
    for i, v in ipairs(list) do
        local param_and_value = split_string_on_char_into_table(v, "=") --param_and_value should be like {"ice","0"}
        output_table[param_and_value[1]] = param_and_value[2]
    end

    return output_table
end

--[[
    Functions above are used to transmute data between these two forms.
    This is done so I can store the table's values into a single variable storage comp

    data = {
        "ice" = "0"
        "electricity" = "0"
        "radioactive" = "0"
        "slice" = "0"
        "curse" = "0"
        "overeating" = "0"
        "projectile" = "0"
        "healing" = "0"
        "physics_hit" = "0"
        "explosion" = "0"
        "poison" = "0"
        "melee" = "0"
        "drill" = "0"
        "fire" = "0.4"
    }

    data = "ice=0,electricity=0,radioactive=0,slice=0,curse=0,overeating=0,projectile=0,healing=0,physics_hit=0,explosion=0,poison=0,melee=0,drill=0,fire=0.4"
]]
-- local projectile_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "ProjectileComponent")
-- local who_shot = ComponentGetValue2(projectile_comp, "mWhoShot")

-- local vel_x, vel_y = 0, 0
-- local projectile_shot_id = shoot_projectile_from_projectile( who_shot, "data/entities/projectiles/deck/death_cross.xml", x + 30, y - 30, vel_x, vel_y )

-- local projectile_shot_projectile_comp = EntityGetFirstComponentIncludingDisabled(projectile_shot_id, "ProjectileComponent")
-- ComponentSetValue2(projectile_shot_projectile_comp, "damage", 4)
-- ComponentSetValue2(projectile_shot_projectile_comp, "friendly_fire", true)

--Get Entity Info
local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform(entity_id)

--Variable Storage Component Values
local power_level = variable_storage_get_value(entity_id, "FLOAT", "power_level")
local power_level_floor = math.floor(power_level)
local projectiles_absorbed = variable_storage_get_value(entity_id, "INT", "projectiles_absorbed")
local stored_damage = variable_storage_get_value(entity_id, "FLOAT", "stored_damage")
local stored_damage_by_type_string = variable_storage_get_value(entity_id, "STRING", "stored_damage_by_type")
local stored_damage_by_type_table = destringifyDamageTypesString(stored_damage_by_type_string)

GamePlaySound("data/audio/Desktop/explosion.bank", "explosions/magic_rocket_big", pos_x, pos_y)

local shooting_directions = {
    { 1,  0 },
    { 0,  1 },
    { -1, 0 },
    { 0,  -1 }
}

--let's just test +x for now
for _, dir in ipairs(shooting_directions) do
    local vel_x = 60000 * (11 - power_level_floor) * dir[1]
    local vel_y = 60000 * (11 - power_level_floor) * dir[2]

    for i = power_level_floor, -power_level_floor, -1 do
        --flip flop x and y because if the proj shoots up, vary its horizontal starting pos
        local shoot_pos_x = pos_x + 1 * i * dir[2]
        local shoot_pos_y = pos_y + 1 * i * dir[1]

        for vel_multiplier = 1, 4 do
            --Shoot Projectile
            local projectile_id = shoot_projectile(entity_id,
                "mods/purgatory/files/entities/projectiles/deck/death_cross_bigger/death_cross_bigger_laser.xml",
                shoot_pos_x,
                shoot_pos_y, vel_multiplier * vel_x, vel_multiplier * vel_y)

            --Get Projectile Comp
            local projectile_comp = EntityGetFirstComponentIncludingDisabled(projectile_id, "ProjectileComponent")


            --Damage By Types
            local dmg_by_type_members = ComponentObjectGetMembers(projectile_comp, "damage_by_type")

            --For each damage by type
            for damage_type, damage_amount in pairs(dmg_by_type_members) do
                ComponentObjectSetValue2(projectile_comp, "damage_by_type", damage_type, tonumber(stored_damage_by_type_table[damage_type]))
            end
        end
    end
end
