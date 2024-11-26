-- Aimlock dan ESP untuk semua pemain (mati atau hidup)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local lockDistance = 50  -- Jarak maksimal untuk aimlock (dalam studs)
local aimStrength = 0.97  -- Kekuatan aimlock 97%

local espColor = Color3.fromRGB(255, 0, 0)  -- Warna ESP Merah

-- Fungsi untuk membuat box ESP di sekitar target
local function createESP(target)
    -- Memastikan box ESP selalu ada meskipun target mati
    local box = Instance.new("BillboardGui")
    box.Adornee = target.Character:WaitForChild("UpperTorso")
    box.Size = UDim2.new(0, 200, 0, 50)
    box.StudsOffset = Vector3.new(0, 2, 0)
    box.AlwaysOnTop = true
    box.Parent = target.Character
    
    local label = Instance.new("TextLabel")
    label.Text = target.Name
    label.TextColor3 = espColor
    label.Size = UDim2.new(1, 0, 1, 0)
    label.TextSize = 18
    label.BackgroundTransparency = 1
    label.Parent = box
end

-- Fungsi untuk lock aim ke musuh
local function aimlock()
    while true do
        -- Menunggu jika tidak ada pemain musuh yang terdeteksi
        local target = nil
        local shortestDistance = lockDistance
        for _, enemy in pairs(game.Players:GetPlayers()) do
            if enemy ~= player and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
                local enemyRoot = enemy.Character.HumanoidRootPart
                local distance = (humanoidRootPart.Position - enemyRoot.Position).Magnitude

                if distance < shortestDistance then
                    target = enemy
                    shortestDistance = distance
                end
            end
        end
        
        -- Jika ada target yang valid, arahkan ke target tersebut
        if target then
            local targetPos = target.Character.HumanoidRootPart.Position
            local direction = (targetPos - humanoidRootPart.Position).unit
            -- Arahkan humanoid root part ke target dengan kekuatan aimlock 97%
            humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position, humanoidRootPart.Position + direction * aimStrength)
        end
        wait(0.1)
    end
end

-- Menambahkan ESP dan menjalankan aimlock
for _, enemy in pairs(game.Players:GetPlayers()) do
    if enemy ~= player then
        createESP(enemy)
    end
end

-- Mulai Aimlock secara otomatis
aimlock()