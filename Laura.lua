-- ╔══════════════════════════════════════╗
-- ║     EPLISMA LAURA v2 | UNIVERSAL     ║
-- ║         Mobile + PC Support          ║
-- ╚══════════════════════════════════════╝

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- ════════════════════════════════════════
--            CHARACTER SETUP
-- ════════════════════════════════════════
local char, hum, root

local function setupCharacter(c)
    char = c
    hum = c:WaitForChild("Humanoid")
    root = c:WaitForChild("HumanoidRootPart")
end

if player.Character then setupCharacter(player.Character) end
player.CharacterAdded:Connect(setupCharacter)

-- ════════════════════════════════════════
--              SETTINGS
-- ════════════════════════════════════════
local cfg = {
    knockbackOn  = true,
    knockPower   = 80,
    antiKB       = false,
    flyOn        = false,
    flySpeed     = 60,
    walkSpeed    = 16,
    jumpPower    = 50,
    noclip       = false,
    infinite_jump = false,
}

-- ════════════════════════════════════════
--              GUI BUILD
-- ════════════════════════════════════════
-- Remove old gui if exists
pcall(function()
    player.PlayerGui:FindFirstChild("EplismaLaura"):Destroy()
end)

local gui = Instance.new("ScreenGui")
gui.Name = "EplismaLaura"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.IgnoreGuiInset = true
gui.Parent = player.PlayerGui

-- ── Open Button (always visible) ──────
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 52, 0, 52)
openBtn.Position = UDim2.new(0, 12, 0.5, -26)
openBtn.BackgroundColor3 = Color3.fromRGB(100, 60, 255)
openBtn.Text = "✦"
openBtn.TextColor3 = Color3.fromRGB(255,255,255)
openBtn.TextSize = 22
openBtn.Font = Enum.Font.GothamBold
openBtn.BorderSizePixel = 0
openBtn.ZIndex = 100
openBtn.Parent = gui

do
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(1,0)
    c.Parent = openBtn
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(150,100,255)
    s.Thickness = 2
    s.Parent = openBtn
end

-- ── Main Panel ────────────────────────
local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.new(0, 300, 0, 480)
panel.Position = UDim2.new(0, 75, 0.5, -240)
panel.BackgroundColor3 = Color3.fromRGB(10, 10, 22)
panel.BorderSizePixel = 0
panel.Visible = true
panel.Active = true
panel.Draggable = true
panel.ZIndex = 50
panel.Parent = gui

do
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 16)
    c.Parent = panel

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(90, 55, 220)
    stroke.Thickness = 1.5
    stroke.Parent = panel

    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(18,14,40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8,8,20)),
    })
    grad.Rotation = 140
    grad.Parent = panel
end

-- ── Header ───────────────────────────
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 52)
header.BackgroundColor3 = Color3.fromRGB(90, 50, 210)
header.BorderSizePixel = 0
header.ZIndex = 51
header.Parent = panel

do
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 16)
    c.Parent = header
    -- fix bottom corners of header
    local fix = Instance.new("Frame")
    fix.Size = UDim2.new(1, 0, 0.5, 0)
    fix.Position = UDim2.new(0, 0, 0.5, 0)
    fix.BackgroundColor3 = Color3.fromRGB(90, 50, 210)
    fix.BorderSizePixel = 0
    fix.ZIndex = 51
    fix.Parent = header

    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(110, 60, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(55, 100, 255)),
    })
    g.Rotation = 90
    g.Parent = header
end

