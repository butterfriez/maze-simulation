--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UILabs = require(ReplicatedStorage.Packages.UILabs)

local Fusion = require(ReplicatedStorage.Packages.Fusion)
type Fusion = typeof(Fusion)
type Scope<T = Fusion> = Fusion.Scope<T>

local PlayerState = require(ReplicatedStorage.state.atoms.PlayerState)

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

local STORY_CONTROLS = {
	State = UILabs.EnumList({
		PlayerState = PlayerState.DefaultPlayerState,
		Preview = FAKE_DEBUG_STATES,
	}, "PlayerState"),
}
type Controls = typeof(STORY_CONTROLS)

return UILabs.CreateFusionStory({
	fusion = Fusion,
	controls = STORY_CONTROLS,
}, function(props)
	local scope = props.scope :: Scope
	local controls = props.controls :: Controls

	Debug(scope, {
		Parent = props.target,
		State = controls.State :: any,
	})
	return nil
end)
