--!strict

--[[
    Replay View
]]

local AssetService = game:GetService("AssetService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local Hooks = script.Parent.Parent.hooks

local BaseGenerator = require(ReplicatedStorage.maze.Generation.BaseGenerator)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local MazeConfig = require(ReplicatedStorage.core.MazeConfig)
local PlayerState = require(ReplicatedStorage.state.atoms.PlayerState)
local Spinner = require(StarterPlayer.StarterPlayerScripts.ui.component.Core.Spinner)
local networking = require(ReplicatedStorage.networking)
local types = require(ReplicatedStorage.maze.types)
local Children = Fusion.Children

type Fusion = typeof(Fusion)
type Scope<T = Fusion> = Fusion.Scope<T>
type UsedAs<T> = Fusion.UsedAs<T>
type StateObject<T> = Fusion.UsedAs<T>

local Theme = require(script.Parent.Parent.Theme)
local UseAtom = require(Hooks.UseAtom)

local Component = script.Parent.Parent.component
local Button = require(Component.Core.Button)
local Card = require(Component.Core.Card)
local Text = require(Component.Core.Text)

local cellPx = MazeConfig.nodeSize
local imgSize = MazeConfig.mazeSize * cellPx
local wallColor = Color3.fromRGB(0, 0, 0)

local function GetMazeAlgorithmGen(key: string)
	local mazeGenerator = ReplicatedStorage.maze.Generation:FindFirstChild(key)
	return mazeGenerator
end

local function cellToPixel(x: number, y: number)
	return Vector2.new((x - 1) * cellPx, (y - 1) * cellPx)
end

local function DrawMaze(image: EditableImage, mazeGenKey: string, seed: number, render: Fusion.Value<boolean>)
	render:set(false)

	local generator = GetMazeAlgorithmGen(mazeGenKey)
	if not generator then return end

	local success, module = pcall(require, generator)

	if not success then return nil end

	local mazeGenerator: BaseGenerator.BaseGenerator<unknown> = module.new()

	mazeGenerator.OnComplete:connect(function()
		local maze = mazeGenerator:GetMaze()

		for i, _ in maze do
			for j, n2 in maze do
				local currentNode: types.Node<unknown> = maze[i][j]
				local px = cellToPixel(currentNode.x, currentNode.y)

				local x0, y0 = px.X, px.Y
				local x1, y1 = x0 + cellPx, y0 + cellPx

				if currentNode.open.Up then
					image:DrawLine(
						Vector2.new(x0, y0),
						Vector2.new(x1, y0),
						wallColor,
						0,
						Enum.ImageCombineType.Overwrite
					)
				end

				if currentNode.open.Down then
					image:DrawLine(
						Vector2.new(x0, y1),
						Vector2.new(x1, y1),
						wallColor,
						0,
						Enum.ImageCombineType.Overwrite
					)
				end

				if currentNode.open.Left then
					image:DrawLine(
						Vector2.new(x0, y0),
						Vector2.new(x0, y1),
						wallColor,
						0,
						Enum.ImageCombineType.Overwrite
					)
				end

				if currentNode.open.Right then
					image:DrawLine(
						Vector2.new(x1, y0),
						Vector2.new(x1, y1),
						wallColor,
						0,
						Enum.ImageCombineType.Overwrite
					)
				end
			end
		end

		render:set(true)
	end)

	task.spawn(mazeGenerator.Generate, mazeGenerator, seed)
end

type ReplayDisplayProps = {
	value: PlayerState.Replay | string,
}

local function ReplayDisplay(scope: Scope, props: ReplayDisplayProps): any -- Silence type error for now
	local value = props.value

	if value == "FAKE_REPLAY" or not value then
		return Spinner(scope, {
			Size = UDim2.fromOffset(50, 50),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
		})
	end

	local theme = Theme.Contextual:now()

	local render = scope:Value(false)

	local image = AssetService:CreateEditableImage({
		Size = Vector2.new(imgSize + 1, imgSize + 1),
	})

	DrawMaze(image, (value :: PlayerState.Replay).algorithms.maze, (value :: PlayerState.Replay).date, render)

	return scope:Computed(function(use)
		if use(render) then
			return scope:New "ImageLabel" {
				Size = UDim2.fromScale(0.95, 0.95),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),

				BackgroundColor3 = theme.Secondary,

				ImageContent = Content.fromObject(image),

				[Children] = {
					scope:New "UICorner" {
						CornerRadius = UDim.new(0.1),
					},
				},
			}
		end

		return Spinner(scope, {
			Size = UDim2.fromOffset(50, 50),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
		})
	end)
