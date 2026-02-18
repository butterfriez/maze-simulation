--!strict
local UI = script.Parent.Parent.Parent.Parent

local Story = require(UI.Story)

local Shadow = require(UI.types.Shadow)
local Texture = require(UI.types.Texture)

local Component = require(script.Parent)

type Control<T> = { ControlValue: T }

-- Construct overwritten controls:
local TEXTURE_CONTROLS = Texture.Story.Construct(function(controls)
	controls.Asset = "rbxassetid://13060262529"
	local scaleType = controls.ScaleType :: Control<Enum.ScaleType>
	scaleType.ControlValue = Enum.ScaleType.Fit
end)
local SHADOW_CONTROLS = Shadow.Story.Construct(function(controls)
	local offset_x = controls["Offset (X)"] :: Control<number>
	offset_x.ControlValue = 0
	local offset_y = controls["Offset (Y)"] :: Control<number>
	offset_y.ControlValue = -5
end)

local STORY_CONTROLS = {
	Toggled = false,
	Text = "HOME",
	Color = Color3.new(1, 1, 1),
}
type Controls = & typeof(STORY_CONTROLS) & typeof(Shadow.Story.Controls) & typeof(Texture.Story.Controls)

return Story.Build(function(props: Story.Props<Controls>)
	local scope = props.scope
	local controls = props.controls

	local texture = Texture.Story.Properties(scope, controls)
	texture.Color = controls.Color

	local shadow = Shadow.Story.Properties(scope, controls)

	Component(scope, {
		Parent = props.target,

		AnchorPoint = Vector2.one / 2,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(0.3, 0.2),

		Icon = texture,
		Toggle = controls.Toggled :: any,

		Text = controls.Text,
		TextScaled = true,
		Color = controls.Color,
		Shadow = shadow,
	})

	return nil
end, Story.Controls(SHADOW_CONTROLS, TEXTURE_CONTROLS, STORY_CONTROLS))