local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(1, -50, 0.6, 0)
titleLbl.Position = UDim2.new(0, 14, 0.1, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "✦  EPLISMA LAURA"
titleLbl.TextColor3 = Color3.fromRGB(255,255,255)
titleLbl.TextSize = 16
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.ZIndex = 52
titleLbl.Parent = header

local subLbl = Instance.new("TextLabel")
subLbl.Size = UDim2.new(1, -50, 0.4, 0)
subLbl.Position = UDim2.new(0, 14, 0.55, 0)
subLbl.BackgroundTransparency = 1
subLbl.Text = "Universal  •  v2.0"
subLbl.TextColor3 = Color3.fromRGB(190, 170, 255)
subLbl.TextSize = 11
subLbl.Font = Enum.Font.Gotham
subLbl.TextXAlignment = Enum.TextXAlignment.Left
subLbl.ZIndex = 52
subLbl.Parent = header

-- Close button in header
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -42, 0.5, -16)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 80)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.ZIndex = 53
closeBtn.Parent = header

do
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(1,0)
    c.Parent = closeBtn
end

-- Toggle panel visibility
openBtn.MouseButton1Click:Connect(function()
    panel.Visible = not panel.Visible
end)
closeBtn.MouseButton1Click:Connect(function()
    panel.Visible = false
end)

-- ── Scroll List ───────────────────────
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -16, 1, -60)
scroll.Position = UDim2.new(0, 8, 0, 56)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 3
scroll.ScrollBarImageColor3 = Color3.fromRGB(100, 60, 255)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ZIndex = 51
scroll.Parent = panel

do
    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 6)
    list.Parent = scroll
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 4)
    pad.PaddingBottom = UDim.new(0, 8)
    pad.Parent = scroll
end

-- ════════════════════════════════════════
--           UI COMPONENTS
-- ════════════════════════════════════════

local function makeSection(txt)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 24)
    f.BackgroundTransparency = 1
    f.ZIndex = 52
    f.Parent = scroll

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = txt
    lbl.TextColor3 = Color3.fromRGB(120, 90, 255)
    lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 52
    lbl.Parent = f
    return f
end

local function makeToggle(label, initVal, onChange)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 46)
    row.BackgroundColor3 = Color3.fromRGB(18, 18, 38)
    row.BorderSizePixel = 0
    row.ZIndex = 52
    row.Parent = scroll

    do
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 10)
        c.Parent = row
        local s = Instance.new("UIStroke")
        s.Color = Color3.fromRGB(45, 45, 75)
        s.Thickness = 1
        s.Parent = row
    end

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -62, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(215, 215, 245)
    lbl.TextSize = 13
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 53
    lbl.Parent = row

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0, 42, 0, 24)
    bg.Position = UDim2.new(1, -52, 0.5, -12)
    bg.BackgroundColor3 = initVal and Color3.fromRGB(100,60,255) or Color3.fromRGB(45,45,70)
    bg.BorderSizePixel = 0
    bg.ZIndex = 53
    bg.Parent = row

    do
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(1,0)
        c.Parent = bg
    end

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 18, 0, 18)
    dot.Position = initVal and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
    dot.BackgroundColor3 = Color3.fromRGB(255,255,255)
    dot.BorderSizePixel = 0
    dot.ZIndex = 54
    dot.Parent = bg

    do
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(1,0)
        c.Parent = dot
    end

    local state = initVal
    local hit = Instance.new("TextButton")
    hit.Size = UDim2.new(1,0,1,0)
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.ZIndex = 55
    hit.Parent = row

    hit.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(bg, TweenInfo.new(0.18), {
            BackgroundColor3 = state and Color3.fromRGB(100,60,255) or Color3.fromRGB(45,45,70)
        }):Play()
        TweenService:Create(dot, TweenInfo.new(0.18), {
            Position = state and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
        }):Play()
        onChange(state)
    end)

    return row
end

