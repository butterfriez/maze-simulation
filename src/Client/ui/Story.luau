--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Sift = require(ReplicatedStorage.Packages.Sift)

local Fusion = require(ReplicatedStorage.Packages.Fusion)
type Fusion = typeof(Fusion)
type Scope<T = Fusion> = Fusion.Scope<T>

type Controls = { [any]: any }
export type Props<T = Controls> = {
	scope: Scope,
	target: GuiObject,
	controls: T,
}

local UILabs = ReplicatedStorage.Packages:FindFirstChild("UILabs")
local Module = if UILabs
	then require(UILabs)
	else setmetatable({}, {
		__index = function()
			error("UILabs is missing from environment!")
		end,
	}) :: any

local function construct(render: (props: Props) -> any?, controls: Controls?)
	return Module.CreateFusionStory({
		fusion = Fusion,
		controls = controls,
	}, render)
end

return table.freeze {
	Available = (UILabs ~= nil) :: true, --> Tells the type solver its there (even if its not)
	Controls = Sift.Dictionary.join :: (...any) -> Controls,
	Build = construct,
}
