dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local p = EntityGetWithTag( "player_unit" )

if ( #p > 0 ) then
	local pl = p[1]
	
	local eid = EntityLoad( "mods/purgatory/files/entities/parallel_bosses/wizard/debuff.xml" )
	EntityAddChild( pl, eid )
end

EntityKill( entity_id )