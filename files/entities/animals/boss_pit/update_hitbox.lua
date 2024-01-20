dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local dm = 1.0

edit_component( entity_id, "HitboxComponent", function(comp,vars)
	dm = ComponentGetValue2( comp, "damage_multiplier" )
	
	if ( dm < 1.0 ) then
		dm = math.min( 1.0, dm + 0.2 )
	end
	
	ComponentSetValue2( comp, "damage_multiplier", dm )
end)

--Note Priskip (20/1/2024):
--I done goofed and didn't realize that Sauvojen had a damage resistance when you hit him.
--Nolla had his hitbox component set to multiply damage by 0.1
--So I fixed that and added the on hit damage resistance again.
--Although I made it so it doesn't go to 0, but instead 0.05.
--That way you can still hit him quickly and he'll anahilate you... ;)