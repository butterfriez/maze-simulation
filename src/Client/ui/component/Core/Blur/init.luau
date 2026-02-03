--!strict

-- Services:
local AssetService = game:GetService("AssetService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- References:
local QuickBlur = require(script.QuickBlur)

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
	local image = AssetService:CreateEditableImage({ Size = Vector2.new(256, 256) })
	QuickBlur:Blur(image)

	return scope:New "ImageLabel" {
		Parent = props.Parent,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),

		BackgroundTransparency = 0.3,
		BackgroundColor3 = Color3.fromRGB(55, 55, 55),

		ImageContent = Content.fromObject(image),
	}
end
