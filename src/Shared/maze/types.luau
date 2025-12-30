export type Node<meta> = {
	x: number,
	y: number,
	meta: meta,
	open: {
		Up: boolean,
		Down: boolean,
		Left: boolean,
		Right: boolean,
	},
}

local Directions = {
	Up = { 0, -1 }, -- up
	Right = { 1, 0 }, -- right
	Down = { 0, 1 }, -- down
	Left = { -1, 0 }, -- left
}

return {
	Directions = Directions,
}
