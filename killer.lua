-- Inisialisasi
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local lockDistance = 100  -- Jarak maksimal untuk auto kill (dalam studs)

-- Fungsi untuk mencari musuh terdekat
local function findClosestEnemy()
    local closestDistance = lockDistance
    local closestTarget = nil

    -- Loop untuk mencari semua pemain
    for _, enemy in ipairs(game.Players:GetPlayers()) do
        if enemy ~= player and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
            local enemyRootPart = enemy.Character.HumanoidRootPart
            local distance = (humanoidRootPart.Position - enemyRootPart.Position).Magnitude

            -- Menyimpan target terdekat dalam radius 100 studs
            if distance < closestDistance then
                closestDistance = distance
                closestTarget = enemy
            end
        end
    end

    return closestTarget
end

-- Fungsi untuk membunuh musuh secara otomatis
local function autoKill()
    local targetPlayer = findClosestEnemy()

    if targetPlayer then
        local targetHumanoid = targetPlayer.Character:FindFirstChild("Humanoid")
        
        if targetHumanoid then
            -- Menyebabkan target musuh mati
            targetHumanoid.Health = 0
        end
    end
end

-- Menjalankan auto kill terus menerus setiap detik
while true do
    wait(1)  -- Update setiap 1 detik
    autoKill()
end