--!strict
--https://elttob.uk/Fusion/0.4/examples/cookbook/loading-spinner/
-- Services:
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Constants:
local SPIN_DEGREES_PER_SECOND = 180

-- Fusion | Definitions:
local Fusion = require(ReplicatedStorage.Packages.Fusion)

-- Fusion | Types:
type Fusion = typeof(Fusion)
type Scope<T = Fusion> = Fusion.Scope<T>
type UsedAs<T> = Fusion.UsedAs<T>
type Value<T> = Fusion.Value<T>
type Child = Fusion.Child

-- Interface Types:
local Types = script.Parent.Parent.Parent.types

local Roblox = require(Types.Roblox)
type Object = Roblox.GuiObject

-- Component | Types:
export type Props = Object & {}

return function(scope: Scope, props: Props): Instance
	scope = scope:innerScope()
	local currentTime = scope:Value(os.clock())

	table.insert(
		scope,
		RunService.PreRender:Connect(function()
			currentTime:set(os.clock())
		end)
	)

	return scope:New "ImageLabel" {
		Parent = props.Parent,

		ZIndex = props.ZIndex,
		LayoutOrder = props.LayoutOrder,

		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		Size = props.Size,

		Image = "rbxassetid://6675230773",
		BackgroundTransparency = 1,

		Rotation = scope:Computed(function(use)
			local time = use(currentTime)
			return (time * SPIN_DEGREES_PER_SECOND) % 360
		end),
	} :: Instance
end
