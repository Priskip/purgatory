dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()

local audio_comps = EntityGetComponent(entity_id, "AudioComponent")
if (audio_comps ~= nil) then
    for i, v in ipairs(audio_comps) do
        EntityRemoveComponent(entity_id, v)
        GamePrint(tostring(v))
    end
end
