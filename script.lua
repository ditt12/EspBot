-- Inisialisasi
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local lockDistance = 100  -- Jarak maksimal untuk aimlock (dalam studs)
local aimStrength = 0.95  -- Kekuatan aimlock 95%

local espColor = Color3.fromRGB(255, 0, 0)  -- Warna ESP Merah

-- Fungsi untuk membuat ESP di atas kepala karakter musuh
local function createESP(target)
    if not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end
    
    -- Membuat BillboardGui untuk ESP
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = target.Character:WaitForChild("Head")  -- Menempel di kepala karakter
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2, 0)  -- Posisi offset sedikit di atas kepala
    billboard.AlwaysOnTop = true
    billboard.Parent = target.Character
    
    -- Label untuk menampilkan nama karakter sebagai ESP
    local label = Instance.new("TextLabel")
    label.Text = target.Name
    label.TextColor3 = espColor
    label.Size = UDim2.new(1, 0, 1, 0)
    label.TextSize = 18
    label.BackgroundTransparency = 1
    label.Parent = billboard
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

-- Fungsi untuk mencari musuh terdekat
local function findClosestEnemy()
    local closestDistance = lockDistance
    local closestTarget = nil
    
    -- Loop untuk mencari semua pemain
    for _, enemy in ipairs(game.Players:GetPlayers()) do
        if enemy ~= player and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
            local enemyRootPart = enemy.Character.HumanoidRootPart
            local distance = (humanoidRootPart.Position - enemyRootPart.Position).Magnitude
            
            -- Menyimpan target terdekat
            if distance < closestDistance then
                closestDistance = distance
                closestTarget = enemy
            end
        end
    end
    
    return closestTarget
end

-- Fungsi untuk mengunci aim ke target dengan 95% kekuatan
local function aimLock()
    local targetPlayer = findClosestEnemy()
    
    if targetPlayer then
        local targetRootPart = targetPlayer.Character.HumanoidRootPart
        -- Mengarahkan dengan kekuatan 95% agar lebih nempel
        local direction = (targetRootPart.Position - humanoidRootPart.Position).unit
        humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position, humanoidRootPart.Position + direction * aimStrength)
    end
end

-- Menjalankan update ESP setiap 1 detik
while true do
    updateESP()  -- Memperbarui ESP untuk setiap pemain
    wait(1)  -- Update setiap 1 detik untuk menangani respawn dan death
end

-- Menjalankan aimlock terus menerus
while true do
    wait(0.1)  -- Interval update
    aimLock()
end