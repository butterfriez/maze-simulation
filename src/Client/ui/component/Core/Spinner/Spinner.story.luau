--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UILabs = require(ReplicatedStorage.Packages.UILabs)

local Sift = require(ReplicatedStorage.Packages.Sift)
local Dictionary = Sift.Dictionary

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children

type Fusion = typeof(Fusion)
type Scope<T = Fusion> = Fusion.Scope<T>

local Card = require(script.Parent.Parent.Card)
local Component = require(script.Parent)

local STORY_CONTROLS = {
	Scale = UILabs.Slider(1, -1, 2),
	Color = Color3.new(0.12549, 0.678431, 1),
}
type Controls = typeof(STORY_CONTROLS)

return UILabs.CreateFusionStory({
	fusion = Fusion,
	controls = STORY_CONTROLS,
}, function(props)
	local scope = props.scope :: Scope
	local controls = props.controls :: Controls

	local scale = scope:Computed(function(use: any)
		return use(controls.Scale)
	end)

	Card(props.scope, {
		Parent = props.target,

		Size = UDim2.fromScale(0.15, 0.3),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),

		Corners = UDim.new(0.1),
		Scale = scale :: any,

		[Children] = {
			Component(scope, {
				Parent = props.target,

				AnchorPoint = Vector2.one / 2,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(50, 50),

				Color = controls.Color,
			}),
		},
	})

	return nil
end)
