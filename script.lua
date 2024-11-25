local players = game:GetService("Players")
local runService = game:GetService("RunService")
local player = players.LocalPlayer
local camera = workspace.CurrentCamera

-- tabel untuk esp
local activeESP = {}

-- fungsi rgb dinamis untuk ESP
local function getRainbowColor()
    local hue = tick() % 5 / 5
    return Color3.fromHSV(hue, 1, 1)
end

-- fungsi buat esp
local function createESP(target)
    if target.Character and target.Character:FindFirstChild("HumanoidRootPart") and not activeESP[target] then
        local billboard = Instance.new("BillboardGui", target.Character.HumanoidRootPart)
        billboard.Name = "ESPBox"
        billboard.Size = UDim2.new(4, 0, 6, 0)
        billboard.AlwaysOnTop = true

        local frame = Instance.new("Frame", billboard)
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundColor3 = getRainbowColor()  -- Menggunakan warna RGB dinamis untuk ESP
        frame.BackgroundTransparency = 0.5
        frame.BorderSizePixel = 0

        activeESP[target] = billboard

        -- update warna RGB secara dinamis
        runService.RenderStepped:Connect(function()
            if billboard and billboard.Parent and frame then
                frame.BackgroundColor3 = getRainbowColor()  -- Pastikan tetap warna RGB dinamis
            end
        end)
        
        -- ESP tetap ada meskipun target mati
        target.Character:WaitForChild("Humanoid").Died:Connect(function()
            -- Tanpa menghapus ESP saat mati, jadi tetap ada
        end)
    end
end

-- fungsi untuk menghapus ESP
local function removeESP(target)
    if activeESP[target] then
        activeESP[target]:Destroy()
        activeESP[target] = nil
    end
end

-- fungsi aimlock otomatis ke target
local function autoAim(target)
    if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local targetPart = target.Character.HumanoidRootPart
        camera.CFrame = CFrame.new(camera.CFrame.Position, targetPart.Position)
    end
end

-- magic bullet otomatis
local function magicBullet(target)
    if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local targetPart = target.Character.HumanoidRootPart
        local direction = (targetPart.Position - player.Character.HumanoidRootPart.Position).Unit
        for i = 1, 8 do
            local bullet = Instance.new("Part", workspace)
            bullet.Size = Vector3.new(2, 2, 20)
            bullet.Anchored = true
            bullet.CanCollide = false
            bullet.Position = player.Character.HumanoidRootPart.Position + (direction * i * 8)
            bullet.Color = Color3.new(1, 0, 0)  -- Warna merah untuk magic bullet
            game.Debris:AddItem(bullet, 0.2)
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

-- Menambahkan label ©Kelperiens di sudut kiri bawah
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local label = Instance.new("TextLabel", screenGui)
label.Size = UDim2.new(0, 200, 0, 50)
label.Position = UDim2.new(0, 10, 1, -60)  -- Posisi di kiri bawah
label.Text = "©Kelperiens"
label.TextColor3 = Color3.new(1, 0, 0)  -- Merah
label.BackgroundTransparency = 1  -- Transparan
label.TextSize = 20
label.Font = Enum.Font.SourceSansBold
label.TextStrokeTransparency = 0.8
label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)  -- Memberikan efek bayangan hitam
