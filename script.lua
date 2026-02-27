-- =====================================================================
-- 🌾 FARMING HUB UI LIBRARY - EUGENEWU STYLE (FULL CODE)
-- =====================================================================
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local FarmingLibrary = {}

-- 🎨 TEMA WARNA (Navy Blue ala EugeneWu Hub)
local Theme = {
    MainBG = Color3.fromRGB(24, 24, 34),       -- Navy sangat gelap (Background utama)
    SidebarBG = Color3.fromRGB(30, 30, 42),    -- Navy sedikit lebih terang (Sidebar)
    ElementBG = Color3.fromRGB(35, 35, 48),    -- Background Tombol/Elemen
    HoverBG = Color3.fromRGB(45, 45, 60),      -- Warna saat mouse di atas elemen
    Accent = Color3.fromRGB(255, 180, 50),     -- Warna Aksen (Kuning/Oranye Padi)
    Text = Color3.fromRGB(255, 255, 255),      -- Putih bersih
    TextDark = Color3.fromRGB(170, 170, 190)   -- Abu-abu terang untuk teks non-aktif
}

local function Tween(instance, properties, duration)
    local tween = TweenService:Create(instance, TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), properties)
    tween:Play()
    return tween
end

-- ==========================================
-- 🖥️ FUNGSI MEMBUAT WINDOW UTAMA & TOMBOL BULAT
-- ==========================================
function FarmingLibrary:CreateWindow(titleText)
    local UIHidden = false

    -- Buat ScreenGui Utama
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "EugeneWuCloneHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

    -- ==========================================
    -- 🟢 TOMBOL BULAT (FLOATING BUTTON) DI KIRI
    -- ==========================================
    local ToggleButton = Instance.new("ImageButton")
    ToggleButton.Size = UDim2.new(0, 45, 0, 45)
    ToggleButton.Position = UDim2.new(0, 15, 0.5, -22) -- Di pinggir kiri layar
    ToggleButton.BackgroundColor3 = Theme.SidebarBG
    ToggleButton.AutoButtonColor = false
    ToggleButton.Parent = ScreenGui

    -- Sudut Bulat Sempurna
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCorner.Parent = ToggleButton

    -- Garis Pinggir Tombol
    local ToggleStroke = Instance.new("UIStroke")
    ToggleStroke.Color = Theme.Accent
    ToggleStroke.Thickness = 2
    ToggleStroke.Parent = ToggleButton

    -- Ikon Padi / Gambar di dalam tombol bulat
    local ToggleIcon = Instance.new("ImageLabel")
    ToggleIcon.Size = UDim2.new(0, 25, 0, 25)
    ToggleIcon.Position = UDim2.new(0.5, -12.5, 0.5, -12.5)
    ToggleIcon.BackgroundTransparency = 1
    -- Ini ID gambar daun/tanaman sebagai contoh. Kamu bisa ganti angka 6031265976 dengan ID gambar padi milikmu
    ToggleIcon.Image = "rbxassetid://6031265976" 
    ToggleIcon.ImageColor3 = Theme.Accent
    ToggleIcon.Parent = ToggleButton

    -- Animasi saat kursor di atas tombol bulat
    ToggleButton.MouseEnter:Connect(function() Tween(ToggleButton, {BackgroundColor3 = Theme.HoverBG}) end)
    ToggleButton.MouseLeave:Connect(function() Tween(ToggleButton, {BackgroundColor3 = Theme.SidebarBG}) end)

    -- ==========================================
    -- 🪟 KANVAS UI UTAMA (MAIN FRAME)
    -- ==========================================
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 550, 0, 380)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -190)
    MainFrame.BackgroundColor3 = Theme.MainBG
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame

    -- Logika Klik Tombol Bulat untuk Buka/Tutup UI
    ToggleButton.MouseButton1Click:Connect(function()
        UIHidden = not UIHidden
        if UIHidden then
            Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0, 35, 0.5, 0)}, 0.3)
            wait(0.3)
            MainFrame.Visible = false
        else
            MainFrame.Visible = true
            Tween(MainFrame, {Size = UDim2.new(0, 550, 0, 380), Position = UDim2.new(0.5, -275, 0.5, -190)}, 0.3)
        end
    end)

    -- Topbar & Fitur Geser UI
    local Topbar = Instance.new("Frame")
    Topbar.Size = UDim2.new(1, 0, 0, 40)
    Topbar.BackgroundColor3 = Theme.SidebarBG
    Topbar.BorderSizePixel = 0
    Topbar.Parent = MainFrame

    local TopbarLine = Instance.new("Frame")
    TopbarLine.Size = UDim2.new(1, 0, 0, 1)
    TopbarLine.Position = UDim2.new(0, 0, 1, 0)
    TopbarLine.BackgroundColor3 = Theme.ElementBG
    TopbarLine.BorderSizePixel = 0
    TopbarLine.Parent = Topbar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = titleText
    Title.TextColor3 = Theme.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Topbar

    -- Logika Dragging (Geser Layar)
    local dragging, dragInput, dragStart, startPos
    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    Topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Sidebar (Menu Kiri)
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 140, 1, -41)
    Sidebar.Position = UDim2.new(0, 0, 0, 41)
    Sidebar.BackgroundColor3 = Theme.SidebarBG
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Padding = UDim.new(0, 5)
    SidebarLayout.Parent = Sidebar

    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.PaddingTop = UDim.new(0, 10)
    SidebarPadding.PaddingLeft = UDim.new(0, 10)
    SidebarPadding.PaddingRight = UDim.new(0, 10)
    SidebarPadding.Parent = Sidebar

    -- Tempat Halaman Kanan
    local PageContainer = Instance.new("Frame")
    PageContainer.Size = UDim2.new(1, -140, 1, -41)
    PageContainer.Position = UDim2.new(0, 140, 0, 41)
    PageContainer.BackgroundTransparency = 1
    PageContainer.Parent = MainFrame

    local WindowAPI = {}
    local FirstTab = true

    -- ==========================================
    -- 📁 FUNGSI MEMBUAT TAB (DENGAN IKON)
    -- ==========================================
    function WindowAPI:CreateTab(tabName, iconId)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 36)
        TabBtn.BackgroundColor3 = Theme.SidebarBG
        TabBtn.Text = "" -- Teks dikosongkan karena kita pakai TextLabel terpisah agar sejajar ikon
        TabBtn.AutoButtonColor = false
        TabBtn.Parent = Sidebar

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabBtn

        -- Ikon di sebelah kiri Tab
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Size = UDim2.new(0, 18, 0, 18)
        TabIcon.Position = UDim2.new(0, 10, 0.5, -9)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = iconId or "rbxassetid://6031265976" -- Default icon
        TabIcon.ImageColor3 = Theme.TextDark
        TabIcon.Parent = TabBtn

        -- Teks Tab
        local TabText = Instance.new("TextLabel")
        TabText.Size = UDim2.new(1, -35, 1, 0)
        TabText.Position = UDim2.new(0, 35, 0, 0)
        TabText.BackgroundTransparency = 1
        TabText.Text = tabName
        TabText.TextColor3 = Theme.TextDark
        TabText.Font = Enum.Font.GothamSemibold
        TabText.TextSize = 13
        TabText.TextXAlignment = Enum.TextXAlignment.Left
        TabText.Parent = TabBtn

        -- Halaman Tab
        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.ScrollBarThickness = 3
        TabPage.ScrollBarImageColor3 = Theme.ElementBG
        TabPage.BorderSizePixel = 0
        TabPage.Visible = FirstTab
        TabPage.Parent = PageContainer

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.Parent = TabPage

        local PagePadding = Instance.new("UIPadding")
        PagePadding.PaddingTop = UDim.new(0, 15)
        PagePadding.PaddingLeft = UDim.new(0, 15)
        PagePadding.PaddingRight = UDim.new(0, 15)
        PagePadding.PaddingBottom = UDim.new(0, 15)
        PagePadding.Parent = TabPage

        -- Jika ini tab pertama, buat jadi warna aktif (Aksen)
        if FirstTab then
            FirstTab = false
            TabBtn.BackgroundColor3 = Theme.Accent
            TabText.TextColor3 = Theme.MainBG
            TabIcon.ImageColor3 = Theme.MainBG
        end

        -- Logika Pindah Tab
        TabBtn.MouseButton1Click:Connect(function()
            for _, child in pairs(PageContainer:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            for _, child in pairs(Sidebar:GetChildren()) do
                if child:IsA("TextButton") then
                    Tween(child, {BackgroundColor3 = Theme.SidebarBG})
                    child:FindFirstChild("TextLabel").TextColor3 = Theme.TextDark
                    child:FindFirstChild("ImageLabel").ImageColor3 = Theme.TextDark
                end
            end
            TabPage.Visible = true
            Tween(TabBtn, {BackgroundColor3 = Theme.Accent})
            TabText.TextColor3 = Theme.MainBG
            TabIcon.ImageColor3 = Theme.MainBG
        end)

        local TabAPI = {}

        -- ==========================================
        -- 🏷️ SECTION HEADER (Tulisan Kuning Pemisah)
        -- ==========================================
        function TabAPI:CreateSection(secName)
            local SecLabel = Instance.new("TextLabel")
            SecLabel.Size = UDim2.new(1, 0, 0, 20)
            SecLabel.BackgroundTransparency = 1
            SecLabel.Text = "✨ " .. secName
            SecLabel.TextColor3 = Theme.Accent
            SecLabel.Font = Enum.Font.GothamBold
            SecLabel.TextSize = 13
            SecLabel.TextXAlignment = Enum.TextXAlignment.Left
            SecLabel.Parent = TabPage
        end

        -- ==========================================
        -- 🔘 BUTTON
        -- ==========================================
        function TabAPI:CreateButton(btnName, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 40)
            Btn.BackgroundColor3 = Theme.ElementBG
            Btn.Text = "   " .. btnName
            Btn.TextColor3 = Theme.Text
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 14
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Btn.AutoButtonColor = false
            Btn.Parent = TabPage

            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 6)
            BtnCorner.Parent = Btn

            Btn.MouseEnter:Connect(function() Tween(Btn, {BackgroundColor3 = Theme.HoverBG}) end)
            Btn.MouseLeave:Connect(function() Tween(Btn, {BackgroundColor3 = Theme.ElementBG}) end)
            Btn.MouseButton1Click:Connect(function() pcall(callback) end)
        end

        -- ==========================================
        -- 🎚️ TOGGLE (ON/OFF)
        -- ==========================================
        function TabAPI:CreateToggle(tglName, default, callback)
            local state = default or false

            local Tgl = Instance.new("TextButton")
            Tgl.Size = UDim2.new(1, 0, 0, 40)
            Tgl.BackgroundColor3 = Theme.ElementBG
            Tgl.Text = "   " .. tglName
            Tgl.TextColor3 = Theme.Text
            Tgl.Font = Enum.Font.Gotham
            Tgl.TextSize = 14
            Tgl.TextXAlignment = Enum.TextXAlignment.Left
            Tgl.AutoButtonColor = false
            Tgl.Parent = TabPage

            local TglCorner = Instance.new("UICorner")
            TglCorner.CornerRadius = UDim.new(0, 6)
            TglCorner.Parent = Tgl

            local SwitchBG = Instance.new("Frame")
            SwitchBG.Size = UDim2.new(0, 36, 0, 18)
            SwitchBG.Position = UDim2.new(1, -46, 0.5, -9)
            SwitchBG.BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(60, 60, 75)
            SwitchBG.Parent = Tgl

            local SwitchBGCorner = Instance.new("UICorner")
            SwitchBGCorner.CornerRadius = UDim.new(1, 0)
            SwitchBGCorner.Parent = SwitchBG

            local SwitchCircle = Instance.new("Frame")
            SwitchCircle.Size = UDim2.new(0, 14, 0, 14)
            SwitchCircle.Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            SwitchCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SwitchCircle.Parent = SwitchBG

            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = SwitchCircle

            Tgl.MouseEnter:Connect(function() Tween(Tgl, {BackgroundColor3 = Theme.HoverBG}) end)
            Tgl.MouseLeave:Connect(function() Tween(Tgl, {BackgroundColor3 = Theme.ElementBG}) end)

            Tgl.MouseButton1Click:Connect(function()
                state = not state
                if state then
                    Tween(SwitchBG, {BackgroundColor3 = Theme.Accent})
                    Tween(SwitchCircle, {Position = UDim2.new(1, -16, 0.5, -7)})
                else
                    Tween(SwitchBG, {BackgroundColor3 = Color3.fromRGB(60, 60, 75)})
                    Tween(SwitchCircle, {Position = UDim2.new(0, 2, 0.5, -7)})
                end
                pcall(callback, state)
            end)
        end

        return TabAPI
    end

    return WindowAPI
