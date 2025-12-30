local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RecursiveBacktracker = require(ReplicatedStorage.maze.Generation.RecursiveBacktracker)
return function(_, mazeAlgorithm)  
    local maze = nil

    if mazeAlgorithm == "Recursive Backtracker" then
        maze = RecursiveBacktracker.new()
        maze:Generate()

        while maze:IsComplete() == false do
            task.wait()
        end

        maze:Build()
    end

end