-- =====================================================================
-- 🪓 HE ZHUSHI HUB - CHOP YOUR TREE (XENO OPTIMIZED EDITION)
-- =====================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Memuat UI Library (TokyoNight Theme)
local FarmingLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/thaufik110/libraryzhushi/refs/heads/main/newui.lua"))()
local Window = FarmingLibrary:CreateWindow("He ZhuShi | Chop Tree", "TokyoNight")

local TabFarm = Window:CreateTab("Main Farm", "rbxassetid://6031265976")
local TabPlayer = Window:CreateTab("Player", "rbxassetid://6031265976")

-- =====================================================================
-- 🟡 TAB 1: AUTO FARM (THE CORE LOOP) - AMAN DARI VOID
-- =====================================================================
TabFarm:CreateSection("Auto Farming OP")

local autoSwing = false
local autoCollect = false

-- 1. AUTO TEBANG (Tetap Dipertahankan Karena Sangat OP)
TabFarm:CreateToggle("1. Auto Swing Axe (OP)", false, function(state)
    autoSwing = state
    if autoSwing then
        task.spawn(function()
            while autoSwing do
                pcall(function()
                    ReplicatedStorage.Remotes.AxeSwing:FireServer()
                end)
                task.wait(0.01)
            end
        end)
    end
end)

-- 2. AUTO COLLECT V2 (Anti-Void & Fake Touch)
TabFarm:CreateToggle("2. Auto Collect Drops", false, function(state)
    autoCollect = state
    if autoCollect then
        task.spawn(function()
            while autoCollect do
                pcall(function()
                    local char = Players.LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        local hrp = char.HumanoidRootPart
                        
                        -- Menggeledah benda di map
                        for _, obj in ipairs(Workspace:GetDescendants()) do
                            -- Syarat 1: Harus BasePart dan punya TouchInterest
                            if obj:IsA("BasePart") and obj:FindFirstChild("TouchInterest") then
                                -- Syarat 2 (ANTI-VOID): Ukuran benda tidak boleh lebih besar dari 10
                                -- Ini mencegah portal atau lantai map ikut ketarik
                                if obj.Size.X < 10 and obj.Size.Y < 10 and obj.Size.Z < 10 then
                                    
                                    -- Mengecek apakah eksekutor (Xeno) mendukung fake touch
                                    if firetouchinterest then
                                        -- Memalsukan sentuhan karakter ke barang (Sangat Aman)
                                        firetouchinterest(hrp, obj, 0) -- Mulai nyentuh
                                        task.wait(0.01)
                                        firetouchinterest(hrp, obj, 1) -- Lepas sentuhan
                                    else
                                        -- Kalau tidak support, pindahkan barangnya tapi sudah difilter
                                        obj.CFrame = hrp.CFrame
                                    end
                                    
                                end
                            end
                        end
                    end
                end)
                task.wait(0.5) -- Jeda dinaikkan jadi 0.5 detik agar Xeno tidak ngelag
            end
        end)
    end
end)

TabFarm:CreateSection("Bantuan Manual (Untuk Siram Air)")
local autoClickEnabled = false
local isHoldingMouse = false

-- Gunakan ini sambil memegang Watering Can!
TabFarm:CreateToggle("Fast Click (Tahan Kiri)", false, function(state)
    autoClickEnabled = state
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isHoldingMouse = true
        while isHoldingMouse and autoClickEnabled do
            local char = Players.LocalPlayer.Character
            if char then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
            end
            task.wait(0.01)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then isHoldingMouse = false end
end)


-- =====================================================================
-- 🟢 TAB 2: PLAYER SETTINGS
-- =====================================================================
TabPlayer:CreateSection("Fly & Noclip")

local isFlying = false
local flySpeed = 50
local flyConnection, bv, bg

local function startFly()
    local char = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    char:WaitForChild("Humanoid").PlatformStand = true

    isFlying = true
    bv = Instance.new("BodyVelocity", hrp)
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.new(0, 0, 0)

    bg = Instance.new("BodyGyro", hrp)
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.P = 9e4
    bg.CFrame = hrp.CFrame

    local camera = Workspace.CurrentCamera
    flyConnection = RunService.RenderStepped:Connect(function()
        if not isFlying or not char:FindFirstChild("HumanoidRootPart") then return end

        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
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

local function stopFly()
    isFlying = false
    local char = Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then char.Humanoid.PlatformStand = false end
    if bv then bv:Destroy() bv = nil end
    if bg then bg:Destroy() bg = nil end
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
end

TabPlayer:CreateToggle("Fly + Noclip", false, function(state)
    if state then startFly() else stopFly() end
end)

TabPlayer:CreateSlider("Fly Speed", 10, 300, 50, function(value)
    flySpeed = value
end)

TabPlayer:CreateSection("Movement")
local customWalkSpeed = false
local walkSpeedVal = 16
local customJump = false
local jumpVal = 50

TabPlayer:CreateToggle("Enable Custom Sprint", false, function(state) customWalkSpeed = state end)
TabPlayer:CreateSlider("Sprint Speed", 16, 300, 16, function(value) walkSpeedVal = value end)

TabPlayer:CreateToggle("Enable Custom Jump", false, function(state) customJump = state end)
TabPlayer:CreateSlider("Jump Power", 50, 500, 50, function(value) jumpVal = value end)

RunService.Heartbeat:Connect(function()
    local char = Players.LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            if customWalkSpeed then humanoid.WalkSpeed = walkSpeedVal end
            if customJump then 
                humanoid.UseJumpPower = true 
                humanoid.JumpPower = jumpVal 
            end
        end
    end
end)
