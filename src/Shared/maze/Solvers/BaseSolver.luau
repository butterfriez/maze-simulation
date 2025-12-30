local ReplicatedStorage = game:GetService("ReplicatedStorage")
local types = require(ReplicatedStorage.maze.types)

export type BaseSolver = {
	Solve: (self: BaseSolver) -> { types.Node<unknown> }, -- path
	IsComplete: (self: BaseSolver) -> boolean,
	Paint: (self: BaseSolver) -> (),
}

return {}
