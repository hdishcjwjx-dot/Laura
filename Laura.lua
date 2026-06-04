-- Eplisma Laura | Arena Script
-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- ═══════════════════════════════════════
--           НАСТРОЙКИ
-- ═══════════════════════════════════════
local Settings = {
    KnockbackPower = 80,     -- Сила откидывания врагов
    AntiKnockback = true,    -- Защита от откидывания
    FlyEnabled = false,      -- Полёт
    FlySpeed = 50,           -- Скорость полёта
    WalkSpeed = 16,          -- Скорость ходьбы
    Enabled = true
}

-- ═══════════════════════════════════════
--           GUI CREATION
-- ═══════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EplismaLaura"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = player.PlayerGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 420)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 16)
UICorner.Parent = MainFrame

-- Gradient
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 15))
})
UIGradient.Rotation = 135
UIGradient.Parent = MainFrame

-- Stroke
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(100, 60, 255)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 55)
Header.BackgroundColor3 = Color3.fromRGB(100, 60, 255)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 16)
HeaderCorner.Parent = Header

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0.5, 0)
HeaderFix.Position = UDim2.new(0, 0, 0.5, 0)
HeaderFix.BackgroundColor3 = Color3.fromRGB(100, 60, 255)
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

local HeaderGrad = Instance.new("UIGradient")
HeaderGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 60, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 100, 255))
})
HeaderGrad.Rotation = 90
HeaderGrad.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "✦ EPLISMA LAURA"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, -20, 0, 18)
SubTitle.Position = UDim2.new(0, 15, 0, 32)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "Arena Abilities"
SubTitle.TextColor3 = Color3.fromRGB(200, 180, 255)
SubTitle.TextSize = 12
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = Header

-- Scroll Container
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 1, -70)
ScrollFrame.Position = UDim2.new(0, 10, 0, 62)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 60, 255)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = ScrollFrame

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 5)
UIPadding.Parent = ScrollFrame

-- ═══════════════════════════════════════
--         HELPER FUNCTIONS
-- ═══════════════════════════════════════

local function createSection(name)
    local Section = Instance.new("TextLabel")
    Section.Size = UDim2.new(1, 0, 0, 25)
    Section.BackgroundTransparency = 1
    Section.Text = "  " .. name
    Section.TextColor3 = Color3.fromRGB(130, 100, 255)
    Section.TextSize = 11
    Section.Font = Enum.Font.GothamBold
    Section.TextXAlignment = Enum.TextXAlignment.Left
    Section.Parent = ScrollFrame
    return Section
end

local function createToggle(labelText, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 42)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = ScrollFrame

    local TCorner = Instance.new("UICorner")
    TCorner.CornerRadius = UDim.new(0, 10)
    TCorner.Parent = ToggleFrame

    local TStroke = Instance.new("UIStroke")
    TStroke.Color = Color3.fromRGB(50, 50, 80)
    TStroke.Thickness = 1
    TStroke.Parent = ToggleFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = labelText
    Label.TextColor3 = Color3.fromRGB(220, 220, 255)
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame

    local ToggleBg = Instance.new("Frame")
    ToggleBg.Size = UDim2.new(0, 40, 0, 22)
    ToggleBg.Position = UDim2.new(1, -50, 0.5, -11)
    ToggleBg.BackgroundColor3 = default and Color3.fromRGB(100, 60, 255) or Color3.fromRGB(50, 50, 70)
    ToggleBg.BorderSizePixel = 0
    ToggleBg.Parent = ToggleFrame

    local TBCorner = Instance.new("UICorner")
    TBCorner.CornerRadius = UDim.new(1, 0)
    TBCorner.Parent = ToggleBg

    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 16, 0, 16)
    Circle.Position = default and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.BorderSizePixel = 0
    Circle.Parent = ToggleBg

    local CCorner = Instance.new("UICorner")
    CCorner.CornerRadius = UDim.new(1, 0)
    CCorner.Parent = Circle

    local state = default
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.BackgroundTransparency = 1
    Button.Text = ""
    Button.Parent = ToggleFrame

    Button.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(ToggleBg, TweenInfo.new(0.2), {
            BackgroundColor3 = state and Color3.fromRGB(100, 60, 255) or Color3.fromRGB(50, 50, 70)
        }):Play()
        TweenService:Create(Circle, TweenInfo.new(0.2), {
            Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        }):Play()
        callback(state)
    end)

    return ToggleFrame
