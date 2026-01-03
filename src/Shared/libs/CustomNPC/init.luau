local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local queue = require(script.queue)
local signal = require(ReplicatedStorage.Packages.signal)

local types = require(script.types)

local Npc = {}
local NpcClass = { metatable = { __index = Npc } }

function NpcClass.new(npc: Model, walkspeed: number)
	local self: types._CustomNPC = setmetatable({}, NpcClass.metatable) :: any

	self._npc = npc
	self._walkspeed = walkspeed
	self._walkQueue = queue.new() :: queue.PriorityQueue<Vector3>
	self._loadedAnimations = {} :: { [string]: AnimationTrack }

	self.MoveToFinished = signal.new()
	self.StateChanged = signal.new()

	return self
end

function Npc.SetState(self: types._CustomNPC, newState: types.NPCStates)
	self._state = newState
	self.StateChanged:fire(newState)
end

function Npc.SetWalkSpeed(self: types._CustomNPC, walkspeed: number)
	self._walkspeed = walkspeed
end

function Npc.GetTracksPlaying(self: types._CustomNPC)
	local playing = {}

	for i, anim in self._loadedAnimations do
		if anim.IsPlaying then
			playing[i] = anim
		end
	end

	return playing
end

function Npc.MoveTo(self: types._CustomNPC, pos: Vector3, priority: number | nil)
	assert(self._npc.PrimaryPart == nil, "NPC must have a primary part.")

	if self._walkGoal == nil then
		self._walkGoal = pos
		self:SetState("Walking")
	end

	if self._walkingConnection == nil and self._walkQueue:Size() > 0 then
		self._walkingConnection = RunService.Heartbeat:Connect(function(dt) end)
	end
end

return NpcClass
