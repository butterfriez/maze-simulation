--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UI = script.Parent.Parent

local Charm = require(ReplicatedStorage.Packages.Charm)
local Fusion = require(ReplicatedStorage.Packages.Fusion)

type Value<T> = Fusion.Value<T>

local PlayerStateHandlers = require(ReplicatedStorage.state.atoms.PlayerState)
export type PlayerState = PlayerStateHandlers.PlayerState

local Story = require(UI.Story)
if Story.Available then
	local UILabs = require(ReplicatedStorage.Packages.UILabs)
	if UILabs.Environment.IsStory() then
		local CONSTANTS = require(ReplicatedStorage.core.CONSTANTS)
		local DEFAULT = PlayerStateHandlers.DefaultPlayerState
		PlayerStateHandlers.SetPlayerState(CONSTANTS.USER_NAME, DEFAULT)
	end
end

local scope = Fusion:scoped()
local PlayerState = {}

PlayerState.current = scope:Value(PlayerStateHandlers.DefaultPlayerState) :: Value<PlayerState>

local Player: Player? = Players.LocalPlayer
if Player then
	Charm.subscribe(function()
		return PlayerStateHandlers.PlayerStatesAtom()[Player.Name]
	end, function(newState: PlayerState)
		PlayerState.current:set(newState)
	end)
end

return PlayerState