end

local function createSlider(labelText, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 58)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = ScrollFrame

    local SCorner = Instance.new("UICorner")
    SCorner.CornerRadius = UDim.new(0, 10)
    SCorner.Parent = SliderFrame

    local SStroke = Instance.new("UIStroke")
    SStroke.Color = Color3.fromRGB(50, 50, 80)
    SStroke.Thickness = 1
    SStroke.Parent = SliderFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 0, 22)
    Label.Position = UDim2.new(0, 12, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = labelText
    Label.TextColor3 = Color3.fromRGB(220, 220, 255)
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0.3, -12, 0, 22)
    ValueLabel.Position = UDim2.new(0.7, 0, 0, 5)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = Color3.fromRGB(130, 100, 255)
    ValueLabel.TextSize = 13
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = SliderFrame

    local TrackBg = Instance.new("Frame")
    TrackBg.Size = UDim2.new(1, -24, 0, 6)
    TrackBg.Position = UDim2.new(0, 12, 0, 36)
    TrackBg.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
    TrackBg.BorderSizePixel = 0
    TrackBg.Parent = SliderFrame

    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(1, 0)
    TrackCorner.Parent = TrackBg

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(100, 60, 255)
    Fill.BorderSizePixel = 0
    Fill.Parent = TrackBg

    local FillGrad = Instance.new("UIGradient")
    FillGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 60, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 140, 255))
    })
    FillGrad.Parent = Fill

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = Fill

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 14, 0, 14)
    Knob.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Knob.ZIndex = 2
    Knob.Parent = TrackBg

    local KCorner = Instance.new("UICorner")
    KCorner.CornerRadius = UDim.new(1, 0)
    KCorner.Parent = Knob

    local dragging = false
    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(1, 0, 0, 20)
    SliderButton.Position = UDim2.new(0, 0, 0, -7)
    SliderButton.BackgroundTransparency = 1
    SliderButton.Text = ""
    SliderButton.ZIndex = 3
    SliderButton.Parent = TrackBg

    local function updateSlider(x)
        local abs = TrackBg.AbsolutePosition.X
        local width = TrackBg.AbsoluteSize.X
        local alpha = math.clamp((x - abs) / width, 0, 1)
        local value = math.floor(min + (max - min) * alpha)
        Fill.Size = UDim2.new(alpha, 0, 1, 0)
        Knob.Position = UDim2.new(alpha, -7, 0.5, -7)
        ValueLabel.Text = tostring(value)
        callback(value)
    end

    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    SliderButton.MouseButton1Down:Connect(function(x, y)
        updateSlider(x)
    end)

    return SliderFrame
end

-- ═══════════════════════════════════════
--           BUILD UI
-- ═══════════════════════════════════════

createSection("⚔️  АТАКА")

createToggle("Нокбэк (Отлёт врагов)", true, function(state)
    Settings.Enabled = state
end)

createSlider("Сила откидывания", 10, 300, Settings.KnockbackPower, function(val)
    Settings.KnockbackPower = val
end)

createSection("🛡️  ЗАЩИТА")

createToggle("Анти-нокбэк", Settings.AntiKnockback, function(state)
    Settings.AntiKnockback = state
end)

createSection("✈️  ПЕРЕДВИЖЕНИЕ")

createToggle("Полёт (Fly)", Settings.FlyEnabled, function(state)
    Settings.FlyEnabled = state
    if not state then
        humanoid.PlatformStand = false
    end
end)

createSlider("Скорость полёта", 10, 200, Settings.FlySpeed, function(val)
    Settings.FlySpeed = val
end)

