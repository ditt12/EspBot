-- Inisialisasi
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local lockDistance = 100  -- Jarak maksimal untuk aimlock (dalam studs)

-- Fungsi untuk mencari musuh terdekat
local function findClosestEnemy()
    local closestDistance = lockDistance
    local closestTarget = nil
    
    -- Loop untuk mencari semua pemain
    for _, enemy in ipairs(game.Players:GetPlayers()) do
        if enemy ~= player and enemy.Character and enemy.Character:FindFirstChild("Head") then
            local enemyHead = enemy.Character.Head  -- Menggunakan Head sebagai target
            local distance = (humanoidRootPart.Position - enemyHead.Position).Magnitude
            
            -- Menyimpan target terdekat
            if distance < closestDistance then
                closestDistance = distance
                closestTarget = enemy
            end
        end
    end
    
    return closestTarget
end

-- Fungsi untuk mengunci aim ke target (langsung ke Kepala)
local function aimLock()
    local targetPlayer = findClosestEnemy()
    
    if targetPlayer then
        local targetHead = targetPlayer.Character.Head
        -- Pastikan CFrame mengarah langsung ke Kepala dengan penyesuaian
        humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position, targetHead.Position)
    end
end

-- Menjalankan aimlock terus menerus
while true do
    wait(0.1)  -- Interval update
    aimLock()
end