--!strict

-- Services:
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- States:
local PlayerState = require(script.Parent.state.PlayerState)
type PlayerState = PlayerState.PlayerState

-- Fusion:
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local scope = Fusion:scoped()

local ThemeContainer = script.Parent.themes
local types = require(ThemeContainer.types)
export type Theme = types.Theme

local DEFAULT_THEME_NAME: ThemeName = "Dark"

local Theme = {}

Theme.List = {
	Dark = require(ThemeContainer.Dark),
	Light = require(ThemeContainer.Light),
}
table.freeze(Theme.List) --> Ensure immutability!
export type ThemeName = keyof<typeof(Theme.List)>

Theme.Name = scope:Computed(function(use)
	local state: PlayerState = use(PlayerState.current)
	return state.uiTheme or DEFAULT_THEME_NAME
end)

Theme.Dynamic = {} :: types.DynamicTheme
-- FIX: Cast to a more generalized table to fix "Cannot iterate over table without indexer" type error
for property in types :: { [string]: Color3 } do
	-- FIX: Cast to any to fix "Cannot add indexer" type error
	(Theme.Dynamic :: any)[property] = scope:Computed(function(use)
		local name = use(Theme.Name)
		return Theme.List[name][property]
	end)
end

return Theme
