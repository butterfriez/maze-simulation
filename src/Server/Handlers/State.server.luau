local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CharmSync = require(ReplicatedStorage.Packages.CharmSync)

local PlayerState = require(ReplicatedStorage.state.atoms.PlayerState)
local atoms = require(ReplicatedStorage.state.atoms)
local remotes = require(ReplicatedStorage.networking)

local syncer = CharmSync.server({ atoms = atoms })

-- https://github.com/littensy/charm-example/blob/main/src/shared/store/sync/utils/filter-payload.ts
local function FilterPayload(player: Player, payload: CharmSync.SyncPayload): CharmSync.SyncPayload
	local data = table.clone(payload.data)

	if payload.type == "init" then
		data.PlayerStates = {
			[player.Name] = data.PlayerStates[player.Name],
		}

		data = data

		return {
			type = payload.type,
			data = data,
		}
	end

	data.PlayerStates = payload.data["PlayerStates"]
			and {
				[player.Name] = payload.data.PlayerStates[player.Name],
			}
		or nil

	return {
		type = payload.type,
		data = data,
	}
end

syncer:connect(function(player, payload)
	remotes.sync:fire(player, FilterPayload(player, payload))
end)

remotes.init:connect(function(player)
	syncer:hydrate(player)
end)

local VALID_STATES = {
	LOBBY = true,
	REPLAYSEL = true,
}

remotes.requestChangeState:connect(function(player, newState)
	if not VALID_STATES[newState] then return end

	local currentState = PlayerState.GetPlayerState(player.Name)
	if not currentState then return end

	local currentGameState = currentState.gameState

	if not VALID_STATES[currentGameState] then return end

	PlayerState.UpdatePlayerState(player.Name, function(state)
		state = table.clone(state)
		state.gameState = newState
		return state
	end)
end)
