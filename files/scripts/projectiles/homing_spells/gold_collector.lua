dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()

local projComp = EntityGetFirstComponentIncludingDisabled(entity_id, "ProjectileComponent")
local mDamagedEntities = ComponentGetValue2(projComp, "mDamagedEntities")

local text = "mDamagedEntities: "

if (mDamagedEntities == nil) or (#mDamagedEntities == 0) then
    text = text .. "none"
else
    for i, v in ipairs(mDamagedEntities) do
        text = text .. tostring(v) .. ", "

    end
end

GamePrint(type(mDamagedEntities))
GamePrint(text)
