local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

-- Load UI
local UILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/thaufik110/libraryzhushi/refs/heads/main/newui.lua"))()

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

-- =========================
-- 🚀 FLY + NOCLIP
-- =========================
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

        -- Noclip
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end

        local moveDir = Vector3.new(0,0,0)

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += camera.CFrame.RightVector end

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

-- Toggle Fly
Section1:AddToggle({
    Text = "Fly + Noclip",
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

-- Slider Fly Speed
Section1:AddSlider({
    Text = "Fly Speed",
    Default = 50,
    Min = 10,
    Max = 300,
    Callback = function(value)
        flySpeed = value
    end
})

-- Button Speed +
Section1:AddButton({
    Text = "Tambah Speed +10",
    Callback = function()
        flySpeed = math.clamp(flySpeed + 10, 10, 300)
        Window:Toast({Message = "Fly Speed: "..flySpeed, Duration = 1})
    end
})

-- Button Speed -
Section1:AddButton({
    Text = "Kurangi Speed -10",
    Callback = function()
        flySpeed = math.clamp(flySpeed - 10, 10, 300)
        Window:Toast({Message = "Fly Speed: "..flySpeed, Duration = 1})
    end
})

-- =========================
-- ⚡ FAST CLICK
-- =========================
local autoClickEnabled = false
local isHoldingMouse = false
local clickDelay = 0.01

-- Toggle Fast Click
Section1:AddToggle({
    Text = "Fast Click (Tahan Kiri)",
    Default = false,
    Callback = function(state)
        autoClickEnabled = state
        Window:Toast({Message = "Fast Click "..(state and "ON" or "OFF"), Duration = 2})
    end
})

-- Slider Speed Click
Section1:AddSlider({
    Text = "Click Speed",
    Default = 0.01,
    Min = 0.001,
    Max = 0.05,
    Callback = function(value)
        clickDelay = value
    end
})

-- Preset Super Cepat
Section1:AddButton({
    Text = "Max Click (Mining)",
    Callback = function()
        clickDelay = 0.001
        Window:Toast({Message = "Max Speed Aktif!", Duration = 2})
    end
})

-- Detect Mouse Hold
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

            pcall(function()
                mouse1click()
            end)

            task.wait(clickDelay)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isHoldingMouse = false
    end
end)

-- =========================
-- 🔔 NOTIF AWAL
-- =========================
Window:Toast({
    Message = "Script Loaded Successfully!",
    Duration = 3
})
