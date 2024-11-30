-- Skrip Anti Recoil di Roblox

-- Menentukan kepekaan recoil (menyesuaikan agar sesuai dengan kebutuhan)
local sensitivity = 0.1

-- Fungsi untuk menyesuaikan recoil
local function antiRecoil()
    local player = game.Players.LocalPlayer
    local character = player.Character
    local humanoid = character and character:FindFirstChild("Humanoid")
    
    -- Pastikan ada karakter dan humanoid
    if humanoid then
        -- Cek apakah senjata ada di tangan
        local tool = character:FindFirstChildOfClass("Tool")
        
        if tool then
            -- Menambahkan logika untuk mengurangi recoil
            local viewModel = tool:FindFirstChild("Handle")
            
            if viewModel then
                -- Setel posisi senjata untuk melawan recoil
                viewModel.CFrame = viewModel.CFrame * CFrame.new(0, -sensitivity, 0) -- Gerakan ke bawah untuk melawan recoil
            end
        end
    end
end

-- Fungsi utama untuk menjalankan anti-recoil setiap 1 detik
while true do
    antiRecoil()  -- Jalankan anti-recoil
    wait(1)  -- Tunggu selama 1 detik sebelum menjalankan lagi
end