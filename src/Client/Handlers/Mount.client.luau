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
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local scope = Fusion:scoped()

-- Interface Modules:
local UI = script.Parent.Parent.ui
local DebugView = require(UI.view.Debug)
local HUDView = require(UI.view.HUD)

-- States:
local PlayerState = require(UI.state.PlayerState)

-- TODO: Move declaration. Handled by Charm?
-- This value should default to `false` and be toggled via some input-sequence or special key.
local DEBUG_MODE = scope:Value(true) --> Temporarily set to `true` until there is a method to toggle.

scope:New "ScreenGui" {
	Name = "Interface [App]",
	Parent = PlayerGui,

	[Fusion.Children] = {
		-- Mount debug menu as necessary:
		scope:Computed(function (use)
			return if use(DEBUG_MODE) then DebugView(scope, {
				States = PlayerState.currentState
			}) else nil
		end),
		
		-- TODO: Uncomment HUDView when there is an implementation in place.
		--HUDView(scope, {})
	}
}