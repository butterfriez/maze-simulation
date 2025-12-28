local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerState = require(ReplicatedStorage.state.atoms.PlayerState)

Players.PlayerAdded:Connect(function(player)
	local key = player.Name

	PlayerState.SetPlayerState(key, PlayerState.DefaultPlayerState)
end)
