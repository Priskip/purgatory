dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()

local player_id = getPlayerEntity()
local x, y = EntityGetTransform(player_id)

--assign electric immunity for a certain amount of time
local elect_immune_ent = EntityLoad("mods/purgatory/files/entities/misc/custom_cards/electric_card_electric_immunity.xml", x, y)
EntityAddChild(player_id, elect_immune_ent)

--[[
    --Needs to be in a child entity
EntityAddComponent(
    player_id,
    "GameEffectComponent",
    {
        effect = "PROTECTION_ELECTRICITY",
        frames = "90"
    }
)
]]

--[[
    NOTE Priskip: This crashes the game when assigned to the custom card directly, so I am assigning it to the player manually with a lua component
    <GameEffectComponent 
		_tags="enabled_in_hand"
		effect="PROTECTION_ELECTRICITY"
		frames="-1">
	</GameEffectComponent>
]]
