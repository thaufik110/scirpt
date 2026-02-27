local Library = loadstring(game:HttpGet("url_raw_kode_ini"))()

local Window = Library.new({
    Title = "My Script Hub",
    Subtitle = "Premium Edition",
    Size = UDim2.new(0, 600, 0, 400),
    Theme = "Dark" -- Pilihan: Dark, Midnight, Ocean, Rose
})

-- Membuat Toggle Button di layar
Window:CreateToggleButton({ Icon = "⚡" })

-- Menambah Tab
local Tab = Window:AddTab({ Name = "Main", Icon = "🏠" })

-- Menambah Section
local Section = Tab:AddSection({ Title = "Settings" })

-- Menambah Elemen
Section:AddToggle({
    Text = "Auto Farm",
    Default = false,
    Callback = function(Value)
        print("Auto Farm:", Value)
    end
})

Section:AddDropdown({
    Text = "Select Weapon",
    Items = {"Sword", "Gun", "Knife"},
    Default = "Sword",
    Callback = function(Value)
        print("Selected:", Value)
    end
})
