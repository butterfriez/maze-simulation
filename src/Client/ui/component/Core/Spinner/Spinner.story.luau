--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UILabs = require(ReplicatedStorage.Packages.UILabs)

local UI = script.Parent.Parent.Parent.Parent

local Story = require(UI.Story)

local Card = require(UI.component.Core.Card)
local Component = require(script.Parent)

local STORY_CONTROLS = {
	Scale = UILabs.Slider(1, -1, 2),
	Color = Color3.new(0.12549, 0.678431, 1),
}
type Controls = typeof(STORY_CONTROLS)

return Story.Build(function(props: Story.Props<Controls>)
	local scope = props.scope
	local controls = props.controls

	local Children = scope.Children

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
end, Story.Controls(STORY_CONTROLS))
