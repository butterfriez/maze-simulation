local ServerStorage = game:GetService("ServerStorage")
local BeforeRun = require(ServerStorage.CommandHooks.BeforeRun)
local Cmdr = require(ServerStorage.ServerPackages.Cmdr)

BeforeRun(Cmdr.Registry)
Cmdr.Registry:RegisterCommandsIn(script)