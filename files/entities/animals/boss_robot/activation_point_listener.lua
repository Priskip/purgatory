dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")

local proj = {}
proj.id = GetUpdatedEntityID()
proj.x, proj.y = EntityGetTransform(proj.id)

local laser_hotspots = EntityGetInRadiusWithTag(proj.x, proj.y, 5, "mecha_turret_laser_spot")

if #laser_hotspots > 0 then
    --Activate Firing Mechanism
    local laser_ent = laser_hotspots[1]

    local lua_comps = EntityGetComponentIncludingDisabled(laser_ent, "LuaComponent")
    for i, lua_comp in ipairs(lua_comps) do
        EntitySetComponentIsEnabled(laser_ent, lua_comp, true)
    end

    local particle_emitter_comps = EntityGetComponentIncludingDisabled(laser_ent, "ParticleEmitterComponent")
    for i, particle_emitter_comp in ipairs(particle_emitter_comps) do
        EntitySetComponentIsEnabled(laser_ent, particle_emitter_comp, true)
    end

    --Kill this Projectile
    EntityKill(proj.id)
end
