-- Aimlock 85% dengan deteksi halangan (Wallcheck)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local lockDistance = 50  -- Jarak maksimal untuk aimlock (dalam studs)
local aimStrength = 0.85  -- Kekuatan aimlock 85%

-- Fungsi untuk mencari musuh terdekat
local function findClosestEnemy()
    local closestDistance = lockDistance
    local closestTarget = nil
    
    -- Loop untuk mencari semua pemain
    for _, enemy in ipairs(game.Players:GetPlayers()) do
        if enemy ~= player and enemy.Character and enemy.Character:FindFirstChild("UpperTorso") then
            local enemyTorso = enemy.Character:FindFirstChild("UpperTorso")
            local distance = (humanoidRootPart.Position - enemyTorso.Position).Magnitude
            
            -- Menyimpan target terdekat
            if distance < closestDistance then
                closestDistance = distance
                closestTarget = enemy
            end
        end
    end
    
    return closestTarget
end

-- Fungsi untuk memeriksa apakah ada halangan antara pemain dan target
local function isObstacleBetween(target)
    local targetTorso = target.Character:FindFirstChild("UpperTorso")
    if targetTorso then
        -- Raycast dari pemain ke target untuk memeriksa halangan
        local ray = workspace:Raycast(humanoidRootPart.Position, targetTorso.Position - humanoidRootPart.Position)
        if ray then
            -- Jika ada halangan (ray hit), maka return true
            return true
        end
    end
    return false
end

-- Fungsi untuk mengunci aim ke badan target dengan kekuatan 85%
local function aimLock()
    local targetPlayer = findClosestEnemy()
    
    if targetPlayer and not isObstacleBetween(targetPlayer) then
        local targetTorso = targetPlayer.Character.UpperTorso
        local directionToTarget = (targetTorso.Position - humanoidRootPart.Position).unit
        local currentLook = humanoidRootPart.CFrame.LookVector
        
        -- Menginterpolasi antara posisi karakter dan target untuk 85% akurasi
        local newLook = currentLook:Lerp(directionToTarget, aimStrength)
        humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position, humanoidRootPart.Position + newLook)
    end
end

-- Menjalankan aimlock terus menerus
while true do
    wait(0.1)  -- Interval update
    aimLock()
end