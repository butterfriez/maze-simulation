--!strict

--[[
    Menu View
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children

type Fusion = typeof(Fusion)
type Scope<T = Fusion> = Fusion.Scope<T>
type UsedAs<T> = Fusion.UsedAs<T>
type StateObject<T> = Fusion.UsedAs<T>

local Component = script.Parent.Parent.component
local Button = require(Component.Button)
local Card = require(Component.Card)
local Text = require(Component.Text)

type Props = {
	Parent: UsedAs<Instance?>?,
}

return function(scope: Scope, props: Props): Instance
	scope = scope:innerScope({}) :: Scope

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
				Color = Color3.new(1, 0.262745, 0.423529),

				[Children] = {
					Button(scope, {
						AnchorPoint = Vector2.new(0.5, 0),
						Position = UDim2.fromScale(0.5, -0.25),
						Size = UDim2.fromScale(0.25, 1),

						Shadow = {
							Offset = UDim2.fromScale(0, -0.05),
							Color = Color3.new(0.760784, 0.2, 0.321569),
							Ratio = 1,
						},
						Texture = texure :: any,

						Corners = UDim.new(0.15),
						Color = Color3.new(1, 0.262745, 0.423529),

						[Children] = {
							scope:New "UIPadding" {
								PaddingTop = UDim.new(0.1),
								PaddingBottom = UDim.new(0.1),
							},
							Text(scope, {
								Size = UDim2.fromScale(1, 1),

								Text = "PLAY",
								TextScaled = true,
								Color = Color3.new(1, 1, 1),
								Font = Font.fromEnum(Enum.Font.BuilderSansExtraBold),

								Shadow = {
									Offset = UDim2.fromScale(0, -0.05),
									Color = Color3.new(0, 0, 0),
								},

								[Children] = scope:New "UIStroke" {
									ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
									StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize,

									Color = Color3.new(0, 0, 0),
									Thickness = 0.025,
								},
							}),
							scope:New "UIStroke" {
								ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
								StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize,
								BorderStrokePosition = Enum.BorderStrokePosition.Inner,

								Color = Color3.new(0.760784, 0.2, 0.321569),
								Thickness = 0.025,
							},
						},
					}),
				},
			}),
		},
	}
end
