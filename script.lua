local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/thaufik110/libraryzhushi/refs/heads/main/newui.lua"))()

local Window = Library:CreateWindow("🌊 AQUA HUB", "TokyoNight")

local TabInfo = Window:CreateTab("Water", "rbxassetid://3926305904")
TabInfo:CreateSection("Berenang")
TabInfo:CreateToggle("Auto Swim", true, function() end)
