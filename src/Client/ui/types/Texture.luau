--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UILabs = require(ReplicatedStorage.Packages.UILabs)

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

local TEXTURE_CONTROLS = {
	["Texture: Asset"] = "",
	["Texture: Color"] = Color3.new(1, 1, 1),
	["Texture: Transparency"] = UILabs.Slider(0, 0, 1),
	["Texture: ScaleType"] = UILabs.EnumList(SCALE_TYPE_LIST, "Stretch"),
}
type TextureControls = typeof(TEXTURE_CONTROLS)
type Controls = { [string]: any }

return table.freeze {
	Empty = EMPTY_TEXTURE,
	Story = table.freeze {
		Controls = function<T>(controls: T): T & TextureControls
			for key, value in TEXTURE_CONTROLS :: any do
				if (controls :: any)[key] then continue end
				(controls :: any)[key] = value
			end
			return controls
		end,
		Properties = function(scope: Scope, controls: Controls & TextureControls): Texture
			return {
				Asset = controls["Texture: Asset"],
				Color = controls["Texture: Color"],
				Transparency = controls["Texture: Transparency"],
				ScaleType = controls["Texture: ScaleType"],
			}
		end,
	},

	Resolve = function(texture: Texture?): (Texture, "Frame" | "ImageLabel")
		if texture then
			return texture, "ImageLabel"
		else
			return EMPTY_TEXTURE, "Frame"
		end
	end,
	Apply = function<T>(texture: Texture, props: T): T
		if texture == EMPTY_TEXTURE then return props end
		for a, b in TEXTURE_MAP :: any do
			if (props :: any)[a] then continue end
			(props :: any)[a] = (texture :: any)[b]
		end
		return props
	end,
}