local function makeSlider(label, mn, mx, def, onChange)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 62)
    row.BackgroundColor3 = Color3.fromRGB(18, 18, 38)
    row.BorderSizePixel = 0
    row.ZIndex = 52
    row.Parent = scroll

    do
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 10)
        c.Parent = row
        local s = Instance.new("UIStroke")
        s.Color = Color3.fromRGB(45, 45, 75)
        s.Thickness = 1
        s.Parent = row
    end

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(0.65, 0, 0, 24)
    nameLbl.Position = UDim2.new(0, 12, 0, 4)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = label
    nameLbl.TextColor3 = Color3.fromRGB(215,215,245)
    nameLbl.TextSize = 13
    nameLbl.Font = Enum.Font.Gotham
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.ZIndex = 53
    nameLbl.Parent = row

    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(0.32, 0, 0, 24)
    valLbl.Position = UDim2.new(0.65, 0, 0, 4)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(def)
    valLbl.TextColor3 = Color3.fromRGB(130, 100, 255)
    valLbl.TextSize = 13
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.ZIndex = 53
    valLbl.Parent = row

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -24, 0, 8)
    track.Position = UDim2.new(0, 12, 0, 40)
    track.BackgroundColor3 = Color3.fromRGB(38, 38, 62)
    track.BorderSizePixel = 0
    track.ZIndex = 53
    track.Parent = row

    do
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(1,0)
        c.Parent = track
    end

    local pct = (def - mn) / (mx - mn)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(pct, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 60, 255)
    fill.BorderSizePixel = 0
    fill.ZIndex = 54
    fill.Parent = track

    do
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(1,0)
        c.Parent = fill
        local g = Instance.new("UIGradient")
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(110,60,255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(60,140,255)),
        })
        g.Parent = fill
    end

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new(pct, -8, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
    knob.BorderSizePixel = 0
    knob.ZIndex = 55
    knob.Parent = track

    do
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(1,0)
        c.Parent = knob
    end

    local function applyX(absX)
        local a = math.clamp((absX - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local v = math.floor(mn + (mx - mn) * a + 0.5)
        fill.Size  = UDim2.new(a, 0, 1, 0)
        knob.Position = UDim2.new(a, -8, 0.5, -8)
        valLbl.Text = tostring(v)
        onChange(v)
    end

    local dragging = false
    local hitBox = Instance.new("TextButton")
    hitBox.Size = UDim2.new(1, 0, 0, 28)
    hitBox.Position = UDim2.new(0, 0, 0.5, -14)
    hitBox.BackgroundTransparency = 1
    hitBox.Text = ""
    hitBox.ZIndex = 56
    hitBox.Parent = track

    hitBox.MouseButton1Down:Connect(function(x) dragging = true; applyX(x) end)
    hitBox.TouchLongPress:Connect(function(touches)
        dragging = true
    end)
    hitBox.TouchMoved:Connect(function(touches)
        if #touches > 0 then
            applyX(touches[1].Position.X)
        end
    end)
    hitBox.TouchEnded:Connect(function() dragging = false end)

    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement
            or i.UserInputType == Enum.UserInputType.Touch) then
            applyX(i.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
            or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return row
end

-- ════════════════════════════════════════
--            POPULATE MENU
-- ════════════════════════════════════════

makeSection("  ⚔️  АТАКА")

makeToggle("Нокбэк врагов", cfg.knockbackOn, function(v)
    cfg.knockbackOn = v
end)

makeSlider("Сила откидывания", 10, 300, cfg.knockPower, function(v)
    cfg.knockPower = v
end)

makeSection("  🛡️  ЗАЩИТА")

makeToggle("Анти-нокбэк (не отлетать)", cfg.antiKB, function(v)
    cfg.antiKB = v
end)

makeSection("  ✈️  ДВИЖЕНИЕ")

makeToggle("Полёт (Fly)", cfg.flyOn, function(v)
    cfg.flyOn = v
    if not v and hum then hum.PlatformStand = false end
end)

makeSlider("Скорость полёта", 10, 250, cfg.flySpeed, function(v)
    cfg.flySpeed = v
end)

makeSlider("WalkSpeed", 8, 150, cfg.walkSpeed, function(v)
    cfg.walkSpeed = v
    if hum then hum.WalkSpeed = v end
end)

makeSlider("JumpPower", 30, 250, cfg.jumpPower, function(v)
    cfg.jumpPower = v
    if hum then hum.JumpPower = v end
end)

makeSection("  🔧  ПРОЧЕЕ")

makeToggle("Infinite Jump", cfg.infinite_jump, function(v)
    cfg.infinite_jump = v
end)

makeToggle("Noclip (сквозь стены)", cfg.noclip, function(v)
    cfg.noclip = v
end)

-- ════════════════════════════════════════
--          KNOCKBACK LOGIC
-- ════════════════════════════════════════

local function doKnockback(hitRoot)
    if not cfg.knockbackOn or not root then return end
    local dir = (hitRoot.Position - root.Position).Unit
    local bv = Instance.new("BodyVelocity")
    bv.Velocity = (dir + Vector3.new(0, 0.5, 0)).Unit * cfg.knockPower
    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bv.P = 1e5
    bv.Parent = hitRoot
    game:GetService("Debris"):AddItem(bv, 0.3)
end

local registered = {}

local function registerTool(tool)
    for _, p in ipairs(tool:GetDescendants()) do
        if p:IsA("BasePart") and not registered[p] then
            registered[p] = true
            p.Touched:Connect(function(hit)
                local c = hit.Parent
                local pl = Players:GetPlayerFromCharacter(c)
                if pl and pl ~= player then
                    local r = c:FindFirstChild("HumanoidRootPart")
                    if r then doKnockback(r) end
                end
            end)
        end
    end
end

if player.Character then
    for _, t in ipairs(player.Character:GetChildren()) do
        if t:IsA("Tool") then registerTool(t) end
    end
end

player.CharacterAdded:Connect(function(c)
    registered = {}
    c.ChildAdded:Connect(function(ch)
        if ch:IsA("Tool") then registerTool(ch) end
    end)
end)

-- ════════════════════════════════════════
--           FLY SYSTEM
-- ════════════════════════════════════════

local flyBV, flyBG

RunService.Heartbeat:Connect(function()
    if not root or not hum then return end

    -- WalkSpeed sync
    if not cfg.flyOn then
        hum.WalkSpeed = cfg.walkSpeed
        hum.JumpPower = cfg.jumpPower
    end

    -- Anti-knockback
    if cfg.antiKB then
        for _, v in ipairs(root:GetChildren()) do
            if (v:IsA("BodyVelocity") or v:IsA("BodyForce") or v:IsA("BodyPosition"))
                and v ~= flyBV then
                v:Destroy()
            end
        end
    end

    -- Noclip
    if cfg.noclip and char then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = false
            end
        end
    end

    -- Fly
    if cfg.flyOn then
        hum.PlatformStand = true

        if not flyBV or not flyBV.Parent then
            flyBV = Instance.new("BodyVelocity")
            flyBV.MaxForce = Vector3.new(1e5,1e5,1e5)
            flyBV.Velocity = Vector3.new(0,0,0)
            flyBV.P = 1e4
            flyBV.Parent = root
        end
        if not flyBG or not flyBG.Parent then
            flyBG = Instance.new("BodyGyro")
            flyBG.MaxTorque = Vector3.new(1e5,1e5,1e5)
            flyBG.D = 100
            flyBG.P = 1e4
            flyBG.Parent = root
        end

        local cam = workspace.CurrentCamera
        local dir = Vector3.new(0,0,0)

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end

        flyBV.Velocity = dir.Magnitude > 0 and dir.Unit * cfg.flySpeed or Vector3.new(0,0,0)
        flyBG.CFrame = cam.CFrame
    else
        hum.PlatformStand = false
        if flyBV and flyBV.Parent then flyBV:Destroy() end
        if flyBG and flyBG.Parent then flyBG:Destroy() end
    end
end)

-- ════════════════════════════════════════
--         INFINITE JUMP
-- ════════════════════════════════════════

UserInputService.JumpRequest:Connect(function()
    if cfg.infinite_jump and hum then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

print("✦ Eplisma Laura v2 — loaded!")
