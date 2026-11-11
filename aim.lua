-- [[ Murder Duels — ХИТБОКСЫ + ESP (Фикс нестабильности) ]]
-- Разработчик: artar

local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ===== НАСТРОЙКИ =====
local HitboxHotkey = Enum.KeyCode.H
local HitboxScale = 3
local HitboxActive = false
local OriginalSizes = {}

local EspActive = false
local EspColor = Color3.fromRGB(255, 0, 0)
local EspHighlights = {}

-- ===== GUI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ArtarioMurderHub"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 290) 
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -145)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(40, 30, 30)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.Text = "ARTARIO HUB (MD)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Parent = TopBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -75, 0.15, 0)
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinimizeBtn.TextSize = 18
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0.15, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.TextSize = 18
CloseBtn.BackgroundTransparency = 1
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, 0, 1, -40)
Content.Position = UDim2.new(0, 0, 0, 40)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

local HotkeyHint = Instance.new("TextLabel")
HotkeyHint.Size = UDim2.new(0.9, 0, 0, 15)
HotkeyHint.Position = UDim2.new(0.05, 0, 0.01, 0) 
HotkeyHint.Text = "горячая клавиша - H"
HotkeyHint.TextColor3 = Color3.fromRGB(120, 120, 120)
HotkeyHint.TextSize = 10
HotkeyHint.TextXAlignment = Enum.TextXAlignment.Center
HotkeyHint.BackgroundTransparency = 1
HotkeyHint.Font = Enum.Font.Gotham
HotkeyHint.Parent = Content

local ToggleHitboxBtn = Instance.new("TextButton")
ToggleHitboxBtn.Size = UDim2.new(0.9, 0, 0, 40)
ToggleHitboxBtn.Position = UDim2.new(0.05, 0, 0.08, 0)
ToggleHitboxBtn.Text = "ХИТБОКСЫ: ВЫКЛ"
ToggleHitboxBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleHitboxBtn.TextSize = 14
ToggleHitboxBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleHitboxBtn.Font = Enum.Font.GothamBold
ToggleHitboxBtn.Parent = Content
Instance.new("UICorner", ToggleHitboxBtn).CornerRadius = UDim.new(0, 8)

local ToggleEspBtn = Instance.new("TextButton")
ToggleEspBtn.Size = UDim2.new(0.9, 0, 0, 40)
ToggleEspBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
ToggleEspBtn.Text = "ESP: ВЫКЛ"
ToggleEspBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleEspBtn.TextSize = 14
ToggleEspBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleEspBtn.Font = Enum.Font.GothamBold
ToggleEspBtn.Parent = Content
Instance.new("UICorner", ToggleEspBtn).CornerRadius = UDim.new(0, 8)

local ColorLabel = Instance.new("TextLabel")
ColorLabel.Size = UDim2.new(0.9, 0, 0, 20)
ColorLabel.Position = UDim2.new(0.05, 0, 0.44, 0)
ColorLabel.Text = "ЦВЕТ ESP:"
ColorLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
ColorLabel.TextSize = 11
ColorLabel.TextXAlignment = Enum.TextXAlignment.Left
ColorLabel.BackgroundTransparency = 1
ColorLabel.Font = Enum.Font.Gotham
ColorLabel.Parent = Content

local ColorButtonsFrame = Instance.new("Frame")
ColorButtonsFrame.Size = UDim2.new(0.9, 0, 0, 35)
ColorButtonsFrame.Position = UDim2.new(0.05, 0, 0.51, 0)
ColorButtonsFrame.BackgroundTransparency = 1
ColorButtonsFrame.Parent = Content

local RedBtn = Instance.new("TextButton")
RedBtn.Size = UDim2.new(0.3, 0, 1, 0)
RedBtn.Position = UDim2.new(0, 0, 0, 0)
RedBtn.Text = ""
RedBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
RedBtn.BorderSizePixel = 0
RedBtn.Parent = ColorButtonsFrame
Instance.new("UICorner", RedBtn).CornerRadius = UDim.new(0, 6)

local GreenBtn = Instance.new("TextButton")
GreenBtn.Size = UDim2.new(0.3, 0, 1, 0)
GreenBtn.Position = UDim2.new(0.35, 0, 0, 0)
GreenBtn.Text = ""
GreenBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
GreenBtn.BorderSizePixel = 0
GreenBtn.Parent = ColorButtonsFrame
Instance.new("UICorner", GreenBtn).CornerRadius = UDim.new(0, 6)

local BlueBtn = Instance.new("TextButton")
BlueBtn.Size = UDim2.new(0.3, 0, 1, 0)
BlueBtn.Position = UDim2.new(0.7, 0, 0, 0)
BlueBtn.Text = ""
BlueBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
BlueBtn.BorderSizePixel = 0
BlueBtn.Parent = ColorButtonsFrame
Instance.new("UICorner", BlueBtn).CornerRadius = UDim.new(0, 6)

local SizeInput = Instance.new("TextBox")
SizeInput.Size = UDim2.new(0.9, 0, 0, 40)
SizeInput.Position = UDim2.new(0.05, 0, 0.68, 0)
SizeInput.Text = "Размер хитбокса: 3"
SizeInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SizeInput.TextSize = 14
SizeInput.BackgroundColor3 = Color3.fromRGB(40, 30, 30)
SizeInput.BorderSizePixel = 0
SizeInput.TextXAlignment = Enum.TextXAlignment.Center
SizeInput.Font = Enum.Font.GothamBold
SizeInput.Parent = Content
Instance.new("UICorner", SizeInput).CornerRadius = UDim.new(0, 8)

