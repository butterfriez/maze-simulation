local ServerStorage = game:GetService("ServerStorage")
local Cmdr = require(ServerStorage.ServerPackages.Cmdr)

Cmdr.Registry:RegisterHooksIn(ServerStorage.cmdrConfig.hooks)
Cmdr.Registry:RegisterCommandsIn(ServerStorage.cmdrConfig.commands)