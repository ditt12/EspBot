local players = game:GetService("Players")
local runService = game:GetService("RunService")
local player = players.LocalPlayer
local camera = workspace.CurrentCamera

-- tabel untuk esp aktif
local activeESP = {}

-- fungsi rgb dinamis
local function getRainbowColor()
    local hue = tick() % 5 / 5
    return Color3.fromHSV(hue, 1, 1)
end

-- fungsi buat esp
local function createESP(target)
    if not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end
    if target.Character.HumanoidRootPart:FindFirstChild("ESPBox") then return end

    local billboard = Instance.new("BillboardGui", target.Character.HumanoidRootPart)
    billboard.Name = "ESPBox"
    billboard.Size = UDim2.new(4, 0, 6, 0)
    billboard.AlwaysOnTop = true

    local frame = Instance.new("Frame", billboard)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = getRainbowColor()
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 0

    activeESP[target] = billboard

    -- update warna rgb dinamis
    runService.RenderStepped:Connect(function()
        if billboard.Parent and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            frame.BackgroundColor3 = getRainbowColor()
        end
    end)
end

-- hapus esp kalau target mati
local function removeESP(target)
    if activeESP[target] then
        activeESP[target]:Destroy()
        activeESP[target] = nil
    end
end

-- fungsi aimlock otomatis
local function autoAim(target)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local targetPart = target.Character.HumanoidRootPart
        camera.CFrame = CFrame.new(camera.CFrame.Position, targetPart.Position)
    end
end

-- fungsi magic bullet otomatis
local function magicBullet(target)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local targetPart = target.Character.HumanoidRootPart
        local direction = (targetPart.Position - player.Character.HumanoidRootPart.Position).Unit
        for i = 1, 8 do -- peluru lebih banyak
            local bullet = Instance.new("Part", workspace)
            bullet.Size = Vector3.new(2, 2, 20) -- peluru lebih lebar dan panjang
            bullet.Anchored = true
            bullet.CanCollide = false
            bullet.Position = player.Character.HumanoidRootPart.Position + (direction * i * 8)
            bullet.Color = Color3.new(1, 0, 0)
            game.Debris:AddItem(bullet, 0.2) -- peluru hilang setelah 0.2s
        end
    end
end

-- update esp dan aimlock secara otomatis
runService.RenderStepped:Connect(function()
    for _, target in pairs(players:GetPlayers()) do
        if target ~= player and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            if not activeESP[target] then
                createESP(target)
            end
            autoAim(target) -- aimlock otomatis
            magicBullet(target) -- magic bullet otomatis
        else
            removeESP(target)
        end
    end
end)
