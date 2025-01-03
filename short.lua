local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local function shrinkCharacter()
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("MeshPart") or part:IsA("Part") then
            part.Size = part.Size * 0.2 -- Skala karakter jadi lebih kecil
        end
    end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.HipWidth = humanoid.HipWidth * 0.2
        humanoid.HipHeight = humanoid.HipHeight * 0.2
        humanoid.BodyHeightScale = 0.2
        humanoid.BodyWidthScale = 0.2
        humanoid.BodyDepthScale = 0.2
    end
    
    local camera = workspace.CurrentCamera
    camera.CameraSubject = character.Humanoid
end

shrinkCharacter()