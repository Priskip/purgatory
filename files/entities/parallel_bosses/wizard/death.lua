dofile_once("data/scripts/lib/utilities.lua")

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	
	-- StatsLogPlayerKill( GetUpdatedEntityID() )
	
	local pw = check_parallel_pos( x )
	SetRandomSeed( pw, 30 )
	
	
end