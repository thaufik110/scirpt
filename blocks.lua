-- =====================================================================
-- 🎣 HE ZHUSHI HUB - BRAINROT FISHING (FINAL AFK EDITION)
-- =====================================================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

-- Memuat UI Library (TokyoNight Theme)
local FarmingLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/thaufik110/libraryzhushi/refs/heads/main/newui.lua"))()
local Window = FarmingLibrary:CreateWindow("He ZhuShi | Brainrot Fishing", "TokyoNight")

local TabFarm = Window:CreateTab("Auto Fishing", "rbxassetid://6031265976")

-- =====================================================================
-- 🟡 TAB 1: FULL AFK SYSTEM (PURE GHOST CLICK / REMOTE SPAM)
-- =====================================================================
TabFarm:CreateSection("🔥 Mesin Pencetak Uang (AFK) 🔥")

local autoFish = false

TabFarm:CreateToggle("Auto Win Minigame (Ghost Click)", false, function(state)
    autoFish = state
    
    if autoFish then
        task.spawn(function()
            while autoFish do
                pcall(function()
                    -- 👻 MURNI KLIK GAIB (TANPA GANGGU MOUSE/KAMERA)
                    -- Kita hanya menembakkan sinyal kemenangan langsung ke server
                    Remotes.LuckyBlockFishing.MiniGameClick:FireServer()
                    Remotes.LuckyBlockFishing.MiniGameHitFeedback:FireServer()
                end)
                
                -- Berjalan sangat cepat di latar belakang tanpa membuat lag kursor
                task.wait() 
            end
        end)
    end
end)

-- =====================================================================
-- ⚙️ PENGATURAN ANTI-DISCONNECT (PENTING UNTUK AFK)
-- =====================================================================
TabFarm:CreateSection("Sistem Keamanan AFK")

TabFarm:CreateButton("Aktifkan Anti-AFK (Biar Gak Di-Kick)", function()
    -- Memaksa Roblox berpikir kamu terus bermain meskipun ditinggal tidur
    local connection = getconnections or get_signal_cons
    if connection then
        for i,v in pairs(connection(Players.LocalPlayer.Idled)) do
            if v["Disable"] then
                v["Disable"](v)
            elseif v["Disconnect"] then
                v["Disconnect"](v)
            end
        end
    else
        Players.LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
    print("Anti-AFK Berhasil Diaktifkan!")
end)
