local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BuildMaze = require(ReplicatedStorage.maze.util.BuildMaze)
local networking = require(ReplicatedStorage.networking)

networking.buildMaze:connect(function(maze)
	BuildMaze(maze)
end)
