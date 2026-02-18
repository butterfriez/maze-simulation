--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UI = script.Parent.Parent.Parent.Parent

local UILabs = require(ReplicatedStorage.Packages.UILabs)

local Story = require(UI.Story)

local Shadow = require(UI.types.Shadow)
local Texture = require(UI.types.Texture)

local Component = require(script.Parent)

local STORY_CONTROLS = {
	Corners = UILabs.Slider(0, 0, 1),
	Color = Color3.new(1, 1, 1),
	Transparency = UILabs.Slider(0, 0, 1),
	Scale = UILabs.Slider(1, -1, 2),
}
type Controls = typeof(STORY_CONTROLS) & typeof(Shadow.Story.Controls) & typeof(Texture.Story.Controls)

return Story.Build(function(props: Story.Props<Controls>)
	local scope = props.scope
	local controls = props.controls

	local Children = scope.Children

	local shadow = Shadow.Story.Properties(scope, controls)
	local texture = Texture.Story.Properties(scope, controls)
	local corners = scope:Computed(function(use: any, scope: typeof(scope))
		return UDim.new(use(controls.Corners))
	end)
	local scale = scope:Computed(function(use: any)
		return use(controls.Scale)
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
				Scale = scale :: any,

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
				Scale = scale :: any,

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
				Scale = scale :: any,

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
				Scale = scale :: any,

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
end, Story.Controls(Shadow.Story.Controls, Texture.Story.Controls, STORY_CONTROLS))
