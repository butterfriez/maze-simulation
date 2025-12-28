export type Node<meta> = {
	x: number,
	y: number,
	meta: meta,
}

local Directions = {
	{ 1, 0 }, -- right
	{ -1, 0 }, -- left
	{ 0, 1 }, -- down
	{ 0, -1 }, -- up
}

return {
	Directions = Directions,
}
