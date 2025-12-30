local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MazeConfig = require(ReplicatedStorage.core.MazeConfig)
local BaseSolver = require(script.Parent.BaseSolver)
local BaseGenerator = require(ReplicatedStorage.maze.Generation.BaseGenerator)
local types = require(ReplicatedStorage.maze.types)
local GetPoints = require(ReplicatedStorage.maze.util.GetPoints)

type WallFollower = BaseSolver.BaseSolver & {
	new: (maze: BaseGenerator.BaseGenerator<unknown>) -> WallFollower,
}

type _WallFollower = WallFollower & {
	_maze: BaseGenerator.BaseGenerator<unknown>,
	_start: types.Node<unknown>,
	_end: types.Node<unknown>,
	_path: { types.Node<unknown> },
	_complete: boolean,
}

local DIR = {
	Up = 1,
	Right = 2,
	Down = 3,
	Left = 4,
}

local DIR_ORDER = { "Up", "Right", "Down", "Left" }

local WallFollower = {}
local WallFollowerClass = { metatable = { __index = WallFollower } }

local function IsOpen(node: types.Node<unknown>, dir: number)
	return node.open[DIR_ORDER[dir]] == true
end

local function MoveForward(maze: BaseGenerator.BaseGenerator<unknown>, node: types.Node<unknown>, dir: number)
	local delta = types.Directions[DIR_ORDER[dir]]
	return maze:GetMaze()[node.x + delta[1]][node.y + delta[2]]
end

local function turnLeft(dir: number)
	return ((dir - 2) % 4) + 1
end

local function turnRight(dir: number)
	return (dir % 4) + 1
end

local function turnBack(dir: number)
	return ((dir + 1) % 4) + 1
end

function WallFollowerClass.new(maze: BaseGenerator.BaseGenerator<unknown>)
	local self: _WallFollower = setmetatable({}, WallFollowerClass.metatable) :: any

	local startPoint, endPoint = GetPoints(maze)

	self._maze = maze
	self._start = startPoint
	self._end = endPoint
	self._path = {}
	self._complete = false

	return self
end

function WallFollower.Solve(self: _WallFollower)
	local current = self._start
	local facing = DIR.Right

	table.insert(self._path, current)

	while current ~= self._end do
		local left = turnLeft(facing)
		if IsOpen(current, left) then
			facing = left
			current = MoveForward(self._maze, current, facing)
		elseif IsOpen(current, facing) then
			current = MoveForward(self._maze, current, facing)
		elseif IsOpen(current, turnRight(facing)) then
			facing = turnRight(facing)
			current = MoveForward(self._maze, current, facing)
		else
			facing = turnBack(facing)
		end

		table.insert(self._path, current)
		task.wait()
	end

	self._complete = true

	return self._path
end

function WallFollower.IsComplete(self: _WallFollower)
	return self._complete
end

-- yes the rest is chatgpted im too lazy to write ts

local function LerpColor(a: Color3, b: Color3, t: number)
	return Color3.new(a.R + (b.R - a.R) * t, a.G + (b.G - a.G) * t, a.B + (b.B - a.B) * t)
end

-- Might change this to be a utililty function
function WallFollower.Paint(self: _WallFollower)
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

return WallFollowerClass
