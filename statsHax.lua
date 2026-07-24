-- Force cleanup of any old broken menus left in your game memory
pcall(function()
    if Rayfield then Rayfield:Destroy() end
end)

local Players = game:GetService("Players")
local me = Players.LocalPlayer

-- Load the clean Rayfield UI environment
local Rayfield = loadstring(game:HttpGet('https://sirius.menu'))()

local win = Rayfield:CreateWindow({
    Name = "Stat Editor",
    LoadingTitle = "Preparing Hax",
    LoadingSubtitle = "by GregTheWizz",
    ConfigurationSaving = { Enabled = false }
})

local StatsTab = win:CreateTab("Change Stats", 16140823621)

-- 1. Walkspeed Slider (Fixed syntax with Range table format)
local SpeedSlider = StatsTab:CreateSlider({
    Name = "Walkspeed editor",
    Info = "Change Walkspeed",
    Range = {10, 120}, -- FIXED: Rayfield syntax requires {Min, Max} array format
    Increment = 1,
    CurrentValue = 16,
    Flag = "WalkspeedEngineFlag",
    Callback = function(val)
        local char = me.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = val
            end
        end
    end,
})
  
-- 2. JumpPower Slider (Fixed syntax with Range table format)
local JumpPowerSlider = StatsTab:CreateSlider({
    Name = "Jump editor",
    Info = "Change JumpPower",
    Range = {10, 1000}, -- FIXED: Rayfield syntax requires {Min, Max} array format
    Increment = 1,
    CurrentValue = 50,
    Flag = "JumpPowerEngineFlag",
    Callback = function(val)
        local char = me.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.UseJumpPower = true
                hum.JumpPower = val
            end
        end
    end,
})
