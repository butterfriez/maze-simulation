local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local BaseGenerator = require(ReplicatedStorage.maze.Generation.BaseGenerator)
local BaseSolver = require(ReplicatedStorage.maze.Solvers.BaseSolver)
local CONSTANTS = require(ReplicatedStorage.core.CONSTANTS)
local CustomNPC = require(ReplicatedStorage.libs.CustomNPC)
local MazeConfig = require(ReplicatedStorage.core.MazeConfig)
local Path = require(ReplicatedStorage.maze.util.Path)
local PlayerState = require(ReplicatedStorage.state.atoms.PlayerState)
local PlayerStateHandlers = require(ReplicatedStorage.state.atoms.PlayerState)
local networking = require(ReplicatedStorage.networking)
local types = require(ReplicatedStorage.maze.types)

local PlayerMazes: { [Player]: BaseGenerator.BaseGenerator<unknown> } = {}
local PlayerPaths: { [Player]: { path: types.Node<unknown>, current: number } } = {}
local PlayerNpcs: { [Player]: Model } = {}

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
		end)

		generator:Generate()
	end
end

local function StartNPC(player)
	if PlayerNpcs[player] then return end

	local path = Path.PathToPositions(PlayerPaths[player].path)
	local npc = ReplicatedStorage.assets.ServerNPC:Clone()

	PlayerNpcs[player] = npc

	npc.PrimaryPart.Position = path[1]
	npc.Parent = workspace

	local npcObject =
		CustomNPC.new(npc, if RunService:IsStudio() then CONSTANTS.DEBUG_WALKSPEED else CONSTANTS.BASE_WALKSPEED)

	npcObject.MoveToFinished:once(function()
		npc:Destroy()
		UpdatePlayerGameState(player, "ENDED")

		PlayerState.UpdatePlayerState(player.Name, function(currentState)
			currentState = table.clone(currentState)
			currentState.coins += CONSTANTS.BASE_REWARD * currentState.rewardMultiplier

			return currentState
		end)

		task.delay(4, function()
			UpdatePlayerGameState(player, "LOBBY")
		end)
	end)

	for i, point in path do
		npcObject:MoveTo(point, i)
	end
end

local function SolveMaze(player: Player)
	local playerMaze = PlayerMazes[player]

	local solverAlgorithmKey = PlayerStateHandlers.GetPlayerState(player.Name).algorithms.solver
	local mazeSolver =
		ReplicatedStorage.maze.Solvers:FindFirstChild(MazeConfig.solvingAlgorithms[solverAlgorithmKey].key)

	if mazeSolver and playerMaze then
		local solverModule = require(mazeSolver) :: BaseSolver.BaseSolver
		local solver = solverModule.new(playerMaze)

		solver.OnComplete:once(function(path)
			PlayerPaths[player] = {
				path = path,
				current = 1,
			}
			networking.startPath:fire(player, Path.PathToPositions(path))

			StartNPC(player)
		end)

		solver:Solve()
	end
end

networking.startGame:connect(function(player)
	local playerState = PlayerStateHandlers.GetPlayerState(player.Name)

	if playerState.gameState == "LOBBY" then
		GenerateMaze(player)
		SolveMaze(player)
		UpdatePlayerGameState(player, "INGAME")
		networking.buildMaze:fire(player, PlayerMazes[player]:GetMaze() :: any)
	end
end)
