local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CharmSync = require(ReplicatedStorage.Packages.CharmSync)
local Remo = require(ReplicatedStorage.Packages.Remo)
local t = require(ReplicatedStorage.Packages.t)
local types = require(ReplicatedStorage.maze.types)

type Remotes = {
	sync: Remo.ServerToClient<CharmSync.SyncPayload>,
	init: Remo.ClientToServer<()>,
	startGame: Remo.ClientToServer<()>,
	gameEnded: Remo.ServerToClient<>,
	buildMaze: Remo.ServerToClient<{ [number]: { [number]: { types.Node<unknown> } } }>,
}

local remotes: Remotes = Remo.createRemotes({
	sync = Remo.remote(),
	init = Remo.remote(),
	startGame = Remo.remote(),
	gameEnded = Remo.remote(),
	buildMaze = Remo.remote(),
})

return remotes
