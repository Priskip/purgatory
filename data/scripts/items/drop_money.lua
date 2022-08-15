dofile_once("data/scripts/lib/utilities.lua")
dofile_once( "data/scripts/game_helpers.lua" )


function load_gold_entity_with_multiplied_value( entity_filename, x, y, remove_timer , multiplier_value)
	local gold_entity = EntityLoad( entity_filename, x, y )
	if( remove_timer ) then
		local lifetime_components = EntityGetComponent( gold_entity, "LifetimeComponent" )
		if( lifetime_components ~= nil ) then
			for i,lifetime_comp in ipairs(lifetime_components) do
				EntityRemoveComponent( gold_entity, lifetime_comp )
			end
		end
	end

	if multiplier_value > 1 then
		local var_storage_comp = EntityGetComponent(gold_entity, "VariableStorageComponent")
		if (var_storage_comp ~= nil) then
			for i, v in ipairs(var_storage_comp) do
				local n = ComponentGetValue2(v, "name")
				if (n == "gold_value") then
					local gold_value = ComponentGetValue2(v, "value_int")
					ComponentSetValue2(v, "value_int", math.floor(gold_value * multiplier_value))
				end
			end
		end
	end

	return gold_entity
end


function do_money_drop( amount_multiplier, trick_kill )
	
	if ( GameGetIsTrailerModeEnabled() ) then return end

	local entity = GetUpdatedEntityID()
	
	local var_storage_comp = EntityGetComponent(entity, "VariableStorageComponent")
	local multiplier_value = 1
	if (var_storage_comp ~= nil) then
    	for i, v in ipairs(var_storage_comp) do
        	local n = ComponentGetValue2(v, "name")
        	if (n == "greed_multiplier_enemy") then
            	multiplier_value = ComponentGetValue2(v, "value_float")
        	end
    	end
	end


	local no_gold_drop = false
	edit_component_with_tag( entity, "VariableStorageComponent", "no_gold_drop", function(comp,vars) no_gold_drop = true end )
	
	if no_gold_drop then
		return
	end

	local amount = 1

	edit_component( entity, "DamageModelComponent", function(comp,vars)
		local health = tonumber(ComponentGetValue( comp, "max_hp")) * 0.25

		if health > 1.0 then
			amount = math.floor(health)
		end

	end)

	amount = amount * amount_multiplier
	--[[if( amount > ( 15 * amount_multiplier ) ) then
		amount = 15 * amount_multiplier
	end]]--

	local money = 10 * amount
	local x, y = EntityGetTransform( entity )


	local gold_entity = "data/entities/items/pickup/goldnugget_"
	local remove_timer = false
	local drop_first_10 = true

	local comp_worldstate = EntityGetFirstComponent( GameGetWorldStateEntity(), "WorldStateComponent" )
	if( comp_worldstate ~= nil ) then
		if( ComponentGetValue2( comp_worldstate, "perk_gold_is_forever" ) ) then
			remove_timer = true
		end

		if( trick_kill ) then
			-- if worldstate perk_trick_kills_blood_money == 1
			if( ComponentGetValue2( comp_worldstate, "perk_trick_kills_blood_money" ) ) then
				gold_entity = "data/entities/items/pickup/bloodmoney_"
				drop_first_10 = false
			end
		end

		-- drop hp?
		SetRandomSeed( x + entity, y - entity )
		local hp_drop_chance = tonumber( ComponentGetValue2( comp_worldstate, "perk_hp_drop_chance" ) )
		hp_drop_chance = amount_multiplier * hp_drop_chance
		if( hp_drop_chance > 0 and Random( 1, 100 ) <= hp_drop_chance ) then
			load_gold_entity( "data/entities/items/pickup/bloodmoney_50.xml", x, y-8, remove_timer )
			money = money - 50
		end
	end

	--- spawn first 10 gold as small nuggets
	if( drop_first_10 ) then
		local nugget_10_count = 0
		while money >= 10 and nugget_10_count < 5 do
			load_gold_entity_with_multiplied_value( gold_entity .. "10.xml", x, y-8, remove_timer, multiplier_value )
			money = money - 10
			nugget_10_count = nugget_10_count + 1
		end	
	end

	---
	while money >= 10000 do
		load_gold_entity_with_multiplied_value( gold_entity .. "10000.xml", x, y-8, remove_timer, multiplier_value )
		money = money - 10000
	end	

	while money >= 1000 do
		load_gold_entity_with_multiplied_value( gold_entity .. "1000.xml", x, y-8, remove_timer, multiplier_value )
		money = money - 1000
	end	

	while money >= 200 do
		load_gold_entity_with_multiplied_value( gold_entity .. "200.xml", x, y-8, remove_timer, multiplier_value )
		money = money - 200
	end	

	while money >= 50 do
		load_gold_entity_with_multiplied_value( gold_entity .. "50.xml", x, y-8, remove_timer, multiplier_value )
		money = money - 50
	end	

	while money >= 10 do
		load_gold_entity_with_multiplied_value( gold_entity .. "10.xml", x, y-8, remove_timer, multiplier_value )
		money = money - 10
	end	

end

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	do_money_drop( 1, false )
end