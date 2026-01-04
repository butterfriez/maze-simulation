local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Charm = require(ReplicatedStorage.Packages.Charm)
local Fusion = require(ReplicatedStorage.Packages.Fusion)

type Value<T> = Fusion.Value<T>

local PlayerStateHandlers = require(ReplicatedStorage.state.atoms.PlayerState)
export type PlayerState = PlayerStateHandlers.PlayerState

local Player = Players.LocalPlayer

local scope = Fusion:scoped()
local PlayerState = {}

PlayerState.current = scope:Value(PlayerStateHandlers.DefaultPlayerState) :: Value<PlayerState>

Charm.subscribe(function()
	return PlayerStateHandlers.PlayerStatesAtom()[Player.Name]
end, function(newState)
	PlayerState.current:set(newState)
end)

return PlayerState
