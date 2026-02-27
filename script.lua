local UILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/thaufik110/libraryzhushi/refs/heads/main/new.lua"))()

local Window = UILib.new({
    Title = "He ZhuShi Hub",
    Subtitle = "Premium Edition",
    Theme = "Dark" -- Pilihan: Dark, Midnight, Ocean, Rose
})

-- Contoh menambah Tab
local Tab1 = Window:AddTab({
    Name = "Main Menu",
    Icon = "🏠"
})

local Section1 = Tab1:AddSection({
    Title = "Player Settings"
})

Section1:AddToggle({
    Text = "Auto Farm",
    Default = false,
    Callback = function(v)
        print("Status: ", v)
    end
})

Window:Notify("Library Berhasil Dimuat!")
