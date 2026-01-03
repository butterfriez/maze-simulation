-- https://devforum.roblox.com/t/how-to-make-an-easy-freecam-script-mobile-support/1972016

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Charm = require(ReplicatedStorage.Packages.Charm)
local PlayerState = require(ReplicatedStorage.state.atoms.PlayerState)

local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local OnMobile = not UserInputService.KeyboardEnabled

local Speed = 5
local Sensitivity = 0.3
local Rotating = false

local KeysDown = {}

Speed /= 10
if OnMobile then
	Sensitivity *= 2
end

local ValidKeys = { "Enum.KeyCode.W", "Enum.KeyCode.A", "Enum.KeyCode.S", "Enum.KeyCode.D" }

UserInputService.InputBegan:Connect(function(Input)
	for i, key in ValidKeys do
		if key == tostring(Input.KeyCode) then
			KeysDown[key] = true
		end
	end

	if
		Input.UserInputType == Enum.UserInputType.MouseButton2
		or (
			Input.UserInputType == Enum.UserInputType.Touch
			and UserInputService:GetMouseLocation().X > (Camera.ViewportSize.X / 2)
		)
	then
		Rotating = true
	end
end)

UserInputService.InputEnded:Connect(function(Input)
	for key, v in KeysDown do
		if key == tostring(Input.KeyCode) then
			KeysDown[key] = false
		end
	end
	if
		Input.UserInputType == Enum.UserInputType.MouseButton2
		or (
			Input.UserInputType == Enum.UserInputType.Touch
			and UserInputService:GetMouseLocation().X > (Camera.ViewportSize.X / 2)
		)
	then
		Rotating = false
	end
end)

local function StartFreeCam() -- im ngl i suck at math - butter
	Camera.CameraType = Enum.CameraType.Scriptable
	RunService:BindToRenderStep("Freecam", 1, function()
		if Rotating then
			local delta = UserInputService:GetMouseDelta()
			local cf = Camera.CFrame

			local deltaY = delta.Y
			local yAngle = cf:ToEulerAngles(Enum.RotationOrder.YZX)

			local newAmount = math.deg(yAngle) + deltaY

			if newAmount > 65 or newAmount < -65 then
				if not (yAngle < 0 and delta.Y < 0) and not (yAngle > 0 and delta.Y > 0) then
					delta = Vector2.new(delta.X, 0)
				end
			end

			cf *= CFrame.Angles(-math.rad(deltaY), 0, 0)
			cf = CFrame.Angles(0, -math.rad(delta.X), 0) * (cf - cf.Position) + cf.Position
			cf = CFrame.lookAt(cf.Position, cf.Position + cf.lookVector)
			if delta ~= Vector2.zero then
				Camera.CFrame = Camera.CFrame:lerp(cf, Sensitivity)
			end
			UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
		else
			UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		end

		if KeysDown["Enum.KeyCode.W"] then
			Camera.CFrame *= CFrame.new(Vector3.new(0, 0, -Speed))
		end

		if KeysDown["Enum.KeyCode.A"] then
			Camera.CFrame *= CFrame.new(Vector3.new(-Speed, 0, 0))
		end

		if KeysDown["Enum.KeyCode.S"] then
			Camera.CFrame *= CFrame.new(Vector3.new(0, 0, Speed))
		end

		if KeysDown["Enum.KeyCode.D"] then
			Camera.CFrame *= CFrame.new(Vector3.new(Speed, 0, 0))
		end
	end)
end

Charm.subscribe(function()
	local state = PlayerState.GetPlayerState(Player.Name)
	if state then
		return state.gameState
	else
		return nil
	end
end, function(state)
	if state == nil then
		return
	end

	if state == "INGAME" then
		StartFreeCam()
	else
		RunService:UnbindFromRenderStep("Freecam")
		Camera.CameraType = Enum.CameraType.Custom
	end
end)
