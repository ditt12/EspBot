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

-- Fungsi untuk mengunci aim ke target
local function aimLock()
    local targetPlayer = findClosestEnemy()
    
    if targetPlayer then
        local targetRootPart = targetPlayer.Character.HumanoidRootPart
        local direction = (targetRootPart.Position - humanoidRootPart.Position).unit
        
        -- Arahkan humanoidRootPart ke target dengan perbaikan untuk posisi nempel
        humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position, targetRootPart.Position) * CFrame.Angles(0, math.atan2(direction.X, direction.Z), 0)
    end
end

-- Loop aimlock diperbarui setiap 1 detik
while true do
    aimLock()
    wait(1)  -- Update aimlock setiap 1 detik
end