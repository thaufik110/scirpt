-- =====================================================================
-- 🔍 SCANNER REMOTE EVENT (UI VERSION - COPYABLE)
-- =====================================================================
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Hapus UI lama kalau ada biar gak numpuk
if CoreGui:FindFirstChild("ScannerUI") then
    CoreGui.ScannerUI:Destroy()
end

-- Membuat ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ScannerUI"
ScreenGui.Parent = CoreGui

-- Membuat Frame Utama
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 300)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Bisa digeser-geser
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Judul
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
Title.Text = " 🔍 RemoteEvent Scanner (Bisa di-Copy)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

-- Tombol Close
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = MainFrame

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Area Scroll untuk Daftar
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -55)
Scroll.Position = UDim2.new(0, 10, 0, 45)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 4
Scroll.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = Scroll

-- Fungsi untuk menambah daftar ke dalam UI
local function addEntry(eventName, fullPath)
    local EntryBox = Instance.new("TextBox")
    EntryBox.Size = UDim2.new(1, -10, 0, 30)
    EntryBox.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    EntryBox.TextColor3 = Color3.fromRGB(150, 255, 150)
    EntryBox.Font = Enum.Font.Code
    EntryBox.TextSize = 12
    EntryBox.TextXAlignment = Enum.TextXAlignment.Left
    EntryBox.ClearTextOnFocus = false -- Teks tidak akan hilang saat diklik
    EntryBox.TextEditable = false -- Teks tidak bisa diedit, cuma bisa di-copy
    
    -- Memodifikasi teks agar langsung siap di-paste ke UI utamamu
    local readyCode = "game:GetService('" .. fullPath:match("^(.-)%.") .. "')." .. fullPath:match("^.-%.(.*)") .. ":FireServer()"
    
    -- Kalau error parsing, tampilkan path biasa
    if not readyCode:match("FireServer") then
        readyCode = fullPath .. ":FireServer()"
    end

    EntryBox.Text = " " .. readyCode
    EntryBox.Parent = Scroll
    
    local EntryCorner = Instance.new("UICorner")
    EntryCorner.CornerRadius = UDim.new(0, 4)
    EntryCorner.Parent = EntryBox
end

-- =====================================================================
-- 🚀 PROSES SCANNING DIMULAI
-- =====================================================================
local count = 0
for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
    if obj:IsA("RemoteEvent") then
        addEntry(obj.Name, obj:GetFullName())
        count = count + 1
    end
end

-- Update ukuran scroll agar pas
Scroll.CanvasSize = UDim2.new(0, 0, 0, count * 35)

-- Notifikasi kecil di judul
Title.Text = " 🔍 Ditemukan " .. count .. " RemoteEvents!"
