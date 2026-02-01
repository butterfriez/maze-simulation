local Sounds: { [string]: Sound } = {}

local function LoadSounds(path: Folder | { Sound })
	if typeof(path) == "Instance" then
		for _, child in path:GetChildren() do
			if not child:IsA("Sound") then continue end
			Sounds[child.Name] = child
		end
		return
	elseif typeof(path) == "table" then
		for _, child in path do
			if not child:IsA("Sound") then continue end
			Sounds[child.Name] = child
		end
		return
	end

	print(Sounds)

	error("Couldn't get Sounds... Path isn't a folder or a table")
end

local function GetSound(name)
	return Sounds[name] :: Sound
end

return {
	LoadSounds = LoadSounds,
	GetSound = GetSound,
}
