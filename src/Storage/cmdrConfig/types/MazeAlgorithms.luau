local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GenTypes = require(ReplicatedStorage.maze.util.GenTypes)
return function(registry)
	registry:RegisterType("algorithm", registry.Cmdr.Util.MakeEnumType("Algorithm", GenTypes.GenGenerationType()))
end
