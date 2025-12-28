--!strict

--[[
    Generates a sourcemap from an active project sync tool: Rojo or Argon.
    Then installs packages via wally, re-typing them with wally-package-types.
]]

local process = require("@lune/process")

local PROJECT_FILE = "default.project.json"
local PROJECT_SYNC_TOOLS = { "rojo", "argon" }
local EXC_OPTIONS: process.ExecOptions = { stdio = "forward" }

for _, tool in PROJECT_SYNC_TOOLS do
    local success = pcall(process.exec, tool, {"sourcemap", PROJECT_FILE, "--output", "sourcemap.json"}, EXC_OPTIONS)
    if success then break end
end

process.exec("wally", {"install"}, EXC_OPTIONS)
process.exec("wally-package-types", {"Packages", "--sourcemap", "sourcemap.json"}, EXC_OPTIONS)