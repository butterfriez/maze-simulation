return {
	Name = "generateandsolve",
	Aliases = { "gs" },
	Description = "Generates a maze with selected generator and solves with selected solver then paints solved path.",
	Group = "Admin",
	Args = {
		{
			Type = "algorithm",
			Name = "algorithm",
			Description = "Algorithm to generate maze.",
		},
		{
			Type = "solver",
			Name = "solver",
			Description = "Solver algorithm to solve maze.",
		},
	},
}
