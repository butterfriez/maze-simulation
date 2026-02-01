--!strict

-- Services:
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Constants:
local ZERO_UDIM2 = UDim2.new()

-- Fusion | Definitions:
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local SoundManager = require(ReplicatedStorage.libs.SoundManager)
local Children = Fusion.Children
local peek = Fusion.peek

-- Fusion | Types:
type Fusion = typeof(Fusion)
type Scope<T = Fusion> = Fusion.Scope<T>
type UsedAs<T> = Fusion.UsedAs<T>
type Value<T> = Fusion.Value<T>
type Child = Fusion.Child

local Card = require(script.Parent.Card)

export type Props = Card.Props & {
	Activated: ((GuiObject) -> ())?,
}
type Children = { [typeof(Children)]: Child? }

return function(scope: Scope, props: Props)
	-- Ensure a reference value exists!
	local ref = props.__ref
	if not ref then
		ref = scope:Value(nil) :: Value<GuiObject?>
		props.__ref = ref
	end

	local offset: Value<UDim2>

	local shadow = props.Shadow
	if shadow then
		if typeof(shadow.Offset) == "UDim2" then
			offset = scope:Value(shadow.Offset) :: Value<UDim2>
		else
			local supplied = shadow.Offset
			offset = scope:Value(ZERO_UDIM2) :: Value<UDim2>
			scope:Observer(supplied):onBind(function()
				local value = peek(supplied :: any) :: UDim2
				offset:set(value)
			end)
		end
		shadow.Offset = scope:Spring(offset :: any, 50) :: UsedAs<UDim2>
	else
		offset = scope:Value(ZERO_UDIM2) :: Value<UDim2>
	end

	local card = Card(scope, props :: Card.Props & Children)

	scope:Observer(ref):onBind(function()
		local object = Fusion.peek(ref) :: GuiButton?
		if not object then return end

		local scope = scope:innerScope() :: Scope
		local preserved = { Offset = nil :: UDim2? }

		local hover = object.MouseEnter:Connect(function()
			SoundManager.GetSound("hover1_btn"):Play()
		end)

		local hoverEnd = object.MouseLeave:Connect(function()
			SoundManager.GetSound("hover2_btn"):Play()
		end)

		local began = object.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
			if not shadow or preserved.Offset then return end
			preserved.Offset = peek(offset :: any) :: UDim2
			offset:set(ZERO_UDIM2)
			SoundManager.GetSound("click_btn"):Play()
		end)
		local ended = object.InputEnded:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
			if not (shadow and preserved.Offset) then return end
			offset:set(preserved.Offset :: UDim2)
			preserved.Offset = nil
			if props.Activated then props.Activated(card :: GuiObject) end
		end)
		scope:insert(began, ended, hover, hoverEnd)
	end)

	return card
end
