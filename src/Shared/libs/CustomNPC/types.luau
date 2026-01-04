local ReplicatedStorage = game:GetService("ReplicatedStorage")
local queue = require(script.Parent.queue)
local Signal = require(ReplicatedStorage.Packages.Signal)

export type NPCStates = "Idle" | "Walking"

export type CustomNPC = {
	new: (npc: Model, walkspeed: number) -> _CustomNPC,
	SetState: (self: _CustomNPC, newState: NPCStates) -> (),
	GetTracksPlaying: (self: _CustomNPC) -> { [string | number]: AnimationTrack },
	MoveTo: (self: _CustomNPC, pos: Vector3) -> (),
	SetWalkSpeed: (self: _CustomNPC, walkspeed: number) -> (),
	MoveToFinished: Signal.Signal<()>,
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
}

return {}
