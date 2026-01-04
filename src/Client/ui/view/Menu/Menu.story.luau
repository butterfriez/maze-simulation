local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local UILabs = require(ReplicatedStorage.Packages.UILabs)

local Menu = require(script.Parent)

return UILabs.CreateFusionStory({
	fusion = Fusion,
}, function(props)
	Menu(props.scope, {
		Parent = props.target,
	})
end)
