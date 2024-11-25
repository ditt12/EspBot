-- Fungsi buat bikin ESP
local function CreateESP(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local highlight = Instance.new("Highlight")
        highlight.Parent = player.Character
        highlight.FillColor = Color3.new(1, 1, 1) -- Putih
        highlight.OutlineColor = Color3.new(0, 0, 0) -- Outline hitam
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Enabled = true
    end
end

-- Loop semua player di game
local function ApplyESP()
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= game.Players.LocalPlayer and not player.Character:FindFirstChildOfClass("Highlight") then
            CreateESP(player)
        end
    end
end

-- Event listener kalau ada player baru masuk
game:GetService("Players").PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(1) -- Tunggu karakter ke-load
        CreateESP(player)
    end)
end)

-- Jalankan script ESP secara berkala
while wait(1) do
    ApplyESP()
end