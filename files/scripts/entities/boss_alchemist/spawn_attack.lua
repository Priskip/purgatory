dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local ent_x, ent_y = EntityGetTransform(entity_id)

local player_id = getPlayerEntity()
local player_x, player_y = EntityGetTransform(player_id)

local alchemist_id = EntityGetClosestWithTag(ent_x, ent_y, "boss_alchemist")

if alchemist_id == nil then
    alchemist_id = 0
end

--Spawn Projectile
SetRandomSeed(ent_x, ent_y)
local num = Random(1, 100)
local vel_x, vel_y = 0, 0

if num <= 30 then
    --Note (Priskip): Potions can break on Alch's Shield - so they have to be summoned far enough away from him
    local facing = 0

    if player_x - ent_x <= 0 then
        facing = -1
    else
        facing = 1
    end

    local potion_spawn_offset = facing * 28

    vel_x = 1 * (player_x - ent_x)
    vel_y = 1 * (player_y - ent_y)

    shoot_projectile(alchemist_id, "mods/purgatory/files/entities/items/pickup/comically_large_potion.xml", ent_x + potion_spawn_offset, ent_y, vel_x, vel_y, true)
else
    --Normal Attack (but normal attack now has a chaos transmutation affect)
    vel_x = 2 * (player_x - ent_x)
    vel_y = 2 * (player_y - ent_y)

    local projectile_ent_id = shoot_projectile(alchemist_id, "data/entities/animals/boss_alchemist/wand_orb.xml", ent_x, ent_y, vel_x, vel_y, true)

    --add chaotic transmutation
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
end

--Kill Old Projectile
EntityKill(entity_id)
