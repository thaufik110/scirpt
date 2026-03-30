local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

-- Memuat UI Library dari GitHub
local UILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/thaufik110/libraryzhushi/refs/heads/main/new.lua"))()

local Window = UILib.new({
    Title = "He ZhuShi Hub",
    Subtitle = "Premium Edition",
    Theme = "Dark" 
})

local Tab1 = Window:AddTab({
    Name = "Main Menu",
    Icon = "🏠"
})

local Section1 = Tab1:AddSection({
    Title = "Player Settings"
})

-- === VARIABEL UNTUK FLY & NOCLIP ===
local isFlying = false
local flySpeed = 50
local flyConnection = nil
local bv = nil
local bg = nil

-- Fungsi untuk memulai Fly + Noclip
local function startFly()
    local player = Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local humanoid = char:WaitForChild("Humanoid")

    isFlying = true
    humanoid.PlatformStand = true

    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.Parent = hrp

    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.P = 9e4
    bg.CFrame = hrp.CFrame
    bg.Parent = hrp

    local camera = Workspace.CurrentCamera

    flyConnection = RunService.RenderStepped:Connect(function()
        if not isFlying or not char:FindFirstChild("HumanoidRootPart") then return end

        -- Logika Noclip
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end

        local moveDir = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end

        bv.Velocity = moveDir * flySpeed
        bg.CFrame = camera.CFrame
    end)
end

-- Fungsi untuk menghentikan Fly & Noclip
local function stopFly()
    isFlying = false
    local player = Players.LocalPlayer
    local char = player.Character
    
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then humanoid.PlatformStand = false end
    end
    
    if bv then bv:Destroy() bv = nil end
    if bg then bg:Destroy() bg = nil end
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
end

-- === MENU UI ===

-- 1. Toggle Fly
Section1:AddToggle({
    Text = "Fly + Noclip",
    Default = false,
    Callback = function(state)
        if state then
            startFly()
            Window:Toast({Message = "Fly Noclip Activated!", Duration = 2})
        else
            stopFly()
            Window:Toast({Message = "Fly Noclip Deactivated!", Duration = 2})
        end
    end
})

-- 2. Slider Kecepatan Fly (Pastikan UILib kamu sudah support AddSlider)
Section1:AddSlider({
    Text = "Fly Speed",
    Default = 50,
    Min = 10,
    Max = 300,
    Callback = function(value)
        flySpeed = value
    end
})

-- === VARIABEL & LOGIKA FAST CLICK (TAHAN MOUSE) ===
local autoClickEnabled = false
local isHoldingMouse = false

-- 3. Toggle Fast Click
Section1:AddToggle({
    Text = "Fast Click (Tahan Kiri)",
    Default = false,
    Callback = function(state)
        autoClickEnabled = state
        Window:Toast({Message = "Fast Click " .. (state and "ON" or "OFF"), Duration = 2})
    end
})

-- Mendeteksi saat mouse ditekan dan dilepas
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isHoldingMouse = true
        
        -- Looping sangat cepat selama tombol ditahan dan toggle aktif
        while isHoldingMouse and autoClickEnabled do
            local player = Players.LocalPlayer
            local char = player.Character
            
            if char then
                -- Mencari Tool/Item yang sedang dipegang karakter
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate() -- Otomatis mengaktifkan tool (sama seperti klik kiri)
                end
            end
            
            -- Jika eksekutor kamu mendukung fungsi 'mouse1click()', 
            -- kamu bisa hapus komentar di bawah ini untuk klik raw system:
            -- pcall(mouse1click) 

            task.wait(0.01) -- Jeda super singkat (0.01 detik per pukulan)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isHoldingMouse = false
    end
end)

-- Notifikasi awal
Window:Toast({
    Message = "Library & Fitur Berhasil Dimuat!",
    Duration = 3
})
