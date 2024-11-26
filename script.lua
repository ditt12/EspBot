-- ESP dan Magic Bullet script

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
                gun:Activate()
            end
        end
    end
end

-- Membuat ESP otomatis untuk semua pemain yang ada di server
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        -- Jika karakter pemain muncul, kita buat ESP
        createESP(player)
    end)
end)

-- Loop untuk terus menerus mengecek dan menembak target
game:GetService("RunService").RenderStepped:Connect(function()
    for _, target in ipairs(game.Players:GetPlayers()) do
        -- Mengecek dan mengaktifkan magic bullet
        if target ~= game.Players.LocalPlayer then
            magicBullet(target)
        end
    end
end)

-- Mengaktifkan ESP untuk semua pemain yang sudah ada
for _, player in ipairs(game.Players:GetPlayers()) do
    createESP(player)
end