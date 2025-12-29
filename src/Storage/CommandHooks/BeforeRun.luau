-- Couldn't find a better place to place hooks

local Admins = {
    game.CreatorId,
}

return function(registry)
    registry:RegisterHook("BeforeRun", function(context)
        if context.Group == "DefaultAdmin" and not table.find(Admins, context.Executor.UserId) then
            return "You don't have permission to run this command"
        end
    end)
end