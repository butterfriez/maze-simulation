--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UILabs = require(ReplicatedStorage.Packages.UILabs)

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children

type Fusion = typeof(Fusion)
type Scope<T = Fusion> = Fusion.Scope<T>

local Component = require(script.Parent)

local Types = script.Parent.Parent.Parent.Parent.types
local Shadow = require(Types.Shadow)
local Texture = require(Types.Texture)

local STORY_CONTROLS = Shadow.Story.Controls(Texture.Story.Controls({
	Corners = UILabs.Slider(0, 0, 1),
	Color = Color3.new(1, 1, 1),
	Transparency = UILabs.Slider(0, 0, 1),
}))
type Controls = typeof(STORY_CONTROLS)

return UILabs.CreateFusionStory({
	fusion = Fusion,
	controls = STORY_CONTROLS,
}, function(props)
	local scope = props.scope :: Scope
	local controls = props.controls :: Controls

	local shadow = Shadow.Story.Properties(scope, controls)
	local texture = Texture.Story.Properties(scope, controls)
	local corners = scope:Computed(function(use: any)
		return UDim.new(use(controls.Corners))
	end)

	scope:New "Frame" {
		Parent = props.target,

		AnchorPoint = Vector2.one / 2,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(0.5, 0.5),

		BackgroundTransparency = 1,

		[Children] = {
			scope:New "UIGridLayout" {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				FillDirectionMaxCells = 2,

				CellSize = UDim2.fromScale(0.45, 0.5),
				CellPadding = UDim2.fromScale(0.1, 0.1),
			},

			Component(props.scope, {
				Parent = props.target,
				LayoutOrder = 1,

				Color = controls.Color,
				Transparency = controls.Transparency :: any,

				Shadow = shadow,
				Texture = texture,
				Corners = corners,

				[Children] = scope:New "TextLabel" {
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					Text = "SHADOW = ENABLED\nTEXTURE = ENABLED",
				},
			}),
			Component(props.scope, {
				Parent = props.target,
				LayoutOrder = 2,

				Color = controls.Color,
				Transparency = controls.Transparency :: any,

				Texture = texture,
				Corners = corners,

				[Children] = scope:New "TextLabel" {
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					Text = "SHADOW = DISABLED\nTEXTURE = ENABLED",
				},
			}),
			Component(props.scope, {
				Parent = props.target,
				LayoutOrder = 3,

				Color = controls.Color,
				Transparency = controls.Transparency :: any,

				Shadow = shadow,
				Corners = corners,

				[Children] = scope:New "TextLabel" {
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					Text = "SHADOW = ENABLED\nTEXTURE = DISABLED",
				},
			}),
			Component(props.scope, {
				Parent = props.target,
				LayoutOrder = 4,

				Color = controls.Color,
				Transparency = controls.Transparency :: any,

				Corners = corners,

				[Children] = scope:New "TextLabel" {
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					Text = "SHADOW = DISABLED\nTEXTURE = DISABLED",
				},
			}),
		},
	}

	return nil
end)
