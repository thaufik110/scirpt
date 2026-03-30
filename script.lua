local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

-- Memuat UI Library milikmu dari GitHub
local UILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/thaufik110/libraryzhushi/refs/heads/main/new.lua"))()

-- Membuat Window Utama
local Window = UILib.new({
    Title = "He ZhuShi Hub",
    Subtitle = "Premium Edition",
    Theme = "Dark" -- Pilihan: Dark, Midnight, Ocean, Rose
})

-- Membuat Tab
local Tab1 = Window:AddTab({
    Name = "Main Menu",
    Icon = "🏠"
})

-- Membuat Section di dalam Tab
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
    humanoid.PlatformStand = true -- Menghentikan animasi jatuh/berjalan

    -- Mengatur BodyVelocity untuk pergerakan
    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.Parent = hrp

    -- Mengatur BodyGyro untuk rotasi mengikuti arah kamera
    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.P = 9e4
    bg.CFrame = hrp.CFrame
    bg.Parent = hrp

    local camera = Workspace.CurrentCamera

    -- Update pergerakan dan noclip setiap frame
    flyConnection = RunService.RenderStepped:Connect(function()
        if not isFlying or not char:FindFirstChild("HumanoidRootPart") then return end

        -- === LOGIKA NOCLIP (Tembus Objek) ===
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
        -- ====================================

        local moveDir = Vector3.new(0, 0, 0)
        
        -- Deteksi input keyboard (WASD)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end

        -- Terapkan pergerakan
        bv.Velocity = moveDir * flySpeed
        bg.CFrame = camera.CFrame
    end)
end

-- Fungsi untuk menghentikan Fly & Noclip
local function stopFly()
    isFlying = false
    local player = Players.LocalPlayer
    local char = player.Character
    
    -- Kembalikan postur karakter
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then humanoid.PlatformStand = false end
    end
    
    -- Hapus instance BodyVelocity dan BodyGyro
    if bv then bv:Destroy() bv = nil end
    if bg then bg:Destroy() bg = nil end
    
    -- Putus koneksi loop (Noclip otomatis mati karena loop berhenti)
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
end

-- === UI TOGGLE UNTUK FLY ===
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

-- Notifikasi awal saat script berhasil dijalankan
Window:Toast({
    Message = "Library Berhasil Dimuat!",
    Duration = 3
})
