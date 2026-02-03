--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Widget: DockWidgetPluginGui? = nil
do -- Retrieve the environment for sounds played in UI stories:
	local module = ReplicatedStorage.Packages:FindFirstChild("UILabs")
	if module then
		local UILabs = require(module)
		Widget = UILabs.Environment.PluginWidget
	end
end

export type SoundPath = Folder | Sound | { Sound }

local sounds: { [string]: Sound } = {}
local loaded: { [SoundPath]: true } = setmetatable({}, { __mode = "k" })

local function Load(path: SoundPath, force: boolean?)
	if not force and loaded[path] then return end
	if typeof(path) == "Instance" then
		if path:IsA("Sound") then
			sounds[path.Name] = path
			return --> Bypass caching if given a Sound directly
		end
		for _, child in path:GetChildren() do
			if not child:IsA("Sound") then continue end
			sounds[child.Name] = child
		end
	elseif typeof(path) == "table" then
		for _, child in path do
			if not child:IsA("Sound") then continue end
			sounds[child.Name] = child
		end
	else
		error("Couldn't get Sounds... Path isn't a folder or a table!")
	end
	loaded[path] = true --> Cached to prevent future unintentional loads
end

local function Get(name: string, clone: boolean?): Sound
	local sound = sounds[name]
	return if clone or Widget then sound:Clone() else sound
end

local function Play(sound: Sound)
	if Widget then
		sound.Parent = Widget
		sound.Ended:Connect(function()
			sound:Destroy()
		end)
	end
	sound:Play()
end

return {
	Load = Load,
	Get = Get,
	Play = Play,
}
