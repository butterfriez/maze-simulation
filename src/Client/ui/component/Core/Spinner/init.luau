--!strict
--https://elttob.uk/Fusion/0.4/examples/cookbook/loading-spinner/
-- Services:
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Constants:
local DEFAULT_IMAGE: string = "rbxassetid://6021874488"
local SPIN_DEGREES_PER_SECOND: number = -180

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

local Theme = require(Types.Parent.Theme)

-- Component | Types:
export type Props = Object & {
	Color: UsedAs<Color3>?,
}

return function(scope: Scope, props: Props): GuiObject
	scope = scope:innerScope() :: Scope
	local theme = Theme.Contextual:now()

	local instance = scope:New "ImageLabel" {
		Parent = props.Parent,

		ZIndex = props.ZIndex,
		LayoutOrder = props.LayoutOrder,

		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		Size = props.Size,

		Image = DEFAULT_IMAGE,
		ImageColor3 = props.Color or theme.Accent,
		BackgroundTransparency = 1,
	} :: GuiObject

	scope:insert(RunService.PreRender:Connect(function()
		instance.Rotation = (os.clock() * SPIN_DEGREES_PER_SECOND) % 360
	end))

	return instance
end
