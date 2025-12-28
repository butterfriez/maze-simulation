local ReplicatedStorage = game:GetService("ReplicatedStorage")

local fusion = require(ReplicatedStorage.Packages.fusion)
local charm = require(ReplicatedStorage.Packages.charm)

local PlayerStateHandlers = require(ReplicatedStorage.state.atoms.PlayerState)

local scope = fusion.scoped(fusion)
local PlayerState = {}

PlayerState.currentState = fusion.Contextual(PlayerStateHandlers.DefaultPlayerState)

charm.subscribe(PlayerStateHandlers.PlayerStatesAtom, function(newState, oldState)
	local override = scope:Value(oldState)
	PlayerState.currentState:is(override):during(function()
		override:set(newState)
	end)
end)

return PlayerState
