-- 1. Mendapatkan referensi ke GUI pemain lokal
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 2. Membuat Wadah Utama (ScreenGui)
local myScreenGui = Instance.new("ScreenGui")
myScreenGui.Name = "MyCustomGUI"
myScreenGui.ResetOnSpawn = false -- Agar UI tidak hilang saat karakter mati
myScreenGui.Parent = playerGui

-- 3. Membuat Latar Belakang (Frame)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
-- UDim2.new(X Scale, X Offset, Y Scale, Y Offset)
mainFrame.Size = UDim2.new(0, 300, 0, 200) -- Ukuran 300x200 pixel
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100) -- Posisikan tepat di tengah layar
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- Warna abu-abu gelap
mainFrame.BorderSizePixel = 0
mainFrame.Parent = myScreenGui

-- (Opsional) Menambahkan sudut melengkung agar terlihat modern
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = mainFrame

-- 4. Membuat Tombol (TextButton)
local myButton = Instance.new("TextButton")
myButton.Name = "ClickMeButton"
myButton.Size = UDim2.new(0, 200, 0, 50)
myButton.Position = UDim2.new(0.5, -100, 0.5, -25) -- Di tengah dalam Frame
myButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255) -- Warna biru
myButton.Text = "Klik Saya!"
myButton.TextColor3 = Color3.fromRGB(255, 255, 255)
myButton.Font = Enum.Font.GothamBold
myButton.TextSize = 18
myButton.Parent = mainFrame

-- (Opsional) Sudut melengkung untuk tombol
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = myButton

-- 5. Menambahkan Logika saat Tombol Diklik
myButton.MouseButton1Click:Connect(function()
    print("Tombol berhasil diklik!")
    myButton.Text = "Sedang Memproses..."
    myButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100) -- Berubah jadi hijau
    
    wait(1) -- Jeda 1 detik
    
    myButton.Text = "Klik Saya!"
    myButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255) -- Kembali biru
end)
