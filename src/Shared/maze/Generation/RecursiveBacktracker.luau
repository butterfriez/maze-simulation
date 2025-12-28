local ReplicatedStorage = game:GetService("ReplicatedStorage")

local MazeConfig = require(ReplicatedStorage.core.MazeConfig)
local types = require(script.Parent.Parent.types)

local size = MazeConfig.mazeSize

type NodeMeta = {
	direction: string,
	visited: boolean,
}

type RecursiveBacktracker = {
	GetMaze: (self: _RecursiveBacktracker) -> { [number]: { [number]: types.Node<NodeMeta> } },
}

type _RecursiveBacktracker = RecursiveBacktracker & {
	_Maze: { [number]: { [number]: types.Node<NodeMeta> } },
	GetNeighbors: (self: _RecursiveBacktracker, x: number, y: number) -> { types.Node<NodeMeta> },
	SetDirection: (self: _RecursiveBacktracker, node1: types.Node<NodeMeta>, node2: types.Node<NodeMeta>) -> (),
}

local RecursiveBacktracker = {}
local RecursiveBacktrackerClass = { metatable = { __index = RecursiveBacktracker } }

function RecursiveBacktrackerClass.new()
	local self: _RecursiveBacktracker = setmetatable({}, RecursiveBacktracker) :: any

	local baseMaze = {}

	for i = 1, size do
		for j = 1, size do
			baseMaze[i][j] = { x = i, y = j, meta = { visited = false } } :: types.Node<NodeMeta>
		end
	end

	self._Maze = baseMaze

	return self
end

function RecursiveBacktracker.GetMaze(self: _RecursiveBacktracker)
	return self._Maze
end

function RecursiveBacktrackerClass.GetNeighbors(self: _RecursiveBacktracker, x: number, y: number)
	local neighbors = {}
	local origin = self._Maze[x][y]

	for _, direction in types.Directions do
		local neighbor = self._Maze[origin.x + direction[0]][origin.y + direction[1]]

		if neighbor.meta.visited then
			continue
		end

		table.insert(neighbors, neighbor)
	end

	return neighbors
end

function RecursiveBacktrackerClass.SetDirection(
	_: _RecursiveBacktracker,
	node1: types.Node<NodeMeta>,
	node2: types.Node<NodeMeta>
)
	local x1, y1 = node1.x, node1.y
	local x2, y2 = node2.x, node2.y

	local dx = x2 - x1
	local dy = y2 - y1

	local dir = "Right"

	if dx == -1 and dy == 0 then
		dir = "Left"
	elseif dx == 0 and dy == 1 then
		dir = "Down"
	elseif dx == 0 and dy == -1 then
		dir = "Up"
	else
		error("Nodes are not adjacent")
	end

	node1.meta.direction = dir
end

function RecursiveBacktrackerClass.Generate(self: _RecursiveBacktracker)
	local stack = {}

	local current = self._Maze[math.random(1, 100)][math.random(1, 100)]

	table.insert(stack, current)

	while true do
		local neighbors = self:GetNeighbors(current.x, current.y)

		if #neighbors ~= 0 then
			local newNode = neighbors[math.random(1, #neighbors)]
			self:SetDirection(current, newNode)
			table.insert(stack, current)
			current = newNode
			current.meta.visited = true
		else
			if #stack ~= 0 then
				current = stack[#stack]
				table.remove(stack, #stack)
			else
				break
			end

			task.wait()
		end
	end
end

return RecursiveBacktrackerClass
