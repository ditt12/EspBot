local function aimlockTarget()
    local closestPlayer = nil
    local closestDistance = math.huge
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local targetPosition = player.Character.HumanoidRootPart.Position
            local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - targetPosition).Magnitude
            if distance <= 50 then
                local ray = Ray.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, targetPosition - game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
                local hitPart, hitPosition = game.Workspace:FindPartOnRay(ray, game.Players.LocalPlayer.Character, true, true)
                if not hitPart or hitPart:IsDescendantOf(game.Workspace) then
                    if distance < closestDistance then
                        closestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end

    if closestPlayer then
        local targetPosition = closestPlayer.Character.HumanoidRootPart.Position
        game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(targetPosition))
    end
end

while wait(0.1) do
    aimlockTarget()
end

local function espPlayer(player)
    local espPart = Instance.new("Part")
    espPart.Size = Vector3.new(5, 5, 5)
    espPart.Position = player.Character.HumanoidRootPart.Position
    espPart.Anchored = true
    espPart.CanCollide = false
    espPart.Transparency = 0.5
    espPart.Color = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
    espPart.Parent = game.Workspace
end

for _, player in pairs(game:GetService("Players"):GetPlayers()) do
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        espPlayer(player)
    end
end

local function magicBullet(target)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local targetPosition = target.Character.HumanoidRootPart.Position
        local bullet = Instance.new("Part")
        bullet.Size = Vector3.new(1, 1, 10)
        bullet.Position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
        bullet.Anchored = false
        bullet.CanCollide = false
        bullet.BrickColor = BrickColor.new("Bright red")
        bullet.Parent = game.Workspace
        bullet.CFrame = CFrame.new(bullet.Position, targetPosition)
    end
end

for _, player in pairs(game:GetService("Players"):GetPlayers()) do
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        magicBullet(player)
    end
end