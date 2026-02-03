--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Sift = require(ReplicatedStorage.Packages.Sift)
local Dictionary = Sift.Dictionary

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children

type Fusion = typeof(Fusion)
type Scope<T = Fusion> = Fusion.Scope<T>
type UsedAs<T> = Fusion.UsedAs<T>

local Components = script.Parent.Parent
local Theme = require(Components.Parent.Theme)

local Types = Components.Parent.types
local Shadow = require(Types.Shadow)
type Shadow = Shadow.Shadow

local Button = require(Components.Core.Button)

type Props = Button.Props & {}

return function(scope: Scope, props: Props)
	scope = scope:innerScope() :: Scope
	local theme = Theme.Contextual:now()

	props.Color = props.Color or theme.Primary

	local shadow: Shadow = {
		Offset = UDim2.fromScale(0, -0.05),
		Color = theme.Shadow,
		Ratio = 1,
	}
	props.Shadow = if props.Shadow then Dictionary.join(props.Shadow, shadow) :: Shadow else shadow

	props[Children] = {
		scope:New "UIStroke" {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize,
			BorderStrokePosition = Enum.BorderStrokePosition.Inner,

			Color = theme.Shadow,
			Thickness = 0.025,
		},
		props[Children],
	}

	return Button(scope, props)
end
