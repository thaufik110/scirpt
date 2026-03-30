-- =====================================================================
-- ⚙️ SCRIPT FUNGSI (FLY, NOCLIP, FAST CLICK) UNTUK UI BARU
-- =====================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

-- MEMBUAT WINDOW MENGGUNAKAN UI BARU
-- (Pastikan fungsi ini dipanggil dari variabel FarmingLibrary kamu)
local Window = FarmingLibrary:CreateWindow("He ZhuShi Hub", "TokyoNight") -- Bisa ganti tema di sini
local Tab1 = Window:CreateTab("Main Menu", "rbxassetid://6031265976")

Tab1:CreateSection("Player Settings")

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

        -- Logika Noclip (Tembus Objek)
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

-- 1. Toggle Fly
Tab1:CreateToggle("Fly + Noclip", false, function(state)
    if state then
        startFly()
    else
        stopFly()
    end
end)

-- 2. Slider Kecepatan Fly
Tab1:CreateSlider("Fly Speed", 10, 300, 50, function(value)
    flySpeed = value
end)


-- =====================================================================
-- === VARIABEL & LOGIKA FAST CLICK (TAHAN MOUSE) ===
-- =====================================================================
Tab1:CreateSection("Auto Clicker (Mining)")

local autoClickEnabled = false
local isHoldingMouse = false
local clickDelay = 0.01 -- Jeda default memukul (0.01 detik)

-- 3. Toggle Fast Click
Tab1:CreateToggle("Fast Click (Tahan Kiri)", false, function(state)
    autoClickEnabled = state
end)

-- 4. Slider Kecepatan Click (Mengatur Delay)
-- Semakin kecil angkanya, semakin cepat dia memukul batu.
Tab1:CreateSlider("Jeda Pukulan (Detik)", 0, 100, 1, function(value)
    -- Karena Slider hanya pakai angka bulat, kita akali pembagiannya.
    -- Jika di slider 1, maka delay = 0.01 detik (Sangat Cepat)
    -- Jika di slider 100, maka delay = 1.00 detik (Sangat Lambat)
    clickDelay = value / 100
    if clickDelay == 0 then clickDelay = 0.01 end -- Mencegah crash (0 detik)
end)

-- Mendeteksi saat mouse ditekan dan dilepas
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isHoldingMouse = true
        
        -- Looping selama tombol ditahan dan toggle aktif
        while isHoldingMouse and autoClickEnabled do
            local player = Players.LocalPlayer
            local char = player.Character
            
            if char then
                -- Mencari Tool/Item (Beliung) yang sedang dipegang karakter
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate() -- Memerintahkan tool untuk memukul
                end
            end

            -- Menunggu sesuai pengaturan Slider sebelum memukul lagi
            task.wait(clickDelay)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isHoldingMouse = false
    end
end)
