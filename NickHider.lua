--// Services
local Players = game:GetService("Players")

--// Variables
local LocalPlayer = Players.LocalPlayer

local Settings = {
    ["All"] = {
        ["Name"] = "XBlueSkyCC",
        ["UserId"] = "1"
    },
    ["4520749081"] = {
        ["Name"] = Utilities.RandomString(math.random(10, 15)),
        ["UserId"] = "991117111" -- Who the fuck is this??
    }
}

--// Core
function HideNick(Object)
    local _Settings = Settings[game.GameId] or Settings["All"]

    local function _(Object, Property)
        local newValue = Object[Property]:gsub(LocalPlayer.Name, _Settings["Name"])
        newValue = newValue:gsub(LocalPlayer.DisplayName, _Settings["Name"])
        newValue = newValue:gsub(LocalPlayer.UserId, _Settings["UserId"])
        Object[Property] = newValue
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
