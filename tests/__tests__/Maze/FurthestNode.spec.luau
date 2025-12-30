local ReplicatedStorage = game:GetService("ReplicatedStorage")
local JestGlobals = require(ReplicatedStorage.DevPackages.JestGlobals)
local promise = require(ReplicatedStorage.Packages.promise)

local RecursiveBacktracker = require(ReplicatedStorage.maze.Generation.RecursiveBacktracker)
local GetPoints = require(ReplicatedStorage.maze.util.GetPoints)

local it = JestGlobals.it
local expect = JestGlobals.expect

local Maze = RecursiveBacktracker.new()

it("Gets the furthest node", function()
	return promise
		.new(function(resolve)
			Maze:Generate()
			while not Maze:IsComplete() do
				task.wait()
			end

			print(GetPoints(Maze))
			resolve(GetPoints(Maze))
		end)
		:andThen(function(points)
			expect(points).toBeDefined()
		end)
end)
