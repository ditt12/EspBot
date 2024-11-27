-- inisialisasi  
local player = game.Players.LocalPlayer  
local character = player.Character or player.CharacterAdded:Wait()  
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")  

local lockDistance = 100  -- jarak maksimal aimlock dalam studs  

-- fungsi mencari musuh terdekat  
local function findClosestEnemy()  
    local closestDistance = lockDistance  
    local closestTarget = nil  

    for _, enemy in ipairs(game.Players:GetPlayers()) do  
        if enemy ~= player and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then  
            local enemyRootPart = enemy.Character.HumanoidRootPart  
            local distance = (humanoidRootPart.Position - enemyRootPart.Position).Magnitude  

            if distance < closestDistance then  
                closestDistance = distance  
                closestTarget = enemy  
            end  
        end  
    end  

    return closestTarget  
end  

-- fungsi untuk mengunci aim ke target  
local function aimLock()  
    while true do  
        local targetPlayer = findClosestEnemy()  
        if targetPlayer then  
            local targetRootPart = targetPlayer.Character.HumanoidRootPart  
            humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position, targetRootPart.Position)  
        end  
        wait(0.1)  
    end  
end  

-- mulai aimlock  
aimLock()