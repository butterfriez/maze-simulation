return {
	Name = "generatemaze",
	Aliases = { "gm" },
	Description = "Generates a maze with selected generator.",
	Group = "Admin",
	Args = {
		{
			Type = "algorithm",
			Name = "algorithm",
			Description = "Algorithm to generate maze.",
		},
	},
}
