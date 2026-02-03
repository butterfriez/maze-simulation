--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Charm = require(ReplicatedStorage.Packages.Charm)
local PlayerState = require(ReplicatedStorage.state.atoms.PlayerState)
local SoundManager = require(ReplicatedStorage.libs.SoundManager)

SoundManager.Load(ReplicatedStorage.assets.sounds)

local CurrentLobbySound = SoundManager.Get("Lobby1")

local function PlayNextSound(): RBXScriptConnection
	local nextSound = tonumber(CurrentLobbySound.Name:match("%d+")) :: number + 1

	CurrentLobbySound = SoundManager.Get("Lobby" .. nextSound) or SoundManager.Get("Lobby1")
	CurrentLobbySound:Play()

	return CurrentLobbySound.Ended:Once(PlayNextSound :: any)
end

local Connection = PlayNextSound()

Charm.subscribe(function()
	return PlayerState.PlayerStatesAtom()[Players.LocalPlayer.Name]
end, function(state, prev)
	if state == nil or prev == nil then return end
	if prev.gameState == "REPLAYSEL" then return end

	if state.gameState == "INGAME" then
		CurrentLobbySound:Stop()
		Connection:Disconnect()
	elseif state.gameState == "LOBBY" then
		Connection = PlayNextSound()
	end
end)
