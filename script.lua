local activePlayers = {}
local updateInterval = 0.1  -- Percepat interval pembaruan menjadi lebih cepat
local mouse = game.Players.LocalPlayer:GetMouse()
local localPlayer = game.Players.LocalPlayer
local closestPlayer = nil

local magicBulletEnabled = true -- Aktifkan Magic Bullet
local magicBulletRange = 2000 -- Rentang Magic Bullet lebih jauh
local magicBulletSize = 20 -- Ukuran Magic Bullet lebih besar

-- Membuat Text Label di PlayerGui yang tetap ada meskipun karakter mati
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local textLabel = Instance.new("TextLabel")
textLabel.Parent = screenGui
textLabel.Text = "©Kelperiens"
textLabel.TextColor3 = Color3.new(1, 1, 1)
textLabel.Position = UDim2.new(0, 10, 1, -30)
textLabel.Size = UDim2.new(0, 200, 0, 50)
textLabel.BackgroundTransparency = 1
textLabel.TextSize = 20

-- Fungsi untuk membuat ESP
local function CreateESP(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local highlight = Instance.new("Highlight")
        highlight.Parent = player.Character
        highlight.FillColor = Color3.fromRGB(255, 255, 255) -- Warna putih
        highlight.OutlineColor = Color3.new(0, 0, 0)
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Enabled = true
        activePlayers[player] = highlight
    end
end

-- Fungsi untuk menghapus ESP
local function RemoveESP(player)
    if activePlayers[player] then
        activePlayers[player]:Destroy()
        activePlayers[player] = nil
    end
end

-- Fungsi untuk memperbarui ESP untuk semua pemain
local function ApplyESP()
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= localPlayer then
            if player.Character and not activePlayers[player] then
                CreateESP(player)
            elseif player.Character == nil and activePlayers[player] then
                RemoveESP(player)
            end
        end
    end
end

-- Fungsi untuk mendapatkan pemain terdekat
local function GetClosestPlayer()
    local shortestDistance = math.huge
    closestPlayer = nil
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (localPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                closestPlayer = player
                shortestDistance = distance
            end
        end
    end
    return closestPlayer
end

-- Fungsi untuk mengunci aim pada kepala pemain terdekat dengan lebih kuat
local function AimLock()
    if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("Head") then
        local targetPosition = closestPlayer.Character.Head.Position
        local mousePosition = mouse.Hit.p
        
        -- Gunakan smoothing untuk menghaluskan pergerakan aim
        local direction = (targetPosition - mousePosition).unit
        local smoothedPosition = mousePosition + direction * 0.2  -- 0.2 adalah faktor smoothing

        -- Update posisi aim
        mouse.Hit = CFrame.new(smoothedPosition)
    end
end

-- Fungsi untuk Magic Bullet
local function FireMagicBullet()
    if magicBulletEnabled and closestPlayer and closestPlayer.Character then
        local bulletStartPos = localPlayer.Character.HumanoidRootPart.Position
        local bulletEndPos = closestPlayer.Character.HumanoidRootPart.Position

        -- Cek jarak tembakan dan periksa lebar Magic Bullet
        if (bulletStartPos - bulletEndPos).Magnitude <= magicBulletRange then
            -- Simulasi Magic Bullet dengan lebar lebih besar
            local bullet = Instance.new("Part")
            bullet.Size = Vector3.new(magicBulletSize, magicBulletSize, (bulletStartPos - bulletEndPos).Magnitude)
            bullet.Position = (bulletStartPos + bulletEndPos) / 2
            bullet.Anchored = true
            bullet.CanCollide = false
            bullet.BrickColor = BrickColor.new("Bright red")
            bullet.Parent = workspace

            -- Bergerak ke target (tembakan instan)
            local direction = (bulletEndPos - bulletStartPos).unit
            bullet.CFrame = CFrame.new(bullet.Position, bullet.Position + direction)

            -- Bisa tambah efek atau partikel tembakan di sini
            game:GetService("TweenService"):Create(bullet, TweenInfo.new(0.2), {Size = Vector3.new(magicBulletSize * 2, magicBulletSize * 2, (bulletStartPos - bulletEndPos).Magnitude * 2)}):Play()
        end
    end
end

-- Fungsi untuk mendapatkan warna RGB yang berubah seiring waktu
local function GetRGBColor()
    local time = tick()
    local r = math.abs(math.sin(time)) * 255
    local g = math.abs(math.sin(time + 2)) * 255
    local b = math.abs(math.sin(time + 4)) * 255
    return Color3.fromRGB(r, g, b)
end

-- Fungsi untuk memperbarui warna ESP dan TextLabel
local function UpdateColors()
    for _, highlight in pairs(activePlayers) do
        if highlight and highlight.Parent then
            highlight.FillColor = GetRGBColor()
        end
    end
    -- Update warna text label
    textLabel.TextColor3 = GetRGBColor()
end

-- Menambahkan event untuk membuat ESP ketika pemain baru bergabung
game:GetService("Players").PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        wait(1)  -- Tunggu sampai karakter benar-benar muncul
        CreateESP(player)
    end)
    
    player.CharacterRemoving:Connect(function(character)
        RemoveESP(player)
    end)
end)

-- Menghapus ESP ketika pemain meninggalkan game
game:GetService("Players").PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

-- Loop utama untuk memperbarui ESP, warna, dan Magic Bullet
while wait(updateInterval) do
    ApplyESP()
    UpdateColors()
    local closest = GetClosestPlayer()
    if closest then
        closestPlayer = closest
        AimLock()
        FireMagicBullet() -- Tambahkan Magic Bullet di sini
    end
end