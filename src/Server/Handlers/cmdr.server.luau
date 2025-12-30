local ServerStorage = game:GetService("ServerStorage")
local Cmdr = require(ServerStorage.ServerPackages.Cmdr)

Cmdr.Registry:RegisterTypesIn(ServerStorage.cmdrConfig.types)
Cmdr.Registry:RegisterHooksIn(ServerStorage.cmdrConfig.hooks)
Cmdr.Registry:RegisterCommandsIn(ServerStorage.cmdrConfig.commands)