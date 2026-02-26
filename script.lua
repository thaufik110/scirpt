-- ==========================================
-- BAGIAN 1: PEMBUATAN LIBRARY (PABRIK UI)
-- ==========================================
local MyCustomUI = {}

function MyCustomUI:CreateWindow(title)
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

    local WindowAPI = {}

    function WindowAPI:CreateTab(tabName)
        local TabAPI = {}
        
        function TabAPI:CreateButton(btnText, callback)
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(0, 200, 0, 35)
            button.Position = UDim2.new(0.5, -100, 0.5, 0) 
            button.Text = btnText
            button.Parent = mainFrame 
            
            button.MouseButton1Click:Connect(function()
                pcall(callback) 
            end)
        end
        
        return TabAPI 
    end

    return WindowAPI 
end

-- ==========================================
-- BAGIAN 2: EKSEKUSI (MEMERINTAHKAN PABRIK)
-- ==========================================
-- Nah, bagian di bawah inilah yang membuat UI-nya benar-benar digambar di layar!

local WindowSaya = MyCustomUI:CreateWindow("Aplikasi Kerenku")
local TabSatu = WindowSaya:CreateTab("Menu Utama")

TabSatu:CreateButton("Klik Tombol Ini", function()
    print("Mantap! Tombolnya berfungsi dan library-mu berjalan.")
end)
