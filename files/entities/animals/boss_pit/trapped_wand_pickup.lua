dofile( "data/scripts/game_helpers.lua" )
dofile( "data/scripts/lib/utilities.lua" )

function item_pickup( entity_item, entity_who_picked, item_name )
    local x, y = EntityGetTransform( entity_item )
    EntityLoad( "data/entities/particles/image_emitters/wand_effect.xml", x, y )
	EntityLoad( "data/entities/animals/boss_pit/boss_pit.xml", x + 85, y + 210 )
	
end
