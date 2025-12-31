function GenGenerationType(): { string }
	local generated = {}
	local generators = script.Parent.Parent.Generation:GetChildren()

	for _, generator in generators do
		if string.find(generator.Name, "Base") then
			continue
		end

		table.insert(generated, generator.Name)
	end

	return generated
end

function GenSolverType(): { string }
	local generated = {}

	local solvers = script.Parent.Parent.Solvers:GetChildren()

	for _, solver in solvers do
		if string.find(solver.Name, "Base") then
			continue
		end
		table.insert(generated, solver.Name)
	end

	return generated
end

return {
	GenGenerationType = GenGenerationType,
	GenSolverType = GenSolverType,
}
