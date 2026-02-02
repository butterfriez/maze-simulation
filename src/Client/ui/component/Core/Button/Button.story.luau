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

local Component = require(script.Parent)

local Types = script.Parent.Parent.Parent.Parent.types
local Shadow = require(Types.Shadow)

local STORY_CONTROLS = {
	Color = Color3.new(1, 1, 1),
	Corners = UILabs.Slider(0.05, 0, 1),
}
type Controls = typeof(STORY_CONTROLS) & Shadow.Controls

return UILabs.CreateFusionStory({
	fusion = Fusion,
	controls = Dictionary.join(Shadow.Story.Controls, STORY_CONTROLS) :: any,
}, function(props)
	SoundManager.LoadSounds(ReplicatedStorage.assets.sounds :: Folder)

	local scope = props.scope :: Scope
	local controls = props.controls :: Controls

	local shadow = Shadow.Story.Properties(scope, controls)
	local corners = scope:Computed(function(use: any)
		return UDim.new(use(controls.Corners))
	end)

	Component(scope, {
		Parent = props.target,

		AnchorPoint = Vector2.one / 2,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(0.25, 0.25),

		Color = controls.Color,
		Shadow = shadow,
		Activated = function(instance)
			print("Pressed!")
		end,
		Corners = corners,

		[Children] = {
			scope:New "TextLabel" {
				Size = UDim2.fromScale(1, 1),

				BackgroundTransparency = 1,

				Text = "Press Me!",
				TextScaled = true,

				[Children] = {
					scope:New "UIPadding" {
						PaddingTop = UDim.new(0.25),
						PaddingBottom = UDim.new(0.25),
						PaddingLeft = UDim.new(0.1),
						PaddingRight = UDim.new(0.1),
					},
				},
			},
		},
	})

	return nil
end, STORY_CONTROLS)
