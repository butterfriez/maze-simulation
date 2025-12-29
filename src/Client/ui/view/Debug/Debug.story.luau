local ReplicatedStorage = game:GetService("ReplicatedStorage")

local fusion = require(ReplicatedStorage.Packages.fusion)
local labs = require(ReplicatedStorage.DevPackages:FindFirstChild("ui-labs"))

local PlayerState = require(ReplicatedStorage.state.atoms.PlayerState)

local DebugView = require(script.Parent)

local FAKE_DEBUG_STATES = PlayerState.DefaultPlayerState -- Use default player state to not hardcode values

return labs.CreateFusionStory({
    fusion = fusion,
}, function (props)
    DebugView(props.scope, {
        Parent = props.target,
        States = FAKE_DEBUG_STATES
    })
end)