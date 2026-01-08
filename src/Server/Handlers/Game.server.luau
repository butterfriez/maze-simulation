local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BaseGenerator = require(ReplicatedStorage.maze.Generation.BaseGenerator)
local BaseSolver = require(ReplicatedStorage.maze.Solvers.BaseSolver)
local MazeConfig = require(ReplicatedStorage.core.MazeConfig)
local Path = require(ReplicatedStorage.maze.util.Path)
local PlayerStateHandlers = require(ReplicatedStorage.state.atoms.PlayerState)
local networking = require(ReplicatedStorage.networking)
local types = require(ReplicatedStorage.maze.types)

local PlayerMazes: { [Player]: BaseGenerator.BaseGenerator<unknown> } = {}
local PlayerPaths: { [Player]: { types.Node<unknown> } } = {}

local function UpdatePlayerGameState(player: Player, newState: "LOBBY" | "GENERATING" | "INGAME" | "ENDED" | "SOLVING")
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

		generator.OnComplete:once(function()
			PlayerMazes[player] = generator

			networking.buildMaze:fire(player, PlayerMazes[player]:GetMaze() :: types.Node<unknown>)
		end)

		generator:Generate()
	end
end

local function SolveMaze(player: Player)
	local playerMaze = PlayerMazes[player]

	local solverAlgorithmKey = PlayerStateHandlers.GetPlayerState(player.Name).algorithms.solver
	local mazeSolver =
		ReplicatedStorage.maze.Solvers:FindFirstChild(MazeConfig.solvingAlgorithms[solverAlgorithmKey].key)

	if mazeSolver and playerMaze then
		UpdatePlayerGameState(player, "SOLVING")

		local solverModule = require(mazeSolver) :: BaseSolver.BaseSolver
		local solver = solverModule.new(playerMaze)

		solver.OnComplete:once(function(path)
			UpdatePlayerGameState(player, "INGAME")
			PlayerPaths[player] = path

			networking.startPath:fire(player, Path.PathToPositions(PlayerPaths[player]))
		end)

		solver:Solve()
	end
end

networking.startGame:connect(function(player)
	local playerState = PlayerStateHandlers.GetPlayerState(player.Name)

	if playerState.gameState == "LOBBY" then
		task.spawn(function()
			GenerateMaze(player)
			SolveMaze(player)
		end)
	end
end)
