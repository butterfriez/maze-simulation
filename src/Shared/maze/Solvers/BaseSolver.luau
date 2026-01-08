local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BaseGenerator = require(ReplicatedStorage.maze.Generation.BaseGenerator)
local Signal = require(ReplicatedStorage.Packages.Signal)
local types = require(ReplicatedStorage.maze.types)

export type BaseSolver = {
	new: (maze: BaseGenerator.BaseGenerator<unknown>) -> BaseSolver,
	Solve: (self: BaseSolver) -> (),
	IsComplete: (self: BaseSolver) -> boolean,
	OnComplete: Signal.Signal<{ types.Node<unknown> }>,
	Paint: (self: BaseSolver) -> (),
}

return {}
