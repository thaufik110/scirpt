-- =====================================================================
-- 🎣 HE ZHUSHI HUB - BRAINROT FISHING EDITION (XENO COMPATIBLE)
-- =====================================================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

-- Memuat UI Library (TokyoNight Theme)
local FarmingLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/thaufik110/libraryzhushi/refs/heads/main/newui.lua"))()
local Window = FarmingLibrary:CreateWindow("He ZhuShi | Brainrot Fishing", "TokyoNight")

local TabFarm = Window:CreateTab("Auto Fishing", "rbxassetid://6031265976")
local TabExploit = Window:CreateTab("Tes Jackpot", "rbxassetid://6031265976")

-- =====================================================================
-- 🟡 TAB 1: AUTO FISHING (MINIGAME BYPASS)
-- =====================================================================
TabFarm:CreateSection("🎣 Auto Farm")

local autoCast = false
local autoClickMinigame = false

-- 1. Lempar Kail Otomatis
TabFarm:CreateToggle("Auto Cast (Lempar Kail)", false, function(state)
    autoCast = state
    if autoCast then
        task.spawn(function()
            while autoCast do
                pcall(function()
                    Remotes.LuckyBlockFishing.CastRequest:FireServer()
                end)
                task.wait(2) -- Jeda 2 detik biar gak terlalu spam
            end
        end)
    end
end)

-- 2. Spam Klik Saat Minigame Mancing Muncul
TabFarm:CreateToggle("Auto Minigame (Spam Click)", false, function(state)
    autoClickMinigame = state
    if autoClickMinigame then
        task.spawn(function()
            while autoClickMinigame do
                pcall(function()
                    -- Menembakkan sinyal klik ke server dengan sangat cepat
                    Remotes.LuckyBlockFishing.MiniGameClick:FireServer()
                end)
                task.wait(0.05) 
            end
        end)
    end
end)

-- =====================================================================
-- 🔴 TAB 2: EKSPERIMEN JACKPOT & BUG
-- =====================================================================
TabExploit:CreateSection("💸 Uji Coba Celah Uang")

local spamMoney = false

TabExploit:CreateToggle("Spam CollectSuccess (Tes Uang)", false, function(state)
    spamMoney = state
    if spamMoney then
        task.spawn(function()
            while spamMoney do
                pcall(function()
                    -- Mencoba menembak kosong
                    Remotes.CollectMoney.CollectSuccess:FireServer()
                    
                    -- Mencoba menebak argumen (berjaga-jaga kalau server minta angka)
                    Remotes.CollectMoney.CollectSuccess:FireServer(999999)
                end)
                task.wait(0.1)
            end
        end)
    end
end)

TabExploit:CreateSection("🎭 Tes Fitur Aneh")

TabExploit:CreateButton("Tes RequestStealBrainrot", function()
    pcall(function()
        -- Nggak tahu ini apa, tapi namanya "Steal" (Mencuri), sangat menarik untuk dites!
        Remotes.Monetization.RequestStealBrainrot:FireServer()
    end)
end)

TabExploit:CreateButton("Bypass Tutorial", function()
    pcall(function()
        Remotes.Tutorial.SkipTutorial:FireServer()
    end)
end)
