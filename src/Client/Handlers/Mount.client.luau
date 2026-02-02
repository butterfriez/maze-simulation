--!strict

--[[
	This script handles mounting the various "views" to the player's PlayerGui.
	Views are predefined interface layouts comprised of UI elements, components,
	and even sometimes other views. 
]]

-- Services:
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Fusion:
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children

type UsedAs<T> = Fusion.UsedAs<T>

-- References:
local UI = script.Parent.Parent.ui --> Luau aliases in Roblox when??
local Player = Players.LocalPlayer :: Player
local PlayerGui = Player:WaitForChild("PlayerGui")

local PlayerState = require(UI.state.PlayerState)
type PlayerState = PlayerState.PlayerState

local scope = Fusion:scoped({
	Debug = require(UI.view.Debug),
	Menu = require(UI.view.Menu),
	HUD = require(UI.view.HUD),
	Replay = require(UI.view.Replay),
})

-- TODO: Move declaration. Handled by Charm?
-- This value should default to `false` and be toggled via some input-sequence or special key.
local DEBUG_MODE = scope:Value(false :: boolean) --> Temporarily set to `true` until there is a method to toggle.

if RunService:IsStudio() then -- extra fail-safe in case ^ goes into public for some reason - butterfriez
	DEBUG_MODE:set(true)
end

-- UserInputService this fucker lmaoooo - butterfriez
UserInputService.InputBegan:Connect(function(i, p)
	if p or not RunService:IsStudio() then return end

	-- Why dis throw a type error... ;-;
	if i.KeyCode == Enum.KeyCode.F then DEBUG_MODE:set(not Fusion.peek(DEBUG_MODE) :: boolean) end
end)

scope:New "ScreenGui" {
	Name = "Interface [App]",
	Parent = PlayerGui,

	[Children] = {
		-- Mount debug menu as necessary:
		scope:Computed(function(use)
			local enabled: boolean = use(DEBUG_MODE)
			return if enabled
				then scope:Debug({
					State = PlayerState.current :: UsedAs<{ [string]: unknown }>,
				})
				else nil
		end),

		scope:Computed(function(use)
			local state: PlayerState.PlayerState = use(PlayerState.current)

			if state then
				if state.gameState == "LOBBY" then
					scope:Menu({})
				elseif state.gameState == "REPLAYSEL" then
					scope:Replay({ Player = Player.Name })
				elseif state.gameState == "INGAME" then
					scope:HUD({})
				end
			end

			return nil
		end),
	},
}
