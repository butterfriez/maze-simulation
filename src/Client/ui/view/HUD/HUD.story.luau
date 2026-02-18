--!strict

local UI = script.Parent.Parent.Parent
local Story = require(UI.Story)

local View = require(script.Parent)

return Story.Build(function(props)
	View(props.scope, { Parent = props.target })
	return nil
end)
