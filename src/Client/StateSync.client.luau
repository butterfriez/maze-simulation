local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CharmSync = require(ReplicatedStorage.Packages.CharmSync)
local remotes = require(ReplicatedStorage.networking)
local atoms = require(ReplicatedStorage.state.atoms)

local client = CharmSync.client({ atoms = atoms })

remotes.sync:connect(function(payload)
	client:sync(payload)
end)

remotes.init:fire()
