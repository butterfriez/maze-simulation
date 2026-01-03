local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BaseGenerator = require(ReplicatedStorage.maze.Generation.BaseGenerator)
local MazeConfig = require(ReplicatedStorage.core.MazeConfig)
local PlayerStateHandlers = require(ReplicatedStorage.state.atoms.PlayerState)
local networking = require(ReplicatedStorage.networking)

local PlayerMazes: { [Player]: BaseGenerator.BaseGenerator<unknown> } = {}

local function UpdatePlayerGameState(player: Player, newState: "LOBBY" | "GENERATING" | "INGAME" | "ENDED")
	PlayerStateHandlers.UpdatePlayerState(player.Name, function(state)
		state = table.clone(state)
		state.gameState = newState
		return state
	end)
end

local function GenerateMaze(player: Player)
	local mazeGenerationAlgorithmKey = PlayerStateHandlers.GetPlayerState(player.Name).algorithms.maze
	local mazeGenerator = ReplicatedStorage.maze.Generation:FindFirstChild(
		MazeConfig.generationAlgorithms[mazeGenerationAlgorithmKey].key
	)

	if mazeGenerator then
		local generatorModule = require(mazeGenerator) :: BaseGenerator.BaseGenerator<unknown>
		local generator = generatorModule.new()

		UpdatePlayerGameState(player, "GENERATING")

		PlayerMazes[player] = generator:Generate()

		while generator:IsComplete() == false do
			task.wait()
		end

		networking.buildMaze:fire(player, generator:GetMaze())
	end
end

networking.startGame:connect(function(player)
	local playerState = PlayerStateHandlers.GetPlayerState(player.Name)

	if playerState.gameState == "LOBBY" then
		task.spawn(function()
			GenerateMaze(player)
			UpdatePlayerGameState(player, "INGAME")
		end)
	end
end)
