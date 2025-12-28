local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local fusion = require(ReplicatedStorage.Packages.fusion)

local scope = fusion:scoped()
local Mount = scope:Value(nil)

scope:New("ScreenGui")({
	Parent = Mount,
})

Mount:set(Players.LocalPlayer:WaitForChild("PlayerGui"))
