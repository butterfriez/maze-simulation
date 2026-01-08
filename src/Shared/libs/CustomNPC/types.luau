local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal = require(ReplicatedStorage.Packages.Signal)
local queue = require(script.Parent.queue)

export type NPCStates = "Idle" | "Walking"

export type CustomNPC = {
	new: (npc: Model, walkspeed: number) -> _CustomNPC,
	SetState: (self: _CustomNPC, newState: NPCStates) -> (),
	LoadAnimation: (self: _CustomNPC, animation: Animation) -> AnimationTrack,
	MoveTo: (self: _CustomNPC, pos: Vector3) -> (),
	SetWalkSpeed: (self: _CustomNPC, walkspeed: number) -> (),
	MoveToFinished: Signal.Signal<>,
	StateChanged: Signal.Signal<NPCStates>,
}

export type _CustomNPC = CustomNPC & {
	_npc: Model,
	_state: NPCStates,
	_loadedAnimations: { [string | number]: AnimationTrack },
	_walkspeed: number,
	_walkingConnection: RBXScriptConnection | nil,
	_walkGoal: Vector3 | nil,
	_walkQueue: queue.PriorityQueue<Vector3>,
	_StartWalking: (self: _CustomNPC) -> (),
}

return {}
