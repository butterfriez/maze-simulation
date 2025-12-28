local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remo = require(ReplicatedStorage.Packages.Remo)
local CharmSync = require(ReplicatedStorage.Packages.CharmSync)

type Remotes = {
	sync: Remo.ServerToClient<CharmSync.SyncPayload>,
	init: Remo.ClientToServer<any>,
}

local remotes: Remotes = Remo.createRemotes({
	sync = Remo.remote(),
	init = Remo.remote(),
})

return remotes
