local ReplicatedStorage = game:GetService("ReplicatedStorage")
local types = require(ReplicatedStorage.maze.types)

export type BaseGenerator<NodeMeta> = {
	new: () -> BaseGenerator<NodeMeta>,
	GetMaze: (self: BaseGenerator<NodeMeta>) -> { [number]: { [number]: types.Node<NodeMeta> } },
	Generate: (self: BaseGenerator<NodeMeta>) -> number, -- returns a seed to be able to remake the maze for possible debugging & replay system?
	IsComplete: (self: BaseGenerator<NodeMeta>) -> boolean,
	Destroy: (self: BaseGenerator<NodeMeta>) -> (),
}

return {}
