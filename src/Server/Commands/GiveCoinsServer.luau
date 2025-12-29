local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local PlayerState = require(ReplicatedStorage.state.atoms.PlayerState)

return function(context, player, amount)  
    if player ~= nil and Players:FindFirstChild(player.Name) then
        PlayerState.UpdatePlayerState(player.Name, function(currentState)
            currentState = table.clone(currentState)
            currentState.coins += amount

            return currentState
        end)
    
        return `Successfully gave {player.Name} {amount} coins`
    end

    return `Player is not in server`
end