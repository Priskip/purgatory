dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")

local boss_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(boss_id)

local alive_turrets = EntityGetInRadiusWithTag(x, y, 1000, "roboroom_mecha_turret_alive")
local number_of_alive_turrets = math.min(#alive_turrets, 8)

--Note Priskip 23/3/24: Damage Multipliers no longer get updated directly. 
--Instead, HitboxComponent's damage_multiplier is updated based on the number of turrets alive 
local hitbox_comp = EntityGetFirstComponentIncludingDisabled(boss_id, "HitboxComponent", "hitbox_default")
if hitbox_comp ~= nil then
    ComponentSetValue2(hitbox_comp, "damage_multiplier", 1 - number_of_alive_turrets / 8)
end

--[[
Mecha's vanilla damage multipliers
projectile="0"
explosion="0"
electricity="0.8"
fire="0"
slice="0.6"

In purgatory,
projectile="0.05"
explosion="0"
electricity="0.8"
slice="0.6"
drill="0.5"
fire="0"

]]
