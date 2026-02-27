-- Memanggil Library dari GitHub kamu
local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/thaufik110/libraryzhushi/refs/heads/main/new.lua"))()

-- Inisialisasi (Langsung muncul tanpa loading screen)
local Window = Lib.new({
    Title = "He ZhuShi V2.4 Lite",
    Theme = "Dark"
})

-- Menambah Tab
local Tab1 = Window:AddTab("Main")

-- Contoh Menambah Button (Tanpa efek ripple yang berat)
-- Note: Di library asli kamu, fungsi AddButton ada di dalam Section/Tab
-- Sesuaikan dengan struktur metode AddTab yang kamu upload.
print("Script Aktif!")
