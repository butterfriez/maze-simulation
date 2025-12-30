return function(registry)
	registry:RegisterType(
		"solver",
		registry.Cmdr.Util.MakeEnumType("Solver", {
			"Wall Follower",
		})
	)
end
