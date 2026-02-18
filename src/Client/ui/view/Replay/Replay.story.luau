--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CONSTANTS = require(ReplicatedStorage.core.CONSTANTS)

local UI = script.Parent.Parent.Parent
local Story = require(UI.Story)
local Theme = require(UI.Theme)

local View = require(script.Parent)

local STORY_CONTROLS = {
	Theme = Theme.Story.Control,
}
type Controls = typeof(STORY_CONTROLS)

return Story.Build(function(props: Story.Props<Controls>)
	local scope = props.scope
	local controls = props.controls

	Theme.Story.Apply(scope, controls.Theme :: any, function(scope)
		View(scope, { Parent = props.target, Player = CONSTANTS.USER_NAME })
	end)

	return nil
end, Story.Controls(STORY_CONTROLS))
