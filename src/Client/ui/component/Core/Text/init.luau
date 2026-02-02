--!strict

-- Services:
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Constants:
local DEFAULT_COLOR: Color3 = Color3.new()

-- Fusion | Definitions:
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children

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

local Shadow = require(Types.Shadow)
type Shadow = Shadow.Shadow

-- Component | Types:
type Props = Object & {
	__ref: Value<GuiObject>?,
	__interactable: boolean?,

	-- Static Properties:
	Shadow: Shadow?,

	-- Dynamic Properties:
	Text: UsedAs<string>?,
	TextScaled: UsedAs<boolean>?,
	Font: UsedAs<Font>?,
	Color: UsedAs<Color3>?,
	Transparency: UsedAs<number>?,
}

-- Component | Constructor:
return function(scope: Scope, props: Props)
	local classname = if props.__interactable then "TextBox" else "TextLabel"

	local children = props[Children]
	local color = props.Color or DEFAULT_COLOR
	local transparency = props.Transparency

	local shadow = props.Shadow
	if shadow then
		local position = Shadow.Position(scope, shadow, UDim2.fromScale(0.5, 0.5))
		children = scope:New(classname) {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = position,
			Size = UDim2.fromScale(1, 1),

			BackgroundTransparency = 1,

			Text = props.Text,
			TextScaled = props.TextScaled,
			TextColor3 = color,
			TextTransparency = transparency,

			FontFace = props.Font,

			[Children] = { props[Children] },
		}
		classname = "TextLabel" --> Ensure static text for the shadow
		color = Shadow.Color(scope, shadow, color)
		transparency = shadow.Transparency or transparency
	end

	local instance = scope:New(classname) {
		Parent = props.Parent,

		ZIndex = props.ZIndex,
		LayoutOrder = props.LayoutOrder,

		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		Size = props.Size,

		BackgroundTransparency = 1,

		Text = props.Text,
		TextScaled = props.TextScaled,
		TextColor3 = color,
		TextTransparency = transparency,

		FontFace = props.Font,

		[Children] = { children },
	}
	if props.__ref then
		local reference = if shadow then children else instance :: any --> Choose the reference
		props.__ref:set(reference)
	end

	return instance
end
