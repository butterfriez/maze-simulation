local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local PlayerState = require(ReplicatedStorage.state.atoms.PlayerState)
local DataHandlers = require(ServerStorage.Data)

Players.PlayerAdded:Connect(function(player)
	local key = player.Name
	DataHandlers.LoadData(player)
	PlayerState.SetPlayerState(key, PlayerState.DefaultPlayerState)

	local data = DataHandlers.GetPlayerData(key)

	PlayerState.UpdatePlayerState(key, function(currentState: PlayerState.PlayerState)
		currentState = table.clone(currentState)
		currentState.coins = data.coins
		currentState.algorithms = {
			maze = data.mazeGenerationAlgorithm,
			solver = data.mazeSolverAlgorithm,
		}
		currentState.ratColor = Color3.fromRGB(data.ratColor.r, data.ratColor.g, data.ratColor.b)

		return currentState -- forgot to return this so it caused me to debug why playerstate wasn't being set for an hour looooooooooool
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	local playerState = PlayerState.GetPlayerState(player.Name)

	DataHandlers.SetPlayerData(player.Name, {
		coins = playerState.coins,
		ratColor = { r = playerState.ratColor.R, g = playerState.ratColor.G, b = playerState.ratColor.B },
		mazeGenerationAlgorithm = playerState.algorithms.maze,
		mazeSolverAlgorithm = playerState.algorithms.solver,
	})

	DataHandlers.SavePlayerData(player.Name)
end)
