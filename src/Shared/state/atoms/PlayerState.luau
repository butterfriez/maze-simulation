local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Charm = require(ReplicatedStorage.Packages.Charm)

export type PlayerState = {
	coins: number,
	algorithms: {
		maze: string,
		solver: string,
	},
	gameState: "LOBBY" | "INGAME" | "GENERATING" | "SOLVING" | "ENDED",
	ratColor: Color3,
	uiTheme: "Light" | "Dark",
	rewardMultiplier: number,
}

local PlayerStatesAtom = Charm.atom({}) :: Charm.Atom<{ [string]: PlayerState }>
local DefaultPlayerState: PlayerState = {
	coins = 0,
	algorithms = {
		maze = "Recursive Backtracker",
		solver = "Wall Follower",
	},
	gameState = "LOBBY",
	ratColor = Color3.new(0, 0, 0),
	uiTheme = "Dark",
	rewardMultiplier = 1,
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
