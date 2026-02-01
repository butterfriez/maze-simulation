local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local SoundManager = require(ReplicatedStorage.libs.SoundManager)
local UILabs = require(ReplicatedStorage.Packages.UILabs)

local Menu = require(script.Parent)
local Theme = require(script.Parent.Parent.Parent.Theme)

return UILabs.CreateFusionStory({
	fusion = Fusion,
}, function(props)
	SoundManager.LoadSounds(ReplicatedStorage.assets.sounds)
	Menu(props.scope, {
		Parent = props.target,
	})
end)
