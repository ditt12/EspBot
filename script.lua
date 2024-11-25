local activePlayers = {}
local updateInterval = 0.5
local mouse = game.Players.LocalPlayer:GetMouse()
local localPlayer = game.Players.LocalPlayer
local closestPlayer = nil

local magicBulletEnabled = true -- Aktifkan Magic Bullet
local magicBulletRange = 500 -- Rentang Magic Bullet

local function CreateESP(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local highlight = Instance.new("Highlight")
        highlight.Parent = player.Character
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.new(0, 0, 0)
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Enabled = true
        activePlayers[player] = highlight
    end
end

local function RemoveESP(player)
    if activePlayers[player] then
        activePlayers[player]:Destroy()
        activePlayers[player] = nil
    end
end

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

local function UpdateESPOnRespawn(player)
    -- Cek saat karakter baru respawn, tambahkan ESP lagi
    player.CharacterAdded:Connect(function(character)
        wait(1)  -- Tunggu sampai karakter benar-benar muncul
        CreateESP(player)
    end)
end

local function GetRGBColor()
    local time = tick()
    local r = math.abs(math.sin(time)) * 255
    local g = math.abs(math.sin(time + 2)) * 255
    local b = math.abs(math.sin(time + 4)) * 255
    return Color3.fromRGB(r, g, b)
end

local function UpdateColors()
    for _, highlight in pairs(activePlayers) do
        if highlight and highlight.Parent then
            highlight.FillColor = GetRGBColor()
        end
    end
end

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

local function AimLock()
    if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetPosition = closestPlayer.Character.HumanoidRootPart.Position
        local mousePosition = mouse.Hit.p
        local direction = (targetPosition - mousePosition).unit
        mouse.Hit = CFrame.new(targetPosition + direction * 5) -- Ganti angka 5 sesuai kebutuhan
    end
end

local function FireMagicBullet()
    if magicBulletEnabled and closestPlayer and closestPlayer.Character then
        local bulletStartPos = localPlayer.Character.HumanoidRootPart.Position
        local bulletEndPos = closestPlayer.Character.HumanoidRootPart.Position

        -- Cek jarak tembakan
        if (bulletStartPos - bulletEndPos).Magnitude <= magicBulletRange then
            -- Simulasi Magic Bullet (tembak langsung ke target)
            local bullet = Instance.new("Part")
            bullet.Size = Vector3.new(0.2, 0.2, (bulletStartPos - bulletEndPos).Magnitude)
            bullet.Position = (bulletStartPos + bulletEndPos) / 2
            bullet.Anchored = true
            bullet.CanCollide = false
            bullet.BrickColor = BrickColor.new("Bright red")
            bullet.Parent = workspace

            -- Bergerak ke target (tembakan instan)
            local direction = (bulletEndPos - bulletStartPos).unit
            bullet.CFrame = CFrame.new(bullet.Position, bullet.Position + direction)
            -- Bisa tambah efek atau partikel tembakan di sini
        end
    end
end

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

game:GetService("Players").PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        -- Create ESP when a new player joins the game
        CreateESP(player)
    end)
    
    player.CharacterRemoving:Connect(function(character)
        -- Remove ESP when a player leaves the game or dies
        RemoveESP(player)
    end)

    -- Update ESP saat respawn
    UpdateESPOnRespawn(player)
end)

game:GetService("Players").PlayerRemoving:Connect(function(player)
    -- Remove ESP when a player leaves the game
    RemoveESP(player)
end)

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