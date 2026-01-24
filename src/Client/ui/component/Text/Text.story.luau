--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UILabs = require(ReplicatedStorage.Packages.UILabs)

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children

type Fusion = typeof(Fusion)
type Scope<T = Fusion> = Fusion.Scope

local Component = require(script.Parent)
local Shadow = require(script.Parent.Parent.Parent.types.Shadow)

local STORY_CONTROLS = Shadow.Story.Controls {
	-- Text Controls:
	Text = "Hello World!",
	TextScaled = true,
	Font = UILabs.EnumList({
		BuilderSans = Font.fromEnum(Enum.Font.BuilderSans),
		Cartoon = Font.fromEnum(Enum.Font.Cartoon),
	}, "BuilderSans"),
	Color = Color3.new(1, 1, 1),
	Transparency = UILabs.Slider(0, 0, 1),

	-- Shadow Controls:
	["Shadow: Offset (X)"] = UILabs.Slider(-2.5, -100, 100),
	["Shadow: Offset (Y)"] = UILabs.Slider(-2.5, -100, 100),
	["Shadow: Ratio"] = UILabs.Slider(0.5, 0, 1),
	["Shadow: Transparency"] = UILabs.Slider(0, 0, 1),
}
type Controls = typeof(STORY_CONTROLS)

return UILabs.CreateFusionStory({
	fusion = Fusion,
	controls = STORY_CONTROLS,
}, function(props)
	local scope = props.scope :: Scope
	local controls = props.controls :: Controls

	local shadow = Shadow.Story.Properties(scope, controls)

	scope:New "Frame" {
		Parent = props.target,

		AnchorPoint = Vector2.one / 2,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(0.5, 0.5),

		BackgroundTransparency = 1,

		[Children] = {
			scope:New "UIGridLayout" {
				FillDirection = Enum.FillDirection.Horizontal,
				FillDirectionMaxCells = 2,

				CellSize = UDim2.fromScale(0.45, 0.5),
				CellPadding = UDim2.fromScale(0.1, 0.1),
			},

			Component(scope, {
				Parent = props.target,

				AnchorPoint = Vector2.one / 2,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.25, 0.25),

				Shadow = shadow,

				Text = controls.Text,
				TextScaled = controls.TextScaled,
				Font = controls.Font :: any,
				Color = controls.Color,
				Transparency = controls.Transparency :: any,
			}),
			Component(scope, {
				Parent = props.target,

				AnchorPoint = Vector2.one / 2,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.25, 0.25),

				Text = controls.Text,
				TextScaled = controls.TextScaled,
				Font = controls.Font :: any,
				Color = controls.Color,
				Transparency = controls.Transparency :: any,
			}),
		},
	}

	return nil
end)
