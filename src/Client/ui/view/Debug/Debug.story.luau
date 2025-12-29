local ReplicatedStorage = game:GetService("ReplicatedStorage")

local fusion = require(ReplicatedStorage.Packages.fusion)
local labs = require(ReplicatedStorage.DevPackages:FindFirstChild("ui-labs"))

local DebugView = require(script.Parent)

local FAKE_DEBUG_STATES = {
    coins = 0,
    algorithms = {
        maze = "Recursive Backtracker",
        solver = "Wall Follower",
    },
    ingame = false,
}

return labs.CreateFusionStory({
    fusion = fusion,
}, function (props)
    DebugView(props.scope, {
        Parent = props.target,
        States = FAKE_DEBUG_STATES
    })
end)