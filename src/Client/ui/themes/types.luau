--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local fusion = require(ReplicatedStorage.Packages.fusion)

type ThemeLayout<T> = {
    background: T,
    foreground: T,
    accent: T,
    text: T
}

export type Theme = ThemeLayout<Color3>
export type DynamicTheme = ThemeLayout<fusion.StateObject<Color3>>

local PLACEHOLDER_COLOR: Color3 = Color3.new()

local placeholder: Theme = {
    background = PLACEHOLDER_COLOR,
    foreground = PLACEHOLDER_COLOR,
    accent = PLACEHOLDER_COLOR,
    text = PLACEHOLDER_COLOR
}
return placeholder