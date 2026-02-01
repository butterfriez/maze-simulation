--!strict

--[[
    Menu View
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local networking = require(ReplicatedStorage.networking)
local Children = Fusion.Children

type Fusion = typeof(Fusion)
type Scope<T = Fusion> = Fusion.Scope<T>
type UsedAs<T> = Fusion.UsedAs<T>
type StateObject<T> = Fusion.UsedAs<T>

local Theme = require(script.Parent.Parent.Theme)

local Component = script.Parent.Parent.component
local Button = require(Component.Core.Button)
local Card = require(Component.Core.Card)
local Text = require(Component.Core.Text)

type Props = {
	Parent: UsedAs<Instance?>?,
}

return function(scope: Scope, props: Props): Instance
	scope = scope:innerScope({}) :: Scope

	local theme = Theme.Contextual:now()
	local texure = {
		Asset = "rbxassetid://17259633983",
		Transparency = 0.75,
		ScaleType = Enum.ScaleType.Tile,
		TileSize = UDim2.fromOffset(100, 100),
	}

	return scope:New "Frame" {
		Parent = props.Parent,

		AnchorPoint = Vector2.one / 2,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),

		BackgroundTransparency = 1,

		[Children] = {
			Card(scope, {
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.fromScale(0.5, 1),
				Size = UDim2.fromScale(1, 0.1),

				Texture = texure :: any,
				Color = theme.Primary,

				[Children] = {
					Button(scope, {
						AnchorPoint = Vector2.new(0.5, 0),
						Position = UDim2.fromScale(0.5, -0.25),
						Size = UDim2.fromScale(0.2, 1),

						Shadow = {
							Offset = UDim2.fromScale(0, -0.05),
							Color = theme.Shadow,
							Ratio = 1,
						},
						Texture = texure :: any,

						Corners = UDim.new(0.15),
						Color = theme.Primary,
						Activated = function()
							networking.startGame:fire()
						end,

						[Children] = {
							scope:New "UIPadding" {
								PaddingTop = UDim.new(0.1),
								PaddingBottom = UDim.new(0.1),
							},
							Text(scope, {
								Size = UDim2.fromScale(1, 1),

								Text = "PLAY",
								TextScaled = true,
								Color = theme.Text,
								Font = Font.fromEnum(Enum.Font.BuilderSansExtraBold),

								Shadow = {
									Offset = UDim2.fromScale(0, -0.05),
									Color = theme.Shadow,
									Ratio = 1,
								},

								[Children] = scope:New "UIStroke" {
									ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
									StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize,

									Color = theme.Shadow,
									Thickness = 0.025,
								},
							}),
							scope:New "UIStroke" {
								ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
								StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize,
								BorderStrokePosition = Enum.BorderStrokePosition.Inner,

								Color = theme.Shadow,
								Thickness = 0.025,
							},
						},
					}),
					scope:New "UIStroke" {
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize,
						BorderStrokePosition = Enum.BorderStrokePosition.Outer,

						Color = theme.Shadow,
						Thickness = 0.025,
					},
				},
			}),
		},
	}
end
