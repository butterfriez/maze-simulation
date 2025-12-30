local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)

local ThemeContainer = script.Parent.themes

local types = require(ThemeContainer.types)
export type Theme = types.Theme

local Theme = {}

local scope = Fusion:scoped()

Theme.List = {
    Dark = require(ThemeContainer.Dark),
    Light = require(ThemeContainer.Light)
}
table.freeze(Theme.List) --> Ensure immutability!

Theme.Name = scope:Value("Dark")
Theme.Dynamic = {} :: types.DynamicTheme

for property in types do
    Theme.Dynamic[property] = scope:Computed(function (use)
        local name = use(Theme.Name)
        return Theme.List[name][property]
    end)
end

return Theme