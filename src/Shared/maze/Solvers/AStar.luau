local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BaseGenerator = require(ReplicatedStorage.maze.Generation.BaseGenerator)
local BaseSolver = require(script.Parent.BaseSolver)
local GetPoints = require(ReplicatedStorage.maze.util.GetPoints)
local MazeConfig = require(ReplicatedStorage.core.MazeConfig)
local Signal = require(ReplicatedStorage.Packages.Signal)
local types = require(ReplicatedStorage.maze.types)

type AStar = BaseSolver.BaseSolver & {}

type _AStar = AStar & {
	_maze: BaseGenerator.BaseGenerator<unknown>,
	_start: types.Node<unknown>,
	_end: types.Node<unknown>,
	_path: { types.Node<unknown> },
	_complete: boolean,
}

local AStar = {}
local AStarClass = { metatable = { __index = AStar } }

function AStarClass.new(maze: BaseGenerator.BaseGenerator<unknown>)
	local self: _AStar = setmetatable({}, AStarClass.metatable) :: any

	local startPoint, endPoint = GetPoints(maze)

	self._maze = maze
	self._start = startPoint
	self._end = endPoint
	self._path = {}
	self._complete = false

	self.OnComplete = Signal.new()

	return self
end

type AStarNode = {
	g: number,
	h: number,
	f: number,
	node: types.Node<unknown>,
	parent: AStarNode?,
}

local function Heuristic(a: types.Node<unknown>, b: types.Node<unknown>)
	return math.abs(a.x - b.x) + math.abs(a.y - b.y)
end

local function GetSuccessors(maze: BaseGenerator.BaseGenerator<unknown>, node: types.Node<unknown>)
	local successors: { types.Node<unknown> } = {}

	for dirName, delta in types.Directions do
		if node.open[dirName] then
			local successor = maze:GetMaze()[node.x + delta[1]][node.y + delta[2]]
			table.insert(successors, successor)
		end
	end

	return successors
end

local function Find(list: { AStarNode }, node: types.Node<unknown>)
	for _, item in list do
		if item.node == node then
			return item
		end
	end
	return nil
end

function AStar.Solve(self: _AStar)
	local open: { AStarNode } = {}
	local closed: { AStarNode } = {}

	table.insert(open, {
		g = 0,
		h = 0,
		f = 0,
		node = self._start,
		parent = nil,
	})

	while #open > 0 do
		table.sort(open, function(a0: AStarNode, a1: AStarNode)
			return a0.f < a1.f
		end)

		local currentNode = table.remove(open, 1)
		table.insert(closed, currentNode)

		if currentNode.node == self._end then
			self._complete = true
			self._path = {}

			while currentNode do
				table.insert(self._path, 1, currentNode.node)
				currentNode = currentNode.parent
			end
			self.OnComplete:fire(self._path)
			return
		end

		for _, successor in GetSuccessors(self._maze, currentNode.node) do
			if Find(closed, successor) then
				continue
			end

			local g = currentNode.g + 1
			local existingNode = Find(open, successor)

			if not existingNode then
				local h = Heuristic(successor, self._end)
				local f = g + h

				table.insert(open, {
					g = g,
					h = h,
					f = f,
					node = successor,
					parent = currentNode,
				})
			elseif g < existingNode.g then
				existingNode.g = g
				existingNode.f = g + existingNode.h
				existingNode.parent = currentNode
			end
		end
	end
end

function AStar.IsComplete(self: _AStar): boolean
	return self._complete
end

local function LerpColor(a: Color3, b: Color3, t: number)
	return Color3.new(a.R + (b.R - a.R) * t, a.G + (b.G - a.G) * t, a.B + (b.B - a.B) * t)
end

function AStar.Paint(self: _AStar)
	local size = MazeConfig.nodeSize
	local pathLength = #self._path

	local startColor = Color3.fromRGB(0, 0, 0) -- red
	local endColor = Color3.fromRGB(255, 255, 255) -- white

	for i, node in self._path do
		local block = Instance.new("Part")
		block.Anchored = true
		block.CanCollide = false
		block.Material = Enum.Material.Neon

		block.Size = Vector3.new(2, 2, 2)

		block.Position = Vector3.new(node.x * size, 2, node.y * size)

		local t = (i - 1) / math.max(pathLength - 1, 1)
		block.Color = LerpColor(startColor, endColor, t)

		if node == self._start then
			block.Size = Vector3.new(3, 3, 3)
			block.Color = Color3.fromRGB(0, 255, 0)
			block.Name = "Start"
		end

		if node == self._end then
			block.Size = Vector3.new(4, 4, 4)
			block.Color = Color3.fromRGB(0, 170, 255)
			block.Name = "End"
		end

		block.Parent = workspace
	end
end

return AStarClass
