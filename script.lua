local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/thaufik110/libraryzhushi/refs/heads/main/new.lua"))()

local Window = Library:CreateWindow("Testing UI Lite", "Ocean") -- Tema: DarkTheme, BloodTheme, Ocean, TokyoNight

-- Contoh Tab
local Tab = Window:CreateTab("Main", "rbxassetid://6031265976") -- Gunakan Icon ID jika perlu

Tab:CreateSection("Settings")
Tab:CreateButton("Test Button", function()
    print("Tombol ditekan!")
end)

Tab:CreateToggle("Auto Farm", false, function(state)
    print("Toggle state:", state)
end)

Tab:CreateSlider("Speed", 1, 100, 16, function(val)
    print("Speed:", val)
end)
