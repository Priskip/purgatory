dofile_once("data/scripts/lib/utilities.lua")

function collision_trigger()
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )

	--Make radius bigger so this function is sure to be called
	--local ctc_id = EntityGetFirstComponentIncludingDisabled(entity_id, "CollisionTriggerComponent")
	--ComponentSetValue2(ctc_id, "radius", "2048")

	EntityLoad( "mods/purgatory/files/entities/animals/boss_dragons/fire_dragon.xml", pos_x, pos_y )
	EntityLoad( "mods/purgatory/files/entities/particles/boss_dragons/fire_dragon_spawn.xml", pos_x, pos_y )

	EntityLoad( "mods/purgatory/files/entities/animals/boss_dragons/ice_dragon_spawner.xml", pos_x - 40, pos_y + 40)

	EntityLoad( "mods/purgatory/files/entities/animals/boss_dragons/poison_dragon_spawner.xml", pos_x + 40, pos_y + 40 )
	
	EntityKill( entity_id )
end
