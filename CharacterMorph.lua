repeat
    task.wait()
until game:IsLoaded()

--// Services
local Players = game:GetService("Players")

--// Variables
local LocalPlayer = Players.LocalPlayer
local RigType = LocalPlayer.Character.Humanoid.RigType

local Settings = {
    ["UserId"] = "991117111"
}

--// Functions
function Transform()
    local Model = Players:GetCharacterAppearanceAsync(Settings["UserId"])

    task.spawn(function()
        -- Remove existing accessories and clothing
        for _, Child in pairs(LocalPlayer.Character:GetDescendants()) do
            if Child:IsA("Accessory") or Child:IsA("Shirt") or Child:IsA("Pants") or Child:IsA("CharacterMesh") or Child:IsA("BodyColors") then
                Child:Destroy()
            end
        end 
    end)

    task.wait(0.1)

    for _, Child in pairs(Model:GetChildren()) do
        if Child:IsA("Shirt") or Child:IsA("Pants") or Child:IsA("BodyColors") then
            -- Add clothing
            Child.Parent = LocalPlayer.Character
        elseif Child:IsA("Accessory") then
            -- Add accessory
            LocalPlayer.Character.Humanoid:AddAccessory(Child)
        elseif Child:IsA("CharacterMesh") then
            -- Add character mesh
            if Child.Name == "R6" and RigType == Enum.HumanoidRigType.R6 then
                Child.Parent = LocalPlayer.Character
            elseif Child.Name == "R15" and RigType == Enum.HumanoidRigType.R15 then
                Child.Parent = LocalPlayer.Character
            end
        end
    end

    -- Add face
    if Model:FindFirstChild("face") then
        pcall(function()
            LocalPlayer.Character.Head.face:Destroy()
            Model.face.Parent = LocalPlayer.Character.Head
        end)
    end

    -- Reload character to fix accessories
    local OldParent = LocalPlayer.Character.Parent
    LocalPlayer.Character.Parent = game
    LocalPlayer.Character.Parent = OldParent
end

Transform()

LocalPlayer.CharacterAdded:Connect(function()
    Transform()
end)
