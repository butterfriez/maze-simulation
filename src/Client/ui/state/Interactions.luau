--!strict

local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local MOUSE_ICONS = {
	Cursor = "rbxassetid://7153417119",
	Pointer = "rbxassetid://7033235466",
}

local Plugin: Plugin? = nil
do -- Retrieve the plugin global for interactions in UI stories:
	local module = ReplicatedStorage.Packages:FindFirstChild("UILabs")
	if module then
		local UILabs = require(module)
		Plugin = UILabs.Environment.Plugin
	end
end

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local peek = Fusion.peek

local Interactions = {}

local scope = Fusion:scoped()
Interactions.__scope = scope

Interactions.Focused = scope:Value(nil :: GuiObject?)
scope:insert(GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(function()
	Interactions.Focused:set(GuiService.SelectedObject)
end))

Interactions.Hovered = scope:Value(nil :: GuiObject?)
scope:Observer(Interactions.Hovered):onBind(function()
	local hovering = peek(Interactions.Hovered) ~= nil
	if Plugin then
		Plugin:GetMouse().Icon = if hovering
			then "rbxasset://SystemCursors/PointingHand"
			else "rbxasset://SystemCursors/Arrow"
	else
		UserInputService.MouseIcon = if hovering then MOUSE_ICONS.Pointer else MOUSE_ICONS.Cursor
	end
end)

function Interactions.Activated(input: InputObject): boolean
	return input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch
		or input.KeyCode == Enum.KeyCode.ButtonA
end

return Interactions
