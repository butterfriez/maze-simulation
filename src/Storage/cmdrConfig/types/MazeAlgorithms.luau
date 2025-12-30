return function (registry)
    registry:RegisterType("algorithm", registry.Cmdr.Util.MakeEnumType("Algorithm", 
    {
	    "Recursive Backtracker",
	    "Binary Tree",
	    "Sidewinder",
	    "Prim's Algorithm",
	    "Kruskal's Algorithm",
	    "Hunt and Kill",
	    "Growing Tree",
	    "Aldous-Broder",
	    "Wilson's Algorithm",
	    "Eller's Algorithm",
    }))
end