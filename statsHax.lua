pcall(function()
    if Rayfield then Rayfield:Destroy() end
end)

local Players = game:GetService("Players")
local me = Players.LocalPlayer

-- Загружаем чистую библиотеку Rayfield [INDEX]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))() [INDEX]

local win = Rayfield:CreateWindow({
    Name = "Stat Editor",
    LoadingTitle = "Preparing Hax",
    LoadingSubtitle = "by GregTheWizz",
    ConfigurationSaving = { Enabled = false } -- Отключаем сохранение, чтобы кэш не ломал слайдеры [INDEX]
})

local StatsTab = win:CreateTab("Change Stats", 16140823621)

-- 1. Слайдер Скорости
local SpeedSlider = StatsTab:CreateSlider({
    Name = "Walkspeed editor",
    Info = "Change Walkspeed",
    Increment = 1,
    Min = 10,
    Max = 120, -- Немного увеличили максимум для тестов
    CurrentValue = 16,
    Flag = "WalkspeedModifierFlag", -- Изменили имя флага для сброса сломанного кэша [INDEX]
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
  
-- 2. Слайдер Прыжка
local JumpPowerSlider = StatsTab:CreateSlider({
    Name = "Jump editor",
    Info = "Change JumpPower",
    Increment = 1,
    Min = 10,
    Max = 1000,
    CurrentValue = 50,
    Flag = "JumpPowerModifierFlag", -- Изменили имя флага для сброса сломанного кэша [INDEX]
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
