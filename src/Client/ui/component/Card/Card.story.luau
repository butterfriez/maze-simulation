--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UILabs = require(ReplicatedStorage.Packages.UILabs)

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children

type Fusion = typeof(Fusion)
type Scope<T = Fusion> = Fusion.Scope<T>

local Component = require(script.Parent)

local STORY_CONTROLS = {
	-- Shadow Properties:
	["Shadow: Offset (X)"] = UILabs.Slider(-5, -100, 100),
	["Shadow: Offset (Y)"] = UILabs.Slider(-5, -100, 100),
	["Shadow: Ratio"] = UILabs.Slider(0.5, 0, 1),

	Corners = UILabs.Slider(0, 0, 1),
	Color = Color3.new(1, 1, 1),
}
type Controls = typeof(STORY_CONTROLS)

return UILabs.CreateFusionStory({
	fusion = Fusion,
	controls = STORY_CONTROLS,
}, function(props)
	local scope = props.scope :: Scope
	local controls = props.controls :: Controls

	local offset = scope:Computed(function(use: any)
		return UDim2.fromOffset(use(controls["Shadow: Offset (X)"]), use(controls["Shadow: Offset (Y)"]))
	end)
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
				FillDirection = Enum.FillDirection.Horizontal,
				FillDirectionMaxCells = 2,

				CellSize = UDim2.fromScale(0.45, 0.5),
				CellPadding = UDim2.fromScale(0.1, 0.1),
			},

			Component(props.scope, {
				Parent = props.target,

				Color = controls.Color,
				Shadow = { Offset = offset, Ratio = controls["Shadow: Ratio"] :: any },
				Corners = corners,

				[Children] = scope:New "TextLabel" {
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					Text = "INTERACTABLE = DISABLED\nSHADOW = ENABLED",
				},
			}),
			Component(props.scope, {
				Parent = props.target,

				Color = controls.Color,
				Corners = corners,

				[Children] = scope:New "TextLabel" {
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					Text = "INTERACTABLE = DISABLED\nSHADOW = DISABLED",
				},
			}),
			Component(props.scope, {
				__iteractable = true,
				Parent = props.target,

				Color = controls.Color,
				Shadow = { Offset = offset, Ratio = controls["Shadow: Ratio"] :: any },
				Corners = corners,

				[Children] = scope:New "TextLabel" {
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					Text = "INTERACTABLE = ENABLED\nSHADOW = ENABLED",
				},
			}),
			Component(props.scope, {
				__iteractable = true,
				Parent = props.target,

				Color = controls.Color,
				Corners = corners,

				[Children] = scope:New "TextLabel" {
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					Text = "INTERACTABLE = ENABLED\nSHADOW = DISABLED",
				},
			}),
		},
	}

	return nil
end)
