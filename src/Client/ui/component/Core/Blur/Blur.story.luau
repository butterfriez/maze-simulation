local CreateStory = require(script.Parent.Parent.Parent.Parent.CreateStory)

local Component = require(script.Parent)

return CreateStory(function(props)
	Component(props.scope, { Parent = props.target })
end)
