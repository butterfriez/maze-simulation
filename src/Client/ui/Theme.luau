--!strict

-- Services:
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Fusion:
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local scope = Fusion:scoped()

local PlayerState = require(script.Parent.state.PlayerState)

local ThemeContainer = script.Parent.themes
local types = require(ThemeContainer.types)
export type Theme = types.Theme

local DEFAULT_THEME_NAME: ThemeName = "Dark"

local Theme = {}

Theme.List = table.freeze {
	Dark = require(ThemeContainer.Dark),
	Light = require(ThemeContainer.Light),
}
export type ThemeName = keyof<typeof(Theme.List)>

Theme.Name = scope:Computed(function(use: any)
	local state: PlayerState.PlayerState = use(PlayerState.current)
	return if state then state.uiTheme else DEFAULT_THEME_NAME
end)

local dynamic = {} :: types.DynamicTheme
for property in types :: { [string]: Color3 } do
	(dynamic :: any)[property] = scope:Computed(function(use: any)
		local name = use(Theme.Name)
		return (Theme.List :: any)[name][property]
	end)
end

Theme.Contextual = Fusion.Contextual(dynamic)

return Theme
