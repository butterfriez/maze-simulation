local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GenTypes = require(ReplicatedStorage.maze.util.GenTypes)

return function(registry)
	registry:RegisterType("solver", registry.Cmdr.Util.MakeEnumType("Solver", GenTypes.GenSolverType()))
end
