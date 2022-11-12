dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

function damage_about_to_be_received(damage, x, y, entity_thats_responsible, critical_hit_chance)
    GamePrint("damage: \"" .. tostring(damage) .. "\"")
    GamePrint("x: \"" .. tostring(x) .. "\"")
    GamePrint("y: \"" .. tostring(y) .. "\"")
    GamePrint("entity_thats_responsible: \"" .. tostring(entity_thats_responsible) .. "\"")
    GamePrint("critical_hit_chance: \"" .. tostring(critical_hit_chance) .. "\"")
    GamePrint("player: \"" .. tostring(getPlayerEntity()) .. "\"")

    return damage, critical_hit_chance
end



--[[
EntityInflictDamage( entity:int, amount:number, damage_type:string, description:string, ragdoll_fx:string, 
    impulse_x:number, impulse_y:number, entity_who_is_responsible:int = 0, world_pos_x:number = entity_x, world_pos_y:number = entity_y, knockback_force:number = 0 )



]]