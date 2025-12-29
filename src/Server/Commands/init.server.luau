local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local BeforeRun = require(ServerStorage.CommandHooks.BeforeRun)
local Cmdr = require(ReplicatedStorage.ServerPackages.Cmdr)

BeforeRun(Cmdr.Registry)
Cmdr.Registry:RegisterCommandsIn(script)