--!strict

--[[

]]

-- Services:
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Constants:
local DEFAULT_COLOR: Color3 = Color3.new(1, 1, 1) --> TODO: Pull from theme?

-- Fusion | Definitons:
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children

-- Fusion | Types:
type Fusion = typeof(Fusion)
type Scope<T = Fusion> = Fusion.Scope<T>
type UsedAs<T> = Fusion.UsedAs<T>
type Child = Fusion.Child
type Value<T> = Fusion.Value<T>

-- Interface Types:
local Types = script.Parent.Parent.types

local Roblox = require(Types.Roblox)
type Object = Roblox.GuiObject

local Shadow = require(Types.Shadow)
type Shadow = Shadow.Shadow

local Texture = require(Types.Texture)
type Texture = Texture.Texture

-- Helper Components:
local function Corners(scope: Scope, size: UsedAs<UDim>?): UICorner?
	if not size then return nil end
	return scope:New "UICorner" {
		CornerRadius = size,
	} :: UICorner
end

-- Component | Types:
export type Props = Object & {
	__ref: Value<GuiObject?>?,

	-- Custom | Static Properties:
	Shadow: Shadow?,
	Texture: Texture?,

	-- Custom | Dynamic Properties:
	Corners: UsedAs<UDim>?,
	Color: UsedAs<Color3>?,
	Transparency: UsedAs<number>?,
}

-- Component | Constructor:
return function(scope: Scope, props: Props)
	scope = scope:innerScope() :: Scope

	local children = props[Children]
	local color: UsedAs<Color3> = props.Color or DEFAULT_COLOR
	local transparency = props.Transparency

	local texture, classname = Texture.Resolve(props.Texture)

	local shadow = props.Shadow
	if shadow then
		local position = Shadow.Position(scope, shadow, UDim2.fromScale(0.5, 0.5))
		children = scope:New(classname)(Texture.Apply(texture, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = position,
			Size = UDim2.fromScale(1, 1),

			BackgroundTransparency = transparency,
			BackgroundColor3 = color,

			[Children] = { props[Children], Corners(scope, props.Corners) },
		}) :: any)

		-- Overwrite values for shadow:
		color = Shadow.Color(scope, shadow, color)
		transparency = shadow.Transparency or transparency
		classname = "Frame"
		texture = Texture.Empty
	end

	local instance = scope:New(classname)(Texture.Apply(texture, {
		Parent = props.Parent,

		ZIndex = props.ZIndex,
		LayoutOrder = props.LayoutOrder,

		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		Size = props.Size,

		BackgroundTransparency = transparency,
		BackgroundColor3 = color,

		[Children] = { children, Corners(scope, props.Corners) },
	}) :: any)

	-- Populate external reference:
	if props.__ref then
		local reference = if shadow then children :: Instance else instance
		props.__ref:set(reference :: GuiObject)
	end

	return instance
end
