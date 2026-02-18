--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UI = script.Parent.Parent

local Fusion = require(ReplicatedStorage.Packages.Fusion)
type Fusion = typeof(Fusion)
type Scope<T = Fusion> = Fusion.Scope<T>
type UsedAs<T> = Fusion.UsedAs<T>

export type Texture = {
	Asset: UsedAs<string>,
	Color: UsedAs<Color3>?,
	Transparency: UsedAs<number>?,
	Size: UsedAs<Vector2>?,
	Offset: UsedAs<Vector2>?,
	ScaleType: UsedAs<Enum.ScaleType>?,

	-- Tile Properties:
	TileSize: UsedAs<UDim2>?,

	-- Slice Properties:
	SliceCenter: UsedAs<Rect>?,
	SliceScale: UsedAs<number>?,
}

local TEXTURE_MAP = {
	Image = "Asset",
	ImageColor3 = "Color",
	ImageTransparency = "Transparency",
	ImageRectSize = "Size",
	ImageRectOffset = "Offset",
	ScaleType = "ScaleType",

	TileSize = "TileSize",

	SliceCenter = "SliceCenter",
	SliceScale = "SliceScale",
}

local EMPTY_TEXTURE = (table.freeze {}) :: Texture

local SCALE_TYPE_LIST: { [string]: Enum.ScaleType } = {}
for _, enum in Enum.ScaleType:GetEnumItems() do
	SCALE_TYPE_LIST[enum.Name] = enum
end

local Texture = {}
Texture.Empty = EMPTY_TEXTURE

Texture.Resolve = function(texture: Texture?): (Texture, "Frame" | "ImageLabel")
	if texture then
		return texture, "ImageLabel"
	else
		return EMPTY_TEXTURE, "Frame"
	end
end

-- TODO: Replace this with some Sift method!
Texture.Apply = function<T>(texture: Texture, props: T): T
	if texture == EMPTY_TEXTURE then return props end
	for a, b in TEXTURE_MAP :: any do
		if (props :: any)[a] then continue end
		(props :: any)[a] = (texture :: any)[b]
	end
	return props
end

local Story = require(UI.Story)
if Story.Available then
	local UILabs = require(ReplicatedStorage.Packages.UILabs)

	local TEXTURE_CONTROLS = {
		["Texture: Asset"] = "",
		["Texture: Color"] = Color3.new(1, 1, 1),
		["Texture: Transparency"] = UILabs.Slider(0, 0, 1),
		["Texture: ScaleType"] = UILabs.EnumList(SCALE_TYPE_LIST, "Stretch"),
	}
	type Controls = typeof(TEXTURE_CONTROLS)

	Texture.Story = table.freeze {
		Controls = TEXTURE_CONTROLS,
		Properties = function(scope: Scope, controls: { [string]: any } & Controls): Texture
			return {
				Asset = controls["Texture: Asset"],
				Color = controls["Texture: Color"],
				Transparency = controls["Texture: Transparency"],
				ScaleType = controls["Texture: ScaleType"],
			}
		end,
	}
end

return table.freeze(Texture)
