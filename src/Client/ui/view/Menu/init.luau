--!strict

--[[
    Menu View
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = require(ReplicatedStorage.networking)

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent

type Fusion = typeof(Fusion)
type Scope<T = Fusion> = Fusion.Scope<T>
type UsedAs<T> = Fusion.UsedAs<T>
type StateObject<T> = Fusion.UsedAs<T>

type Props = {
	Parent: UsedAs<Instance?>?,
}

return function(scope: Scope, props: Props): Instance
	scope = scope:innerScope() :: Scope
	return scope:New("Frame")({
		Parent = props.Parent,

		AnchorPoint = Vector2.one / 2,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),

		BackgroundTransparency = 1,

		[Children] = {
			scope:New("TextButton")({
				AnchorPoint = Vector2.one / 2,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.1, 0.1),

				Text = "Start Game",

				[OnEvent("Activated")] = function()
					Remotes.startGame:fire()
				end,
			}),
		},
	})
end
