dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local projectiles = EntityGetWithTag( "projectile" )

if ( #projectiles > 0 ) then
	for i,projectile_id in ipairs( projectiles ) do
		local tags = EntityGetTags( projectile_id )
		
		if ( tags == nil ) or ( string.find( tags, "death_cross" ) == nil ) then
			local px, py = EntityGetTransform( projectile_id )
			
			local projectilecomponents = EntityGetComponent( projectile_id, "ProjectileComponent" )
			local velocitycomponents = EntityGetComponent( projectile_id, "VelocityComponent" )
			
			if ( projectilecomponents ~= nil ) then
				for j,comp_id in ipairs( projectilecomponents ) do
					ComponentSetValue( comp_id, "on_death_explode", "0" )
					ComponentSetValue( comp_id, "on_lifetime_out_explode", "0" )
				end
			end
			
			SetRandomSeed( px, py - 543 )
			local rnd = Random( 1, 101 )
			local selection = 1

			if rnd == 1 then
				selection = 3 --omega death cross
			elseif rand > 1 and rand <= 50 then
				selection = 2 --giga death cross
			end

			local opts = {
				"data/entities/projectiles/deck/death_cross.xml",
				"data/entities/projectiles/deck/death_cross_big.xml",
				"mods/purgatory/files/entities/projectiles/deck/death_cross_bigger/death_cross_bigger.xml"
			}
			
			local opt = opts[selection]

			shoot_projectile_from_projectile( projectile_id, opt, px, py, 0, 0 )
			EntityKill( projectile_id )
		end
	end
end