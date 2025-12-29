--!strict

--[[
	This script handles mounting the various "views" to the player's PlayerGui.
	Views are predefined interface layouts comprised of UI elements, components,
	and even sometimes other views. 
]]

-- Services:
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer :: Player
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Fusion:
local fusion = require(ReplicatedStorage.Packages.fusion)
local scope = fusion:scoped()

-- Interface Modules:
local UI = script.Parent.ui
local DebugView = require(UI.view.Debug)
local HUDView = require(UI.view.HUD)

-- TODO: Move declaration. Handled by Charm?
-- This value should default to `false` and be toggled via some input-sequence or special key.
local DEBUG_MODE = scope:Value(true) --> Temporarily set to `true` until there is a method to toggle.

scope:New "ScreenGui" {
	Name = "Interface [App]",
	Parent = PlayerGui,

	[fusion.Children] = {
		-- Mount debug menu as necessary:
		scope:Computed(function (use)
			return if use(DEBUG_MODE) then DebugView(scope, {}) else nil
		end),
		HUDView(scope, {})
	}
}