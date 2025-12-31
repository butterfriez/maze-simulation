local ReplicatedStorage = game:GetService("ReplicatedStorage")

local JestGlobals = require(ReplicatedStorage.Packages.JestGlobals)
local Promise = require(ReplicatedStorage.Packages.Promise)
local RecursiveBacktracker = require(ReplicatedStorage.maze.Generation.RecursiveBacktracker)
local Maze = RecursiveBacktracker.new()

local it = JestGlobals.it
local expect = JestGlobals.expect

it("Checks if maze is successfully built", function()
	return Promise
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
