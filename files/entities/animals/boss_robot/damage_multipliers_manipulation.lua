dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")

local boss_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(boss_id)

local alive_turrets = EntityGetInRadiusWithTag(x, y, 1000, "roboroom_mecha_turret_alive")
local number_of_alive_turrets = math.min(#alive_turrets, 8)

local alive_turret_count_storage = variable_storage_get_value(boss_id, "INT", "alive_turrets")

if alive_turret_count_storage > number_of_alive_turrets then
    --Turret got destroyed, therefore increase Mecha's vulnerability
    local damage_model_comp = EntityGetFirstComponentIncludingDisabled(boss_id, "DamageModelComponent")

    local projectile = tonumber(ComponentObjectGetValue(damage_model_comp, "damage_multipliers", "projectile"))
    local explosion = tonumber(ComponentObjectGetValue(damage_model_comp, "damage_multipliers", "explosion"))
    local electricity = tonumber(ComponentObjectGetValue(damage_model_comp, "damage_multipliers", "electricity"))
    local slice = tonumber(ComponentObjectGetValue(damage_model_comp, "damage_multipliers", "slice"))

    projectile = projectile + 0.0125
    explosion = explosion + 0.0125
    electricity = electricity + 0.1
    slice = slice + 0.1

    ComponentObjectSetValue(damage_model_comp, "damage_multipliers", "projectile", tostring(projectile))
    ComponentObjectSetValue(damage_model_comp, "damage_multipliers", "explosion", tostring(explosion))
    ComponentObjectSetValue(damage_model_comp, "damage_multipliers", "electricity", tostring(electricity))
    ComponentObjectSetValue(damage_model_comp, "damage_multipliers", "slice", tostring(slice))

    --Update storage count
    variable_storage_set_value(boss_id, "INT", "alive_turrets", number_of_alive_turrets)
end

if alive_turret_count_storage < number_of_alive_turrets then
    --Turret got healed, therefore lower Mecha's vulnerabilty
    local damage_model_comp = EntityGetFirstComponentIncludingDisabled(boss_id, "DamageModelComponent")

    local projectile = tonumber(ComponentObjectGetValue(damage_model_comp, "damage_multipliers", "projectile"))
    local explosion = tonumber(ComponentObjectGetValue(damage_model_comp, "damage_multipliers", "explosion"))
    local electricity = tonumber(ComponentObjectGetValue(damage_model_comp, "damage_multipliers", "electricity"))
    local slice = tonumber(ComponentObjectGetValue(damage_model_comp, "damage_multipliers", "slice"))

    projectile = projectile - 0.0125
    explosion = explosion - 0.0125
    electricity = electricity - 0.1
    slice = slice - 0.1

    ComponentObjectSetValue(damage_model_comp, "damage_multipliers", "projectile", tostring(projectile))
    ComponentObjectSetValue(damage_model_comp, "damage_multipliers", "explosion", tostring(explosion))
    ComponentObjectSetValue(damage_model_comp, "damage_multipliers", "electricity", tostring(electricity))
    ComponentObjectSetValue(damage_model_comp, "damage_multipliers", "slice", tostring(slice))

    --Update storage count
    variable_storage_set_value(boss_id, "INT", "alive_turrets", number_of_alive_turrets)
end

--if alive_turret_count_storage = number_of_alive_turrets then do nothing

--[[
Mecha's vanilla damage multipliers
projectile="0"
explosion="0"
electricity="0.8"
fire="0"
slice="0.6"

In purgatory, we'll increase the slice and electric damage by 0.1 per turret destroyed
we'll also increase explosion and projectile damage by 0.0125
Thus if all turrets are dead, he'll take the following
projectile="0.1"
explosion="0.1"
electricity="0.8"
slice="0.8"
fire="0"

]]