SizeInput.FocusLost:Connect(function()
    local val = tonumber(SizeInput.Text:match("%d+"))
    if val and val >= 1 and val <= 100 then
        HitboxScale = val
        SizeInput.Text = "Размер хитбокса: " .. val
        if HitboxActive then
            DisableHitbox()
            EnableHitbox()
        end
    else
        SizeInput.Text = "Размер хитбокса: " .. HitboxScale
    end
end)

-- ===== ФУНКЦИИ =====
local function ApplyHitboxToPlayer(op)
    if op == Player then return end
    local char = op.Character
    if not char or char == Player.Character then return end
    
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            -- Если размер не записан или игра его сбросила — применяем заново
            if not OriginalSizes[part] then
                OriginalSizes[part] = {Size = part.Size}
                part.Size = part.Size * HitboxScale
            elseif part.Size ~= OriginalSizes[part].Size * HitboxScale then
                -- Если игра пытается вернуть старый размер, мы его перебиваем
                part.Size = OriginalSizes[part].Size * HitboxScale
            end
        end
    end
end

local function EnableHitbox()
    HitboxActive = true
    OriginalSizes = {}
    ToggleHitboxBtn.Text = "ХИТБОКСЫ: ВКЛ"
    ToggleHitboxBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    for _, op in ipairs(game.Players:GetPlayers()) do ApplyHitboxToPlayer(op) end
end

local function DisableHitbox()
    HitboxActive = false
    ToggleHitboxBtn.Text = "ХИТБОКСЫ: ВЫКЛ"
    ToggleHitboxBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    for part, data in pairs(OriginalSizes) do
        if part and part.Parent then 
            part.Size = data.Size 
        end
    end
    OriginalSizes = {}
end

local function ApplyEspToPlayer(op)
    if op == Player then return end
    local char = op.Character
    if not char or char == Player.Character then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum or hum.Health <= 0 then return end
    
    if not char:FindFirstChild("ArtarioESP") then
        local hl = Instance.new("Highlight")
        hl.Name = "ArtarioESP"
        hl.FillColor = EspColor
        hl.FillTransparency = 0.7
        hl.OutlineColor = EspColor
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = char
        EspHighlights[op] = hl
    end
end

local function EnableEsp()
    EspActive = true
    EspHighlights = {}
    ToggleEspBtn.Text = "ESP: ВКЛ"
    ToggleEspBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    for _, op in ipairs(game.Players:GetPlayers()) do ApplyEspToPlayer(op) end
end

local function DisableEsp()
    EspActive = false
    ToggleEspBtn.Text = "ESP: ВЫКЛ"
    ToggleEspBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    for _, hl in pairs(EspHighlights) do
        if hl and hl.Parent then hl:Destroy() end
    end
    EspHighlights = {}
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p.Character then
            local h = p.Character:FindFirstChild("ArtarioESP")
            if h then h:Destroy() end
        end
    end
end

-- ===== ОБРАБОТКА ЦВЕТОВ =====
RedBtn.MouseButton1Click:Connect(function()
    EspColor = Color3.fromRGB(255, 0, 0)
    for _, hl in pairs(EspHighlights) do
        if hl and hl.Parent then
            hl.FillColor = EspColor
            hl.OutlineColor = EspColor
        end
    end
end)

GreenBtn.MouseButton1Click:Connect(function()
    EspColor = Color3.fromRGB(0, 255, 0)
    for _, hl in pairs(EspHighlights) do
        if hl and hl.Parent then
            hl.FillColor = EspColor
            hl.OutlineColor = EspColor
        end
    end
end)

BlueBtn.MouseButton1Click:Connect(function()
    EspColor = Color3.fromRGB(0, 100, 255)
    for _, hl in pairs(EspHighlights) do
        if hl and hl.Parent then
            hl.FillColor = EspColor
            hl.OutlineColor = EspColor
        end
    end
end)

-- ===== КНОПКИ ВКЛ/ВЫКЛ =====
ToggleHitboxBtn.MouseButton1Click:Connect(function()
    if HitboxActive then DisableHitbox() else EnableHitbox() end
end)

ToggleEspBtn.MouseButton1Click:Connect(function()
    if EspActive then DisableEsp() else EnableEsp() end
end)

-- 🔥 ГОРЯЧАЯ КЛАВИША H
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == HitboxHotkey then
        if HitboxActive then DisableHitbox() else EnableHitbox() end
    end
end)

-- ===== ЦИКЛ ОБНОВЛЕНИЯ (Ускорен для стабильности) =====
task.spawn(function()
    while ScreenGui.Parent do
        task.wait(0.1) -- 🔥 Проверяем быстрее (10 раз в секунду), чтобы хитбоксы не сбрасывались
        if EspActive then
            for _, p in ipairs(game.Players:GetPlayers()) do ApplyEspToPlayer(p) end
        end
        if HitboxActive then
            for _, p in ipairs(game.Players:GetPlayers()) do ApplyHitboxToPlayer(p) end
        end
    end
end)

game.Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(1)
        if EspActive then ApplyEspToPlayer(p) end
        if HitboxActive then ApplyHitboxToPlayer(p) end
    end)
end)

-- ===== СВОРАЧИВАНИЕ И ЗАКРЫТИЕ =====
local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    Content.Visible = not minimized
    MinimizeBtn.Text = minimized and "+" or "—"
    MainFrame.Size = minimized and UDim2.new(0, 320, 0, 40) or UDim2.new(0, 320, 0, 290)
end)

CloseBtn.MouseButton1Click:Connect(function()
    if HitboxActive then DisableHitbox() end
    if EspActive then DisableEsp() end
    ScreenGui:Destroy()
end)

print("✅ ARTARIO HUB (Murder Duels) загружен")
