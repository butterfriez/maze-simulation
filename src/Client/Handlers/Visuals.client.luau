local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BuildMaze = require(ReplicatedStorage.maze.util.BuildMaze)
local networking = require(ReplicatedStorage.networking)

--[[
	Might need to change this method so that the server spawns the npcs,
	moves along the path,
	and the client just visualizes the movement.

	(Transparency of 1 on model -> server)
	(Transparency of 0 on model -> client)

]]
local function StartNPCWalk() -- Kept blanked for now to find a better solution
	--networking.requestNextPathNode:request():andThen(function(currentNode) end)
end

networking.buildMaze:connect(function(maze)
	BuildMaze(maze)
	StartNPCWalk()
end)
