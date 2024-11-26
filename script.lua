-- ESP, Magic Bullet, dan Wallhack script

-- Setting warna RGB untuk ESP
local espColor = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)) -- RGB acak

-- Magic bullet settings
local magicBulletRadius = 30 -- radius magic bullet lebih lebar
local minimumDistance = 1 -- minimal jarak 1 meter
local magicBulletEnabled = true -- enable magic bullet

-- Label text di kiri bawah
local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(0, 200, 0, 50)
textLabel.Position = UDim2.new(0, 0, 1, -100)
textLabel.Text = "©Kelperiens"
textLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- Merah
textLabel.BackgroundTransparency = 1
textLabel.Parent = game.CoreGui

-- Membuat ESP untuk target
local function createESP(target)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local box = Instance.new("BillboardGui")
        box.Size = UDim2.new(0, 100, 0, 100)
        box.Adornee = target.Character.HumanoidRootPart
        box.StudsOffset = Vector3.new(0, 2, 0)
        box.Parent = game.CoreGui

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundColor3 = espColor
        frame.BorderSizePixel = 0
        frame.Parent = box
    end
end

-- Membuat ESP line yang menghubungkan pemain dengan target
local function createESPLines(target)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local playerHRP = game.Players.LocalPlayer.Character.HumanoidRootPart
        local targetHRP = target.Character.HumanoidRootPart
        
        -- Cek apakah target ada dalam jangkauan ESP
        if (targetHRP.Position - playerHRP.Position).Magnitude <= magicBulletRadius then
            -- Membuat line antara pemain dan target
            local line = Instance.new("Part")
            line.Size = Vector3.new(0.1, 0.1, (targetHRP.Position - playerHRP.Position).Magnitude)
            line.Position = (targetHRP.Position + playerHRP.Position) / 2
            line.Anchored = true
            line.CanCollide = false
            line.BrickColor = BrickColor.new(espColor)
            line.Parent = game.Workspace

            -- Mengarahkan line ke target
            line.CFrame = CFrame.new(playerHRP.Position, targetHRP.Position)
            game:GetService("Debris"):AddItem(line, 0.1) -- Menghapus line setelah waktu tertentu
        end
    end
end

-- Fungsi untuk Magic Bullet
function magicBullet(target)
    if magicBulletEnabled and target.Character then
        local targetPosition = target.Character:FindFirstChild("HumanoidRootPart").Position
        local myPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
        local distance = (targetPosition - myPosition).Magnitude
        
        -- Cek jika target berada dalam radius magic bullet dan lebih dari atau sama dengan 1 meter
        if distance <= magicBulletRadius and distance >= minimumDistance then
            -- tembak otomatis ke target yang dalam radius
            local gun = game.Players.LocalPlayer.Character:FindFirstChild("Tool") -- ganti dengan senjata yang dipake
            if gun then
                -- Aktivasi tembakan ke target
                gun:Activate()
            end
        end
    end
end

-- Wallhack: Hanya objek selain tanah, semen, dan jalanan
local function enableWallhack()
    local ignoredMaterials = {"Grass", "Concrete", "Stone"} -- Menambahkan tanah dan jalanan
    local ignoredNames = {"Terrain", "Baseplate"} -- Menambahkan baseplate atau tanah

    -- Menyembunyikan objek yang tidak perlu
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Part") and not table.find(ignoredMaterials, obj.Material.Name) and not table.find(ignoredNames, obj.Name) then
            obj.LocalTransparencyModifier = 0 -- Menampilkan objek selain tanah dan semen
        elseif obj:IsA("Part") then
            obj.LocalTransparencyModifier = 1 -- Menyembunyikan objek tanah dan semen
        end
    end
end

-- Fungsi untuk mendeteksi dan mengaktifkan Wallhack
game:GetService("RunService").RenderStepped:Connect(function()
    -- Mengaktifkan Wallhack untuk objek yang tepat
    enableWallhack()
    
    -- Membuat ESP dan Magic Bullet untuk target
    for _, target in ipairs(game.Players:GetPlayers()) do
        if target ~= game.Players.LocalPlayer then
            -- Cek apakah target ada dalam jangkauan ESP
            if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                -- Membuat ESP untuk target yang baru
                createESP(target)

                -- Membuat ESP line
                createESPLines(target)

                -- Mengecek dan mengaktifkan magic bullet untuk target yang terlihat
                magicBullet(target)
            end
        end
    end
end)

-- Mengaktifkan ESP untuk semua pemain yang sudah ada
for _, player in ipairs(game.Players:GetPlayers()) do
    createESP(player)
end