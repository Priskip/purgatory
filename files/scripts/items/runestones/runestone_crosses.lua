dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local projectiles = EntityGetInRadiusWithTag( x, y, 192, "projectile" )
if ( #projectiles > 0 ) then
	for i,projectile_id in ipairs( projectiles ) do
		local tags = EntityGetTags( projectile_id )
		
		if ( tags == nil ) or ( string.find( tags, "death_cross" ) == nil and EntityGetFilename(projectile_id) ~= "data/entities/projectiles/deck/death_cross_big_laser.xml") then
			local px, py = EntityGetTransform( projectile_id )
			local vel_x, vel_y = 0,0
			
			local projectilecomponents = EntityGetComponent( projectile_id, "ProjectileComponent" )
			local velocitycomponents = EntityGetComponent( projectile_id, "VelocityComponent" )
			
			if ( projectilecomponents ~= nil ) then
				for j,comp_id in ipairs( projectilecomponents ) do
					ComponentSetValue( comp_id, "on_death_explode", "0" )
					ComponentSetValue( comp_id, "on_lifetime_out_explode", "0" )
				end
			end
			
			if ( velocitycomponents ~= nil ) then
				edit_component( projectile_id, "VelocityComponent", function(comp,vars)
					vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity", vel_x, vel_y)
				end)
			end
			
			SetRandomSeed(px,py)
			local num = Random(1,101)
			if num == 1 then
				shoot_projectile_from_projectile( projectile_id, "mods/purgatory/files/entities/projectiles/deck/death_cross_bigger/death_cross_bigger.xml", px, py, vel_x, vel_y )
			elseif num > 1 and num <= 20 then
				shoot_projectile_from_projectile( projectile_id, "data/entities/projectiles/deck/death_cross_big.xml", px, py, vel_x, vel_y )
			else
				shoot_projectile_from_projectile( projectile_id, "data/entities/projectiles/deck/death_cross.xml", px, py, vel_x, vel_y )
			end
			EntityKill( projectile_id )
		end
	end
end