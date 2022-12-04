repeat
    task.wait()
until game:IsLoaded()

--// Services
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

--// Variables
local Settings = {
    ["Name"] = "XBlueSkyCC",
    ["UserId"] = "1"
}

--// Core
function HideNick(Object)
    local function _(Object, Property)
        Object[Property] = Object[Property]:gsub(LocalPlayer.Name, Settings["Name"])
        Object[Property] = Object[Property]:gsub(LocalPlayer.DisplayName, Settings["Name"])
        Object[Property] = Object[Property]:gsub(LocalPlayer.UserId, Settings["UserId"])
    end

    if Object:IsA("TextLabel") or Object:IsA("TextButton") then
        _(Object, "Text")

        Object:GetPropertyChangedSignal("Text"):connect(function()
            _(Object, "Text")
        end)
    end

    -- ?User Thumbnail
    if Object:IsA("ImageLabel") then
        _(Object, "Image")

        Object:GetPropertyChangedSignal("Image"):connect(function()
            _(Object, "Image")
        end)
    end
end

for _, Child in pairs(game:GetDescendants()) do
    HideNick(Child)
end

game.DescendantAdded:Connect(HideNick)