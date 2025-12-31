local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Charm = require(ReplicatedStorage.Packages.Charm)

local PlayerStateHandlers = require(ReplicatedStorage.state.atoms.PlayerState)

local scope = Fusion:scoped()
local PlayerState = {}

PlayerState.currentState = scope:Value({})

Charm.subscribe(PlayerStateHandlers.PlayerStatesAtom, function(newState)
	PlayerState.currentState:set(newState)
end)

return PlayerState
