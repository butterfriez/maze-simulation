local ReplicatedStorage = game:GetService("ReplicatedStorage")

local fusion = require(ReplicatedStorage.Packages.fusion)
local charm = require(ReplicatedStorage.Packages.charm)

local PlayerStateHandlers = require(ReplicatedStorage.state.atoms.PlayerState)

local scope = fusion:scoped()
local PlayerState = {}

PlayerState.currentState = scope:Value({})

charm.subscribe(PlayerStateHandlers.PlayerStatesAtom, function(newState)
	PlayerState.currentState:set(newState)
end)

return PlayerState
