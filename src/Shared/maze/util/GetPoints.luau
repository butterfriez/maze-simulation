local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MazeConfig = require(ReplicatedStorage.core.MazeConfig)
local BaseGenerator = require(ReplicatedStorage.maze.Generation.BaseGenerator)

local function GetPoints(maze: BaseGenerator.BaseGenerator<unknown>)
	return maze:GetMaze()[1][1], maze:GetMaze()[MazeConfig.mazeSize][MazeConfig.mazeSize]
end

return GetPoints
