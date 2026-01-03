local ReplicatedStorage = game:GetService("ReplicatedStorage")
local networking = require(ReplicatedStorage.networking)
return {
	Name = "startgame",
	Aliases = { "sg" },
	Description = "Starts a game locally.",
	Group = "Admin",
	Args = {},

	ClientRun = function(_, player)
		networking.startGame:fire()

		return "Game started."
	end,
}
