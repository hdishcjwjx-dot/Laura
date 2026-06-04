-- Завантаження сучасної бібліотеки інтерфейсу (Rayfield)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Eplisma Laura | Арена Способностей",
   LoadingTitle = "Запуск системи Eplisma...",
   LoadingSubtitle = "by AI Collaborator",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = "EplismaLauraConfig"
   },
   KeySystem = false
})

-- Локальні змінні для функцій
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local walkSpeedValue = 16
local flySpeedValue = 50
local knockbackForce = 100

local flyEnabled = false
local superKnockbackEnabled = false
local antiKnockbackEnabled = false

-- Оновлення посилання на персонажа після респавну
Player.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = newCharacter:WaitForChild("Humanoid")
end)

-- ================= GADGETS & TABS =================

local MainTab = Window:CreateTab("Головна (Мувмент)", 4483362458)
local CombatTab = Window:CreateTab("Бой (Combat)", 4483362534)

-- ================= TAB 1: MOVEMENT =================

-- Налаштування швидкості
MainTab:CreateSlider({
   Name = "Швидкість бігу (Speed)",
   Range = {16, 250},
   Increment = 1,
   CurrentValue = 16,
   Flag = "SpeedSlider",
   Callback = function(Value)
      walkSpeedValue = Value
      if Character and Character:FindFirstChild("Humanoid") then
          Character.Humanoid.WalkSpeed = Value
      end
   end,
})

-- Постійне підтримання швидкості
game:GetService("RunService").Heartbeat:Connect(function()
    if Character and Character:FindFirstChild("Humanoid") and Character.Humanoid.WalkSpeed ~= walkSpeedValue and not flyEnabled then
        Character.Humanoid.WalkSpeed = walkSpeedValue
    end
end)

-- Налаштування польоту
MainTab:CreateToggle({
   Name = "Режим польоту (Fly)",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(Value)
      flyEnabled = Value
      if flyEnabled then
          -- Логіка польоту
          local UserInputService = game:GetService("UserInputService")
          local RunService = game:GetService("RunService")
          local HRP = Character:WaitForChild("HumanoidRootPart")
          
          local bv = Instance.new("BodyVelocity")
          bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
          bv.Velocity = Vector3.new(0, 0, 0)
          bv.Parent = HRP
          
          local bg = Instance.new("BodyGyro")
          bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
          bg.CFrame = HRP.CFrame
          bg.Parent = HRP
          
          spawn(function()
              while flyEnabled and Character and HRP and bv.Parent do
                  RunService.RenderStepped:Wait()
                  local camCFrame = workspace.CurrentCamera.CFrame
                  local direction = Vector3.new(0,0,0)
                  
                  if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + camCFrame.LookVector end
                  if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction - camCFrame.LookVector end
                  if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction = direction - camCFrame.RightVector end
                  if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction = direction + camCFrame.RightVector end
                  if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction = direction + Vector3.new(0,1,0) end
                  if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then direction = direction - Vector3.new(0,1,0) end
                  
                  bv.Velocity = direction.Unit * flySpeedValue
                  if direction == Vector3.new(0,0,0) then bv.Velocity = Vector3.new(0,0,0) end
                  bg.CFrame = camCFrame
              end
              bv:Destroy()
              bg:Destroy()
          end)
      end
   end,
})

MainTab:CreateSlider({
   Name = "Швидкість польоту",
   Range = {20, 300},
   Increment = 5,
   CurrentValue = 50,
   Flag = "FlySpeedSlider",
   Callback = function(Value)
      flySpeedValue = Value
   end,
})

-- ================= TAB 2: COMBAT =================

-- Супер-відкидання
CombatTab:CreateToggle({
   Name = "Сильне відкидання ворогів (Super Knockback)",
   CurrentValue = false,
   Flag = "KnockbackToggle",
   Callback = function(Value)
      superKnockbackEnabled = Value
   end,
})

-- Повзунок сили відкидання
CombatTab:CreateSlider({
   Name = "Сила відкидання",
   Range = {50, 500},
   Increment = 10,
   CurrentValue = 100,
   Flag = "ForceSlider",
   Callback = function(Value)
      knockbackForce = Value
   end,
})

-- Логіка супер-відкидання при дотику твоєї зброї/рук до ворога
game:GetService("RunService").Stepped:Connect(function()
    if superKnockbackEnabled and Character then
        for _, part in pairs(Character:GetChildren()) do
            if part:IsA("BasePart") or (part:IsA("Tool") and part:FindFirstChild("Handle")) then
                local triggerPart = part:IsA("Tool") and part.Handle or part
                triggerPart.Touched:Connect(function(hit)
                    if superKnockbackEnabled and hit.Parent and hit.Parent:FindFirstChildOfClass("Humanoid") then
                        local enemyRoot = hit.Parent:FindFirstChild("HumanoidRootPart")
                        if enemyRoot and hit.Parent.Name ~= Player.Name then
                            -- Вираховуємо вектор удару (від тебе до ворога)
                            local direction = (enemyRoot.Position - Character.HumanoidRootPart.Position).Unit
                            -- Примусово міняємо швидкість ворога (працює, якщо активований NetworkOwnership або стандартна фізика)
                            enemyRoot.AssemblyLinearVelocity = (direction * knockbackForce) + Vector3.new(0, knockbackForce/2, 0)
                        end
                    end
                end)
            end
        end
    end
end)

-- Анти-відкидання та Анти-падіння (Anti-Knockback / Anti-Ragdoll)
CombatTab:CreateToggle({
   Name = "Анти-відкидання та Анти-падіння",
   CurrentValue = false,
   Flag = "AntiKnockbackToggle",
   Callback = function(Value)
      antiKnockbackEnabled = Value
   end,
})

-- Логіка заморожування імпульсу при ударі по тобі
game:GetService("RunService").Heartbeat:Connect(function()
    if antiKnockbackEnabled and Character and Character:FindFirstChild("HumanoidRootPart") then
        local HRP = Character.HumanoidRootPart
        local Hum = Character:FindFirstChildOfClass("Humanoid")
        
        -- Вимикаємо стани падіння та регдоллу (тряпки)
        if Hum then
            Hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            Hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            if Hum:GetState() == Enum.HumanoidStateType.Ragdoll or Hum:GetState() == Enum.HumanoidStateType.FallingDown then
                Hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
        
        -- Якщо швидкість по осях X або Z стає занадто аномальною (наприклад, тебе вдарили), скрипт гасить цей імпульс
        local velocity = HRP.AssemblyLinearVelocity
        if velocity.Magnitude > walkSpeedValue + 10 and not flyEnabled then
            HRP.AssemblyLinearVelocity = Vector3.new(0, velocity.Y, 0) -- Залишаємо лише гравітацію/стрибок
        end
    end
end)

Rayfield:Notify({
   Title = "Eplisma Laura активовано!",
   Content = "Скрипт успішно запущено для Арени Способностей.",
   Duration = 5,
   Image = 4483362458,
})
