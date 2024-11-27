-- Inisialisasi
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Kecepatan jalan yang diinginkan
local boostedWalkSpeed = 100000  -- Atur kecepatan berjalan sesuai keinginan

-- Fungsi untuk memastikan WalkSpeed tetap diperbarui
local function applyWalkSpeed()
    while true do
        if humanoid then
            humanoid.WalkSpeed = boostedWalkSpeed
        end
        wait(1)  -- Perbarui setiap 1 detik
    end
end

-- Pastikan script berjalan ulang jika karakter respawn
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = boostedWalkSpeed
end)

-- Jalankan loop untuk memperbarui WalkSpeed
applyWalkSpeed()