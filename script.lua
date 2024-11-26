local function showToast()
    local toast = Instance.new("ScreenGui")
    toast.Name = "Toast"
    toast.Parent = game.Players.LocalPlayer.PlayerGui

    local message = Instance.new("TextLabel")
    message.Size = UDim2.new(0, 600, 0, 100)
    message.Position = UDim2.new(0.5, -300, 0.8, 0)
    message.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    message.BackgroundTransparency = 0.5
    message.TextColor3 = Color3.fromRGB(255, 255, 255)
    message.TextSize = 36
    message.Text = "This script is no longer available"
    message.TextCentered = true
    message.Parent = toast

    wait(10)
    toast:Destroy()
end

while true do
    showToast()
    wait(5)
end