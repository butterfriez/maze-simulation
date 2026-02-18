local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UILabs = require(ReplicatedStorage.Packages.UILabs)

local UI = script.Parent.Parent.Parent.Parent

local Story = require(UI.Story)
local Theme = require(UI.Theme)

local Component = require(script.Parent)

local STORY_CONTROLS = {
	Theme = Theme.Story.Control,
	Corners = UILabs.Slider(0.15, 0, 1),

	Pressed = false,
	Hovered = false,
}
type Controls = typeof(STORY_CONTROLS)

return Story.Build(function(props: Story.Props<Controls>)
	local scope = props.scope
	local controls = props.controls

	local corners = scope:Computed(function(use: any, scope: typeof(scope))
		return UDim.new(use(controls.Corners))
	end)

	Theme.Story.Apply(scope, controls.Theme, function(scope)
		Component(scope, {
			Parent = props.target,

			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(0.2, 0.2),

			Corners = corners,

			Pressed = controls.Pressed,
			Hovered = controls.Hovered,
		})
	end)
end, STORY_CONTROLS)
