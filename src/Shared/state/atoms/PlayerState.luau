local ReplicatedStorage = game:GetService("ReplicatedStorage")

local charm = require(ReplicatedStorage.Packages.charm)

export type PlayerState = {
	coins: number,
	algorithms: {
		maze: string,
		solver: string,
	},
}

local PlayerStatesAtom = charm.atom({}) :: charm.Atom<{ [string]: PlayerState }>
local DefaultPlayerState: PlayerState = {
	coins = 0,
	algorithms = {
		maze = "Recursive Backtracker",
		solver = "Wall Follower",
	},
}

local function GetPlayerState(player: string)
	return PlayerStatesAtom()[player]
end

local function SetPlayerState(player: string, newState: PlayerState)
	PlayerStatesAtom(function(currentState)
		currentState = table.clone(currentState)
		currentState[player] = newState
		return currentState
	end)
end

return {
	PlayerStatesAtom = PlayerStatesAtom,
	GetPlayerState = GetPlayerState,
	SetPlayerState = SetPlayerState,
	DefaultPlayerState = DefaultPlayerState,
}
