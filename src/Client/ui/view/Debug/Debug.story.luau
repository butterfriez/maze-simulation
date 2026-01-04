local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local UILabs = require(ReplicatedStorage.Packages.UILabs)

local Debug = require(script.Parent)

local FAKE_DEBUG_STATES: { [string]: unknown }
do
	local cyclic = {}
	cyclic.self = cyclic

	FAKE_DEBUG_STATES = {
		coins = 0,
		name = "Roblox",
		module = cyclic,
		set = {
			A = true,
			B = true,
			C = false,
		},
		array = { { value = BrickColor.Red() }, { value = BrickColor.Yellow() }, { value = BrickColor.Blue() } },
	}
end

return UILabs.CreateFusionStory({
	fusion = Fusion,
}, function(props)
	Debug(props.scope, {
		Parent = props.target,
		State = FAKE_DEBUG_STATES,
	})
end)
