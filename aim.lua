-- Aimlock 100% Script dengan Repeat setiap 1 detik
local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()
local Target
local LockSpeed = 0.1

function getTarget()
    local closestTarget
    local shortestDistance = math.huge

    for _, v in pairs(game.Players:GetPlayers()) do
        if v.Character and v.Character:FindFirstChild("Head") and v ~= Player then
            local distance = (v.Character.Head.Position - Player.Character.Head.Position).magnitude
            if distance < shortestDistance then
                closestTarget = v
                shortestDistance = distance
            end
        end
    end
    return closestTarget
end

function aimAtTarget(target)
    if target then
        local headPos = target.Character.Head.Position
        local mousePos = Mouse.Hit.p
        local direction = (headPos - mousePos).unit
        local newPos = mousePos + direction * LockSpeed
        Mouse.Hit = CFrame.new(newPos)
    end
end

while true do
    wait(1)  -- Repeat setiap 1 detik
    Target = getTarget()
    if Target then
        aimAtTarget(Target)
    end
end