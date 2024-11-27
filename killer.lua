local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local flying = false
local maxHeight = 30  -- Maksimal ketinggian terbang
local speed = 50      -- Kecepatan terbang

-- Fungsi untuk mengaktifkan/mematikan terbang
local function toggleFly()
    flying = not flying
    if flying then
        -- Loop terbang
        while flying do
            local currentHeight = humanoidRootPart.Position.Y
            if currentHeight < maxHeight then
                humanoidRootPart.Velocity = Vector3.new(0, speed, 0)
            else
                humanoidRootPart.Velocity = Vector3.zero
            end
            wait(0.1)
        end
    else
        humanoidRootPart.Velocity = Vector3.zero  -- Menghentikan terbang
    end
end

-- Membuat tombol GUI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local flyButton = Instance.new("TextButton")

flyButton.Size = UDim2.new(0, 200, 0, 50)
flyButton.Position = UDim2.new(0.5, -100, 0.9, -25)
flyButton.Text = "Fly"
flyButton.BackgroundColor3 = Color3.fromRGB(0, 128, 255)
flyButton.TextColor3 = Color3.new(1, 1, 1)
flyButton.Font = Enum.Font.SourceSansBold
flyButton.TextSize = 24
flyButton.Parent = screenGui

-- Fungsi untuk mengubah teks tombol
local function updateButtonText()
    flyButton.Text = flying and "Stop Flying" or "Fly"
end

-- Event untuk tombol
flyButton.MouseButton1Click:Connect(function()
    toggleFly()
    updateButtonText()
end)