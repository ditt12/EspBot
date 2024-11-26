-- Inisialisasi
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Fungsi untuk membuat ESP karakter musuh
local function createESP(target)
    if not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end
    
    -- Membuat ESP yang menampilkan karakter musuh
    local box = Instance.new("BillboardGui")
    box.Adornee = target.Character:WaitForChild("HumanoidRootPart")
    box.Size = UDim2.new(0, 200, 0, 50)
    box.StudsOffset = Vector3.new(0, 2, 0)
    box.AlwaysOnTop = true
    box.Parent = target.Character
    
    -- Label untuk ESP
    local label = Instance.new("TextLabel")
    label.Text = target.Name
    label.TextColor3 = Color3.fromRGB(255, 0, 0)  -- Warna ESP Merah
    label.Size = UDim2.new(1, 0, 1, 0)
    label.TextSize = 18
    label.BackgroundTransparency = 1
    label.Parent = box
end

-- Fungsi untuk memperbarui ESP
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

-- Menjalankan update ESP setiap 1 detik
while true do
    updateESP()  -- Memperbarui ESP untuk setiap pemain
    wait(1)      -- Update setiap 1 detik
end