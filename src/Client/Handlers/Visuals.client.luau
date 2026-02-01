local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BuildMaze = require(ReplicatedStorage.maze.util.BuildMaze)
local CustomNPC = require(ReplicatedStorage.libs.CustomNPC)
local networking = require(ReplicatedStorage.networking)

--[[
@@ -11,11 +12,51 @@ local networking = require(ReplicatedStorage.networking)
	(Transparency of 0 on model -> client)

]]
local function StartNPCWalk(path: { Vector3 })
	local npc = ReplicatedStorage.assets.Mouse:Clone() :: Model
	npc.PrimaryPart.Anchored = true
	npc.PrimaryPart.Position = path[1] + Vector3.new(0, 1, 0)
	npc.Parent = workspace

	local npcObject = CustomNPC.new(npc, 12)

	local idle = npc.Animations.Idle :: Animation
	local run = npc.Animations.Run :: Animation

	idle = npcObject:LoadAnimation(idle)
	run = npcObject:LoadAnimation(run)

	idle:Play()

	npcObject.StateChanged:connect(function(a0: "Idle" | "Walking")
		if a0 == "Idle" then
			run:Stop()
			idle:Play()
		elseif a0 == "Walking" then
			idle:Stop()
			run:Play()
		end
	end)

	npcObject.MoveToFinished:once(function()
		npc:Destroy()
		workspace:FindFirstChild("ClientMaze"):Destroy()

		networking.foundCheese:fire() -- Replacement for server-client npc sync until its implemented
	end)

	for i, point in path do
		npcObject:MoveTo(point, i)
	end
end

networking.buildMaze:connect(function(maze)
	BuildMaze(maze)
end)

networking.startPath:connect(function(path)
	StartNPCWalk(path)
end)
