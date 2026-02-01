local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Charm = require(ReplicatedStorage.Packages.Charm)
local PlayerState = require(ReplicatedStorage.state.atoms.PlayerState)
local SoundManager = require(ReplicatedStorage.libs.SoundManager)

SoundManager.LoadSounds(ReplicatedStorage.assets.sounds :: Folder)

local CurrentLobbySound = SoundManager.GetSound("Lobby1")

local function PlayNextSound()
	local nextSound = tonumber(CurrentLobbySound.Name:match("%d+")) :: number + 1

	CurrentLobbySound = SoundManager.GetSound("Lobby" .. nextSound) or SoundManager.GetSound("Lobby" .. 1)
	CurrentLobbySound:Play()

	return CurrentLobbySound.Ended:Once(PlayNextSound)
end

local Connection = PlayNextSound()

Charm.subscribe(function()
	return PlayerState.PlayerStatesAtom()[Players.LocalPlayer.Name]
end, function(state)
	if state == nil then return end

	if state.gameState == "INGAME" then
		CurrentLobbySound:Stop()
		Connection:Disconnect()
	elseif state.gameState == "LOBBY" then
		Connection = PlayNextSound()
	end
end)
