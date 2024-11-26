-- Inisialisasi
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local lockDistance = 50  -- Jarak maksimal untuk aimlock (dalam studs)
local aimStrength = 1.0  -- Kekuatan aimlock 100%

local espColor = Color3.fromRGB(255, 0, 0)  -- Warna ESP Merah

-- Fungsi untuk membuat box ESP di sekitar target
local function createESP(target)
    if not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end
    
    -- Membuat box ESP di sekitar musuh
    local box = Instance.new("BillboardGui")
    box.Adornee = target.Character:WaitForChild("HumanoidRootPart")
    box.Size = UDim2.new(0, 200, 0, 50)
    box.StudsOffset = Vector3.new(0, 2, 0)
    box.AlwaysOnTop = true
    box.Parent = target.Character
    
    -- Label untuk ESP
    local label = Instance.new("TextLabel")
    label.Text = target.Name
    label.TextColor3 = espColor
    label.Size = UDim2.new(1, 0, 1, 0)
    label.TextSize = 18
    label.BackgroundTransparency = 1
    label.Parent = box
end

-- Fungsi untuk aimlock ke musuh dengan kekuatan 100%
local function aimlock()
    while true do
        -- Menunggu jika tidak ada pemain musuh yang terdeteksi
        local target = nil
        local shortestDistance = lockDistance
        for _, enemy in pairs(game.Players:GetPlayers()) do
            if enemy ~= player and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
                local enemyRoot = enemy.Character.HumanoidRootPart
                local distance = (humanoidRootPart.Position - enemyRoot.Position).Magnitude

                -- Hanya pilih musuh yang masih hidup
                local health = enemy.Character:FindFirstChild("Humanoid") and enemy.Character.Humanoid.Health or 0
                if distance < shortestDistance and health > 0 then
                    target = enemy
                    shortestDistance = distance
                end
            end
        end
        
        -- Jika ada target yang valid, arahkan ke target tersebut
        if target then
            local targetPos = target.Character.HumanoidRootPart.Position
            local direction = (targetPos - humanoidRootPart.Position).unit
            -- Arahkan humanoid root part ke target dengan kekuatan aimlock 100%
            humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position, humanoidRootPart.Position + direction * aimStrength)
        end
        wait(0.1)
    end
end

-- Fungsi untuk memeriksa pemain yang ada di dalam server dan memperbarui ESP
local function updateESP()
    for _, enemy in pairs(game.Players:GetPlayers()) do
        if enemy ~= player and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
            -- Cek apakah musuh sudah memiliki ESP
            local existingESP = enemy.Character:FindFirstChildOfClass("BillboardGui")
            if not existingESP then
                -- Buat ESP baru jika belum ada
                createESP(enemy)
            end
        end
    end
end

-- Menjalankan update ESP setiap beberapa detik
while true do
    updateESP()  -- Memperbarui ESP untuk setiap pemain
    wait(1)  -- Update setiap 1 detik untuk menangani respawn dan death
end

-- Mulai Aimlock secara otomatis
aimlock()