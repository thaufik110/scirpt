-- =====================================================================
-- 🪓 HE ZHUSHI HUB - CHOP YOUR TREE EXCLUSIVE EDITION
-- =====================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Memuat UI Library dari GitHub kamu
local FarmingLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/thaufik110/libraryzhushi/refs/heads/main/newui.lua"))()

-- Membuat Window Utama
local Window = FarmingLibrary:CreateWindow("He ZhuShi | Chop Tree", "TokyoNight")

-- Membuat Tab
local TabPlayer = Window:CreateTab("Player", "rbxassetid://6031265976")
local TabFarm = Window:CreateTab("Auto Farm", "rbxassetid://6031265976")
local TabAdmin = Window:CreateTab("Admin Lab", "rbxassetid://6031265976")

-- =====================================================================
-- 🟢 TAB 1: PLAYER SETTINGS (FLY, NOCLIP, MOVEMENT)
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

-- =====================================================================
-- 🟡 TAB 2: AUTO FARM (REMOTE EXPLOIT)
-- =====================================================================
TabFarm:CreateSection("Auto Farming (Tanpa Gerak)")

local autoSwing = false
local autoWater = false
local autoCollect = false

-- 1. Auto Tebang Pohon
TabFarm:CreateToggle("Auto Swing Axe (Tebang)", false, function(state)
    autoSwing = state
    if autoSwing then
        task.spawn(function()
            while autoSwing do
                pcall(function()
                    ReplicatedStorage.Remotes.AxeSwing:FireServer()
                end)
                task.wait(0.01) -- Eksekusi sangat cepat
            end
        end)
    end
end)

-- 2. Auto Siram Pohon
TabFarm:CreateToggle("Auto Water Tree (Siram)", false, function(state)
    autoWater = state
    if autoWater then
        task.spawn(function()
            while autoWater do
                pcall(function()
                    ReplicatedStorage.Remotes.ClickWateringCan:FireServer()
                end)
                task.wait(0.05)
            end
        end)
    end
end)

-- 3. Auto Ambil Koin (Bypass Collect)
TabFarm:CreateToggle("Auto Collect Coins", false, function(state)
    autoCollect = state
    if autoCollect then
        task.spawn(function()
            while autoCollect do
                pcall(function()
                    ReplicatedStorage.Remotes.CollectCoin:FireServer()
                end)
                task.wait(0.1)
            end
        end)
    end
end)

TabFarm:CreateSection("Auto Clicker Manual")
local autoClickEnabled = false
local isHoldingMouse = false

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
-- 🔴 TAB 3: ADMIN & EXPLOIT LAB
-- =====================================================================
TabAdmin:CreateSection("Tes Kelemahan Server (Admin)")

-- Tombol ini untuk ngetes apakah developer mengunci fitur Admin mereka
TabAdmin:CreateButton("Beri Uang Admin (GiveCurrencyAdmin)", function()
    pcall(function()
        -- Mencoba menembak langsung
        ReplicatedStorage.Remotes.GiveCurrencyAdmin:FireServer()
        
        -- Mencoba menembak dengan argumen tebakan (berjaga-jaga kalau butuh angka)
        ReplicatedStorage.Remotes.GiveCurrencyAdmin:FireServer("Coins", 9999999)
        ReplicatedStorage.Remotes.GiveCurrencyAdmin:FireServer(9999999)
    end)
end)

TabAdmin:CreateButton("Boost Global (GlobalBoostsAdmin)", function()
    pcall(function()
        ReplicatedStorage.Remotes.GlobalBoostsAdmin:FireServer()
        ReplicatedStorage.Remotes.GlobalBoostsAdmin:FireServer(true)
    end)
end)

TabAdmin:CreateSection("Spam Custom (Dari Scanner)")
local customSpam = false
local customPath = ""

-- Textbox untuk memasukkan kode (contoh: ReplicatedStorage.Remotes.CrateUnbox)
TabAdmin:CreateTextBox("Masukkan Path (Tanpa :FireServer)", "Contoh: ReplicatedStorage.Remotes.CrateUnbox", function(text)
    customPath = text
end)

TabAdmin:CreateToggle("Eksekusi Custom Spam", false, function(state)
    customSpam = state
    if customSpam and customPath ~= "" then
        task.spawn(function()
            while customSpam do
                pcall(function()
                    -- Mengeksekusi path string menjadi kode Lua
                    local func = loadstring("game:GetService('" .. customPath:match("^(.-)%.") .. "')." .. customPath:match("^.-%.(.*)") .. ":FireServer()")
                    if func then func() end
                end)
                task.wait(0.1)
            end
        end)
    end
end)
