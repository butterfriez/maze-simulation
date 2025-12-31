local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MazeConfig = require(ReplicatedStorage.core.MazeConfig)
local types = require(ReplicatedStorage.maze.types)

local WALL_HEIGHT = 10
local WALL_THICKNESS = 1
local SIZE = MazeConfig.nodeSize

local DIR_DATA = {
	Up = {
		offset = Vector3.new(0, WALL_HEIGHT / 2, -SIZE / 2),
		size = Vector3.new(SIZE, WALL_HEIGHT, WALL_THICKNESS),
	},
	Down = {
		offset = Vector3.new(0, WALL_HEIGHT / 2, SIZE / 2),
		size = Vector3.new(SIZE, WALL_HEIGHT, WALL_THICKNESS),
	},
	Left = {
		offset = Vector3.new(-SIZE / 2, WALL_HEIGHT / 2, 0),
		size = Vector3.new(WALL_THICKNESS, WALL_HEIGHT, SIZE),
	},
	Right = {
		offset = Vector3.new(SIZE / 2, WALL_HEIGHT / 2, 0),
		size = Vector3.new(WALL_THICKNESS, WALL_HEIGHT, SIZE),
	},
}

local function BuildNode<NodeMeta>(node: types.Node<NodeMeta>)
	local cellPos = Vector3.new(node.x * SIZE, 0, node.y * SIZE)

	local base = Instance.new("Part")
	base.Size = Vector3.new(SIZE, 1, SIZE)
	base.Position = cellPos + Vector3.new(0, 0.5, 0)
	base.Anchored = true
	base.Parent = workspace

	for dir, data in pairs(DIR_DATA) do
		if not node.open[dir] then
			local wall = Instance.new("Part")
			wall.Anchored = true
			wall.Size = data.size
			wall.Position = cellPos + data.offset
			wall.Parent = workspace
		end
	end
end

return BuildNode
