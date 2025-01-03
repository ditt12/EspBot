local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local function enlargeCharacter()
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("MeshPart") or part:IsA("Part") then
            part.Size = part.Size * 20
        end
    end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.HipWidth = humanoid.HipWidth * 20
        humanoid.HipHeight = humanoid.HipHeight * 20
        humanoid.BodyHeightScale = 20
        humanoid.BodyWidthScale = 20
        humanoid.BodyDepthScale = 20
    end
end

enlargeCharacter()