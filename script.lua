local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local UILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/thaufik110/libraryzhushi/refs/heads/main/new.lua"))()

local Window = UILib.new({
    Title = "He ZhuShi Hub",
    Subtitle = "Premium Edition",
    Theme = "Dark" -- Pilihan: Dark, Midnight, Ocean, Rose
})

local Tab1 = Window:AddTab({
    Name = "Main Menu",
    Icon = "🏠"
})

local Section1 = Tab1:AddSection({
    Title = "Player Settings"
})

-- === VARIABEL UNTUK FLY ===
local isFlying = false
local flySpeed = 50
local flyConnection = nil
local bv = nil
local bg = nil

-- Fungsi untuk memulai Fly
local function startFly()
    local player = Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local humanoid = char:WaitForChild("Humanoid")

    isFlying = true
    humanoid.PlatformStand = true -- Membuat animasi jalan/jatuh berhenti

    -- Mengatur kecepatan terbang
    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.Parent = hrp

    -- Mengatur rotasi karakter (mengikuti kamera)
    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.P = 9e4
    bg.CFrame = hrp.CFrame
    bg.Parent = hrp

    local camera = Workspace.CurrentCamera

    -- Update pergerakan setiap frame
    flyConnection = RunService.RenderStepped:Connect(function()
        if not isFlying or not char:FindFirstChild("HumanoidRootPart") then return end

        local moveDir = Vector3.new(0, 0, 0)
        
        -- Deteksi tombol WASD
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end

        -- Terapkan pergerakan
        bv.Velocity = moveDir * flySpeed
        bg.CFrame = camera.CFrame
    end)
end

-- Fungsi untuk menghentikan Fly
local function stopFly()
    isFlying = false
    local player = Players.LocalPlayer
    local char = player.Character
    
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then humanoid.PlatformStand = false end
    end
    
    -- Hapus instance BodyVelocity dan BodyGyro
    if bv then bv:Destroy() bv = nil end
    if bg then bg:Destroy() bg = nil end
    
    -- Putus koneksi loop
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
end

-- === TOGGLE FLY DI UI ===
Section1:AddToggle({
    Text = "Fly Mode",
    Default = false,
    Callback = function(state)
        if state then
            startFly()
            Window:Toast({Message = "Fly Activated!", Duration = 2})
        else
            stopFly()
            Window:Toast({Message = "Fly Deactivated!", Duration = 2})
        end
    end
})

-- Menggunakan Toast sesuai dengan function di UI Library kamu
Window:Toast({
    Message = "Library Berhasil Dimuat!",
    Duration = 3
})
