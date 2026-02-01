return {
	baseReward = 20, -- Multiplies with an upgrade.
	generationAlgorithms = {
		["Recursive Backtracker"] = {
			key = "RecursiveBacktracker",
			cost = 0,
		},
		["Binary Tree"] = {
			key = "BinaryTree",
			cost = 50,
		},
		["Sidewinder"] = {
			key = "Sidewinder",
			cost = 75,
		},
		["Prim's Algorithm"] = {
			key = "Prims",
			cost = 150,
		},
		["Kruskal's Algorithm"] = {
			key = "Kruskals",
			cost = 175,
		},
		["Hunt and Kill"] = {
			key = "HuntAndKill",
			cost = 200,
		},
		["Growing Tree"] = {
			key = "GrowingTree",
			cost = 225,
		},
		["Aldous-Broder"] = {
			key = "AldousBroder",
			cost = 300,
		},
		["Wilson's Algorithm"] = {
			key = "Wilsons",
			cost = 350,
		},
		["Eller's Algorithm"] = {
			key = "Ellers",
			cost = 400,
		},
	},

	solvingAlgorithms = {
		["Wall Follower"] = {
			key = "WallFollower",
			cost = 0,
		},
		["Random Mouse"] = {
			key = "RandomMouse",
			cost = 50,
		},
		["Pledge Algorithm"] = {
			key = "Pledge",
			cost = 75,
		},
		["Trémaux Algorithm"] = {
			key = "Tremaux",
			cost = 125,
		},
		["Depth-First Search"] = {
			key = "DFS",
			cost = 150,
		},
		["Breadth-First Search"] = {
			key = "BFS",
			cost = 200,
		},
		["Greedy Best-First"] = {
			key = "GreedyBestFirst",
			cost = 275,
		},
		["Dijkstra"] = {
			key = "Dijkstra",
			cost = 300,
		},
		["Bidirectional BFS"] = {
			key = "BidirectionalBFS",
			cost = 325,
		},
		["A* Search"] = {
			key = "AStar",
			cost = 350,
		},
	},

	mazeSize = 20, -- 100x100 STUDS
	nodeSize = 5, -- 5x5 STUDS
}
