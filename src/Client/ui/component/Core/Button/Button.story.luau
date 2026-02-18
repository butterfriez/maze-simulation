--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UI = script.Parent.Parent.Parent.Parent
local UILabs = require(ReplicatedStorage.Packages.UILabs)

local Shadow = require(UI.types.Shadow)
local Story = require(UI.Story)

local Component = require(script.Parent)

local STORY_CONTROLS = {
	Color = Color3.new(1, 1, 1),
	Corners = UILabs.Slider(0.05, 0, 1),
}
type Controls = typeof(STORY_CONTROLS) & typeof(Shadow.Story.Controls)

return Story.Build(function(props: Story.Props<Controls>)
	local scope = props.scope
	local controls = props.controls

	local Children = scope.Children

	local shadow = Shadow.Story.Properties(scope, controls)

	local corners = scope:Computed(function(use: any, scope: typeof(scope))
		return UDim.new(use(controls.Corners))
	end)
	local function onActivate()
		print("Pressed!")
	end

	scope:New "Frame" {
		Parent = props.target,

		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,

		[Children] = {
			scope:New "UIGridLayout" {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				CellSize = UDim2.fromScale(0.2, 0.2),
				CellPadding = UDim2.fromScale(0.05, 0.05),
			},
			Component(scope, {
				LayoutOrder = 1,

				Color = controls.Color,
				Shadow = shadow,
				Corners = corners,

				Activated = onActivate,

				[Children] = {
					scope:New "TextLabel" {
						Size = UDim2.fromScale(1, 1),

						BackgroundTransparency = 1,

						Text = "SHADOW = ENABLED",
						TextScaled = true,

						[Children] = {
							scope:New "UIPadding" {
								PaddingTop = UDim.new(0.25),
								PaddingBottom = UDim.new(0.25),
								PaddingLeft = UDim.new(0.1),
								PaddingRight = UDim.new(0.1),
							},
						},
					},
				},
			}),
			Component(scope, {
				LayoutOrder = 2,

				Color = controls.Color,
				Corners = corners,

				Activated = onActivate,

				[Children] = {
					scope:New "TextLabel" {
						Size = UDim2.fromScale(1, 1),

						BackgroundTransparency = 1,

						Text = "SHADOW = DISABLED",
						TextScaled = true,

						[Children] = {
							scope:New "UIPadding" {
								PaddingTop = UDim.new(0.25),
								PaddingBottom = UDim.new(0.25),
								PaddingLeft = UDim.new(0.1),
								PaddingRight = UDim.new(0.1),
							},
						},
					},
				},
			}),
		},
	}

	return nil
end, Story.Controls(Shadow.Story.Controls, STORY_CONTROLS))
