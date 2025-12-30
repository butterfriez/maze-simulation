local ReplicatedStorage = game:GetService("ReplicatedStorage")

local JestGlobals = require(ReplicatedStorage.DevPackages.JestGlobals)
local promise = require(ReplicatedStorage.Packages.promise)
local RecursiveBacktracker = require(ReplicatedStorage.maze.Generation.RecursiveBacktracker)
local Maze = RecursiveBacktracker.new()

local it = JestGlobals.it
local expect = JestGlobals.expect

it("Checks if maze is successfully built", function()
	return promise
		.new(function(resolve, reject, onCancel)
			Maze:Generate()
			while not Maze:IsComplete() do
				task.wait()
			end

			resolve(Maze:GetMaze())
		end)
		:andThen(function(maze)
			print(maze)
			expect(maze).toBeDefined()
		end)
end)
