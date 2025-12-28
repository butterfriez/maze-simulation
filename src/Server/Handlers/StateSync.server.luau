local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CharmSync = require(ReplicatedStorage.Packages.CharmSync)

local atoms = require(ReplicatedStorage.state.atoms)
local remotes = require(ReplicatedStorage.networking)

local syncer = CharmSync.server({ atoms = atoms })
syncer:connect(function(player, payload)
	remotes.sync:fire(player, payload)
end)

remotes.init:connect(function(player)
	syncer:hydrate(player)
end)
