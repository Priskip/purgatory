dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()

local path_finding_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "PathFindingComponent")
EntitySetComponentIsEnabled(entity_id, path_finding_comp, true)

--GamePrint("Enabled Path Finding")