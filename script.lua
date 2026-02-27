-- =====================================================================
-- 🌌 MYCUSTOM UI LIBRARY - PREMIUM EDITION (ANIMATED & MODERN)
-- =====================================================================
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local MyLibrary = {}

-- Tema Warna Modern
local Theme = {
    MainBG = Color3.fromRGB(20, 20, 25),
    SidebarBG = Color3.fromRGB(25, 25, 31),
    TopbarBG = Color3.fromRGB(20, 20, 25),
    ElementBG = Color3.fromRGB(32, 32, 38),
    HoverBG = Color3.fromRGB(42, 42, 48),
    Accent = Color3.fromRGB(0, 195, 255), -- Neon Cyan
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(180, 180, 180)
}

-- Fungsi Bantuan Animasi (Tweening)
local function Tween(instance, properties, duration)
    local tweenInfo = TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

-- ==========================================
-- 🖥️ 1. FUNGSI MEMBUAT WINDOW UTAMA
-- ==========================================
function MyLibrary:CreateWindow(titleText, bindKey)
    local WindowKeybind = bindKey or Enum.KeyCode.RightControl
    local UIHidden = false

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PremiumHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui

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

    -- Fitur Hide/Show UI pakai Keyboard
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == WindowKeybind then
            UIHidden = not UIHidden
            MainFrame.Visible = not UIHidden
        end
    end)

    -- Topbar & Dragging
    local Topbar = Instance.new("Frame")
    Topbar.Size = UDim2.new(1, 0, 0, 40)
    Topbar.BackgroundColor3 = Theme.TopbarBG
    Topbar.BorderSizePixel = 0
    Topbar.Parent = MainFrame

    local TopbarLine = Instance.new("Frame")
    TopbarLine.Size = UDim2.new(1, 0, 0, 1)
    TopbarLine.Position = UDim2.new(0, 0, 1, 0)
    TopbarLine.BackgroundColor3 = Theme.Accent
    TopbarLine.BorderSizePixel = 0
    TopbarLine.Parent = Topbar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = titleText
    Title.TextColor3 = Theme.Accent
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Topbar

    -- Drag Logic
    local dragging, dragInput, dragStart, startPos
    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
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

    -- Sidebar
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

    -- Container Halaman
    local PageContainer = Instance.new("Frame")
    PageContainer.Size = UDim2.new(1, -140, 1, -41)
    PageContainer.Position = UDim2.new(0, 140, 0, 41)
    PageContainer.BackgroundTransparency = 1
    PageContainer.Parent = MainFrame

    local WindowAPI = {}
    local FirstTab = true

    -- ==========================================
    -- 📁 2. FUNGSI MEMBUAT TAB
    -- ==========================================
    function WindowAPI:CreateTab(tabName)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 32)
        TabBtn.BackgroundColor3 = Theme.ElementBG
        TabBtn.Text = tabName
        TabBtn.TextColor3 = Theme.TextDark
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextSize = 13
        TabBtn.AutoButtonColor = false
        TabBtn.Parent = Sidebar

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabBtn

        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.ScrollBarThickness = 2
        TabPage.ScrollBarImageColor3 = Theme.Accent
        TabPage.BorderSizePixel = 0
        TabPage.Visible = FirstTab
        TabPage.Parent = PageContainer

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.Parent = TabPage

        local PagePadding = Instance.new("UIPadding")
        PagePadding.PaddingTop = UDim.new(0, 10)
        PagePadding.PaddingLeft = UDim.new(0, 10)
        PagePadding.PaddingRight = UDim.new(0, 10)
        PagePadding.PaddingBottom = UDim.new(0, 10)
        PagePadding.Parent = TabPage

        if FirstTab then
            FirstTab = false
            TabBtn.BackgroundColor3 = Theme.Accent
            TabBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        end

        TabBtn.MouseButton1Click:Connect(function()
            for _, child in pairs(PageContainer:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            for _, child in pairs(Sidebar:GetChildren()) do
                if child:IsA("TextButton") then
                    Tween(child, {BackgroundColor3 = Theme.ElementBG})
                    Tween(child, {TextColor3 = Theme.TextDark})
                end
            end
            TabPage.Visible = true
            Tween(TabBtn, {BackgroundColor3 = Theme.Accent})
            Tween(TabBtn, {TextColor3 = Color3.fromRGB(0, 0, 0)})
        end)

        local TabAPI = {}

        -- ==========================================
        -- 🏷️ SECTION HEADER (Pemisah Kategori)
        -- ==========================================
        function TabAPI:CreateSection(secName)
            local SecLabel = Instance.new("TextLabel")
            SecLabel.Size = UDim2.new(1, 0, 0, 20)
            SecLabel.BackgroundTransparency = 1
            SecLabel.Text = " " .. secName
            SecLabel.TextColor3 = Theme.Accent
            SecLabel.Font = Enum.Font.GothamBold
            SecLabel.TextSize = 14
            SecLabel.TextXAlignment = Enum.TextXAlignment.Left
            SecLabel.Parent = TabPage
        end

        -- ==========================================
        -- 🔘 BUTTON (Tombol Animasi)
        -- ==========================================
        function TabAPI:CreateButton(btnName, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 36)
            Btn.BackgroundColor3 = Theme.ElementBG
            Btn.Text = "  " .. btnName
            Btn.TextColor3 = Theme.Text
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 14
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Btn.AutoButtonColor = false
            Btn.Parent = TabPage

            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 6)
            BtnCorner.Parent = Btn

            -- Hover Animation
            Btn.MouseEnter:Connect(function() Tween(Btn, {BackgroundColor3 = Theme.HoverBG}) end)
            Btn.MouseLeave:Connect(function() Tween(Btn, {BackgroundColor3 = Theme.ElementBG}) end)
            
            Btn.MouseButton1Click:Connect(function()
                -- Click Ripple Effect
                local originalColor = Btn.BackgroundColor3
                Tween(Btn, {BackgroundColor3 = Theme.Accent}, 0.1)
                wait(0.1)
                Tween(Btn, {BackgroundColor3 = Theme.HoverBG}, 0.1)
                pcall(callback)
            end)
        end

        -- ==========================================
        -- 🎚️ TOGGLE (Switch ala iOS)
        -- ==========================================
        function TabAPI:CreateToggle(tglName, default, callback)
            local state = default or false

            local Tgl = Instance.new("TextButton")
            Tgl.Size = UDim2.new(1, 0, 0, 36)
            Tgl.BackgroundColor3 = Theme.ElementBG
            Tgl.Text = "  " .. tglName
            Tgl.TextColor3 = Theme.Text
            Tgl.Font = Enum.Font.Gotham
            Tgl.TextSize = 14
            Tgl.TextXAlignment = Enum.TextXAlignment.Left
            Tgl.AutoButtonColor = false
            Tgl.Parent = TabPage

            local TglCorner = Instance.new("UICorner")
            TglCorner.CornerRadius = UDim.new(0, 6)
            TglCorner.Parent = Tgl

            -- Switch BG (Capsule)
            local SwitchBG = Instance.new("Frame")
            SwitchBG.Size = UDim2.new(0, 40, 0, 20)
            SwitchBG.Position = UDim2.new(1, -50, 0.5, -10)
            SwitchBG.BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(50, 50, 55)
            SwitchBG.Parent = Tgl

            local SwitchBGCorner = Instance.new("UICorner")
            SwitchBGCorner.CornerRadius = UDim.new(1, 0)
            SwitchBGCorner.Parent = SwitchBG

            -- Switch Circle
            local SwitchCircle = Instance.new("Frame")
            SwitchCircle.Size = UDim2.new(0, 16, 0, 16)
            SwitchCircle.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
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
                    Tween(SwitchCircle, {Position = UDim2.new(1, -18, 0.5, -8)})
                else
                    Tween(SwitchBG, {BackgroundColor3 = Color3.fromRGB(50, 50, 55)})
                    Tween(SwitchCircle, {Position = UDim2.new(0, 2, 0.5, -8)})
                end
                pcall(callback, state)
            end)
        end

        -- ==========================================
        -- 🎛️ SLIDER (Animasi Smooth)
        -- ==========================================
        function TabAPI:CreateSlider(slName, min, max, default, callback)
            local value = math.clamp(default, min, max)

            local Sl = Instance.new("Frame")
            Sl.Size = UDim2.new(1, 0, 0, 55)
            Sl.BackgroundColor3 = Theme.ElementBG
            Sl.Parent = TabPage

            local SlCorner = Instance.new("UICorner")
            SlCorner.CornerRadius = UDim.new(0, 6)
            SlCorner.Parent = Sl

            local Title = Instance.new("TextLabel")
            Title.Size = UDim2.new(1, -20, 0, 25)
            Title.Position = UDim2.new(0, 10, 0, 5)
            Title.BackgroundTransparency = 1
            Title.Text = slName
            Title.TextColor3 = Theme.Text
            Title.Font = Enum.Font.Gotham
            Title.TextSize = 14
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.Parent = Sl

            local ValLabel = Instance.new("TextLabel")
            ValLabel.Size = UDim2.new(1, -20, 0, 25)
            ValLabel.Position = UDim2.new(0, 10, 0, 5)
            ValLabel.BackgroundTransparency = 1
            ValLabel.Text = tostring(value)
            ValLabel.TextColor3 = Theme.Accent
            ValLabel.Font = Enum.Font.GothamBold
            ValLabel.TextSize = 14
            ValLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValLabel.Parent = Sl

            local BarBG = Instance.new("TextButton")
            BarBG.Size = UDim2.new(1, -20, 0, 8)
            BarBG.Position = UDim2.new(0, 10, 0, 35)
            BarBG.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            BarBG.Text = ""
            BarBG.AutoButtonColor = false
            BarBG.Parent = Sl

            local BarCorner = Instance.new("UICorner")
            BarCorner.CornerRadius = UDim.new(1, 0)
            BarCorner.Parent = BarBG

            local BarFill = Instance.new("Frame")
            local percentage = (value - min) / (max - min)
            BarFill.Size = UDim2.new(percentage, 0, 1, 0)
            BarFill.BackgroundColor3 = Theme.Accent
            BarFill.Parent = BarBG

            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = BarFill

            local isDragging = false
            local function UpdateSlider(input)
                local pos = math.clamp((input.Position.X - BarBG.AbsolutePosition.X) / BarBG.AbsoluteSize.X, 0, 1)
                value = math.floor(((max - min) * pos) + min)
                ValLabel.Text = tostring(value)
                Tween(BarFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.05)
                pcall(callback, value)
            end

            BarBG.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isDragging = true; UpdateSlider(input)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then isDragging = false end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then UpdateSlider(input) end
            end)
        end

        -- ==========================================
        -- 📋 DROPDOWN (Expand Halus)
        -- ==========================================
        function TabAPI:CreateDropdown(dropName, options, callback)
            local isOpen = false

            local DropFrame = Instance.new("Frame")
            DropFrame.Size = UDim2.new(1, 0, 0, 36)
            DropFrame.BackgroundColor3 = Theme.ElementBG
            DropFrame.ClipsDescendants = true
            DropFrame.Parent = TabPage

            local DropCorner = Instance.new("UICorner")
            DropCorner.CornerRadius = UDim.new(0, 6)
            DropCorner.Parent = DropFrame

            local DropBtn = Instance.new("TextButton")
            DropBtn.Size = UDim2.new(1, 0, 0, 36)
            DropBtn.BackgroundTransparency = 1
            DropBtn.Text = "  " .. dropName .. " : -"
            DropBtn.TextColor3 = Theme.Text
            DropBtn.Font = Enum.Font.Gotham
            DropBtn.TextSize = 14
            DropBtn.TextXAlignment = Enum.TextXAlignment.Left
            DropBtn.Parent = DropFrame

            local Arrow = Instance.new("TextLabel")
            Arrow.Size = UDim2.new(0, 30, 0, 36)
            Arrow.Position = UDim2.new(1, -30, 0, 0)
            Arrow.BackgroundTransparency = 1
            Arrow.Text = "▼"
            Arrow.TextColor3 = Theme.TextDark
            Arrow.Font = Enum.Font.Gotham
            Arrow.TextSize = 14
            Arrow.Parent = DropBtn

            local OptionContainer = Instance.new("Frame")
            OptionContainer.Size = UDim2.new(1, 0, 1, -36)
            OptionContainer.Position = UDim2.new(0, 0, 0, 36)
            OptionContainer.BackgroundTransparency = 1
            OptionContainer.Parent = DropFrame

            local OptionLayout = Instance.new("UIListLayout")
            OptionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            OptionLayout.Parent = OptionContainer

            DropBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    Tween(DropFrame, {Size = UDim2.new(1, 0, 0, 36 + (#options * 32))})
                    Tween(Arrow, {Rotation = 180})
                else
                    Tween(DropFrame, {Size = UDim2.new(1, 0, 0, 36)})
                    Tween(Arrow, {Rotation = 0})
                end
            end)

            for _, option in ipairs(options) do
                local OptBtn = Instance.new("TextButton")
                OptBtn.Size = UDim2.new(1, 0, 0, 32)
                OptBtn.BackgroundColor3 = Theme.HoverBG
                OptBtn.Text = "    " .. option
                OptBtn.TextColor3 = Theme.TextDark
                OptBtn.Font = Enum.Font.Gotham
                OptBtn.TextSize = 13
                OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                OptBtn.AutoButtonColor = false
                OptBtn.Parent = OptionContainer

                OptBtn.MouseEnter:Connect(function() Tween(OptBtn, {TextColor3 = Theme.Accent}) end)
                OptBtn.MouseLeave:Connect(function() Tween(OptBtn, {TextColor3 = Theme.TextDark}) end)

                OptBtn.MouseButton1Click:Connect(function()
                    DropBtn.Text = "  " .. dropName .. " : " .. option
                    isOpen = false
                    Tween(DropFrame, {Size = UDim2.new(1, 0, 0, 36)})
                    Tween(Arrow, {Rotation = 0})
                    pcall(callback, option)
                end)
            end
        end

        -- ==========================================
        -- ✍️ TEXTBOX (Kolom Ketik)
        -- ==========================================
        function TabAPI:CreateTextBox(boxName, placeholder, callback)
            local BoxFrame = Instance.new("Frame")
            BoxFrame.Size = UDim2.new(1, 0, 0, 40)
            BoxFrame.BackgroundColor3 = Theme.ElementBG
            BoxFrame.Parent = TabPage
            
            local BoxCorner = Instance.new("UICorner")
            BoxCorner.CornerRadius = UDim.new(0, 6)
            BoxCorner.Parent = BoxFrame
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0.5, 0, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = boxName
            Label.TextColor3 = Theme.Text
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = BoxFrame
            
            local Box = Instance.new("TextBox")
            Box.Size = UDim2.new(0.45, -10, 0, 26)
            Box.Position = UDim2.new(0.5, 0, 0.5, -13)
            Box.BackgroundColor3 = Theme.MainBG
            Box.TextColor3 = Theme.Text
            Box.PlaceholderText = placeholder
            Box.Font = Enum.Font.Gotham
            Box.TextSize = 13
            Box.Parent = BoxFrame
            
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 4)
            UICorner.Parent = Box
            
            Box.FocusLost:Connect(function(enterPressed)
                pcall(callback, Box.Text)
            end)
        end

        -- ==========================================
        -- ⌨️ KEYBIND (Jalan Pintas Keyboard)
        -- ==========================================
        function TabAPI:CreateKeybind(keyName, defaultKey, callback)
            local key = defaultKey
            local isBinding = false

            local KeyFrame = Instance.new("Frame")
            KeyFrame.Size = UDim2.new(1, 0, 0, 36)
            KeyFrame.BackgroundColor3 = Theme.ElementBG
            KeyFrame.Parent = TabPage
            
            local KeyCorner = Instance.new("UICorner")
            KeyCorner.CornerRadius = UDim.new(0, 6)
            KeyCorner.Parent = KeyFrame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0.5, 0, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = keyName
            Label.TextColor3 = Theme.Text
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = KeyFrame

            local KeyBtn = Instance.new("TextButton")
            KeyBtn.Size = UDim2.new(0, 80, 0, 24)
            KeyBtn.Position = UDim2.new(1, -90, 0.5, -12)
            KeyBtn.BackgroundColor3 = Theme.MainBG
            KeyBtn.Text = key.Name
            KeyBtn.TextColor3 = Theme.Accent
            KeyBtn.Font = Enum.Font.GothamBold
            KeyBtn.TextSize = 13
            KeyBtn.Parent = KeyFrame

            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 4)
            BtnCorner.Parent = KeyBtn

            KeyBtn.MouseButton1Click:Connect(function()
                isBinding = true
                KeyBtn.Text = "..."
                KeyBtn.TextColor3 = Color3.fromRGB(255, 50, 50) -- Merah saat mendeteksi
            end)

            UserInputService.InputBegan:Connect(function(input, gpe)
                if isBinding and input.UserInputType == Enum.UserInputType.Keyboard then
                    key = input.KeyCode
                    KeyBtn.Text = key.Name
                    KeyBtn.TextColor3 = Theme.Accent
                    isBinding = false
                elseif not gpe and input.KeyCode == key and not isBinding then
                    pcall(callback)
                end
            end)
        end

        return TabAPI
    end

    return WindowAPI
end


-- =====================================================================
-- 🚀 AREA EKSEKUSI (CARA MENGGUNAKAN LIBRARY PREMIUN INI)
-- =====================================================================

-- 1. Buat Window (Tekan RightControl untuk Hide/Show UI)
local Window = MyLibrary:CreateWindow("💎 Premium Hub v1", Enum.KeyCode.RightControl)

-- 2. Buat Tabs
local TabUtama = Window:CreateTab("General")
local TabPlayer = Window:CreateTab("Local Player")
local TabCombat = Window:CreateTab("Combat")

-- =====================================
-- ISI TAB UTAMA
-- =====================================
TabUtama:CreateSection("Fitur Utama") -- Teks pembatas agar lebih rapi!

TabUtama:CreateToggle("Auto-Farm Monsters", false, function(state)
    print("Auto Farm is now:", state)
end)

TabUtama:CreateDropdown("Pilih Target Area", {"Spawn", "Desert", "Snow", "Volcano"}, function(pilihan)
    print("Menteleportasi bot ke:", pilihan)
end)

TabUtama:CreateSection("Jalan Pintas Keyboard")

-- Coba fitur baru: Keybind!
TabUtama:CreateKeybind("Teleport to Base", Enum.KeyCode.H, function()
    print("Player teleported to Base!")
end)

-- =====================================
-- ISI TAB PLAYER
-- =====================================
TabPlayer:CreateSection("Modifikasi Karakter")

TabPlayer:CreateSlider("Kecepatan Lari", 16, 300, 16, function(nilai)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = nilai
end)

TabPlayer:CreateSlider("Ketinggian Lompat", 50, 500, 50, function(nilai)
    game.Players.LocalPlayer.Character.Humanoid.UseJumpPower = true 
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = nilai
end)

TabPlayer:CreateTextBox("Teleport ke Pemain", "Ketik nama player...", function(nama)
    print("Mencari pemain:", nama)
end)

-- =====================================
-- ISI TAB COMBAT
-- =====================================
TabCombat:CreateSection("Bantuan Bertarung")

TabCombat:CreateButton("Beri Semua Senjata", function()
    print("Senjata berhasil dimasukkan ke inventory!")
end)

TabCombat:CreateToggle("Aimbot Assist", false, function(state)
    print("Aimbot aktif:", state)
end)

TabCombat:CreateToggle("ESP (Tembus Pandang)", true, function(state)
    print("ESP aktif:", state)
end)
