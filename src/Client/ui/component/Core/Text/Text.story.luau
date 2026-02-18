--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UILabs = require(ReplicatedStorage.Packages.UILabs)

local UI = script.Parent.Parent.Parent.Parent

local Story = require(UI.Story)

local Shadow = require(UI.types.Shadow)

local Component = require(script.Parent)

local STORY_CONTROLS = {
	-- Text Controls:
	Text = "Hello World!",
	TextScaled = true,
	Font = UILabs.EnumList({
		BuilderSans = Font.fromEnum(Enum.Font.BuilderSans),
		Cartoon = Font.fromEnum(Enum.Font.Cartoon),
		Merriweather = Font.fromEnum(Enum.Font.Merriweather),
		LuckiestGuy = Font.fromEnum(Enum.Font.LuckiestGuy),
		FredokaOne = Font.fromEnum(Enum.Font.FredokaOne),
		Bangers = Font.fromEnum(Enum.Font.Bangers),
		Arcade = Font.fromEnum(Enum.Font.Arcade),
	}, "BuilderSans"),
	Color = Color3.new(1, 1, 1),
	Transparency = UILabs.Slider(0, 0, 1),
}
type Controls = typeof(STORY_CONTROLS) & typeof(Shadow.Story.Controls)

return Story.Build(function(props: Story.Props<Controls>)
	local scope = props.scope
	local controls = props.controls

	local Children = scope.Children

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
end, Story.Controls(Shadow.Story.Controls, STORY_CONTROLS))