createSlider("Скорость ходьбы", 8, 100, Settings.WalkSpeed, function(val)
    Settings.WalkSpeed = val
    humanoid.WalkSpeed = val
end)

-- ═══════════════════════════════════════
--         KNOCKBACK LOGIC
-- ═══════════════════════════════════════

local tool = character:FindFirstChildOfClass("Tool")

character.ChildAdded:Connect(function(child)
    if child:IsA("Tool") then
        tool = child
    end
end)

local function applyKnockback(target)
    if not Settings.Enabled then return end
    local targetChar = target.Character
    if not targetChar then return end
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    local targetHum = targetChar:FindFirstChild("Humanoid")
    if not targetRoot or not targetHum or targetHum.Health <= 0 then return end

    local direction = (targetRoot.Position - rootPart.Position).Unit
    local force = direction * Settings.KnockbackPower + Vector3.new(0, Settings.KnockbackPower * 0.4, 0)

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = force
    bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyVelocity.P = 1e4
    bodyVelocity.Parent = targetRoot

    game:GetService("Debris"):AddItem(bodyVelocity, 0.25)
end

-- Detect hits via touched events on equipped tool
character.ChildAdded:Connect(function(child)
    if child:IsA("Tool") then
        for _, part in ipairs(child:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Touched:Connect(function(hit)
                    local hitChar = hit.Parent
                    local hitPlayer = Players:GetPlayerFromCharacter(hitChar)
                    if hitPlayer and hitPlayer ~= player then
                        applyKnockback(hitPlayer)
                    end
                end)
            end
        end
    end
end)

-- ═══════════════════════════════════════
--         ANTI-KNOCKBACK LOGIC
-- ═══════════════════════════════════════

RunService.Heartbeat:Connect(function()
    if Settings.AntiKnockback then
        for _, obj in ipairs(rootPart:GetChildren()) do
            if obj:IsA("BodyVelocity") or obj:IsA("BodyForce") then
                obj:Destroy()
            end
        end
    end
end)

-- ═══════════════════════════════════════
--              FLY LOGIC
-- ═══════════════════════════════════════

local flyBodyVelocity = Instance.new("BodyVelocity")
flyBodyVelocity.MaxForce = Vector3.new(0, 0, 0)
flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
flyBodyVelocity.P = 1e4
flyBodyVelocity.Name = "FlyVelocity"

local flyBodyGyro = Instance.new("BodyGyro")
flyBodyGyro.MaxTorque = Vector3.new(0, 0, 0)
flyBodyGyro.D = 100
flyBodyGyro.P = 1e4
flyBodyGyro.Name = "FlyGyro"

local camera = workspace.CurrentCamera

RunService.Heartbeat:Connect(function()
    if not character or not rootPart then return end

    if Settings.FlyEnabled then
        if not flyBodyVelocity.Parent then
            flyBodyVelocity.Parent = rootPart
            flyBodyGyro.Parent = rootPart
        end

        flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        flyBodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        humanoid.PlatformStand = true

        local moveDir = Vector3.new(0, 0, 0)
        local camCF = camera.CFrame

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + camCF.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - camCF.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - camCF.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + camCF.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDir = moveDir - Vector3.new(0, 1, 0)
        end

        if moveDir.Magnitude > 0 then
            flyBodyVelocity.Velocity = moveDir.Unit * Settings.FlySpeed
        else
            flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end

        flyBodyGyro.CFrame = camCF
    else
        flyBodyVelocity.MaxForce = Vector3.new(0, 0, 0)
        flyBodyGyro.MaxTorque = Vector3.new(0, 0, 0)
        humanoid.PlatformStand = false
        if flyBodyVelocity.Parent then
            flyBodyVelocity.Parent = nil
            flyBodyGyro.Parent = nil
        end
    end
end)

-- Respawn handling
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    rootPart = newChar:WaitForChild("HumanoidRootPart")
end)

print("✦ Eplisma Laura loaded!")
