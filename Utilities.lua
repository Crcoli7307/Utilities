--// Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

--// Variables
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

--// Api
local Utilities = {
    ["Color"] = {},
    ["Ui"] = {
        ["ForcedProps"] = {
            ["Text"] = "",
            ["Font"] = Enum.Font.SourceSans
        }
    }
}

-- Color
function Utilities.Color.Add(Color, Color2)
    return Color3.fromRGB(
        math.min((Color.R + Color2.R) * 255, 255),
        math.min((Color.G + Color2.G) * 255, 255),
        math.min((Color.B + Color2.B) * 255, 255)
    )
end

function Utilities.Color.Sub(Color, Color2)
    return Color3.fromRGB(
        math.min((Color.R - Color2.R) * 255, 255),
        math.min((Color.G - Color2.G) * 255, 255),
        math.min((Color.B - Color2.B) * 255, 255)
    )
end

-- Ui
function Utilities.Ui.CreateObject(Class, Properties, Radius)
    local _Object = Instance.new(Class)

    for Property, Value in next, Utilities["Ui"]["ForcedProps"] do
        pcall(function()
            _Object[Property] = Value
        end)
    end

    for Property, Value in next, Properties do
        if Property ~= "Parent" then
            if typeof(Value) == "Instance" then
                Value.Parent = _Object
            else
                _Object[Property] = Value
            end
        end
    end

    if Radius then
        Instance.new("UICorner", _Object).CornerRadius = UDim.new(0, Radius)
    end

    return _Object
end

function Utilities.Ui.Pop(Object, Shrink)
    local ObjClone = Object:Clone()

    ObjClone.AnchorPoint = Vector2.new(0.5, 0.5)
    ObjClone.Size = ObjClone.Size - UDim2.new(0, Shrink, 0, Shrink)
    ObjClone.Position = UDim2.new(0.5, 0, 0.5, 0)

    ObjClone.Parent = Object

    Object.BackgroundTransparency = 1

    TweenService:Create(ObjClone, TweenInfo.new(0.2), {
        Size = Object.Size
    }):Play()

    task.spawn(function()
        task.wait(0.2)
        Object.BackgroundTransparency = 0
        ObjClone:Destroy()
    end)

    return ObjClone
end

function Utilities.Ui.MakeDraggable(Object, DragFrame, Smoothness)
    local StartPos 
    local Dragging = false

    DragFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            StartPos = Vector2.new(
                Mouse.X - Object.AbsolutePosition.X ,
                Mouse.Y - Object.AbsolutePosition.Y
            )
        end
    end)

    DragFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = false
        end
    end)

    Mouse.Move:Connect(function()
        if Dragging then
            TweenService:Create(Object, TweenInfo.new(math.clamp(Smoothness, 0, 1), Enum.EasingStyle.Sine), {
                Position = UDim2.new(
                    0, 
                    Mouse.X - StartPos.X + (Object.Size.X.Offset * Object.AnchorPoint.X),
                    0, 
                    Mouse.Y - StartPos.Y + (Object.Size.Y.Offset * Object.AnchorPoint.Y)
                )
            }):Play()
        end
    end)
end
