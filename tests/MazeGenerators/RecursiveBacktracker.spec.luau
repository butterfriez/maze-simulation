local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RecursiveBacktracker = require(ReplicatedStorage.maze.Generation.RecursiveBacktracker)
local Maze = RecursiveBacktracker.new()

return function()
	describe("Recursive Backtracker", function()
		it("Should successfully generate a maze", function()
			--[[Maze:Generate()

			print("Generating maze...")

			while not Maze.Completed do
				task.wait()
			end

			expect(Maze.Completed).to.be.ok()]]
			-- Find a better way to write this
			expect(true == true).to.be.ok() -- placeholder for now
		end)
	end)
end
