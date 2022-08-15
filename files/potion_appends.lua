--Standard potion materials
materials_standard = 
{
	{
		material="lava",
		cost=300,
	},
	{
		material="water",
		cost=200,
	},
	{
		material="blood",
		cost=200,
	},
	{
		material="alcohol",
		cost=200,
	},
	{
		material="oil",
		cost=200,
	},
	{
		material="slime",
		cost=200,
	},
	{
		material="acid",
		cost=400,
	},
	{
		material="radioactive_liquid",
		cost=300,
	},
	{
		material="gunpowder_unstable",
		cost=400,
	},
	{
		material="liquid_fire",
		cost=400,
	},
	{
		material="poison",
		cost=400,
	},
	{
		material="glue",
		cost=400,
	},
	{
		material="urine",
		cost=400,
	}
}

materials_magic = 
{
	{
		material="magic_liquid_unstable_teleportation",
		cost=500,
	},
	{
		material="magic_liquid_teleportation",
		cost=500,
	},
	{
		material="magic_liquid_polymorph",
		cost=500,
	},
	{
		material="magic_liquid_random_polymorph",
		cost=500,
	},
	{
		material="magic_liquid_berserk",
		cost=500,
	},
	{
		material="magic_liquid_charm",
		cost=800,
	},
	{
		material="magic_liquid_invisibility",
		cost=800,
	},
	{
		material="material_confusion",
		cost=800,
	},
	{
		material="magic_liquid_movement_faster",
		cost=800,
	},
	{
		material="magic_liquid_faster_levitation",
		cost=800,
	},
	{
		material="magic_liquid_worm_attractor",
		cost=800,
	},
	{
		material="magic_liquid_protection_all",
		cost=800,
	},
	{
		material="magic_liquid_mana_regeneration",
		cost=500,
	},
	{
		material="material_rainbow",
		cost=400,
	},
	{
		material="magic_liquid_hp_regeneration",
		cost=400,
	},
	{
		material="material_darkness",
		cost=400,
	},
	{
		material="blood_worm",
		cost=400,
	}
}

function init( entity_id )
	local x,y = EntityGetTransform( entity_id )
	SetRandomSeed( x, y ) -- so that all the potions will be the same in every position with the same seed

	local potion_material = "water"

	if( Random( 0, 100 ) <= 50 ) then
		-- 50% chance of magic_liquid_
		potion_material = random_from_array( materials_magic )
		potion_material = potion_material.material
	else
		potion_material = random_from_array( materials_standard )
		potion_material = potion_material.material
	end
	
	local components = EntityGetComponent( entity_id, "VariableStorageComponent" )

	if( components ~= nil ) then
		for key,comp_id in pairs(components) do 
			local var_name = ComponentGetValue( comp_id, "name" )
			if( var_name == "potion_material") then
				potion_material = ComponentGetValue( comp_id, "value_string" )
			end
		end
	end

	AddMaterialInventoryMaterial( entity_id, potion_material, 1000 )
end