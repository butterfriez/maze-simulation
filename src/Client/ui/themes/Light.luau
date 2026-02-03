--!strict

local types = require(script.Parent.types)

local theme: types.Theme = {
	Primary = Color3.fromHex("#B6AE9F"),
	Secondary = Color3.fromHex("#C5C7BC"),
	Accent = Color3.new(1, 0.541176, 0.168627),
	Shadow = Color3.fromHex("#4e472e"),
	Text = Color3.new(1, 1, 1),
}
return theme
