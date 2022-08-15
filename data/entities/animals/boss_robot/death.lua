dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/perks/perk.lua")

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	
	EntityLoad("data/entities/projectiles/deck/explosion_giga.xml", x, y)
	
	local kill_count = tonumber(GlobalsGetValue("MECHA_KOLMI_KILL_COUNT", "1"))

	if kill_count == 1 then
		perk_spawn( x, y, "MAP" )
	elseif kill_count == 2 then
		perk_spawn( x, y, "MAP_LEVEL_2" )
	elseif kill_count == 3 then
		perk_spawn( x, y, "MAP_LEVEL_3" )
	elseif kill_count == 4 then
		perk_spawn( x, y, "MAP_LEVEL_4" )
	else
		EntityLoad("data/entities/items/pickup/heart_fullhp.xml",x ,y )
	end

	kill_count = kill_count + 1

	GlobalsSetValue("MECHA_KOLMI_KILL_COUNT", tostring(kill_count))

	
	AddFlagPersistent( "miniboss_robot" )
end