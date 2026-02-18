--!strict

-- Services:
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UI = script.Parent

-- Fusion:
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local scope = Fusion:scoped()
local peek = Fusion.peek :: any

type Fusion = typeof(Fusion)
type Scope<T = Fusion> = Fusion.Scope<T>
type StateObject<T> = Fusion.StateObject<T>

local PlayerState = require(UI.state.PlayerState)

local ThemeContainer = UI.themes
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

Theme.Contextual = Fusion.Contextual(dynamic :: Theme)

local Story = require(UI.Story)
if Story.Available then
	local UILabs = require(ReplicatedStorage.Packages.UILabs)

	local apply = function(scope: Scope, theme: StateObject<Theme>, func: (scope: Scope) -> ())
		local tempScope: Scope? = nil
		scope:Observer(theme):onBind(function()
			local current = peek(theme)

			if tempScope then
				tempScope:doCleanup()
				tempScope = nil
			end

			Theme.Contextual:is(current):during(function()
				tempScope = scope:innerScope() :: Scope
				func(tempScope)
			end :: any)
		end)
	end

	Theme.Story = table.freeze {
		Control = UILabs.EnumList(Theme.List :: any, DEFAULT_THEME_NAME),
		Apply = apply,
	}
end

return Theme
