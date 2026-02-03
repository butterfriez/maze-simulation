--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UILabs = require(ReplicatedStorage.Packages.UILabs)

local CONSTANTS = require(ReplicatedStorage.core.CONSTANTS)
local Fusion = require(ReplicatedStorage.Packages.Fusion)

local Replay = require(script.Parent)

return UILabs.CreateFusionStory({
	fusion = Fusion,
}, function(props)
	Replay(props.scope, { Parent = props.target, Player = CONSTANTS.USER_NAME })
	return nil
end)
