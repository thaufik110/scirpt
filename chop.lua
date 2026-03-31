-- =====================================================================
-- 🪓 HE ZHUSHI HUB - CHOP YOUR TREE (LITE EDITION)
-- =====================================================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Memuat UI Library (TokyoNight Theme) dari GitHub
local FarmingLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/thaufik110/libraryzhushi/refs/heads/main/newui.lua"))()
local Window = FarmingLibrary:CreateWindow("He ZhuShi | Chop Tree", "TokyoNight")

local TabFarm = Window:CreateTab("Auto Farm", "rbxassetid://6031265976")

-- =====================================================================
-- 🟡 TAB 1: AUTO FARM (FITUR UTAMA)
-- =====================================================================
TabFarm:CreateSection("🔥 God Mode Farming 🔥")

local autoSwing = false

-- AUTO TEBANG (Instant Destroy Tree)
TabFarm:CreateToggle("Auto Swing Axe (OP)", false, function(state)
    autoSwing = state
    if autoSwing then
        task.spawn(function()
            while autoSwing do
                pcall(function()
                    ReplicatedStorage.Remotes.AxeSwing:FireServer()
                end)
                task.wait(0.01) -- Spam kecepatan maksimal
            end
        end)
    end
end)
