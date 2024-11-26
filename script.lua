local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

function CreateESP(target)
    if target:FindFirstChild("Humanoid") and not target:FindFirstChild("ESPBox") then
        local espBox = Instance.new("BoxHandleAdornment")
        espBox.Name = "ESPBox"
        espBox.Adornee = target
        espBox.Size = target.Size + Vector3.new(1.5, 1.5, 1.5)
        espBox.Color3 = Color3.new(math.random(), math.random(), math.random())
        espBox.AlwaysOnTop = true
        espBox.ZIndex = 10
        espBox.Parent = target
    end
end

function RemoveESP(target)
    if target:FindFirstChild("ESPBox") then
        target:FindFirstChild("ESPBox"):Destroy()
    end
end

function UpdateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            CreateESP(player.Character)
        elseif player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health <= 0 then
            RemoveESP(player.Character)
        end
    end
end

function MagicBullet(target)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = target.Character.HumanoidRootPart
        hrp.Position = hrp.Position + Vector3.new(0, 0, 0.5)
    end
end

function AimLock(target)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = target.Character.HumanoidRootPart
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position, hrp.Position)
    end
end

RunService.RenderStepped:Connect(function()
    UpdateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            MagicBullet(player)
            AimLock(player)
        end
    end
end)