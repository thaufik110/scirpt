-- 1. Panggil mesin dari GitHub-mu
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/thaufik110/libraryzhushi/refs/heads/main/newui.lua"))()

-- 2. Mulai buat UI spesifik untuk game ini
local Window = Library:CreateWindow("⚡ SCRIPT FISH IT")

-- 3. Buat Tab & Isinya
local TabUtama = Window:CreateTab("Auto Cast", "rbxassetid://6031265976")

TabUtama:CreateToggle("Auto Mancing", false, function(state)
    if state then
        print("Bot pancing aktif!")
    else
        print("Bot pancing mati!")
    end
end)
