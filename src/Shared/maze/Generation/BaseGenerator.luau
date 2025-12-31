local ReplicatedStorage = game:GetService("ReplicatedStorage")
local types = require(ReplicatedStorage.maze.types)

export type BaseGenerator<NodeMeta> = {
	new: () -> BaseGenerator<NodeMeta>,
	GetMaze: (self: BaseGenerator<NodeMeta>) -> { [number]: { [number]: types.Node<NodeMeta> } },
	Generate: (self: BaseGenerator<NodeMeta>) -> (),
	Build: (self: BaseGenerator<NodeMeta>) -> (),
	IsComplete: (self: BaseGenerator<NodeMeta>) -> boolean,
}

return {}
