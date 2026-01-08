local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Signal = require(ReplicatedStorage.Packages.Signal)
local queue = require(script.queue)

local types = require(script.types)

local Npc = {}
local NpcClass = { metatable = { __index = Npc } }

function NpcClass.new(npc: Model, walkspeed: number)
	local self: types._CustomNPC = setmetatable({}, NpcClass.metatable) :: any

	self._npc = npc
	self._walkspeed = walkspeed
	self._walkQueue = queue.new() :: queue.PriorityQueue<Vector3>
	self._loadedAnimations = {} :: { [string]: AnimationTrack }

	self.MoveToFinished = Signal.new()
	self.StateChanged = Signal.new()

	return self
end

function Npc.SetState(self: types._CustomNPC, newState: types.NPCStates)
	self._state = newState
	self.StateChanged:fire(newState)
end

function Npc.SetWalkSpeed(self: types._CustomNPC, walkspeed: number)
	self._walkspeed = walkspeed
end

-- yet to be implemented (Going to change to crunchyroll once i find out how to get bones to work)
function Npc.GetTracksPlaying(self: types._CustomNPC)
	local animationController = self._npc:FindFirstChildOfClass("AnimationController")
	return animationController:GetPlayingAnimationTracks()
end

function Npc.LoadAnimation(self: types._CustomNPC, animation: Animation)
	local animationController = self._npc:FindFirstChildOfClass("AnimationController")
	assert(animationController, "NPC must have an AnimationController.")

	return animationController:LoadAnimation(animation)
end

function Npc.MoveTo(self: types._CustomNPC, pos: Vector3, priority: number | nil)
	assert(self._npc.PrimaryPart ~= nil, "NPC must have a primary part.")

	priority = priority or 0
	self._walkQueue:Enqueue(pos, priority :: number)

	if self._walkGoal == nil then
		self._walkGoal = self._walkQueue:Dequeue()
		self:SetState("Walking")
	end

	if self._walkingConnection == nil and self._walkQueue:Size() > 0 then
		self:_StartWalking()
	end
end

function Npc._StartWalking(self: types._CustomNPC)
	self:SetState("Walking")

	local function Step(dt: number)
		local root = self._npc.PrimaryPart :: BasePart
		local goal = self._walkGoal
		if not goal then
			return
		end

		local pos = root.Position
		local offset = goal - pos
		local distance = offset.Magnitude

		if distance < 1 then
			if self._walkQueue:Size() == 0 and self._walkingConnection ~= nil then
				self._walkingConnection:Disconnect()
				self._walkingConnection = nil
				self._walkGoal = nil
				self:SetState("Idle")
				self.MoveToFinished:fire()
				return
			end

			self._walkGoal = self._walkQueue:Dequeue()
			return
		end

		local moveSpeed = self._walkspeed
		local moveAlpha = math.clamp((moveSpeed * dt) / distance, 0, 1)

		local newPos = pos:Lerp(goal, moveAlpha)

		local dir = (goal - newPos).Unit
		local flatDir = Vector3.new(dir.X, 0, dir.Z)
		if flatDir.Magnitude > 0 then
			flatDir = flatDir.Unit
		else
			flatDir = root.CFrame.LookVector
		end

		local currentCF = root.CFrame
		local targetRot = CFrame.lookAt(newPos, newPos + flatDir)

		local turnSpeed = math.rad(360) -- tweak
		local angle = math.acos(math.clamp(currentCF.LookVector:Dot(flatDir), -1, 1))

		local rotAlpha = math.clamp((turnSpeed * dt) / math.max(angle, 1e-4), 0, 1)

		root.CFrame = CFrame.new(newPos) * currentCF.Rotation:Lerp(targetRot.Rotation, rotAlpha)
	end

	if RunService:IsServer() then
		self._walkingConnection = RunService.Heartbeat:Connect(function(dt)
			Step(dt)
		end)
	else
		self._walkingConnection = RunService.RenderStepped:Connect(function(dt)
			Step(dt)
		end)
	end
end

return NpcClass
