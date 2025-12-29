local ReplicatedStorage = game:GetService("ReplicatedStorage")

local fusion = require(ReplicatedStorage.Packages.fusion)
local labs = require(ReplicatedStorage.DevPackages:FindFirstChild("ui-labs"))

local HUDView = require(script.Parent)

return labs.CreateFusionStory({
    fusion = fusion,
}, function (props)
    HUDView(props.scope, {
        Parent = props.target
    })
end)