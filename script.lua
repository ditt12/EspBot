local player = game.Players.LocalPlayer

local boostedWalkSpeed = 50000
local boostedJumpPower = 150

local function applyBoosts(character)
    local humanoid = character:WaitForChild("Humanoid", 5)
    if humanoid then
        humanoid.WalkSpeed = boostedWalkSpeed
        humanoid.JumpPower = boostedJumpPower
    end
end

local function onCharacterAdded(character)
    applyBoosts(character)
end

player.CharacterAdded:Connect(onCharacterAdded)

if player.Character then
    applyBoosts(player.Character)
end