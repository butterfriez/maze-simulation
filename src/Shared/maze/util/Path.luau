local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MazeConfig = require(ReplicatedStorage.core.MazeConfig)
local types = require(ReplicatedStorage.maze.types)

local function NodeToPosition(node: types.Node<unknown>): Vector3
	return Vector3.new(node.x * MazeConfig.nodeSize, 0, node.y * MazeConfig.nodeSize)
end

local function PathToPositions(path: { types.Node<unknown> }): { Vector3 }
	local positions: { Vector3 } = {}
	for _, node in path do
		table.insert(positions, NodeToPosition(node))
	end
	return positions
end

return {
	NodeToPosition = NodeToPosition,
	PathToPositions = PathToPositions,
}
