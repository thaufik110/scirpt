-- Memuat Library dari GitHub
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/thaufik110/libraryzhushi/refs/heads/main/new.lua"))()

-- 1. Inisialisasi Window Utama
local Window = Library.new({
    Title = "He ZhuShi Premium", -- Menggunakan nickname kamu
    Subtitle = "V2.4 Lite Edition",
    Theme = "Dark"
})

-- 2. Menambah Tab (misalnya untuk game Fish It atau Lost Saga)
local MainTab = Window:AddTab("Main Menu")
local MiscTab = Window:AddTab("Misc")

-- 3. Menambahkan Elemen ke dalam Tab
MainTab:AddToggle("Auto Clicker", false, function(v)
    print("Status: ", v)
end)

MainTab:AddButton("Teleport to Base", function()
    print("Teleporting...")
end)

-- 4. Contoh Notification / Toast (Jika fiturnya ada di script GitHub kamu)
-- Library:Toast({Title = "Success", Message = "Script Loaded!", Type = "Success"})

print("UI Berhasil Dimuat!")
