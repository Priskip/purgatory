dofile_once("data/scripts/lib/utilities.lua")

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	local has_already_killed_leviathan = GameHasFlagRun("miniboss_fish")

    if not has_already_killed_leviathan then
	ConvertMaterialEverywhere( CellFactory_GetType( "water" ), CellFactory_GetType( "smoke" ) )
    GameAddFlagRun( "miniboss_fish" )
    end

	EntityLoad( "data/entities/items/pickup/heart_fullhp.xml",  x + 16, y )
	EntityLoad( "data/entities/items/pickup/chest_random_super.xml",  x - 16, y )
	EntityLoad( "data/entities/buildings/teleport_teleroom.xml",  x, y )

    LoadPixelScene( "data/biome_impl/tower_start.png", "", x-64, y-32, "", true )

	AddFlagPersistent( "miniboss_fish" )
end