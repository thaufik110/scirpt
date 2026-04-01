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
-- 🟡 TAB 1: FULL AFK SYSTEM (REVISI AUTO KLIK SAJA)
-- =====================================================================
TabFarm:CreateSection("🔥 Mesin Pencetak Uang (AFK) 🔥")

local autoFish = false

TabFarm:CreateToggle("Auto Klik Minigame (Super Cepat)", false, function(state)
    autoFish = state
    
    if autoFish then
        task.spawn(function()
            while autoFish do
                pcall(function()
                    -- Hanya fokus menembakkan remote klik minigame!
                    -- Lempar pancingan secara manual, dan script akan otomatis
                    -- memenangkan minigamenya sekejap mata.
                    Remotes.LuckyBlockFishing.MiniGameClick:FireServer()
                end)
                
                -- Menggunakan task.wait() tanpa angka.
                -- Ini adalah cara paling aman dan paling cepat di Roblox (berjalan setiap frame/~0.01 detik).
                -- Jauh lebih cepat dari task.wait(0.05) tapi tidak akan membuat Roblox kamu freeze/crash.
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
