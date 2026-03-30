local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

-- Memuat UI Library BARU dari GitHub (newui.lua)
local FarmingLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/thaufik110/libraryzhushi/refs/heads/main/newui.lua"))()

-- MEMBUAT WINDOW MENGGUNAKAN UI BARU
local Window = FarmingLibrary:CreateWindow("He ZhuShi Hub", "TokyoNight")
local Tab1 = Window:CreateTab("Main Menu", "rbxassetid://6031265976")

-- =====================================================================
-- === SECTION 1: FLY & NOCLIP ===
-- =====================================================================
Tab1:CreateSection("Fly Settings")

local isFlying = false
local flySpeed = 50
local flyConnection = nil
local bv = nil
local bg = nil

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

Tab1:CreateToggle("Fly + Noclip", false, function(state)
    if state then
        startFly()
    else
        stopFly()
    end
end)

Tab1:CreateSlider("Fly Speed", 10, 300, 50, function(value)
    flySpeed = value
end)

-- =====================================================================
-- === SECTION 2: MOVEMENT (SPRINT & JUMP) ===
-- =====================================================================
Tab1:CreateSection("Movement Settings")

local customWalkSpeedEnabled = false
local walkSpeedValue = 16 -- Kecepatan normal roblox

local customJumpEnabled = false
local jumpPowerValue = 50 -- Kekuatan lompat normal roblox

-- Toggle & Slider Sprint
Tab1:CreateToggle("Enable Custom Sprint", false, function(state)
    customWalkSpeedEnabled = state
end)

Tab1:CreateSlider("Sprint Speed", 10, 300, 16, function(value)
    walkSpeedValue = value
end)

-- Toggle & Slider Jump
Tab1:CreateToggle("Enable Custom Jump", false, function(state)
    customJumpEnabled = state
end)

Tab1:CreateSlider("Jump Power", 10, 500, 50, function(value)
    jumpPowerValue = value
end)

-- Loop untuk memastikan Sprint & Jump tidak di-reset oleh game
RunService.Heartbeat:Connect(function()
    local player = Players.LocalPlayer
    local char = player.Character
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            if customWalkSpeedEnabled then
                humanoid.WalkSpeed = walkSpeedValue
            end
            if customJumpEnabled then
                humanoid.UseJumpPower = true -- Memaksa game menggunakan sistem JumpPower
                humanoid.JumpPower = jumpPowerValue
            end
        end
    end
end)

-- =====================================================================
-- === SECTION 3: AUTO CLICKER (MINING) ===
-- =====================================================================
Tab1:CreateSection("Auto Clicker (Mining)")

local autoClickEnabled = false
local isHoldingMouse = false
local clickDelay = 0.01 

Tab1:CreateToggle("Fast Click (Tahan Kiri)", false, function(state)
    autoClickEnabled = state
end)

Tab1:CreateSlider("Jeda Pukulan (Detik)", 0, 100, 1, function(value)
    clickDelay = value / 100
    if clickDelay <= 0 then clickDelay = 0.01 end 
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isHoldingMouse = true
        
        while isHoldingMouse and autoClickEnabled do
            local player = Players.LocalPlayer
            local char = player.Character
            
            if char then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate() 
                end
            end

            task.wait(clickDelay)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isHoldingMouse = false
    end
end)
