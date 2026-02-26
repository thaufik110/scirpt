-- ==========================================
-- 🛠️ INISIALISASI LIBRARY & SERVICES
-- ==========================================
local MyCustomUI = {}
local UserInputService = game:GetService("UserInputService")

-- ==========================================
-- 🖥️ FUNGSI MEMBUAT WINDOW UTAMA
-- ==========================================
function MyCustomUI:CreateWindow(title)
    -- 1. Setup Layar Utama
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MyHubGUI"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 500, 0, 350)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 6)
    uiCorner.Parent = mainFrame

    -- 2. Setup TopBar (Untuk Judul & Area Drag)
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 30)
    topBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    topBar.BorderSizePixel = 0
    topBar.Parent = mainFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = "  " .. title
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = topBar

    -- 🖱️ LOGIKA DRAG (MENGGESER UI)
    local dragging, dragInput, dragStart, startPos

    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- 3. Setup Sidebar (Menu Kiri)
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 130, 1, -30)
    sidebar.Position = UDim2.new(0, 0, 0, 30)
    sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainFrame

    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Padding = UDim.new(0, 2)
    sidebarLayout.Parent = sidebar

    -- 4. Setup Wadah Halaman Konten
    local pagesContainer = Instance.new("Frame")
    pagesContainer.Size = UDim2.new(1, -130, 1, -30)
    pagesContainer.Position = UDim2.new(0, 130, 0, 30)
    pagesContainer.BackgroundTransparency = 1
    pagesContainer.Parent = mainFrame

    local WindowAPI = {}
    local isFirstTab = true

    -- ==========================================
    -- 📁 FUNGSI MEMBUAT TAB BARU
    -- ==========================================
    function WindowAPI:CreateTab(tabName)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1, 0, 0, 35)
        tabBtn.Text = tabName
        tabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        tabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        tabBtn.Font = Enum.Font.GothamSemibold
        tabBtn.BorderSizePixel = 0
        tabBtn.Parent = sidebar

        local tabPage = Instance.new("ScrollingFrame")
        tabPage.Size = UDim2.new(1, -10, 1, -10)
        tabPage.Position = UDim2.new(0, 5, 0, 5)
        tabPage.BackgroundTransparency = 1
        tabPage.ScrollBarThickness = 4
        tabPage.BorderSizePixel = 0
        tabPage.Visible = isFirstTab
        tabPage.Parent = pagesContainer

        local pageLayout = Instance.new("UIListLayout")
        pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        pageLayout.Padding = UDim.new(0, 6)
        pageLayout.Parent = tabPage

        -- Tampilan Tab Aktif Default
        if isFirstTab then
            isFirstTab = false
            tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            tabBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
        end

        -- Logika Pindah Tab
        tabBtn.MouseButton1Click:Connect(function()
            for _, child in pairs(pagesContainer:GetChildren()) do
                if child:IsA("ScrollingFrame") then
                    child.Visible = false
                end
            end
            for _, child in pairs(sidebar:GetChildren()) do
                if child:IsA("TextButton") then
                    child.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    child.TextColor3 = Color3.fromRGB(200, 200, 200)
                end
            end
            
            tabPage.Visible = true
            tabBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
            tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        local TabAPI = {}
        
        -- ==========================================
        -- 🔘 FUNGSI MEMBUAT TOMBOL BIASA
        -- ==========================================
        function TabAPI:CreateButton(btnText, callback)
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, -10, 0, 35) 
            button.Text = btnText
            button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.Font = Enum.Font.Gotham
            button.Parent = tabPage

            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 4)
            btnCorner.Parent = button

            button.MouseButton1Click:Connect(function()
                pcall(callback) 
            end)
        end

        -- ==========================================
        -- 🎚️ FUNGSI MEMBUAT TOGGLE (ON/OFF)
        -- ==========================================
        function TabAPI:CreateToggle(tglText, defaultState, callback)
            local state = defaultState or false
            
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Size = UDim2.new(1, -10, 0, 35)
            toggleFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            toggleFrame.Parent = tabPage
            
            local uiCorner = Instance.new("UICorner")
            uiCorner.CornerRadius = UDim.new(0, 4)
            uiCorner.Parent = toggleFrame
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -50, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = tglText
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = toggleFrame
            
            local checkBtn = Instance.new("TextButton")
            checkBtn.Size = UDim2.new(0, 25, 0, 25)
            checkBtn.Position = UDim2.new(1, -35, 0.5, -12.5)
            checkBtn.Text = ""
            checkBtn.BackgroundColor3 = state and Color3.fromRGB(50, 150, 255) or Color3.fromRGB(30, 30, 30)
            checkBtn.Parent = toggleFrame
            
            local checkCorner = Instance.new("UICorner")
            checkCorner.CornerRadius = UDim.new(0, 4)
            checkCorner.Parent = checkBtn
            
            checkBtn.MouseButton1Click:Connect(function()
                state = not state 
                checkBtn.BackgroundColor3 = state and Color3.fromRGB(50, 150, 255) or Color3.fromRGB(30, 30, 30)
                pcall(callback, state) 
            end)
        end
        
        return TabAPI 
    end

    return WindowAPI 
end

-- ==========================================
-- 🚀 AREA EKSEKUSI (PENGGUNAAN LIBRARY)
-- ==========================================

-- 1. Buat Window
local WindowSaya = MyCustomUI:CreateWindow("Exploit Hub Premium")

-- 2. Buat Tab
local TabUtama = WindowSaya:CreateTab("Main")
local TabSetting = WindowSaya:CreateTab("Settings")

-- 3. Isi Tab Utama dengan Tombol & Toggle
TabUtama:CreateButton("Beri Saya Uang", function()
    print("Mengeksekusi cheat uang...")
end)

TabUtama:CreateToggle("Auto-Farm", false, function(kondisi)
    if kondisi then
        print("Auto-Farm: ON")
    else
        print("Auto-Farm: OFF")
    end
end)

TabUtama:CreateToggle("ESP Benda", true, function(kondisi)
    print("Status ESP saat ini:", kondisi)
end)

-- 4. Isi Tab Settings
TabSetting:CreateButton("Hancurkan GUI", function()
    game.Players.LocalPlayer.PlayerGui:FindFirstChild("MyHubGUI"):Destroy()
end)
