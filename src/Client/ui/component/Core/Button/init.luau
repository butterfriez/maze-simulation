--!strict

-- Services:
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Constants:
local ZERO_UDIM2: UDim2 = UDim2.new()
local SPRING_SPEED: number = 50

-- Fusion | Definitions:
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children
local peek = Fusion.peek

-- Fusion | Types:
type Fusion = typeof(Fusion)
type Scope<T = Fusion> = Fusion.Scope<T>
type UsedAs<T> = Fusion.UsedAs<T>
type Value<T> = Fusion.Value<T>
type Spring<T> = Fusion.Spring<T>
type Child = Fusion.Child

local SoundManager = require(ReplicatedStorage.libs.SoundManager)
SoundManager.Load(ReplicatedStorage.assets.sounds.Button) --> Load button sounds!

local Components = script.Parent.Parent
local Interactions = require(Components.Parent.state.Interactions)
local Theme = require(Components.Parent.Theme)

local Card = require(Components.Core.Card)

-- Note: Idk if I should actually be doing something like this, it feels gross
local function Privatize<T>(scope: Scope, value: UsedAs<T>): Value<T>
	local internal: Value<T>
	if typeof(value) == "table" then
		internal = scope:Value(peek(value)) :: Value<T>
		scope:Observer(value):onChange(function()
			internal:set(peek(value))
		end)
	else
		internal = scope:Value(value)
	end
	return internal
end

export type Props = Card.Props & {
	-- TODO: Interactable: UsedAs<boolean>?,
	Activated: ((GuiObject) -> ())?,
	Hovered: Value<boolean>?,
}
type Children = { [typeof(Children)]: Child? }

return function(scope: Scope, props: Props)
	scope = scope:innerScope() :: Scope
	local theme = Theme.Contextual:now()

	local ref = props.__ref
	local shadow = props.Shadow
	local hovered: Value<boolean> = props.Hovered or scope:Value(false) :: any

	-- Ensure reference Value exists:
	if not ref then
		ref = scope:Value(nil) :: Value<GuiObject?>
		props.__ref = ref
	end

	do -- Handle color highlighting:
		local color = props.Color or theme.Primary
		local goal = Privatize(scope, color :: Color3)

		scope:Observer(hovered):onChange(function()
			local current = peek(color)
			local highlight = current:Lerp(peek(theme.Shadow), 0.25)
			goal:set(if peek(hovered) then highlight else current)
		end)
		props.Color = scope:Spring(goal :: any, 50, 2) :: any
	end

	local __offset: UsedAs<UDim2>?, offset: Value<UDim2>? = nil, nil
	if shadow then
		__offset = shadow.Offset
		offset = Privatize(scope, __offset :: UDim2)
		shadow.Offset = scope:Spring(offset :: any, SPRING_SPEED) :: UsedAs<UDim2>
	end

	local card = Card(scope, props :: Card.Props & Children)

	local previous: Scope? = nil
	scope:Observer(ref):onBind(function()
		local object = Fusion.peek(ref) :: GuiObject?
		if not object then return end

		if previous then
			previous:doCleanup()
			previous = nil
		end

		local scope = scope:innerScope() :: Scope
		previous = scope

		scope:insert({
			object.MouseEnter:Connect(function()
				Interactions.Hovered:set(object)
				hovered:set(true)
				SoundManager.Play(SoundManager.Get("hover_btn"))
			end),
			object.MouseLeave:Connect(function()
				Interactions.Hovered:set(nil)
				hovered:set(false)
			end),

			object.InputBegan:Connect(function(input)
				if not Interactions.Activated(input) then return end
				if __offset and offset then offset:set(ZERO_UDIM2) end
			end),
			object.InputEnded:Connect(function(input)
				if not Interactions.Activated(input) then return end
				if __offset and offset then offset:set(peek(__offset)) end
				if props.Activated then props.Activated(object) end
				SoundManager.Play(SoundManager.Get("click_btn"))
			end),
		})
	end)

	return card
end
