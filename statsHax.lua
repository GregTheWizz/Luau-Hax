local Players = game:GetService("Players")
local me = Players.LocalPlayer

-- Load Rayfield [INDEX]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu'))() [INDEX]

local win = Rayfield:CreateWindow({
    Name = "Stat Editor",
    LoadingTitle = "Preparing Hax",
    LoadingSubtitle = "by GregTheWizz",
    ConfigurationSaving = { Enabled = false }
})

local StatsTab = win:CreateTab("Change Stats", 16140823621)

-- 1. Walkspeed Slider (Fixed with Suffix)
local SpeedSlider = StatsTab:CreateSlider({
    Name = "Walkspeed editor",
    Info = "Change Walkseed",
    Min = 10,
    Max = 100,
    Increment = 1,
    CurrentValue = 16,
    Suffix = "Speed", -- REQUIRED FIX: Rayfield needs this to align text properly [INDEX]
    Flag = "SpeedFlag",
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
  
-- 2. JumpPower Slider (Fixed with Suffix)
local JumpPowerSlider = StatsTab:CreateSlider({
    Name = "Jump editor",
    Info = "Change JumpPower",
    Min = 10,
    Max = 1000,
    Increment = 1,
    CurrentValue = 50,
    Suffix = "Power", -- REQUIRED FIX: Rayfield needs this to align text properly [INDEX]
    Flag = "JumpFlag",
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
