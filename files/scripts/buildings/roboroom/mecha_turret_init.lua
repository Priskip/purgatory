dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

local turret = {}
local center = {}

turret.id = GetUpdatedEntityID()
turret.x, turret.y = EntityGetTransform(turret.id)
center.id = EntityGetClosestWithTag(turret.x, turret.y, "roboroom_center")
center.x, center.y = EntityGetTransform(center.id)

local r, phi = get_r_and_phi(turret.x, turret.y, center.x, center.y)
turret.phi = phi + math.pi / 2

EntitySetTransform(turret.id, turret.x, turret.y, turret.phi)
EntityApplyPolarTransform(turret.id, 9.5, phi)

--HIT Boxes
local aabb_min_x, aabb_max_x, aabb_min_y, aabb_max_y = 0, 0, 0, 0

local poi = {
    {
        x = -6.5,
        y = 9.5
    },
    {
        x = 6.5,
        y = 9.5
    },
    {
        x = -6.5,
        y = -9.5
    },
    {
        x = 6.5,
        y = -9.5
    }
}

for i, v in ipairs(poi) do
    v.r = math.sqrt(v.x ^ 2 + v.y ^ 2)
    v.phi = math.atan2(v.y, v.x)

    v.phi = v.phi + turret.phi
    v.x = v.r * math.cos(v.phi)
    v.y = v.r * math.sin(v.phi)
end

for i, v in ipairs(poi) do
    if v.x < aabb_min_x then
        aabb_min_x = v.x
    end

    if v.x > aabb_max_x then
        aabb_max_x = v.x
    end

    if v.y < aabb_min_y then
        aabb_min_y = v.y
    end

    if v.y > aabb_max_y then
        aabb_max_y = v.y
    end
end

aabb_min_x = aabb_min_x + 2
aabb_max_x = aabb_max_x - 2
aabb_min_y = aabb_min_y + 2
aabb_max_y = aabb_max_y - 2

local hitbox_comp = EntityGetFirstComponentIncludingDisabled(turret.id, "HitboxComponent")
ComponentSetValue2(hitbox_comp, "aabb_min_x", aabb_min_x)
ComponentSetValue2(hitbox_comp, "aabb_max_x", aabb_max_x)
ComponentSetValue2(hitbox_comp, "aabb_min_y", aabb_min_y)
ComponentSetValue2(hitbox_comp, "aabb_max_y", aabb_max_y)

--Child Entity Position
local children = EntityGetAllChildren(turret.id)

for i, child in ipairs(children) do
    if EntityHasTag(child, "mecha_turret_laser_spot") then
        EntitySetTransform(child, turret.x, turret.y)
        EntityApplyPolarTransform(child, 9.5 + 7, phi)
    end
end
