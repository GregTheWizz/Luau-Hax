local Players = game:GetService("Players")
local me = Players.LocalPlayer

-- THE CORRECT COMPLETE LINK: Erase the old line and use this exact URL path
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua"))()

local win = Rayfield:CreateWindow({
    Name = "Stat Editor",
    LoadingTitle = "Preparing Hax",
    LoadingSubtitle = "by GregTheWizz",
    ConfigurationSaving = { Enabled = false }
})

local StatsTab = win:CreateTab("Change Stats", 16140823621)

-- 1. Walkspeed Slider Configuration
local SpeedSlider = StatsTab:CreateSlider({
    Name = "Walkspeed editor",
    Info = "Change Walkspeed",
    Min = 10,
    Max = 100,
    Increment = 1,
    CurrentValue = 16,
    Flag = "WalkspeedModifierFlag",
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
  
-- 2. JumpPower Slider Configuration
local JumpPowerSlider = StatsTab:CreateSlider({
    Name = "Jump editor",
    Info = "Change JumpPower",
    Min = 10,
    Max = 1000,
    Increment = 1,
    CurrentValue = 50,
    Flag = "JumpPowerModifierFlag",
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
