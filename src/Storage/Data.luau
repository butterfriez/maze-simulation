local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local DocumentService = require(ReplicatedStorage.Packages.DocumentService)
local t = require(ReplicatedStorage.Packages.t)

type SerC3 = {
	r: number,
	g: number,
	b: number,
}

type DataSchema = {
	coins: number,
	mazeGenerationAlgorithm: string,
	mazeSolverAlgorithm: string,
	ratColor: SerC3,
	uiTheme: string,
}

local DataInterface = {
	coins = t.number,
	mazeGenerationAlgorithm = t.string,
	mazeSolverAlgorithm = t.string,
	ratColor = t.interface({
		r = t.number,
		g = t.number,
		b = t.number,
	}),
	uiTheme = t.string,
}

local function dataCheck(value: any): DataSchema
	assert(type(value) == "table", "Data must be a table")
	local Value = value

	return {
		coins = DataInterface.coins(Value.coins),
		mazeGenerationAlgorithm = DataInterface.mazeGenerationAlgorithm(Value.mazeGenerationAlgorithm),
		mazeSolverAlgorithm = DataInterface.mazeSolverAlgorithm(Value.mazeSolverAlgorithm),
		ratColor = DataInterface.ratColor(Value.ratColor),
		uiTheme = DataInterface.uiTheme(Value.uiTheme),
	}
end

local store = DocumentService.DocumentStore.new({
	dataStore = DataStoreService:GetDataStore(if RunService:IsStudio() then "Dev-0" else "Prod-0") :: any,
	check = function(value)
		return dataCheck(value)
	end,
	default = {
		coins = 0,
		mazeGenerationAlgorithm = "Recursive Backtracker",
		mazeSolverAlgorithm = "Wall Follower",
		ratColor = { r = 0, g = 0, b = 0 },
	},
	migrations = {
		{
			migrate = function(old)
				old = table.clone(old)
				old.uiTheme = "Dark"
				return old
			end,
			backwardsCompatible = true,
		},
	},
	lockSessions = true,
})

local Documents: { [string]: DocumentService.Document<DataSchema> } = {}

local function LoadData(player: Player)
	local document = store:GetDocument(tostring(player.UserId))
	local result = document:Open()

	if not result.success and result.reason == "SessionLockedError" then
		document:Steal()
		result = document:Open()
	end

	if not result.success then
		if result.reason == "BackwardsCompatibilityError" then
			player:Kick(
				"You joined an old server which does not support your saved data."
					.. "Please try joining another server. If this persists, contact a developer."
			)
		end

		if result.reason == "RobloxAPIError" then
			player:Kick("Failed to load data due to a Roblox service issue. Try again later.")
		end

		player:Kick(
			`Failed to load data: {result.reason}. Please screenshot this message and report it to a developer.`
		)

		return false
	end

	Documents[player.Name] = document
end

local function GetPlayerData(player: string)
	if Documents[player]:IsOpen() then
		return Documents[player]:GetCache()
	end

	return nil
end

local function SetPlayerData(player: string, data: DataSchema)
	if Documents[player]:IsOpen() then
		Documents[player]:SetCache(data)
	end
end

local function SavePlayerData(player: string)
	if Documents[player]:IsOpen() then
		Documents[player]:Save()
		Documents[player] = nil
	end
end

return {
	LoadData = LoadData,
	GetPlayerData = GetPlayerData,
	SetPlayerData = SetPlayerData,
	SavePlayerData = SavePlayerData,
}
