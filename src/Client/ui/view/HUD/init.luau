--!strict

--[[
    HUD View
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children

type Fusion = typeof(Fusion)
type Scope<T> = Fusion.Scope<T>
type UsedAs<T> = Fusion.UsedAs<T>

type Props = {
	Parent: UsedAs<Instance?>?,
}

return function(scope: Scope<Fusion>, props: Props)
	scope = scope:innerScope()
	return scope:New("ScreenGui")({
		Name = "HUD [View]",
		Parent = props.Parent,
	})
end
