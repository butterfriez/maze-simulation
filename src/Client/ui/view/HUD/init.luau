--!strict

--[[
    HUD View
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local fusion = require(ReplicatedStorage.Packages.fusion)
local Children = fusion.Children

type Fusion = typeof(fusion)
type Scope<T> = fusion.Scope<T>
type UsedAs<T> = fusion.UsedAs<T>

type Props = {
    Parent: UsedAs<Instance?>?,
    States: UsedAs<{[string]: any}>
}

return function (scope: Scope<Fusion>, props: Props)
    scope = scope:innerScope()
    return scope:New "ScreenGui" {
        Name = "HUD [View]",
        Parent = props.Parent
    }
end