--!strict

--[[
    Debug View
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local fusion = require(ReplicatedStorage.Packages.fusion)
local Children, Child = fusion.Children, fusion.Child

type Fusion = typeof(fusion)
type Scope<T = Fusion> = fusion.Scope<T>
type UsedAs<T> = fusion.UsedAs<T>

type UnknownTable = {[unknown]: unknown}
type StackTrace = { depth: number, [unknown]: boolean }

-- TODO: We should probably pull this from the theme
local BACKGROUND_COLOR: Color3 = Color3.new(0.772549, 0.831373, 1)
local PRIMITIVE_COLOR_MAP: {[string]: Color3} = {
    ["string"] = Color3.new(0.043137, 0.219608, 0.129412),
    ["number"] = Color3.new(0.160784, 0.2, 0.411765),
    ["boolean"] = Color3.new(0.388235, 0.164706, 0.176471)
} 

local STACK_DEPTH_LIMIT: number = 10

local function Header(scope: Scope, content: string): Instance
    return scope:New "TextLabel" {
        LayoutOrder = 1,

        Size = UDim2.fromScale(0.1, 0),
        AutomaticSize = Enum.AutomaticSize.XY,
        
        BackgroundTransparency = 0.75,
        BackgroundColor3 = BACKGROUND_COLOR,
        
        Text = content,
        TextXAlignment = Enum.TextXAlignment.Left,
        FontFace = Font.fromEnum(Enum.Font.BuilderSansBold)
    }
end

local function Primitive(scope: Scope, value: unknown): Instance
    local valueType = typeof(value)
    return scope:New "TextLabel" {
        LayoutOrder = 2,

        Size = UDim2.fromScale(0, 0),
        AutomaticSize = Enum.AutomaticSize.XY,
        
        BackgroundTransparency = 1,

        Text = if valueType == "string" then `"{value}"` else tostring(value),
        TextColor3 = PRIMITIVE_COLOR_MAP[valueType] or Color3.new(),
        TextXAlignment = Enum.TextXAlignment.Left
    }
end

local function Collection(scope: Scope, children: {Instance}): Instance
    return scope:New "Frame" {
        LayoutOrder = 2,

        Size = UDim2.new(1, 0, 0, 10),
        AutomaticSize = Enum.AutomaticSize.XY,

        BackgroundTransparency = 1,

        [Children] = Child {
            scope:New "UIListLayout" {
                Padding = UDim.new(0, 5)
            },
            children
        }
    }
end

local function Builder(scope: Scope, name: string, data: unknown, trace: StackTrace?): Instance
    local stack = trace or setmetatable({ depth = 0 }, { __mode = "k" }) :: any
    if stack.depth >= STACK_DEPTH_LIMIT then return Primitive(scope, "[🛑]") end

    local header = Header(scope, name)

    local body: Instance
    if typeof(data) == "table" then
        if not stack[data] then
            (stack :: StackTrace)[data] = true

            local children: {Instance} = {}
            for key, value in data :: UnknownTable do
                local instance = Builder(scope, tostring(key), value, stack)
                table.insert(children, instance)
            end
            body = Collection(scope, children)
        else
            data = "[🔁]"
        end
    end

    if not body then
        -- I'm just going to assume everything else is some primitive.
        -- TODO: We do need to handle for Instances though!
        body = Primitive(scope, data)
    end

    return scope:New "Frame" {
        Size = UDim2.new(1, 0, 0, 10),
        AutomaticSize = Enum.AutomaticSize.XY,

        BackgroundTransparency = 1,

        [Children] = {
            scope:New "UIListLayout" {
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = UDim.new(0, 5),
                SortOrder = Enum.SortOrder.LayoutOrder
            },
            header, body
        }
    }
end

type Props = {
    Parent: UsedAs<Instance?>?,
    States: UsedAs<{[string]: unknown}>
}

return function (scope: Scope, props: Props)
    scope = scope:innerScope()

    local stateRows = scope:ForPairs(props.States, function (_, scope: Scope, key: string, value: unknown)
        scope = scope:innerScope()
        return key, Builder(scope, key, value)
    end)
    
    return scope:New "Frame" {
        Name = "Debug [View]",
        Parent = props.Parent,

        Position = UDim2.fromOffset(5, 5),
        Size = UDim2.fromScale(0.1, 1),

        BackgroundTransparency = 1,

        [Children] = {
            scope:New "UIListLayout" {
                Padding = UDim.new(0, 5),
                SortOrder = Enum.SortOrder.LayoutOrder
            },
            scope:New "TextLabel" {
                LayoutOrder = 1,

                Size = UDim2.new(0.25, 0, 0, 20),
                AutomaticSize = Enum.AutomaticSize.XY,

                BackgroundTransparency = 0.75,
                BackgroundColor3 = BACKGROUND_COLOR,

                Text = "[ DEBUG ]",
                TextXAlignment = Enum.TextXAlignment.Left,
                FontFace = Font.fromEnum(Enum.Font.BuilderSansBold)
            },
            scope:New "Frame" {
                LayoutOrder = 2,

                Position = UDim2.fromOffset(5, 5),
                Size = UDim2.fromScale(1, 0.5),

                BackgroundTransparency = 1,

                [Children] = Child {
                    stateRows,
                    scope:New "UIListLayout" {
                        Padding = UDim.new(0, 5)
                    }
                }
            }
        }
    }
end