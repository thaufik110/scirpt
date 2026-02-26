-- ==========================================
-- BAGIAN 1: PEMBUATAN LIBRARY (PABRIK UI)
-- ==========================================
local MyCustomUI = {}

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
    
    -- Memperhalus sudut MainFrame
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 6)
    uiCorner.Parent = mainFrame

    -- 2. Setup TopBar (Judul)
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

    -- 3. Setup Sidebar (Wadah untuk Tombol Tab)
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 130, 1, -30)
    sidebar.Position = UDim2.new(0, 0, 0, 30)
    sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainFrame

    -- Ini sihirnya: otomatis menyusun tombol Tab ke bawah
    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Padding = UDim.new(0, 2)
    sidebarLayout.Parent = sidebar

    -- 4. Setup Wadah Halaman (Tempat isi Tab ditampilkan)
    local pagesContainer = Instance.new("Frame")
    pagesContainer.Size = UDim2.new(1, -130, 1, -30)
    pagesContainer.Position = UDim2.new(0, 130, 0, 30)
    pagesContainer.BackgroundTransparency = 1
    pagesContainer.Parent = mainFrame

    local WindowAPI = {}
    local isFirstTab = true -- Untuk mengecek tab pertama yang harus dibuka

    -- ==========================================
    -- FUNGSI MEMBUAT TAB
    -- ==========================================
    function WindowAPI:CreateTab(tabName)
        -- Membuat Tombol Navigasi di Sidebar
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1, 0, 0, 35)
        tabBtn.Text = tabName
        tabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        tabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        tabBtn.Font = Enum.Font.GothamSemibold
        tabBtn.BorderSizePixel = 0
        tabBtn.Parent = sidebar

        -- Membuat Halaman yang bisa di-scroll untuk Tab ini
        local tabPage = Instance.new("ScrollingFrame")
        tabPage.Size = UDim2.new(1, -10, 1, -10)
        tabPage.Position = UDim2.new(0, 5, 0, 5)
        tabPage.BackgroundTransparency = 1
        tabPage.ScrollBarThickness = 4
        tabPage.BorderSizePixel = 0
        tabPage.Visible = isFirstTab -- Hanya tab pertama yang langsung terlihat
        tabPage.Parent = pagesContainer

        -- Sihir kedua: otomatis menyusun elemen di dalam Tab ini
        local pageLayout = Instance.new("UIListLayout")
        pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        pageLayout.Padding = UDim.new(0, 6)
        pageLayout.Parent = tabPage

        if isFirstTab then
            isFirstTab = false
            tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            tabBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255) -- Warna aktif
        end

        -- Logika ketika Tab diklik (Sistem Routing)
        tabBtn.MouseButton1Click:Connect(function()
            -- Sembunyikan semua halaman
            for _, child in pairs(pagesContainer:GetChildren()) do
                if child:IsA("ScrollingFrame") then
                    child.Visible = false
                end
            end
            -- Reset warna semua tombol tab
            for _, child in pairs(sidebar:GetChildren()) do
                if child:IsA("TextButton") then
                    child.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    child.TextColor3 = Color3.fromRGB(200, 200, 200)
                end
            end
            
            -- Tampilkan halaman ini dan tandai tombolnya
            tabPage.Visible = true
            tabBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
            tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        local TabAPI = {}
        
        -- ==========================================
        -- FUNGSI MEMBUAT TOMBOL DALAM TAB
        -- ==========================================
        function TabAPI:CreateButton(btnText, callback)
            local button = Instance.new("TextButton")
            -- Lebarnya otomatis mengikuti wadah, tingginya 35
            button.Size = UDim2.new(1, -10, 0, 35) 
            button.Text = btnText
            button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.Font = Enum.Font.Gotham
            button.Parent = tabPage -- Masukkan ke dalam halaman Tab

            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 4)
            btnCorner.Parent = button

            button.MouseButton1Click:Connect(function()
                pcall(callback) 
            end)
        end
        
        return TabAPI 
    end

    return WindowAPI 
end

-- ==========================================
-- CARA MENGGUNAKAN LIBRARY VERSI 2
-- ==========================================
local WindowSaya = MyCustomUI:CreateWindow("Exploit Hub Premium")

-- Bikin 2 Kategori (Tab)
local TabUtama = WindowSaya:CreateTab("Main")
local TabSetting = WindowSaya:CreateTab("Settings")

-- Isi Tab Utama
TabUtama:CreateButton("Aktifkan Auto-Farm", function()
    print("Auto-Farm Berjalan!")
end)

TabUtama:CreateButton("Teleport ke Spawn", function()
    print("Menteleportasi pemain...")
end)

-- Isi Tab Setting
TabSetting:CreateButton("Hancurkan GUI", function()
    game.Players.LocalPlayer.PlayerGui.MyHubGUI:Destroy()
end)
