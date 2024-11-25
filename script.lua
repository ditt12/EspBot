local function CreateESP(player)
    local highlight = Instance.new("Highlight")
    highlight.Parent = player.Character
    highlight.FillColor = Color3.new(1, 0, 0) -- Warna merah
    highlight.OutlineColor = Color3.new(1, 1, 1) -- Outline putih
    highlight.Enabled = true
end

for _, player in pairs(game:GetService("Players"):GetPlayers()) do
    if player ~= game.Players.LocalPlayer then
        CreateESP(player)
    end
end
