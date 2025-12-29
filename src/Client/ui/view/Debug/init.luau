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

type Props = {
    Parent: UsedAs<Instance?>?,
    States: UsedAs<{[string]: unknown}>
}

return function (scope: Scope, props: Props)
    scope = scope:innerScope()

    local stateRows = scope:ForPairs(props.States, function (_, scope: Scope, key: string, value: unknown)
        scope = scope:innerScope()

        local header = scope:New "TextLabel" {
            Size = UDim2.fromScale(0.25, 0),
            AutomaticSize = Enum.AutomaticSize.XY,
            
            BackgroundTransparency = 0.75,
            BackgroundColor3 = Color3.new(0.772549, 0.831373, 1),
            
            Text = key,
            TextXAlignment = Enum.TextXAlignment.Left,
            FontFace = Font.fromEnum(Enum.Font.BuilderSansBold)
        }

        local body: Instance
        if typeof(value) == "table" then
            body = scope:New "TextLabel" {
                Size = UDim2.fromScale(0, 0),
                AutomaticSize = Enum.AutomaticSize.XY,
                
                BackgroundTransparency = 1,

                Text = "[ WIP ]",
                TextXAlignment = Enum.TextXAlignment.Left
            }
        else
            body = scope:New "TextLabel" {
                Size = UDim2.fromScale(0, 0),
                AutomaticSize = Enum.AutomaticSize.XY,
                
                BackgroundTransparency = 1,

                Text = tostring(value),
                TextXAlignment = Enum.TextXAlignment.Left
            }
        end

        local container = scope:New "Frame" {
            Size = UDim2.new(1, 0, 0, 10),
            AutomaticSize = Enum.AutomaticSize.XY,

            BackgroundTransparency = 1,

            [Children] = {
                scope:New "UIListLayout" {
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 5)
                },
                header, body
            }
        }
        return key, container
    end)
    
    return scope:New "Frame" {
        Name = "Debug [View]",
        Parent = props.Parent,

        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1),

        BackgroundTransparency = 1,

        [Children] = {
            scope:New "Frame" {
                Position = UDim2.fromOffset(5, 5),
                Size = UDim2.fromScale(0.1, 0.5),

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