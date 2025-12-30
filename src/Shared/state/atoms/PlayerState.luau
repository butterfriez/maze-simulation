local ReplicatedStorage = game:GetService("ReplicatedStorage")

local charm = require(ReplicatedStorage.Packages.charm)

export type PlayerState = {
	coins: number,
	algorithms: {
		maze: string,
		solver: string,
	},
	gameState: "LOBBY" | "INGAME" | "GENERATING" | "ENDED",
	ratColor: Color3
}

local PlayerStatesAtom = charm.atom({}) :: charm.Atom<{ [string]: PlayerState }>
local DefaultPlayerState: PlayerState = {
	coins = 0,
	algorithms = {
		maze = "Recursive Backtracker",
		solver = "Wall Follower",
	},
	gameState = "LOBBY",
	ratColor = Color3.new(0,0,0)
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

local function UpdatePlayerState(player: string, updater: (currentState: PlayerState) -> PlayerState)
	PlayerStatesAtom(function(state)
		state = table.clone(state)
		state[player] = updater(state[player])

		return state
	end)
end

return {
	PlayerStatesAtom = PlayerStatesAtom,
	GetPlayerState = GetPlayerState,
	SetPlayerState = SetPlayerState,
	UpdatePlayerState = UpdatePlayerState,
	DefaultPlayerState = DefaultPlayerState,
}
