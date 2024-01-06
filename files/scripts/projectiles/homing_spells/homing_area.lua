dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local root_id = EntityGetRootEntity(entity_id)
local x, y = EntityGetTransform(entity_id)
local radius = 32
local targets = EntityGetInRadiusWithTag(x, y, radius, "homing_target")
local comp = EntityGetFirstComponent(root_id, "ProjectileComponent")
local player_id = getPlayerEntity()

--get homing type
local target_type = ""
local var_stor_comps = EntityGetComponent(entity_id, "VariableStorageComponent")
if (var_stor_comps ~= nil) then
	for i, v in ipairs(var_stor_comps) do
		local name = ComponentGetValue2(v, "name")

		if (name == "target_type") then
			target_type = ComponentGetValue2(v, "value_string")
		end
	end
end

if target_type == "enemy" then
	if (comp ~= nil) then
		local target = ComponentGetValue2(comp, "mWhoShot")

		for i, v in ipairs(targets) do
			if (v ~= target) and (GameGetGameEffect(v, "CHARM") == 0) and (EntityGetHerdRelation(target, v) < 60) then
				local tx, ty = EntityGetFirstHitboxCenter(v)

				EntitySetTransform(root_id, tx, ty)
				EntityApplyTransform(root_id, tx, ty)
				break
			end
		end
	end
elseif target_type == "player" then
	if (comp ~= nil) then
		targets = EntityGetInRadiusWithTag(x, y, radius, "player_unit")
		for i, v in ipairs(targets) do
			if v == player_id then
				local tx, ty = EntityGetFirstHitboxCenter(v)

				EntitySetTransform(root_id, tx, ty)
				EntityApplyTransform(root_id, tx, ty)
				break
			end
		end
	end
end
