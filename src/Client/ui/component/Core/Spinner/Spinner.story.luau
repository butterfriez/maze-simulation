--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local CreateStory = require(StarterPlayer.StarterPlayerScripts.ui.CreateStory)
local UILabs = require(ReplicatedStorage.Packages.UILabs)

local Sift = require(ReplicatedStorage.Packages.Sift)
local Dictionary = Sift.Dictionary

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children

type Fusion = typeof(Fusion)
type Scope<T = Fusion> = Fusion.Scope<T>

local Card = require(script.Parent.Parent.Card)
local Component = require(script.Parent)

local Types = script.Parent.Parent.Parent.Parent.types
local Shadow = require(Types.Shadow)

local STORY_CONTROLS = {
	Scale = UILabs.Slider(1, -1, 2),
}
type Controls = typeof(STORY_CONTROLS) & Shadow.Controls

return CreateStory(function(props)
	local scope = props.scope :: Scope
	local controls = props.controls :: Controls

	local scale = scope:Computed(function(use: any)
		return use(controls.Scale)
	end)

	Card(props.scope, {
		Size = UDim2.fromScale(0.15, 0.3),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),

		Corners = UDim.new(0.1),
		Parent = props.target,

		Scale = scale,

		[Children] = {
			Component(scope, {
				Parent = props.target,

				AnchorPoint = Vector2.one / 2,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(50, 50),
			}),
		},
	})

	return nil
end, Dictionary.join(STORY_CONTROLS))
