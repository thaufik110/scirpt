-- =====================================================================
-- 🛠️ PREMIUM REMOTE EVENT SCANNER (TOKYONIGHT THEME + COPY ALL)
-- =====================================================================
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Hapus UI lama agar tidak menumpuk
if CoreGui:FindFirstChild("PremiumScannerUI") then
    CoreGui.PremiumScannerUI:Destroy()
end

-- Setup fungsi Clipboard (Mendukung mayoritas eksekutor)
local clipboard = setclipboard or toclipboard or function() 
    warn("Eksekutor kamu tidak mendukung fitur Copy Clipboard otomatis.") 
end

-- Membuat ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PremiumScannerUI"
ScreenGui.Parent = CoreGui

-- ================== TAMPILAN UTAMA ==================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 550, 0, 400)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(26, 27, 38) -- TokyoNight Background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Header / Judul
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(36, 40, 59)
Header.BorderSizePixel = 0
Header.Parent = MainFrame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

-- Menutupi sudut bawah header agar menyatu dengan background
local HeaderBlock = Instance.new("Frame")
HeaderBlock.Size = UDim2.new(1, 0, 0, 10)
HeaderBlock.Position = UDim2.new(0, 0, 1, -10)
HeaderBlock.BackgroundColor3 = Color3.fromRGB(36, 40, 59)
HeaderBlock.BorderSizePixel = 0
HeaderBlock.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🔍 Memindai RemoteEvent..."
Title.TextColor3 = Color3.fromRGB(122, 162, 247) -- TokyoNight Blue
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -40, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(247, 118, 142) -- TokyoNight Red
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.Parent = Header

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ================== AREA DAFTAR (SCROLL) ==================
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -100)
Scroll.Position = UDim2.new(0, 10, 0, 45)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 5
Scroll.ScrollBarImageColor3 = Color3.fromRGB(122, 162, 247)
Scroll.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 8)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Parent = Scroll

-- Variabel untuk menyimpan SELURUH hasil text
local allCollectedData = "-- HASIL SCAN REMOTE EVENT (CHOP YOUR TREE)\n\n"
local remoteCount = 0

-- ================== TOMBOL COPY ALL ==================
local CopyAllBtn = Instance.new("TextButton")
CopyAllBtn.Size = UDim2.new(1, -20, 0, 40)
CopyAllBtn.Position = UDim2.new(0, 10, 1, -45)
CopyAllBtn.BackgroundColor3 = Color3.fromRGB(122, 162, 247)
CopyAllBtn.Text = "📋 COPY SEMUA HASIL KE CLIPBOARD"
CopyAllBtn.TextColor3 = Color3.fromRGB(26, 27, 38)
CopyAllBtn.Font = Enum.Font.GothamBold
CopyAllBtn.TextSize = 14
CopyAllBtn.Parent = MainFrame
Instance.new("UICorner", CopyAllBtn).CornerRadius = UDim.new(0, 8)

CopyAllBtn.MouseButton1Click:Connect(function()
    clipboard(allCollectedData)
    CopyAllBtn.Text = "✅ BERHASIL DI-COPY!"
    task.wait(2)
    CopyAllBtn.Text = "📋 COPY SEMUA HASIL KE CLIPBOARD"
end)

-- ================== FUNGSI PENAMBAH DAFTAR ==================
local function CreateEntry(number, name, fullPath)
    -- Membentuk kode eksekusi yang rapi
    local executeCode
    if fullPath:sub(1, 17) == "ReplicatedStorage" then
        executeCode = "game:GetService('ReplicatedStorage')" .. fullPath:sub(18) .. ":FireServer()"
    else
        executeCode = fullPath .. ":FireServer()"
    end

    -- Menambahkan ke string raksasa untuk Copy All
    allCollectedData = allCollectedData .. "-- [" .. number .. "] Nama: " .. name .. "\n"
    allCollectedData = allCollectedData .. "-- Lokasi: " .. fullPath .. "\n"
    allCollectedData = allCollectedData .. executeCode .. "\n\n"

    -- Membuat UI Kotak per item
    local ItemFrame = Instance.new("Frame")
    ItemFrame.Size = UDim2.new(1, -10, 0, 60)
    ItemFrame.BackgroundColor3 = Color3.fromRGB(41, 46, 66)
    ItemFrame.BorderSizePixel = 0
    ItemFrame.Parent = Scroll
    Instance.new("UICorner", ItemFrame).CornerRadius = UDim.new(0, 6)

    local InfoLabel = Instance.new("TextLabel")
    InfoLabel.Size = UDim2.new(1, -60, 0, 20)
    InfoLabel.Position = UDim2.new(0, 10, 0, 5)
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.Text = "💡 [" .. number .. "] Nama: " .. name .. " | Lokasi: " .. fullPath
    InfoLabel.TextColor3 = Color3.fromRGB(169, 177, 214)
    InfoLabel.Font = Enum.Font.GothamSemibold
    InfoLabel.TextSize = 12
    InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
    InfoLabel.TextTruncate = Enum.TextTruncate.AtEnd
    InfoLabel.Parent = ItemFrame

    local CodeBox = Instance.new("TextBox")
    CodeBox.Size = UDim2.new(1, -70, 0, 25)
    CodeBox.Position = UDim2.new(0, 10, 0, 30)
    CodeBox.BackgroundColor3 = Color3.fromRGB(26, 27, 38)
    CodeBox.Text = executeCode
    CodeBox.TextColor3 = Color3.fromRGB(158, 206, 106) -- TokyoNight Green
    CodeBox.Font = Enum.Font.Code
    CodeBox.TextSize = 11
    CodeBox.TextXAlignment = Enum.TextXAlignment.Left
    CodeBox.ClearTextOnFocus = false
    CodeBox.TextEditable = false
    CodeBox.Parent = ItemFrame
    Instance.new("UICorner", CodeBox).CornerRadius = UDim.new(0, 4)

    local CopySingle = Instance.new("TextButton")
    CopySingle.Size = UDim2.new(0, 50, 0, 25)
    CopySingle.Position = UDim2.new(1, -55, 0, 30)
    CopySingle.BackgroundColor3 = Color3.fromRGB(36, 40, 59)
    CopySingle.Text = "Copy"
    CopySingle.TextColor3 = Color3.fromRGB(122, 162, 247)
    CopySingle.Font = Enum.Font.GothamBold
    CopySingle.TextSize = 11
    CopySingle.Parent = ItemFrame
    Instance.new("UICorner", CopySingle).CornerRadius = UDim.new(0, 4)

    CopySingle.MouseButton1Click:Connect(function()
        clipboard(executeCode)
        CopySingle.Text = "OK!"
        task.wait(1)
        CopySingle.Text = "Copy"
    end)
end

-- ================== PROSES SCANNING ==================
for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
    if obj:IsA("RemoteEvent") then
        remoteCount = remoteCount + 1
        CreateEntry(remoteCount, obj.Name, obj:GetFullName())
    end
end

Title.Text = "🔍 Ditemukan " .. remoteCount .. " RemoteEvents!"

-- Update otomatis ukuran ScrollArea
ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
end)
