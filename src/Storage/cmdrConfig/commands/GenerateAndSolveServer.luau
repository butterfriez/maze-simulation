local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RecursiveBacktracker = require(ReplicatedStorage.maze.Generation.RecursiveBacktracker)
local WallFollower = require(ReplicatedStorage.maze.Solvers.WallFollower)
return function(_, mazeAlgorithm, mazeSolver)
	local maze = nil

	if mazeAlgorithm == "Recursive Backtracker" then
		maze = RecursiveBacktracker.new()
		maze:Generate()

		while maze:IsComplete() == false do
			task.wait()
		end

		maze:Build()
	end

	local solver = nil

	if mazeSolver == "Wall Follower" then
		solver = WallFollower.new(maze)
		solver:Solve()

		while solver:IsComplete() == false do
			task.wait()
		end

		solver:Paint()
	end
end
