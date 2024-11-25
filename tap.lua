-- Auto Tap Script for Roblox
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

-- Set the time interval for auto-click (in seconds)
local interval = 0.1

-- Function to simulate mouse click
local function autoClick()
    mouse.Button1Down:Fire()
end

-- Repeat loop to continuously click at the set interval
repeat
    autoClick()
    wait(interval)
until false