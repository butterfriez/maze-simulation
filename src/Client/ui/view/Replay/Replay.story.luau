local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UILabs = require(ReplicatedStorage.Packages.UILabs)

local Fusion = require(ReplicatedStorage.Packages.Fusion)

local Replay = require(script.Parent)

return UILabs.CreateFusionStory({
	fusion = Fusion,
}, function(props)
	Replay(props.scope, { Parent = props.target })
	return nil
end)
