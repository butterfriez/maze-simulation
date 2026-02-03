local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UILabs = require(ReplicatedStorage.Packages.UILabs)

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local peek = Fusion.peek

type Fusion = typeof(Fusion)
type Scope<T = Fusion> = Fusion.Scope<T>

local Menu = require(script.Parent)
local Theme = require(script.Parent.Parent.Parent.Theme)

local STORY_CONTROLS = {
	Theme = UILabs.EnumList(Theme.List, "Dark"),
}
type Controls = typeof(STORY_CONTROLS)

return UILabs.CreateFusionStory({
	fusion = Fusion,
	controls = STORY_CONTROLS,
}, function(props)
	local scope = props.scope :: Scope
	local controls = props.controls :: Controls

	local previous: Scope? = nil
	scope:Observer(controls.Theme):onBind(function()
		if previous then
			previous:doCleanup()
			previous = nil
		end

		local scope = scope:innerScope() :: Scope
		previous = scope

		Theme.Contextual:is(peek(controls.Theme)):during(function()
			Menu(previous, { Parent = props.target })
		end)
	end)
end)
