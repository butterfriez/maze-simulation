local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local UILabs = require(ReplicatedStorage.Packages.UILabs)

local HUDView = require(script.Parent)

return UILabs.CreateFusionStory({
	fusion = Fusion,
}, function(props)
	HUDView(props.scope, {
		Parent = props.target,
	})
end)
