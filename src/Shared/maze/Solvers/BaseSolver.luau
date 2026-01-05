local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BaseGenerator = require(ReplicatedStorage.maze.Generation.BaseGenerator)
local signal = require(ReplicatedStorage.Packages.signal)
local types = require(ReplicatedStorage.maze.types)

export type BaseSolver = {
	new: (maze: BaseGenerator.BaseGenerator<unknown>) -> BaseSolver,
	Solve: (self: BaseSolver) -> { types.Node<unknown> }, -- path
	IsComplete: (self: BaseSolver) -> boolean,
	OnComplete: signal.Signal<>,
	Paint: (self: BaseSolver) -> (),
}

return {}
