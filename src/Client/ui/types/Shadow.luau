--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DEFAULT_SHADOW_RATIO: number = 0.25

local UILabs = require(ReplicatedStorage.Packages.UILabs)

local Fusion = require(ReplicatedStorage.Packages.Fusion)
type Fusion = typeof(Fusion)
type Scope<T = Fusion> = Fusion.Scope<T>
type UsedAs<T> = Fusion.UsedAs<T>
type StateObject<T> = Fusion.StateObject<T>

export type Shadow = {
	Offset: UsedAs<UDim2>,
	Color: UsedAs<Color3>?,
	Ratio: UsedAs<number>?,
	Transparency: UsedAs<number>?,
}

local SHADOW_CONTROLS = {
	["Shadow: Offset (X)"] = UILabs.Slider(-2.5, -100, 100),
	["Shadow: Offset (Y)"] = UILabs.Slider(-2.5, -100, 100),
	["Shadow: Ratio"] = UILabs.Slider(0.5, 0, 1),
	["Shadow: Transparency"] = UILabs.Slider(0, 0, 1),
}
export type Controls = typeof(SHADOW_CONTROLS)

return table.freeze {
	Story = table.freeze {
		Controls = SHADOW_CONTROLS,
		Properties = function(scope: Scope, controls: { [string]: any } & Controls): Shadow
			local offset = scope:Computed(function(use: any)
				return UDim2.fromOffset(use(controls["Shadow: Offset (X)"]), use(controls["Shadow: Offset (Y)"]))
			end)
			return {
				Offset = offset,
				Ratio = controls["Shadow: Ratio"],
				Transparency = controls["Shadow: Transparency"],
			}
		end,
	},
	Color = function(scope: Scope, shadow: Shadow, color: UsedAs<Color3>): StateObject<Color3>
		local ratio = shadow.Ratio or DEFAULT_SHADOW_RATIO
		return scope:Computed(function(use: any)
			local h, s, v = (use(shadow.Color or color) :: Color3):ToHSV()
			local ratio = use(ratio) :: number
			return Color3.fromHSV(h, s, v * ratio)
		end)
	end,
	Position = function(scope: Scope, shadow: Shadow, position: UsedAs<UDim2>): StateObject<UDim2>
		return scope:Computed(function(use: any)
			local offset = use(shadow.Offset) :: UDim2
			return (use(position) :: UDim2) + offset
		end)
	end,
}
