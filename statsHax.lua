local Players = game:GetService("Players")
local me = Players.LocalPlayer


local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local win = Rayfield:CreateWindow({
    Name = "Stat Editor",
    LoadingTitle = "Preparing Hax",
    LoadingSubtitle = "by GregTheWizz",
    ConfigurationSaving = { Enabled = false }
})

local StatsTab = win:CreateTab("Change Stats", 16140823621)

local SpeedSlider = Tab:CreateSlider({
    Name = "Walkspeed editor",
    Info = "Change Walkseed",
    Increment = 0.1,
    Min = 10,
    Max = 100,
    Current = 16,
    Flag = "SpeedFlag",
    Callback = function(val)

      local char = me.Character
      if char and char:FindFirstChildOfClass("Humanoid") then
          local hum = char:FindFirstChildOfClass("Humanoid")
          hum.WalkSpeed = val
      end
    end,
)
  
local JumpPowerSlider = Tab:CreateSlider({
    Name = "Jump editor",
    Info = "Change JumpPower",
    Increment = 0.1,
    Min = 10,
    Max = 1000,
    Current = 50,
    Flag = "SpeedFlag",
    Callback = function(val)

      local char = me.Character
      if char and char:FindFirstChildOfClass("Humanoid") then
          local hum = char:FindFirstChildOfClass("Humanoid")
          hum.UseJumpPower = true
          hum.JumpPower = val
      end
  
)
