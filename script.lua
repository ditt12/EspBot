local activePlayers = {}
local updateInterval = 0.5

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
        if player ~= game.Players.LocalPlayer then
            if player.Character and not activePlayers[player] then
                CreateESP(player)
            elseif player.Character == nil and activePlayers[player] then
                RemoveESP(player)
            end
        end
    end
end

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

local function GetRGBColor()
    local time = tick()
    local r = math.abs(math.sin(time)) * 255
    local g = math.abs(math.sin(time + 2)) * 255
    local b = math.abs(math.sin(time + 4)) * 255
    return Color3.fromRGB(r, g, b)
end

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
textLabel.Position = UDim2.new(0, 10, 1, -30)
textLabel.Size = UDim2.new(0, 200, 0, 50)
textLabel.BackgroundTransparency = 1
textLabel.TextSize = 20

local function KeepTextLabelAlive()
    while true do
        if not screenGui.Parent then
            screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        end
        wait(1)
    end
end

keepTextLabelAliveThread = coroutine.create(KeepTextLabelAlive)
coroutine.resume(keepTextLabelAliveThread)

local function UpdateColors()
    for _, highlight in pairs(activePlayers) do
        if highlight and highlight.Parent then
            highlight.FillColor = GetRGBColor()
        end
    end
    textLabel.TextColor3 = GetRGBColor()
end

while wait(updateInterval) do
    ApplyESP()
    UpdateColors()
end