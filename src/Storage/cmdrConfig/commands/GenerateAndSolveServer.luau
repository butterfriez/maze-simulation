local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BaseGenerator = require(ReplicatedStorage.maze.Generation.BaseGenerator)
local BuildMaze = require(ReplicatedStorage.maze.util.BuildMaze)

return function(_, mazeAlgorithm, mazeSolver)
	local success, generator: BaseGenerator.BaseGenerator<unknown> =
		pcall(require, ReplicatedStorage.maze.Generation:FindFirstChild(mazeAlgorithm))

	if success then
		generator = generator.new()
		generator:Generate()

		while generator:IsComplete() == false do
			task.wait()
		end

		BuildMaze(generator:GetMaze())
	end

	local success, solver = pcall(require, ReplicatedStorage.maze.Solvers:FindFirstChild(mazeSolver))

	if success then
		solver = solver.new(generator)
		solver:Solve()

		while solver:IsComplete() == false do
			task.wait()
		end

		solver:Paint()
	end
end
