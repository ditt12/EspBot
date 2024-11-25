local activePlayers = {}
local updateInterval = 0.5 -- Interval update ESP (lebih jarang supaya tidak memberatkan)

local function CreateESP(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local highlight = Instance.new("Highlight")
        highlight.Parent = player.Character
        highlight.FillColor = Color3.new(1, 1, 1) -- Warna putih
        highlight.OutlineColor = Color3.new(0, 0, 0) -- Outline hitam
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
        if player ~= game.Players.LocalPlayer then
            if player.Character and not activePlayers[player] then
                CreateESP(player)
            elseif player.Character == nil and activePlayers[player] then
                RemoveESP(player)
            end
        end
    end
end

game:GetService("Players").PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(1)
        CreateESP(player)
    end)
end)

local function GetClosestPlayer()
    local localPlayer = game.Players.LocalPlayer
    local closestPlayer = nil
    local shortestDistance = math.huge

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

local mouse = game.Players.LocalPlayer:GetMouse()

-- Mengurangi pembaruan yang terlalu sering
local lastUpdate = 0
game:GetService("RunService").RenderStepped:Connect(function()
    local currentTime = tick()
    if currentTime - lastUpdate > updateInterval then
        local closestPlayer = GetClosestPlayer()
        if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("HumanoidRootPart") then
            mouse.Hit = CFrame.new(closestPlayer.Character.HumanoidRootPart.Position)
        end
        lastUpdate = currentTime
    end
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local textLabel = Instance.new("TextLabel")
textLabel.Parent = screenGui
textLabel.Text = "©Kelperiens"
textLabel.TextColor3 = Color3.new(1, 1, 1)
textLabel.Position = UDim2.new(0, 10, 1, -30)  -- Posisi di kiri bawah
textLabel.Size = UDim2.new(0, 200, 0, 50)
textLabel.BackgroundTransparency = 1
textLabel.TextSize = 20

-- Fungsi untuk menjaga TextLabel tetap ada meski karakter mati
local function KeepTextLabelAlive()
    while true do
        if not screenGui.Parent then
            screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        end
        wait(1)
    end
end

keepTextLabelAliveThread = coroutine.create(KeepTextLabelAlive)  -- Menjalankan KeepTextLabelAlive
coroutine.resume(keepTextLabelAliveThread)

-- Fungsi untuk menghapus highlight jika objek terlalu banyak
local function CleanupHighlights()
    for player, highlight in pairs(activePlayers) do
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            RemoveESP(player)
        end
    end
end

while wait(updateInterval) do
    ApplyESP()
    CleanupHighlights()
end