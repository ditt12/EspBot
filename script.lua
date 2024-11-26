-- Aimlock Script 100%
local aimlockEnabled = true
local aimlockTarget = nil
local lockPart = "Head" -- Bagian tubuh yang akan dikunci (Head, Torso, dll)

-- Fungsi untuk mendapatkan target terdekat
local function getClosestTarget()
    local closestPlayer = nil
    local shortestDistance = math.huge -- Nilai jarak awal sangat besar

    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild(lockPart) then
            local targetPart = player.Character[lockPart]
            local playerHRP = game.Players.LocalPlayer.Character.HumanoidRootPart

            -- Hitung jarak antara pemain lokal dan target
            local distance = (playerHRP.Position - targetPart.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = player
            end
        end
    end

    return closestPlayer
end

-- Fungsi untuk mengunci aim ke target
local function aimlock()
    if aimlockEnabled and aimlockTarget and aimlockTarget.Character and aimlockTarget.Character:FindFirstChild(lockPart) then
        local targetPart = aimlockTarget.Character[lockPart]
        local camera = workspace.CurrentCamera

        -- Paksa crosshair atau kamera mengarah ke target
        camera.CFrame = CFrame.new(camera.CFrame.Position, targetPart.Position)
    end
end

-- Aktifkan aimlock secara otomatis
game:GetService("RunService").RenderStepped:Connect(function()
    if aimlockEnabled then
        aimlockTarget = getClosestTarget() -- Perbarui target terdekat
        aimlock() -- Jalankan fungsi aimlock
    end
end)

-- Keybind untuk mengaktifkan atau menonaktifkan aimlock
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.E then -- Tekan "E" untuk mengaktifkan/menonaktifkan aimlock
        aimlockEnabled = not aimlockEnabled
        if aimlockEnabled then
            print("Aimlock diaktifkan!")
        else
            print("Aimlock dimatikan!")
        end
    end
end)