local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Charm = require(ReplicatedStorage.Packages.Charm)
local Fusion = require(ReplicatedStorage.Packages.Fusion)

local PlayerStateHandlers = require(ReplicatedStorage.state.atoms.PlayerState)

local Player = Players.LocalPlayer

local scope = Fusion:scoped()
local PlayerState = {}

PlayerState.currentState = scope:Value({})

Charm.subscribe(function()
	return PlayerStateHandlers.PlayerStatesAtom()[Player.Name]
end, function(newState)
	PlayerState.currentState:set(newState)
end)

return PlayerState
