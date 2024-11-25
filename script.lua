-- Inisialisasi player
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local espEnabled = true
local magicBulletEnabled = true
local aimlockEnabled = true

-- Fungsi untuk membuat ESP
local function createESP(target)
    if not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local espBox = Instance.new("BillboardGui", target.Character.HumanoidRootPart)
    espBox.Size = UDim2.new(0, 100, 0, 100)
    espBox.Adornee = target.Character.HumanoidRootPart
    espBox.AlwaysOnTop = true
    espBox.BackgroundTransparency = 1
    espBox.Name = "ESPBox"

    local espFrame = Instance.new("Frame", espBox)
    espFrame.Size = UDim2.new(1, 0, 1, 0)
    espFrame.BackgroundTransparency = 0.5
    espFrame.BorderSizePixel = 0
    espFrame.BackgroundColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)  -- RGB effect on ESP
    
    game.Debris:AddItem(espBox, 10)  -- Hapus ESP setelah 10 detik
end

-- Fungsi magic bullet otomatis yang lebih sedikit dan lebih kecil
local function magicBullet(target)
    if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local targetPart = target.Character.HumanoidRootPart
        local direction = (targetPart.Position - player.Character.HumanoidRootPart.Position).Unit
        for i = 1, 4 do  -- Mengurangi jumlah bullet dari 8 menjadi 4
            local bullet = Instance.new("Part", workspace)
            bullet.Size = Vector3.new(1, 1, 5)  -- Mengurangi ukuran bullet
            bullet.Anchored = true
            bullet.CanCollide = false
            bullet.Position = player.Character.HumanoidRootPart.Position + (direction * i * 5)  -- Mengurangi jarak antar bullet
            bullet.Color = Color3.new(1, 0, 0)  -- Warna merah untuk magic bullet
            bullet.Transparency = 0.8  -- Memberikan transparansi agar tidak terlalu mengganggu pandangan
            game.Debris:AddItem(bullet, 0.5)  -- Menghapus bullet setelah beberapa detik
        end
    end
end

-- Fungsi untuk Aimlock
local function aimlock()
    if aimlockEnabled then
        local closestTarget
        local shortestDistance = math.huge
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (v.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if distance < shortestDistance then
                    closestTarget = v
                    shortestDistance = distance
                end
            end
        end
        
        if closestTarget then
            local targetPosition = closestTarget.Character.HumanoidRootPart.Position
            player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
        end
    end
end

-- Label untuk text ©Kelperiens
local function createLabel()
    local label = Instance.new("TextLabel", game.CoreGui)
    label.Text = "©Kelperiens"
    label.TextColor3 = Color3.fromRGB(255, 0, 0)  -- Merah
    label.TextSize = 30
    label.Position = UDim2.new(0, 10, 1, -50)  -- Posisi di kiri bawah
    label.BackgroundTransparency = 1
    label.TextStrokeTransparency = 0.5
end

-- Aktifkan ESP, Magic Bullet, dan Label
local function activate()
    createLabel()
    
    -- Enable ESP untuk setiap player di server
    game.Players.PlayerAdded:Connect(function(target)
        target.CharacterAdded:Connect(function()
            if espEnabled then
                createESP(target)
            end
        end)
    end)
    
    -- Aktifkan Magic Bullet jika diaktifkan
    game:GetService("RunService").Heartbeat:Connect(function()
        if magicBulletEnabled then
            for _, target in pairs(game.Players:GetPlayers()) do
                if target ~= player then
                    magicBullet(target)
                end
            end
        end
    end)

    -- Aktifkan Aimlock
    game:GetService("RunService").Heartbeat:Connect(aimlock)
end

-- Jalankan fungsi utama
activate()