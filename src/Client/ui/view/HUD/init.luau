--!strict

--[[
    HUD View
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children

type Fusion = typeof(Fusion)
type Scope<T = Fusion> = Fusion.Scope<T>
type UsedAs<T> = Fusion.UsedAs<T>

local Theme = require(script.Parent.Parent.Theme)

local Component = script.Parent.Parent.component

type Props = {
	Parent: UsedAs<Instance?>?,
}

return function(scope: Scope<Fusion>, props: Props)
	scope = scope:innerScope() :: Scope
	local theme = Theme.Contextual:now()

	return scope:New "Frame" {
		Name = "HUD [View]",
		Parent = props.Parent,

		Active = false,

		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),

		BackgroundTransparency = 1,

		[Children] = {
			scope:New "UIPadding" {
				PaddingTop = UDim.new(0, 20),
				PaddingBottom = UDim.new(0, 20),
				PaddingLeft = UDim.new(0, 20),
				PaddingRight = UDim.new(0, 20),
			},
		},
	}
end
