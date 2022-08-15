dofile_once("data/scripts/lib/utilities.lua")

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	local entity_id = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )

    local how_many = 8
	local angle = 0
	local angle_inc = (math.pi * 2) / how_many

	for i=1,how_many do
		local shot_vel_x = math.cos(angle) * 150
		local shot_vel_y = 0 - math.sin(angle) * 150
		
		angle = angle + angle_inc

		shoot_projectile( entity_id, "data/entities/projectiles/propane_tank.xml", pos_x + shot_vel_x * 0.05, pos_y + shot_vel_y * 0.05, shot_vel_x, shot_vel_y, false )
	end

end