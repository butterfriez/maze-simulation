local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UILabs = require(ReplicatedStorage.Packages.UILabs)

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children

type Fusion = typeof(Fusion)
type Scope<T = Fusion> = Fusion.Scope<T>

local Component = require(script.Parent)

local STORY_CONTROLS = {
	Corners = UILabs.Slider(0.15, 0, 1),
}
type Controls = typeof(STORY_CONTROLS)

return UILabs.CreateFusionStory({
	fusion = Fusion,
	controls = STORY_CONTROLS,
}, function(props)
	local scope = props.scope :: Scope
	local controls = props.controls :: Controls

	local corners = scope:Computed(function(use: any, scope: Scope)
		return UDim.new(use(controls.Corners))
	end)

	Component(scope, {
		Parent = props.target,

		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(0.2, 0.2),

		Corners = corners,
	})
end)
