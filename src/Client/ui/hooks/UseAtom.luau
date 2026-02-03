local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Charm = require(ReplicatedStorage.Packages.Charm)
-- https://discord.com/channels/385151591524597761/895437663040077834/1383591681735135264 <3
return function<T>(scope, selector: () -> T)
	local state = scope:Value(selector())
	local disconnect = Charm.subscribe(selector, function(v)
		state:set(v)
	end)
	table.insert(scope, disconnect)
	return state
end
