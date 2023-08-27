dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform(entity_id)

SetRandomSeed(pos_x, pos_y
)
local how_many = 10

for i = 1, how_many do
    LoadRagdoll("data/ragdolls/rat/filenames.txt", pos_x + Random(-2, 2), pos_y + Random(-2, 2), "meat", 1, Random(-50, 50), Random(-50, 50))
end
