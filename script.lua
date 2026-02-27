-- 1. Panggil Library dari GitHub kamu
local FarmingLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/thaufik110/libraryzhushi/refs/heads/main/newui.lua"))()

-- 2. Langsung buat UI-nya!
local Window = FarmingLibrary:CreateWindow("⚡ SCRIPT BARU")
local TabUtama = Window:CreateTab("General", "rbxassetid://6031265976")

TabUtama:CreateSection("Fitur")
TabUtama:CreateToggle("Auto-Farm", false, function(state)
    print("Auto-farm nyala?", state)
end)
