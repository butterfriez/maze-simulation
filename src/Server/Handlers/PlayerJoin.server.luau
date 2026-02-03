local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local DataHandlers = require(ServerStorage.Data)
local PlayerState = require(ReplicatedStorage.state.atoms.PlayerState)

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
		currentState.rewardMultiplier = data.rewardMultiplier
		currentState.replays = data.savedReplays

		return currentState
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	local playerState = PlayerState.GetPlayerState(player.Name)

	DataHandlers.SetPlayerData(player.Name, {
		coins = playerState.coins,
		ratColor = { r = playerState.ratColor.R, g = playerState.ratColor.G, b = playerState.ratColor.B },
		mazeGenerationAlgorithm = playerState.algorithms.maze,
		mazeSolverAlgorithm = playerState.algorithms.solver,
		uiTheme = playerState.uiTheme,
		rewardMultiplier = playerState.rewardMultiplier,
		savedReplays = playerState.replays,
	})

	DataHandlers.SavePlayerData(player.Name)
end)
