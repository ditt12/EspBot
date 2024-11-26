-- Inisialisasi
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local lockDistance = 100  -- Jarak maksimal untuk aimlock (dalam studs)
local aimlockEnabled = true  -- Variabel untuk mengaktifkan/mematikan aimlock

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
    if not aimlockEnabled then return end  -- Cek apakah Aimlock aktif
    local targetPlayer = findClosestEnemy()
    
    if targetPlayer then
        local targetRootPart = targetPlayer.Character.HumanoidRootPart
        humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position, targetRootPart.Position)
    end
end

-- Menjalankan aimlock terus menerus
while true do
    wait(0.1)  -- Interval update
    aimLock()  -- Mengaktifkan aimlock jika aktif
end

-- Fungsi untuk tombol On/Off Aimlock
local function toggleAimlock()
    aimlockEnabled = not aimlockEnabled  -- Mengubah status Aimlock
end

-- Memanggil fungsi toggle saat tombol ditekan (contoh dengan penggunaan tombol tertentu)
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F then  -- Tekan tombol F untuk toggle Aimlock
        toggleAimlock()
    end
end)