end


-- =====================================================================
-- 🚀 AREA EKSEKUSI (BISA LANGSUNG DITES!)
-- =====================================================================

-- 1. Buat Window Utama
local Window = FarmingLibrary:CreateWindow("⚡ EUGENEWU HUB CLONE")

-- 2. Buat Tab (Format: Nama Tab, ID Ikon Gambar)
-- ID "3926305904" itu ID bawaan Roblox, kamu bebas ganti dengan URL rbxassetid punyamu
local TabInfo = Window:CreateTab("Info", "rbxassetid://3926305904")
local TabFarm = Window:CreateTab("Farm", "rbxassetid://3926307971")
local TabShop = Window:CreateTab("Shop", "rbxassetid://3926305904")

-- =====================================
-- MENGISI TAB INFO
-- =====================================
TabInfo:CreateSection("EUGENEWU HUB")

TabInfo:CreateButton("Script auto farming lengkap untuk game bertani...", function()
    -- Hanya tombol sebagai info (bisa diabaikan)
end)

-- =====================================
-- MENGISI TAB FARM
-- =====================================
TabFarm:CreateSection("Fitur Utama Farming")

TabFarm:CreateToggle("Farm — Kontrol manual", false, function(state)
    print("Manual Farm:", state)
end)

TabFarm:CreateToggle("Full Auto — Plant+Harvest+Sell", true, function(state)
    print("Full Auto Farm:", state)
end)

TabFarm:CreateToggle("Teleport — Pindah Kebun", false, function(state)
    print("Teleport Kebun:", state)
end)

TabFarm:CreateButton("Burst Plant — Semua biji 1 frame!", function()
    print("Mengeksekusi ledakan penanaman...")
end)