end

type ReplayButtonProps = {
	value: PlayerState.Replay | string,
}

local function ReplayButton(scope: Scope, props: ReplayButtonProps): Instance
	local theme = Theme.Contextual:now()

	return Button(scope, {
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.fromScale(0.5, 1),
		Size = UDim2.new(0, 130, 1, 0),
		Shadow = {
			Offset = UDim2.fromScale(0, -0.05),
			Color = theme.Shadow,
			Ratio = 1,
		},

		Corners = UDim.new(0.15),
		Color = theme.Primary,

		[Children] = {
			scope:New "UIStroke" {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize,
				BorderStrokePosition = Enum.BorderStrokePosition.Inner,

				Color = theme.Shadow,
				Thickness = 0.025,
			},
			ReplayDisplay(scope, props) :: any,
		},
	})
end

type Props = {
	Parent: UsedAs<Instance?>?,
	Player: string,
}

return function(scope: Scope, props: Props): Instance
	scope = scope:innerScope({}) :: Scope

	local theme = Theme.Contextual:now()
	local texture = {
		Asset = "rbxassetid://17259633983",
		Transparency = 0.75,
		ScaleType = Enum.ScaleType.Tile,
		TileSize = UDim2.fromOffset(100, 100),
	}

	local replays = UseAtom(scope, function()
		local state = PlayerState.GetPlayerState(props.Player)

		if state then return state.replays end

		return {}
	end)

	local filled = scope:Computed(function(use)
		local list = table.clone(use(replays))

		for i = #list + 1, 11 do
			list[i] = "FAKE_REPLAY"
		end

		return list
	end)

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
				Size = UDim2.fromScale(1, 0.15),

				Texture = texture :: any,
				Color = theme.Primary,

				[Children] = {
					-- Main Content
					scope:New "ScrollingFrame" {
						AnchorPoint = Vector2.one / 2,
						Position = UDim2.fromScale(0.5, 0.5),
						Size = UDim2.fromScale(1, 1),
						CanvasSize = UDim2.new(1, 0, 1, 0),
						AutomaticCanvasSize = Enum.AutomaticSize.X,

						BackgroundTransparency = 1,

						ScrollingDirection = Enum.ScrollingDirection.X,

						[Children] = {
							scope:ForValues(filled, function(a0, a1, value)
								return ReplayButton(scope, { value = value })
							end),

							scope:New "UIListLayout" {
								FillDirection = Enum.FillDirection.Horizontal,
								Padding = UDim.new(0, 15),
							} :: any,

							scope:New "UIPadding" {
								PaddingTop = UDim.new(0.05),
								PaddingBottom = UDim.new(0.1),
								PaddingLeft = UDim.new(0.01),
								PaddingRight = UDim.new(0.01),
							} :: any,
						},
					},

					Button(scope, {
						AnchorPoint = Vector2.new(0.5, 1),
						Position = UDim2.fromOffset(75, -10),
						Size = UDim2.new(0, 130, 0.5, 0),
						Shadow = {
							Offset = UDim2.fromScale(0, -0.05),
							Color = theme.Shadow,
							Ratio = 1,
						},

						Corners = UDim.new(0.15),
						Color = theme.Primary,

						Activated = function()
							networking.requestChangeState:fire("LOBBY")
						end,

						[Children] = {
							scope:New "UIStroke" {
								ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
								StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize,
								BorderStrokePosition = Enum.BorderStrokePosition.Inner,

								Color = theme.Shadow,
								Thickness = 0.025,
							},
							Text(scope, {
								Size = UDim2.fromScale(1, 1),

								Text = `Back`,
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
						},
					}) :: any,

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
