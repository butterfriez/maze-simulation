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
	Generate: (self: _RecursiveBacktracker) -> (),
	Completed: boolean,
}

type _RecursiveBacktracker = RecursiveBacktracker & {
	_Maze: { [number]: { [number]: types.Node<NodeMeta> } },
	GetNeighbors: (self: _RecursiveBacktracker, x: number, y: number) -> { types.Node<NodeMeta> },
	SetDirection: (self: _RecursiveBacktracker, node1: types.Node<NodeMeta>, node2: types.Node<NodeMeta>) -> (),
}

local RecursiveBacktracker = {}
RecursiveBacktracker.__index = RecursiveBacktracker

function RecursiveBacktracker.new()
	local self: _RecursiveBacktracker = setmetatable({}, RecursiveBacktracker) :: any

	local baseMaze = {}

	for i = 1, size do
		baseMaze[i] = {}
		for j = 1, size do
			baseMaze[i][j] = { x = i, y = j, meta = { visited = false } } :: types.Node<NodeMeta>
		end
	end

	self._Maze = baseMaze
	self.Completed = false

	return self
end

function RecursiveBacktracker.GetMaze(self: _RecursiveBacktracker)
	return self._Maze
end

function RecursiveBacktracker.GetNeighbors(self: _RecursiveBacktracker, x: number, y: number)
	local neighbors = {}
	local origin = self._Maze[x][y]

	for _, dir in ipairs(types.Directions) do
		local nx = origin.x + dir[1]
		local ny = origin.y + dir[2]

		if not self._Maze[nx] or not self._Maze[nx][ny] then
			continue
		end

		local neighbor = self._Maze[nx][ny]
		if neighbor.meta.visited then
			continue
		end

		table.insert(neighbors, neighbor)
	end

	return neighbors
end

function RecursiveBacktracker.SetDirection(
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
		dir = "None"
	end

	node1.meta.direction = dir
end

function RecursiveBacktracker.Generate(self: _RecursiveBacktracker)
	local stack = {}

	local current = self._Maze[math.random(1, MazeConfig.mazeSize)][math.random(1, MazeConfig.mazeSize)]
	current.meta.visited = true
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

	self.Completed = true
end

return RecursiveBacktracker
