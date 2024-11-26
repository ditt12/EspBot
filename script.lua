-- konfigurasi esp rgb
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local espColor = Color3.new(1, 0, 0) -- default merah
local espEnabled = true
local labelColor = Color3.fromRGB(255, 0, 0) -- warna label merah
local magicBulletEnabled = true
local aimlockEnabled = true
local magicBulletRadius = 30 -- jarak magic bullet lebih lebar

-- fungsi untuk membuat esp
function createESP(target)
    if not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
        return
    end

    if target.Character:FindFirstChild("ESPBox") then
        target.Character.ESPBox:Destroy()
    end

    local espBox = Instance.new("BoxHandleAdornment")
    espBox.Name = "ESPBox"
    espBox.Size = Vector3.new(4, 6, 4)
    espBox.Adornee = target.Character:FindFirstChild("HumanoidRootPart")
    espBox.AlwaysOnTop = true
    espBox.ZIndex = 10
    espBox.Color3 = espColor
    espBox.Parent = target.Character
end

-- fungsi untuk update warna esp (rgb)
function updateESPColor()
    local hue = tick() % 5 / 5 -- rgb animasi
    espColor = Color3.fromHSV(hue, 1, 1)
end

-- fungsi untuk menampilkan label "©Kelperiens"
function createLabel(target)
    if target.Character and not target.Character:FindFirstChild("Label") then
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Text = "©Kelperiens"
        label.TextColor3 = labelColor
        label.TextSize = 20
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 10, 0, 50)
        label.Parent = target.Character
    end
end

-- fungsi untuk magic bullet
function magicBullet(target)
    if magicBulletEnabled and target.Character then
        local targetPosition = target.Character:FindFirstChild("HumanoidRootPart").Position
        local myPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
        local distance = (targetPosition - myPosition).Magnitude
        if distance <= magicBulletRadius then
            -- tembak otomatis ke target yang dalam radius
            local gun = game.Players.LocalPlayer.Character:FindFirstChild("Tool") -- ganti dengan senjata yang dipake
            if gun then
                gun:Activate()
            end
        end
    end
end

-- fungsi untuk aimlock
function aimLock(target)
    if aimlockEnabled and target.Character then
        local head = target.Character:FindFirstChild("Head")
        if head then
            -- lock pada kepala
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(head.Position)
        end
    end
end

-- listener untuk pemain baru
players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(1) -- delay untuk memastikan karakter ter-load
        if espEnabled then
            createESP(player)
            createLabel(player)
        end
    end)
end)

-- update esp untuk semua pemain yang ada
function updateAllESP()
    for _, player in pairs(players:GetPlayers()) do
        if player ~= players.LocalPlayer then
            if player.Character then
                createESP(player)
                createLabel(player)
            end
        end
    end
end

-- loop untuk animasi rgb dan update esp
runService.RenderStepped:Connect(function()
    updateESPColor()
    updateAllESP()

    -- aplikasi magic bullet ke semua musuh yang terdekat
    for _, player in pairs(players:GetPlayers()) do
        if player ~= players.LocalPlayer then
            magicBullet(player)
            aimLock(player)
        end
    end
end)

-- otomatis aktif saat dijalankan
espEnabled = true