local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BaseGenerator = require(ReplicatedStorage.maze.Generation.BaseGenerator)
local signal = require(ReplicatedStorage.Packages.Signal)
local types = require(ReplicatedStorage.maze.types)

export type BaseSolver = {
	new: (maze: BaseGenerator.BaseGenerator<unknown>) -> BaseSolver,
	Solve: (self: BaseSolver) -> { types.Node<unknown> }, -- path
	IsComplete: (self: BaseSolver) -> boolean,
	OnComplete: signal.Signal<{ types.Node<unknown> }>,
	Paint: (self: BaseSolver) -> (),
}

return {}
