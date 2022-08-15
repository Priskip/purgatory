dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

local ent = {}
local player = {}
ent.id = GetUpdatedEntityID()
ent.x, ent.y = EntityGetTransform(ent.id)

player.id = getPlayerEntity()
player.x, player.y = EntityGetTransform(player.id)

--EntityLoad("mods/purgatory/files/entities/misc/test.xml", x, y)

--[[
comps = EntityGetComponent(entity_id, "LaserEmitterComponent")
if (comps ~= nil) then
	for i, comp in ipairs(comps) do
		ComponentObjectSetValue2(comp, "laser", "beam_particle_type", beam_particle_type)
	end
end
]]
local r, phi = get_r_and_phi(ent.x, ent.y, player.x, player.y)
EntitySetTransform(ent.id, ent.x, ent.y, phi)

local comps = EntityGetComponent(ent.id, "LaserEmitterComponent")
if (comps ~= nil) then
	for i, comp in ipairs(comps) do
		ComponentObjectSetValue2(comp, "laser", "max_length", math.floor(r))
	end
end

local raytrace = RaytraceSurfaces(ent.x, ent.y, player.x, player.y)

if raytrace then
	if (comps ~= nil) then
		for i, comp in ipairs(comps) do
			ComponentObjectSetValue2(comp, "laser", "beam_particle_type", CellFactory_GetType("spark_red"))
		end
	end
else
	if (comps ~= nil) then
		for i, comp in ipairs(comps) do
			ComponentObjectSetValue2(comp, "laser", "beam_particle_type", CellFactory_GetType("spark_green"))
		end
	end
end
