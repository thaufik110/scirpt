-- Inisialisasi Table utama sebagai Library
local MyCustomUI = {}

-- 1. Fungsi untuk membuat Window Utama
function MyCustomUI:CreateWindow(title)
    -- Di sini kamu membuat Instance.new("ScreenGui") dan "Frame" utama
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MyHubGUI"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 450, 0, 300)
    mainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.Parent = screenGui
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = title
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = mainFrame

    -- Table untuk menyimpan fungsi-fungsi yang ada di dalam Window ini
    local WindowAPI = {}

    -- 2. Fungsi untuk membuat Tab di dalam Window
    function WindowAPI:CreateTab(tabName)
        -- Di sini biasanya kamu membuat Frame baru yang bertindak sebagai halaman tab
        -- dan tombol navigasi untuk membuka tab ini
        
        -- Table untuk menyimpan elemen di dalam Tab ini
        local TabAPI = {}
        
        -- 3. Fungsi untuk membuat elemen interaktif di dalam Tab
        function TabAPI:CreateButton(btnText, callback)
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(0, 200, 0, 35)
            button.Position = UDim2.new(0.5, -100, 0.5, 0) -- Nanti diganti pakai UIListLayout agar otomatis rapi
            button.Text = btnText
            button.Parent = mainFrame -- Seharusnya masuk ke dalam Frame Tab
            
            -- Menjalankan fungsi panggil balik (callback) saat diklik
            button.MouseButton1Click:Connect(function()
                pcall(callback) -- pcall mencegah script error jika fungsi callback bermasalah
            end)
        end
        
        return TabAPI -- Kembalikan fungsi Tab agar bisa di-chain
    end

    return WindowAPI -- Kembalikan fungsi Window
end

return MyCustomUI
