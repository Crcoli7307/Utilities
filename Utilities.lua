--// Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

--// Variables
local LocalPlayer = Players.LocalPlayer
local Mouse = Players:GetMouse()

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
    local R, G, B = Color.R + Color2.R, Color.G + Color2.G, Color.B + Color2.B
    return Color3.fromRGB(
        math.min(R * 255, 255),
        math.min(G * 255, 255),
        math.min(B * 255, 255)
    )
end

function Utilities.Color.Sub(Color, Color2)
    local R, G, B = Color.R - Color2.R, Color.G - Color2.G, Color.B - Color2.B
    return Color3.fromRGB(
        math.min(R * 255, 255),
        math.min(G * 255, 255),
        math.min(B * 255, 255)
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

function Utilities.Ui.MakeDraggable(Object, DragFrame, Smoothness)
    local StartPos 
    local Dragging = false

    DragFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            StartPos = Vector2.new(
                Mouse.X - Object.AbsolutePosition.X,
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
                Position = UDim2.new(0, Mouse.X - StartPos.X, 0, Mouse.Y - StartPos.Y) 
            }):Play()
        end
    end)
end

-- Others
function Utilities.SetDefault(Defaults, Options)
    Defaults, Options = Defaults or {}, Options or {}

    for Option, Value in next, Options do
        Defaults[Option] = Value
    end

    return Defaults
end

return Utilities