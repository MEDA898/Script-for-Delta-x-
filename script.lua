-- Получаем необходимые сервисы
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 5)

-- Проверка PlayerGui
if not PlayerGui then
    warn("PlayerGui не найден!")
    return
end
print("PlayerGui успешно найден")

-- Создаем ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
print("ScreenGui создан")

-- Создаем основной фрейм меню
local MenuFrame = Instance.new("Frame")
MenuFrame.Parent = ScreenGui
MenuFrame.Size = UDim2.new(0, 400, 0, 300)
MenuFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MenuFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MenuFrame.BorderSizePixel = 0
MenuFrame.Active = true
MenuFrame.ClipsDescendants = true
MenuFrame.BackgroundTransparency = 1
print("MenuFrame создан")

-- Скругленные углы
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MenuFrame

-- Создаем шторку (HeaderFrame) для основного меню
local HeaderFrame = Instance.new("Frame")
HeaderFrame.Parent = MenuFrame
HeaderFrame.Size = UDim2.new(1, 0, 0, 30)
HeaderFrame.Position = UDim2.new(0, 0, 0, 0)
HeaderFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
HeaderFrame.BorderSizePixel = 0
HeaderFrame.ZIndex = 3
HeaderFrame.ClipsDescendants = true

-- Скругленные углы для шторки
local HeaderUICorner = Instance.new("UICorner")
HeaderUICorner.CornerRadius = UDim.new(0, 8)
HeaderUICorner.Parent = HeaderFrame

-- Градиент для шторки
local HeaderGradient = Instance.new("UIGradient")
HeaderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 70, 70)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 100, 100))
})
HeaderGradient.Rotation = 45
HeaderGradient.Parent = HeaderFrame

-- Текст в шторке
local HeaderLabel = Instance.new("TextLabel")
HeaderLabel.Parent = HeaderFrame
HeaderLabel.Size = UDim2.new(0.5, -10, 1, 0)
HeaderLabel.Position = UDim2.new(0, 10, 0, 0)
HeaderLabel.BackgroundTransparency = 1
HeaderLabel.Text = "Script v2 Roblox by @meda898"
HeaderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
HeaderLabel.TextYAlignment = Enum.TextYAlignment.Center
HeaderLabel.Font = Enum.Font.GothamBold
HeaderLabel.TextSize = 14
HeaderLabel.ZIndex = 3

-- Текст для минимизированного содержимого
local MinimizedContentLabel = Instance.new("TextLabel")
MinimizedContentLabel.Parent = MenuFrame
MinimizedContentLabel.Text = "@meda898"
MinimizedContentLabel.Size = UDim2.new(1, 0, 1, 0)
MinimizedContentLabel.BackgroundTransparency = 1
MinimizedContentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizedContentLabel.TextScaled = true
MinimizedContentLabel.TextWrapped = true
MinimizedContentLabel.TextXAlignment = Enum.TextXAlignment.Center
MinimizedContentLabel.TextYAlignment = Enum.TextYAlignment.Center
MinimizedContentLabel.ZIndex = 2
MinimizedContentLabel.Visible = false

-- Кнопка для разворачивания
local ExpandButton = Instance.new("TextButton")
ExpandButton.Parent = MenuFrame
ExpandButton.Size = UDim2.new(1, 0, 1, 0)
ExpandButton.BackgroundTransparency = 1
ExpandButton.Text = ""
ExpandButton.ZIndex = 3
ExpandButton.Visible = false
ExpandButton.Active = true

-- Кнопка "Закрыть"
local CloseButton = Instance.new("TextButton")
CloseButton.Parent = HeaderFrame
CloseButton.Text = "X"
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Position = UDim2.new(1, -25, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 14
CloseButton.ZIndex = 3
CloseButton.Visible = true
CloseButton.Active = true

-- Кнопка "Свернуть"
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Parent = HeaderFrame
MinimizeButton.Text = "_"
MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
MinimizeButton.Position = UDim2.new(1, -50, 0, 5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.TextSize = 14
MinimizeButton.ZIndex = 3
MinimizeButton.Visible = true
MinimizeButton.Active = true

-- Кнопка переключения темы
local isDarkTheme = true
local ThemeButton = Instance.new("TextButton")
ThemeButton.Parent = HeaderFrame
ThemeButton.Size = UDim2.new(0, 20, 0, 20)
ThemeButton.Position = UDim2.new(1, -75, 0, 5)
ThemeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
ThemeButton.Text = "T"
ThemeButton.TextColor3 = Color3.fromRGB(0, 0, 0)
ThemeButton.Font = Enum.Font.SourceSansBold
ThemeButton.TextSize = 14
ThemeButton.ZIndex = 3
ThemeButton.Active = true

-- Кнопка-шестерёнка для настроек меню
local MenuSettingsButton = Instance.new("TextButton")
MenuSettingsButton.Parent = HeaderFrame
MenuSettingsButton.Size = UDim2.new(0, 20, 0, 20)
MenuSettingsButton.Position = UDim2.new(1, -100, 0, 5)
MenuSettingsButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
MenuSettingsButton.Text = "⚙"
MenuSettingsButton.TextColor3 = Color3.fromRGB(0, 0, 0)
MenuSettingsButton.Font = Enum.Font.SourceSansBold
MenuSettingsButton.TextSize = 14
MenuSettingsButton.ZIndex = 3
MenuSettingsButton.Active = true

-- Кнопка "Activate Fly"
local ActivateButton = Instance.new("TextButton")
ActivateButton.Parent = MenuFrame
ActivateButton.Size = UDim2.new(0, 150, 0, 40)
ActivateButton.Position = UDim2.new(0, 10, 0, 40)
ActivateButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
ActivateButton.Text = "Activate Fly"
ActivateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ActivateButton.Font = Enum.Font.GothamBold
ActivateButton.TextSize = 16
ActivateButton.ZIndex = 2
ActivateButton.AutoButtonColor = false

-- Кнопка "WallHack"
local WallHackButton = Instance.new("TextButton")
WallHackButton.Parent = MenuFrame
WallHackButton.Size = UDim2.new(0, 150, 0, 40)
WallHackButton.Position = UDim2.new(0, 185, 0, 40)
WallHackButton.BackgroundColor3 = Color3.fromRGB(128, 0, 128)
WallHackButton.Text = "Toggle WallHack"
WallHackButton.TextColor3 = Color3.fromRGB(255, 255, 255)
WallHackButton.Font = Enum.Font.GothamBold
WallHackButton.TextSize = 16
WallHackButton.ZIndex = 2
WallHackButton.AutoButtonColor = false

-- Кнопка "SpeedHack"
local SpeedHackButton = Instance.new("TextButton")
SpeedHackButton.Parent = MenuFrame
SpeedHackButton.Size = UDim2.new(0, 150, 0, 40)
SpeedHackButton.Position = UDim2.new(0, 10, 0, 90)
SpeedHackButton.BackgroundColor3 = Color3.fromRGB(0, 128, 255)
SpeedHackButton.Text = "Toggle SpeedHack"
SpeedHackButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedHackButton.Font = Enum.Font.GothamBold
SpeedHackButton.TextSize = 16
SpeedHackButton.ZIndex = 2
SpeedHackButton.AutoButtonColor = false

-- Кнопка-шестерёнка для настроек SpeedHack
local SpeedSettingsButton = Instance.new("TextButton")
SpeedSettingsButton.Parent = MenuFrame
SpeedSettingsButton.Size = UDim2.new(0, 20, 0, 20)
SpeedSettingsButton.Position = UDim2.new(0, 160, 0, 95)
SpeedSettingsButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
SpeedSettingsButton.Text = "⚙"
SpeedSettingsButton.TextColor3 = Color3.fromRGB(0, 0, 0)
SpeedSettingsButton.Font = Enum.Font.SourceSansBold
SpeedSettingsButton.TextSize = 14
SpeedSettingsButton.ZIndex = 2

-- Кнопка "Noclip"
local NoclipButton = Instance.new("TextButton")
NoclipButton.Parent = MenuFrame
NoclipButton.Size = UDim2.new(0, 150, 0, 40)
NoclipButton.Position = UDim2.new(0, 185, 0, 90)
NoclipButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
NoclipButton.Text = "Toggle Noclip"
NoclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipButton.Font = Enum.Font.GothamBold
NoclipButton.TextSize = 16
NoclipButton.ZIndex = 2
NoclipButton.AutoButtonColor = false
print("NoclipButton создан")

-- Кнопка "Teleport to Player"
local TeleportButton = Instance.new("TextButton")
TeleportButton.Parent = MenuFrame
TeleportButton.Size = UDim2.new(0, 150, 0, 40)
TeleportButton.Position = UDim2.new(0, 185, 0, 140)
TeleportButton.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
TeleportButton.Text = "Teleport to Player"
TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportButton.Font = Enum.Font.GothamBold
TeleportButton.TextSize = 16
TeleportButton.ZIndex = 2
TeleportButton.AutoButtonColor = false

-- Кнопка "Infinite Jump"
local InfiniteJumpButton = Instance.new("TextButton")
InfiniteJumpButton.Parent = MenuFrame
InfiniteJumpButton.Size = UDim2.new(0, 150, 0, 40)
InfiniteJumpButton.Position = UDim2.new(0, 10, 0, 140)
InfiniteJumpButton.BackgroundColor3 = Color3.fromRGB(0, 200, 200)
InfiniteJumpButton.Text = "Toggle Infinite Jump"
InfiniteJumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
InfiniteJumpButton.Font = Enum.Font.GothamBold
InfiniteJumpButton.TextSize = 16
InfiniteJumpButton.ZIndex = 2
InfiniteJumpButton.AutoButtonColor = false
print("InfiniteJumpButton создан")

-- Панель для списка игроков
local TeleportPanel = Instance.new("Frame")
TeleportPanel.Parent = ScreenGui
TeleportPanel.Size = UDim2.new(0, 200, 0, 300)
TeleportPanel.Position = UDim2.new(0.5, -100, 0.5, -150)
TeleportPanel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TeleportPanel.BorderSizePixel = 0
TeleportPanel.Visible = false
TeleportPanel.ClipsDescendants = true
TeleportPanel.ZIndex = 5
TeleportPanel.Active = true
TeleportPanel.BackgroundTransparency = 1

local TeleportPanelUICorner = Instance.new("UICorner")
TeleportPanelUICorner.CornerRadius = UDim.new(0, 10)
TeleportPanelUICorner.Parent = TeleportPanel

-- Шапка для TeleportPanel
local TeleportHeaderFrame = Instance.new("Frame")
TeleportHeaderFrame.Parent = TeleportPanel
TeleportHeaderFrame.Size = UDim2.new(1, 0, 0, 25)
TeleportHeaderFrame.Position = UDim2.new(0, 0, 0, 0)
TeleportHeaderFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
TeleportHeaderFrame.BorderSizePixel = 0
TeleportHeaderFrame.ZIndex = 6

local TeleportHeaderLabel = Instance.new("TextLabel")
TeleportHeaderLabel.Parent = TeleportHeaderFrame
TeleportHeaderLabel.Size = UDim2.new(1, -30, 1, 0)
TeleportHeaderLabel.Position = UDim2.new(0, 5, 0, 0)
TeleportHeaderLabel.BackgroundTransparency = 1
TeleportHeaderLabel.Text = "Teleport Panel"
TeleportHeaderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportHeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
TeleportHeaderLabel.Font = Enum.Font.GothamBold
TeleportHeaderLabel.TextSize = 14
TeleportHeaderLabel.ZIndex = 6

-- ScrollingFrame для списка игроков
local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Parent = TeleportPanel
PlayerList.Size = UDim2.new(1, -10, 1, -65)
PlayerList.Position = UDim2.new(0, 5, 0, 30)
PlayerList.BackgroundTransparency = 1
PlayerList.ScrollBarThickness = 5
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerList.ZIndex = 6

-- UIListLayout для списка игроков
local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = PlayerList
ListLayout.Padding = UDim.new(0, 5)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Кнопка "Close" для панели
local TeleportCloseButton = Instance.new("TextButton")
TeleportCloseButton.Parent = TeleportPanel
TeleportCloseButton.Text = "X"
TeleportCloseButton.Size = UDim2.new(0, 20, 0, 20)
TeleportCloseButton.Position = UDim2.new(1, -25, 0, 5)
TeleportCloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
TeleportCloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportCloseButton.Font = Enum.Font.SourceSansBold
TeleportCloseButton.TextSize = 14
TeleportCloseButton.ZIndex = 6

-- Панель настроек SpeedHack
local SpeedSettingsPanel = Instance.new("Frame")
SpeedSettingsPanel.Parent = ScreenGui
SpeedSettingsPanel.Size = UDim2.new(0, 200, 0, 300)
SpeedSettingsPanel.Position = UDim2.new(0.5, -100, 0.5, -150)
SpeedSettingsPanel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedSettingsPanel.BorderSizePixel = 0
SpeedSettingsPanel.Visible = false
SpeedSettingsPanel.ClipsDescendants = true
SpeedSettingsPanel.ZIndex = 5
SpeedSettingsPanel.Active = true
SpeedSettingsPanel.BackgroundTransparency = 1

local SpeedSettingsUICorner = Instance.new("UICorner")
SpeedSettingsUICorner.CornerRadius = UDim.new(0, 10)
SpeedSettingsUICorner.Parent = SpeedSettingsPanel

-- Шапка для SpeedSettingsPanel
local SpeedSettingsHeaderFrame = Instance.new("Frame")
SpeedSettingsHeaderFrame.Parent = SpeedSettingsPanel
SpeedSettingsHeaderFrame.Size = UDim2.new(1, 0, 0, 25)
SpeedSettingsHeaderFrame.Position = UDim2.new(0, 0, 0, 0)
SpeedSettingsHeaderFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
SpeedSettingsHeaderFrame.BorderSizePixel = 0
SpeedSettingsHeaderFrame.ZIndex = 6

local SpeedSettingsHeaderLabel = Instance.new("TextLabel")
SpeedSettingsHeaderLabel.Parent = SpeedSettingsHeaderFrame
SpeedSettingsHeaderLabel.Size = UDim2.new(1, -30, 1, 0)
SpeedSettingsHeaderLabel.Position = UDim2.new(0, 5, 0, 0)
SpeedSettingsHeaderLabel.BackgroundTransparency = 1
SpeedSettingsHeaderLabel.Text = "Speed Settings"
SpeedSettingsHeaderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedSettingsHeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedSettingsHeaderLabel.Font = Enum.Font.GothamBold
SpeedSettingsHeaderLabel.TextSize = 14
SpeedSettingsHeaderLabel.ZIndex = 6

local SpeedSettingsList = Instance.new("ScrollingFrame")
SpeedSettingsList.Parent = SpeedSettingsPanel
SpeedSettingsList.Size = UDim2.new(1, -10, 1, -65)
SpeedSettingsList.Position = UDim2.new(0, 5, 0, 30)
SpeedSettingsList.BackgroundTransparency = 1
SpeedSettingsList.ScrollBarThickness = 5
SpeedSettingsList.CanvasSize = UDim2.new(0, 0, 0, 0)
SpeedSettingsList.ZIndex = 6

local SpeedSettingsListLayout = Instance.new("UIListLayout")
SpeedSettingsListLayout.Parent = SpeedSettingsList
SpeedSettingsListLayout.Padding = UDim.new(0, 5)
SpeedSettingsListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local SpeedSettingsCloseButton = Instance.new("TextButton")
SpeedSettingsCloseButton.Parent = SpeedSettingsPanel
SpeedSettingsCloseButton.Text = "X"
SpeedSettingsCloseButton.Size = UDim2.new(0, 20, 0, 20)
SpeedSettingsCloseButton.Position = UDim2.new(1, -25, 0, 5)
SpeedSettingsCloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
SpeedSettingsCloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedSettingsCloseButton.Font = Enum.Font.SourceSansBold
SpeedSettingsCloseButton.TextSize = 14
SpeedSettingsCloseButton.ZIndex = 6

-- Элементы настроек SpeedHack
local SpeedSettingsInput = Instance.new("TextBox")
SpeedSettingsInput.Parent = SpeedSettingsList
SpeedSettingsInput.Size = UDim2.new(1, -10, 0, 30)
SpeedSettingsInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SpeedSettingsInput.Text = "16"
SpeedSettingsInput.TextColor3 = Color3.fromRGB(0, 0, 0)
SpeedSettingsInput.Font = Enum.Font.Gotham
SpeedSettingsInput.TextSize = 14
SpeedSettingsInput.ZIndex = 6

local AutoSpeedMaintainButton = Instance.new("TextButton")
AutoSpeedMaintainButton.Parent = SpeedSettingsList
AutoSpeedMaintainButton.Size = UDim2.new(1, -10, 0, 30)
AutoSpeedMaintainButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
AutoSpeedMaintainButton.Text = "Auto Maintain Speed: OFF"
AutoSpeedMaintainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoSpeedMaintainButton.Font = Enum.Font.Gotham
AutoSpeedMaintainButton.TextSize = 14
AutoSpeedMaintainButton.ZIndex = 6

SpeedSettingsList.CanvasSize = UDim2.new(0, 0, 0, 2 * 35)

-- Панель настроек меню
local MenuSettingsPanel = Instance.new("Frame")
MenuSettingsPanel.Parent = ScreenGui
MenuSettingsPanel.Size = UDim2.new(0, 400, 0, 300)
MenuSettingsPanel.Position = UDim2.new(0.5, -200, 0.5, -150)
MenuSettingsPanel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MenuSettingsPanel.BorderSizePixel = 0
MenuSettingsPanel.Visible = false
MenuSettingsPanel.ClipsDescendants = true
MenuSettingsPanel.ZIndex = 4
MenuSettingsPanel.Active = true
MenuSettingsPanel.BackgroundTransparency = 1

local MenuSettingsUICorner = Instance.new("UICorner")
MenuSettingsUICorner.CornerRadius = UDim.new(0, 10)
MenuSettingsUICorner.Parent = MenuSettingsPanel

-- Создаем шторку (MenuSettingsHeaderFrame) для MenuSettingsPanel
local MenuSettingsHeaderFrame = Instance.new("Frame")
MenuSettingsHeaderFrame.Parent = MenuSettingsPanel
MenuSettingsHeaderFrame.Size = UDim2.new(1, 0, 0, 30)
MenuSettingsHeaderFrame.Position = UDim2.new(0, 0, 0, 0)
MenuSettingsHeaderFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
MenuSettingsHeaderFrame.BorderSizePixel = 0
MenuSettingsHeaderFrame.ZIndex = 5
MenuSettingsHeaderFrame.ClipsDescendants = true

-- Скругленные углы для шторки
local MenuSettingsHeaderUICorner = Instance.new("UICorner")
MenuSettingsHeaderUICorner.CornerRadius = UDim.new(0, 8)
MenuSettingsHeaderUICorner.Parent = MenuSettingsHeaderFrame

-- Градиент для шторки
local MenuSettingsHeaderGradient = Instance.new("UIGradient")
MenuSettingsHeaderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 70, 70)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 100, 100))
})
MenuSettingsHeaderGradient.Rotation = 45
MenuSettingsHeaderGradient.Parent = MenuSettingsHeaderFrame

-- Текст в шторке
local MenuSettingsHeaderLabel = Instance.new("TextLabel")
MenuSettingsHeaderLabel.Parent = MenuSettingsHeaderFrame
MenuSettingsHeaderLabel.Size = UDim2.new(0.5, -10, 1, 0)
MenuSettingsHeaderLabel.Position = UDim2.new(0, 10, 0, 0)
MenuSettingsHeaderLabel.BackgroundTransparency = 1
MenuSettingsHeaderLabel.Text = "Menu Settings"
MenuSettingsHeaderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
MenuSettingsHeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
MenuSettingsHeaderLabel.TextYAlignment = Enum.TextYAlignment.Center
MenuSettingsHeaderLabel.Font = Enum.Font.GothamBold
MenuSettingsHeaderLabel.TextSize = 14
MenuSettingsHeaderLabel.ZIndex = 5

-- Кнопка "Назад" для MenuSettingsPanel (перемещена внутрь шторки)
local MenuSettingsCloseButton = Instance.new("TextButton")
MenuSettingsCloseButton.Parent = MenuSettingsHeaderFrame
MenuSettingsCloseButton.Text = "←"
MenuSettingsCloseButton.Size = UDim2.new(0, 20, 0, 20)
MenuSettingsCloseButton.Position = UDim2.new(1, -25, 0, 5)
MenuSettingsCloseButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
MenuSettingsCloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MenuSettingsCloseButton.Font = Enum.Font.SourceSansBold
MenuSettingsCloseButton.TextSize = 14
MenuSettingsCloseButton.ZIndex = 5

-- Скругленные углы и градиент для кнопок
local function applyButtonStyle(button)
    local success, result = pcall(function()
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = button
        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, button.BackgroundColor3),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 255))
        })
        gradient.Rotation = 45
        gradient.Parent = button
        local shadow = Instance.new("UIStroke")
        shadow.Thickness = 2
        shadow.Color = Color3.fromRGB(0, 0, 0)
        shadow.Transparency = 0.5
        shadow.Parent = button
    end)
    if success then
        print("Стиль применён к кнопке: " .. (button.Text or "TextBox"))
    else
        warn("Ошибка при применении стиля к кнопке: " .. tostring(result))
    end
end

applyButtonStyle(ActivateButton)
applyButtonStyle(WallHackButton)
applyButtonStyle(SpeedHackButton)
applyButtonStyle(SpeedSettingsButton)
applyButtonStyle(SpeedSettingsInput)
applyButtonStyle(AutoSpeedMaintainButton)
applyButtonStyle(ThemeButton)
applyButtonStyle(CloseButton)
applyButtonStyle(MinimizeButton)
applyButtonStyle(NoclipButton)
applyButtonStyle(TeleportButton)
applyButtonStyle(InfiniteJumpButton)
applyButtonStyle(TeleportCloseButton)
applyButtonStyle(SpeedSettingsCloseButton)
applyButtonStyle(MenuSettingsButton)
applyButtonStyle(MenuSettingsCloseButton)

-- Визуальная обратная связь для кнопок
local function setupButtonFeedback(button)
    if not button then return end
    local success, result = pcall(function()
        local originalColor = button.BackgroundColor3
        local hoverColor = Color3.new(
            math.min(originalColor.R + 0.1, 1),
            math.min(originalColor.G + 0.1, 1),
            math.min(originalColor.B + 0.1, 1)
        )
        local pressColor = Color3.new(
            math.max(originalColor.R - 0.2, 0),
            math.max(originalColor.G - 0.2, 0),
            math.max(originalColor.B - 0.2, 0)
        )
        button.MouseEnter:Connect(function()
            button.BackgroundColor3 = hoverColor
        end)
        button.MouseLeave:Connect(function()
            button.BackgroundColor3 = originalColor
        end)
        button.MouseButton1Down:Connect(function()
            button.BackgroundColor3 = pressColor
        end)
        button.MouseButton1Up:Connect(function()
            button.BackgroundColor3 = hoverColor
        end)
        button.MouseButton1Click:Connect(function()
            wait()
            button.BackgroundColor3 = originalColor
        end)
    end)
    if not success then
        warn("Ошибка настройки обратной связи для кнопки: " .. tostring(result))
    end
end

local buttons = {
    ActivateButton, WallHackButton, SpeedHackButton, SpeedSettingsButton,
    NoclipButton, ThemeButton, CloseButton, MinimizeButton, TeleportButton,
    InfiniteJumpButton, TeleportCloseButton, SpeedSettingsCloseButton,
    AutoSpeedMaintainButton, MenuSettingsButton, MenuSettingsCloseButton
}
for _, button in ipairs(buttons) do
    setupButtonFeedback(button)
end

-- Уведомления
local activeNotifications = {}
local function showNotification(message, color)
    local success, result = pcall(function()
        if #activeNotifications >= 5 then
            local oldest = table.remove(activeNotifications, 1)
            if oldest then
                oldest:Destroy()
            end
        end
        local notification = Instance.new("TextLabel")
        notification.Parent = ScreenGui
        notification.Size = UDim2.new(0, 200, 0, 50)
        notification.Position = UDim2.new(0.5, -100, 0, 10)
        notification.BackgroundColor3 = color or Color3.fromRGB(50, 50, 50)
        notification.Text = message
        notification.TextColor3 = Color3.fromRGB(255, 255, 255)
        notification.TextScaled = true
        notification.ZIndex = 10
        local corner = UICorner:Clone()
        corner.Parent = notification
        local tween = TweenService:Create(notification, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -100, 0, -50),
            BackgroundTransparency = 1,
            TextTransparency = 1
        })
        tween:Play()
        table.insert(activeNotifications, notification)
        tween.Completed:Connect(function()
            local index = table.find(activeNotifications, notification)
            if index then
                table.remove(activeNotifications, index)
            end
            notification:Destroy()
        end)
    end)
    if success then
        print("Уведомление показано: " .. message)
    else
        warn("Ошибка уведомления: " .. tostring(result))
    end
end
showNotification("Скрипт загружен!", Color3.fromRGB(0, 255, 0))

-- Функция применения темы
local playerButtons = {}
local function applyTheme()
    local success, result = pcall(function()
        if isDarkTheme then
            MenuFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            HeaderFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            MenuSettingsPanel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            MenuSettingsHeaderFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            MinimizedContentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            HeaderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            MenuSettingsHeaderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            ActivateButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
            WallHackButton.BackgroundColor3 = Color3.fromRGB(128, 0, 128)
            SpeedHackButton.BackgroundColor3 = Color3.fromRGB(0, 128, 255)
            SpeedSettingsButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            MenuSettingsButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            NoclipButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
            TeleportButton.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
            InfiniteJumpButton.BackgroundColor3 = Color3.fromRGB(0, 200, 200)
            TeleportPanel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            TeleportHeaderFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            SpeedSettingsPanel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            SpeedSettingsHeaderFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            for _, button in pairs(playerButtons) do
                if button then
                    button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                end
            end
        else
            MenuFrame.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            HeaderFrame.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
            MenuSettingsPanel.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            MenuSettingsHeaderFrame.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
            MinimizedContentLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
            HeaderLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
            MenuSettingsHeaderLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
            ActivateButton.BackgroundColor3 = Color3.fromRGB(150, 150, 255)
            WallHackButton.BackgroundColor3 = Color3.fromRGB(180, 100, 180)
            SpeedHackButton.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
            SpeedSettingsButton.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
            MenuSettingsButton.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
            NoclipButton.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
            TeleportButton.BackgroundColor3 = Color3.fromRGB(100, 255, 255)
            InfiniteJumpButton.BackgroundColor3 = Color3.fromRGB(100, 255, 255)
            TeleportPanel.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            TeleportHeaderFrame.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
            SpeedSettingsPanel.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            SpeedSettingsHeaderFrame.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
            for _, button in pairs(playerButtons) do
                if button then
                    button.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
                end
            end
        end
    end)
    if success then
        print("Тема применена: " .. (isDarkTheme and "Тёмная" or "Светлая"))
    else
        warn("Ошибка применения темы: " .. tostring(result))
    end
end

ThemeButton.MouseButton1Click:Connect(function()
    isDarkTheme = not isDarkTheme
    applyTheme()
    showNotification(isDarkTheme and "Тёмная тема включена" or "Светлая тема включена", Color3.fromRGB(0, 255, 0))
end)
applyTheme()

-- Анимация появления и закрытия
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function animateMenuAppearance()
    local success, result = pcall(function()
        MenuFrame.Size = UDim2.new(0, 0, 0, 0)
        local tween = TweenService:Create(MenuFrame, tweenInfo, {
            BackgroundTransparency = 0,
            Size = UDim2.new(0, 400, 0, 300)
        })
        tween:Play()
        HeaderFrame.Position = UDim2.new(0, 0, 0, -30)
        local headerTween = TweenService:Create(HeaderFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(0, 0, 0, 0)})
        headerTween:Play()
    end)
    if success then
        print("Анимация меню выполнена")
    else
        warn("Ошибка анимации меню: " .. tostring(result))
    end
end
animateMenuAppearance()

local function animateTeleportPanelAppearance()
    local success, result = pcall(function()
        TeleportPanel.Size = UDim2.new(0, 0, 0, 0)
        TeleportPanel.BackgroundTransparency = 1
        TeleportPanel.Visible = true
        local tween = TweenService:Create(TeleportPanel, tweenInfo, {
            BackgroundTransparency = 0,
            Size = UDim2.new(0, 200, 0, 300)
        })
        tween:Play()
    end)
    if success then
        print("Анимация появления TeleportPanel выполнена")
    else
        warn("Ошибка анимации TeleportPanel: " .. tostring(result))
    end
end

local function animateTeleportPanelDisappearance(callback)
    local success, result = pcall(function()
        local tween = TweenService:Create(TeleportPanel, tweenInfo, {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 0, 0)
        })
        tween:Play()
        tween.Completed:Connect(function()
            TeleportPanel.Visible = false
            if callback then callback() end
        end)
    end)
    if success then
        print("Анимация закрытия TeleportPanel выполнена")
    else
        warn("Ошибка анимации закрытия TeleportPanel: " .. tostring(result))
    end
end

local function animateSpeedSettingsPanelAppearance()
    local success, result = pcall(function()
        SpeedSettingsPanel.Size = UDim2.new(0, 0, 0, 0)
        SpeedSettingsPanel.BackgroundTransparency = 1
        SpeedSettingsPanel.Visible = true
        local tween = TweenService:Create(SpeedSettingsPanel, tweenInfo, {
            BackgroundTransparency = 0,
            Size = UDim2.new(0, 200, 0, 300)
        })
        tween:Play()
    end)
    if success then
        print("Анимация появления SpeedSettingsPanel выполнена")
    else
        warn("Ошибка анимации SpeedSettingsPanel: " .. tostring(result))
    end
end

local function animateSpeedSettingsPanelDisappearance(callback)
    local success, result = pcall(function()
        local tween = TweenService:Create(SpeedSettingsPanel, tweenInfo, {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 0, 0)
        })
        tween:Play()
        tween.Completed:Connect(function()
            SpeedSettingsPanel.Visible = false
            if callback then callback() end
        end)
    end)
    if success then
        print("Анимация закрытия SpeedSettingsPanel выполнена")
    else
        warn("Ошибка анимации закрытия SpeedSettingsPanel: " .. tostring(result))
    end
end

local function animateMenuSettingsPanelAppearance()
    local success, result = pcall(function()
        MenuSettingsPanel.Size = UDim2.new(0, 0, 0, 0)
        MenuSettingsPanel.BackgroundTransparency = 1
        MenuSettingsPanel.Visible = true
        local tween = TweenService:Create(MenuSettingsPanel, tweenInfo, {
            BackgroundTransparency = 0,
            Size = UDim2.new(0, 400, 0, 300)
        })
        tween:Play()
        -- Анимация шторки
        MenuSettingsHeaderFrame.Position = UDim2.new(0, 0, 0, -30)
        local headerTween = TweenService:Create(MenuSettingsHeaderFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(0, 0, 0, 0)})
        headerTween:Play()
    end)
    if success then
        print("Анимация появления MenuSettingsPanel выполнена")
    else
        warn("Ошибка анимации MenuSettingsPanel: " .. tostring(result))
    end
end

local function animateMenuSettingsPanelDisappearance(callback)
    local success, result = pcall(function()
        local tween = TweenService:Create(MenuSettingsPanel, tweenInfo, {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 0, 0)
        })
        tween:Play()
        tween.Completed:Connect(function()
            MenuSettingsPanel.Visible = false
            if callback then callback() end
        end)
    end)
    if success then
        print("Анимация закрытия MenuSettingsPanel выполнена")
    else
        warn("Ошибка анимации закрытия MenuSettingsPanel: " .. tostring(result))
    end
end

-- Перетаскивание основного меню и панелей
local dragging = false
local startPos = nil
local startMousePos = nil
local draggedFrame = nil

local function isTouchingButton(touchPos, frame)
    local buttons = (frame == MenuFrame) and
        {CloseButton, MinimizeButton, ThemeButton, MenuSettingsButton, ActivateButton, WallHackButton, SpeedHackButton, SpeedSettingsButton, NoclipButton, TeleportButton, InfiniteJumpButton} or
        (frame == TeleportPanel) and {TeleportCloseButton} or
        (frame == SpeedSettingsPanel) and {SpeedSettingsCloseButton, SpeedSettingsInput, AutoSpeedMaintainButton} or
        (frame == MenuSettingsPanel) and {MenuSettingsCloseButton} or
        {}
    for _, button in ipairs(buttons) do
        if not button then continue end
        local buttonPos = button.AbsolutePosition
        local buttonSize = button.AbsoluteSize
        if touchPos.X >= buttonPos.X and touchPos.X <= buttonPos.X + buttonSize.X and
           touchPos.Y >= buttonPos.Y and touchPos.Y <= buttonPos.Y + buttonSize.Y then
            return true
        end
    end
    return false
end

local function isMouseOverFrame(mousePos, frame)
    if not frame or not frame.Visible then return false end
    local framePos = frame.AbsolutePosition
    local frameSize = frame.AbsoluteSize
    return mousePos.X >= framePos.X and mousePos.X <= framePos.X + frameSize.X and
           mousePos.Y >= framePos.Y and mousePos.Y <= framePos.Y + frameSize.Y
end

local function clampPosition(position, frameSize)
    local screenSize = ScreenGui.AbsoluteSize
    local minX, maxX = 0, screenSize.X - frameSize.X
    local minY, maxY = 0, screenSize.Y - frameSize.Y
    return UDim2.new(0, math.clamp(position.X.Offset, minX, maxX), 0, math.clamp(position.Y.Offset, minY, maxY))
end

local function startDragging(input)
    if not dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) then
        local mousePos = input.Position
        local frame = nil
        if isMouseOverFrame(mousePos, MenuSettingsPanel) and not isTouchingButton(mousePos, MenuSettingsPanel) then
            frame = MenuSettingsPanel
        elseif isMouseOverFrame(mousePos, SpeedSettingsPanel) and not isTouchingButton(mousePos, SpeedSettingsPanel) then
            frame = SpeedSettingsPanel
        elseif isMouseOverFrame(mousePos, TeleportPanel) and not isTouchingButton(mousePos, TeleportPanel) then
            frame = TeleportPanel
        elseif isMouseOverFrame(mousePos, HeaderFrame) and not isTouchingButton(mousePos, MenuFrame) then
            frame = MenuFrame
        elseif isMouseOverFrame(mousePos, MenuFrame) and not isTouchingButton(mousePos, MenuFrame) then
            frame = MenuFrame
        elseif isMouseOverFrame(mousePos, MenuFrame) and ExpandButton.Visible then
            frame = MenuFrame
        end
        if frame then
            dragging = true
            draggedFrame = frame
            startPos = frame.Position
            startMousePos = input.Position
            frame.BackgroundTransparency = 0.2
            print("Начато перетаскивание: " .. frame.Name)
        end
    end
end

local lastUpdate = 0
local function updateDragging(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local now = tick()
        if now - lastUpdate < 0.016 then return end
        lastUpdate = now
        local delta = input.Position - startMousePos
        local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        draggedFrame.Position = clampPosition(newPos, draggedFrame.AbsoluteSize)
    end
end

local function endDragging(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        if dragging then
            dragging = false
            if draggedFrame then
                draggedFrame.BackgroundTransparency = 0
                if draggedFrame == MenuFrame then
                    savePosition()
                end
                print("Перетаскивание завершено: " .. draggedFrame.Name)
                draggedFrame = nil
            end
        end
    end
end

HeaderFrame.InputBegan:Connect(startDragging)
HeaderFrame.InputChanged:Connect(updateDragging)
HeaderFrame.InputEnded:Connect(endDragging)
MenuFrame.InputBegan:Connect(startDragging)
MenuFrame.InputChanged:Connect(updateDragging)
MenuFrame.InputEnded:Connect(endDragging)
ExpandButton.InputBegan:Connect(startDragging)
ExpandButton.InputChanged:Connect(updateDragging)
ExpandButton.InputEnded:Connect(endDragging)
TeleportPanel.InputBegan:Connect(startDragging)
TeleportPanel.InputChanged:Connect(updateDragging)
TeleportPanel.InputEnded:Connect(endDragging)
SpeedSettingsPanel.InputBegan:Connect(startDragging)
SpeedSettingsPanel.InputChanged:Connect(updateDragging)
SpeedSettingsPanel.InputEnded:Connect(endDragging)
MenuSettingsPanel.InputBegan:Connect(startDragging)
MenuSettingsPanel.InputChanged:Connect(updateDragging)
MenuSettingsPanel.InputEnded:Connect(endDragging)
MenuSettingsHeaderFrame.InputBegan:Connect(startDragging) -- Добавляем перетаскивание через шторку
MenuSettingsHeaderFrame.InputChanged:Connect(updateDragging)
MenuSettingsHeaderFrame.InputEnded:Connect(endDragging)

-- Сохранение и загрузка позиции меню
local function savePosition()
    local success, result = pcall(function()
        local pos = MenuFrame.Position
        local posValue = ReplicatedStorage:FindFirstChild("MenuPosition") or Instance.new("Vector3Value")
        posValue.Name = "MenuPosition"
        posValue.Parent = ReplicatedStorage
        posValue.Value = Vector3.new(pos.X.Offset, pos.Y.Offset, 0)
    end)
    if success then
        print("Позиция сохранена")
    else
        warn("Ошибка сохранения позиции: " .. tostring(result))
    end
end

local function loadPosition()
    local success, result = pcall(function()
        local posValue = ReplicatedStorage:FindFirstChild("MenuPosition")
        if posValue then
            MenuFrame.Position = UDim2.new(0, posValue.Value.X, 0, posValue.Value.Y)
        end
    end)
    if success then
        print("Позиция загружена")
    else
        warn("Ошибка загрузки позиции: " .. tostring(result))
    end
end
loadPosition()

-- Горячие клавиши
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.H then
        MenuFrame.Visible = not MenuFrame.Visible
        print("Меню " .. (MenuFrame.Visible and "показано" or "скрыто"))
    end
end)

-- Очистка событий
local connections = {}
local function cleanup()
    local success, result = pcall(function()
        for _, connection in ipairs(connections) do
            connection:Disconnect()
        end
        if ScreenGui then
            ScreenGui:Destroy()
        end
        if TeleportPanel then
            TeleportPanel:Destroy()
        end
        if SpeedSettingsPanel then
            SpeedSettingsPanel:Destroy()
        end
        if MenuSettingsPanel then
            MenuSettingsPanel:Destroy()
        end
    end)
    if success then
        print("Скрипт очищен")
    else
        warn("Ошибка очистки: " .. tostring(result))
    end
end

table.insert(connections, HeaderFrame.InputBegan:Connect(startDragging))
table.insert(connections, HeaderFrame.InputChanged:Connect(updateDragging))
table.insert(connections, HeaderFrame.InputEnded:Connect(endDragging))
table.insert(connections, MenuFrame.InputBegan:Connect(startDragging))
table.insert(connections, MenuFrame.InputChanged:Connect(updateDragging))
table.insert(connections, MenuFrame.InputEnded:Connect(endDragging))
table.insert(connections, ExpandButton.InputBegan:Connect(startDragging))
table.insert(connections, ExpandButton.InputChanged:Connect(updateDragging))
table.insert(connections, ExpandButton.InputEnded:Connect(endDragging))
table.insert(connections, TeleportPanel.InputBegan:Connect(startDragging))
table.insert(connections, TeleportPanel.InputChanged:Connect(updateDragging))
table.insert(connections, TeleportPanel.InputEnded:Connect(endDragging))
table.insert(connections, SpeedSettingsPanel.InputBegan:Connect(startDragging))
table.insert(connections, SpeedSettingsPanel.InputChanged:Connect(updateDragging))
table.insert(connections, SpeedSettingsPanel.InputEnded:Connect(endDragging))
table.insert(connections, MenuSettingsPanel.InputBegan:Connect(startDragging))
table.insert(connections, MenuSettingsPanel.InputChanged:Connect(updateDragging))
table.insert(connections, MenuSettingsPanel.InputEnded:Connect(endDragging))
table.insert(connections, MenuSettingsHeaderFrame.InputBegan:Connect(startDragging))
table.insert(connections, MenuSettingsHeaderFrame.InputChanged:Connect(updateDragging))
table.insert(connections, MenuSettingsHeaderFrame.InputEnded:Connect(endDragging))
table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.H then
        MenuFrame.Visible = not MenuFrame.Visible
    end
end))

-- Обработчик кнопки "Закрыть"
CloseButton.MouseButton1Click:Connect(function()
    print("Меню закрыто")
    cleanup()
end)

-- Обработчик кнопки "Свернуть"
MinimizeButton.MouseButton1Click:Connect(function()
    local success, result = pcall(function()
        print("Меню сворачивается")
        MinimizedContentLabel.Visible = true
        if ActivateButton then ActivateButton.Visible = false end
        if WallHackButton then WallHackButton.Visible = false end
        if SpeedHackButton then SpeedHackButton.Visible = false end
        if SpeedSettingsButton then SpeedSettingsButton.Visible = false end
        if NoclipButton then NoclipButton.Visible = false end
        if TeleportButton then TeleportButton.Visible = false end
        if InfiniteJumpButton then InfiniteJumpButton.Visible = false end
        if HeaderFrame then HeaderFrame.Visible = false end
        if ExpandButton then ExpandButton.Visible = true end
        local tween = TweenService:Create(MenuFrame, tweenInfo, {Size = UDim2.new(0, 50, 0, 50), BackgroundTransparency = 0.3})
        tween:Play()
    end)
    if not success then
        warn("Ошибка сворачивания: " .. tostring(result))
    end
end)

-- Обработчик разворачивания
ExpandButton.MouseButton1Click:Connect(function()
    local success, result = pcall(function()
        print("Меню разворачивается")
        MinimizedContentLabel.Visible = false
        if ActivateButton then ActivateButton.Visible = true end
        if WallHackButton then WallHackButton.Visible = true end
        if SpeedHackButton then SpeedHackButton.Visible = true end
        if SpeedSettingsButton then SpeedSettingsButton.Visible = true end
        if NoclipButton then NoclipButton.Visible = true end
        if TeleportButton then TeleportButton.Visible = true end
        if InfiniteJumpButton then InfiniteJumpButton.Visible = true end
        if HeaderFrame then HeaderFrame.Visible = true end
        if ExpandButton then ExpandButton.Visible = false end
        local tween = TweenService:Create(MenuFrame, tweenInfo, {Size = UDim2.new(0, 400, 0, 300), BackgroundTransparency = 0})
        tween:Play()
    end)
    if not success then
        warn("Ошибка разворачивания: " .. tostring(result))
    end
end)

-- Обработчик кнопки настроек меню
MenuSettingsButton.MouseButton1Click:Connect(function()
    MenuFrame.Visible = false
    animateMenuSettingsPanelAppearance()
    showNotification("Открыты настройки меню", Color3.fromRGB(0, 255, 0))
end)

-- Обработчик кнопки закрытия настроек меню
MenuSettingsCloseButton.MouseButton1Click:Connect(function()
    animateMenuSettingsPanelDisappearance(function()
        MenuFrame.Visible = true
        showNotification("Настройки меню закрыты", Color3.fromRGB(255, 0, 0))
    end)
end)

-- Активация Fly
local FLY_SCRIPT_URL = "https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"
local isFlyEnabled = false
local flyInstance = nil

local function toggleFly()
    local success, result = pcall(function()
        isFlyEnabled = not isFlyEnabled
        if isFlyEnabled then
            flyInstance = loadstring(game:HttpGet(FLY_SCRIPT_URL))()
            showNotification("Fly активирован!", Color3.fromRGB(0, 255, 0))
        else
            if flyInstance then
                flyInstance = nil
            end
            showNotification("Fly деактивирован!", Color3.fromRGB(255, 0, 0))
        end
    end)
    if success then
        print("Fly " .. (isFlyEnabled and "включён" or "выключен"))
    else
        showNotification("Ошибка Fly: " .. tostring(result), Color3.fromRGB(255, 0, 0))
        isFlyEnabled = false
        warn("Ошибка Fly: " .. tostring(result))
    end
end

ActivateButton.MouseButton1Click:Connect(function()
    print("Активируется FlyGuiV3")
    toggleFly()
end)

-- Логика SpeedHack
local isSpeedHackEnabled = false
local defaultSpeed = 16
local isAutoSpeedMaintainEnabled = false
local speedMaintainConnection = nil

local function setSpeed(speed, showNotify)
    local success, result = pcall(function()
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speed
            if showNotify then
                showNotification("Скорость установлена: " .. speed, Color3.fromRGB(0, 255, 0))
            end
        else
            if showNotify then
                showNotification("Персонаж не найден!", Color3.fromRGB(255, 0, 0))
            end
        end
    end)
    if not success then
        warn("Ошибка SpeedHack: " .. tostring(result))
    end
end

local function maintainSpeed()
    if not isAutoSpeedMaintainEnabled or not isSpeedHackEnabled then return end
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local targetSpeed = tonumber(SpeedSettingsInput.Text) or defaultSpeed
        if humanoid.WalkSpeed ~= targetSpeed then
            humanoid.WalkSpeed = targetSpeed
        end
    end
end

local function toggleSpeedHack()
    local success, result = pcall(function()
        isSpeedHackEnabled = not isSpeedHackEnabled
        if isSpeedHackEnabled then
            local speed = tonumber(SpeedSettingsInput.Text) or defaultSpeed
            if speed < 16 or speed > 2500 then
                speed = defaultSpeed
                SpeedSettingsInput.Text = tostring(defaultSpeed)
            end
            setSpeed(speed, true)
            SpeedHackButton.Text = "Disable SpeedHack"
            SpeedHackButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
            if isAutoSpeedMaintainEnabled then
                if speedMaintainConnection then
                    speedMaintainConnection:Disconnect()
                end
                speedMaintainConnection = RunService.Heartbeat:Connect(maintainSpeed)
            end
        else
            setSpeed(defaultSpeed, true)
            SpeedHackButton.Text = "Toggle SpeedHack"
            SpeedHackButton.BackgroundColor3 = isDarkTheme and Color3.fromRGB(0, 128, 255) or Color3.fromRGB(100, 180, 255)
            if speedMaintainConnection then
                speedMaintainConnection:Disconnect()
                speedMaintainConnection = nil
            end
        end
    end)
    if success then
        print("SpeedHack " .. (isSpeedHackEnabled and "включён" or "выключен"))
    else
        warn("Ошибка SpeedHack: " .. tostring(result))
    end
end

SpeedHackButton.MouseButton1Click:Connect(toggleSpeedHack)

SpeedSettingsInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local success, result = pcall(function()
            local speed = tonumber(SpeedSettingsInput.Text)
            if speed and speed >= 0 then
                if isSpeedHackEnabled then
                    setSpeed(speed, true)
                end
                local speedValue = ReplicatedStorage:FindFirstChild("SpeedHackValue") or Instance.new("NumberValue")
                speedValue.Name = "SpeedHackValue"
                speedValue.Parent = ReplicatedStorage
                speedValue.Value = speed
            else
                showNotification("Введите число больше или равно 0!", Color3.fromRGB(255, 0, 0))
                SpeedSettingsInput.Text = tostring(defaultSpeed)
            end
        end)
        if not success then
            warn("Ошибка ввода скорости: " .. tostring(result))
        end
    end
end)

AutoSpeedMaintainButton.MouseButton1Click:Connect(function()
    local success, result = pcall(function()
        isAutoSpeedMaintainEnabled = not isAutoSpeedMaintainEnabled
        AutoSpeedMaintainButton.Text = "Auto Maintain Speed: " .. (isAutoSpeedMaintainEnabled and "ON" or "OFF")
        AutoSpeedMaintainButton.BackgroundColor3 = isAutoSpeedMaintainEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)
        if isAutoSpeedMaintainEnabled and isSpeedHackEnabled then
            if speedMaintainConnection then
                speedMaintainConnection:Disconnect()
            end
            speedMaintainConnection = RunService.Heartbeat:Connect(maintainSpeed)
        else
            if speedMaintainConnection then
                speedMaintainConnection:Disconnect()
                speedMaintainConnection = nil
            end
        end
        showNotification("Авто-поддержание скорости: " .. (isAutoSpeedMaintainEnabled and "ON" or "OFF"), isAutoSpeedMaintainEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
    end)
    if not success then
        warn("Ошибка авто-поддержания скорости: " .. tostring(result))
        showNotification("Ошибка авто-поддержания скорости: " .. tostring(result), Color3.fromRGB(255, 0, 0))
    end
end)

SpeedSettingsButton.MouseButton1Click:Connect(function()
    animateSpeedSettingsPanelAppearance()
    showNotification("Открыты настройки SpeedHack", Color3.fromRGB(0, 255, 0))
end)

SpeedSettingsCloseButton.MouseButton1Click:Connect(function()
    animateSpeedSettingsPanelDisappearance(function()
        showNotification("Настройки SpeedHack закрыты", Color3.fromRGB(255, 0, 0))
    end)
end)

local function loadSpeed()
    local success, result = pcall(function()
        local speedValue = ReplicatedStorage:FindFirstChild("SpeedHackValue")
        if speedValue then
            SpeedSettingsInput.Text = tostring(speedValue.Value)
        end
    end)
    if success then
        print("Скорость загружена")
    else
        warn("Ошибка загрузки скорости: " .. tostring(result))
    end
end
loadSpeed()

-- Логика Infinite Jump
local isInfiniteJumpEnabled = false
local infiniteJumpConnection = nil

local function toggleInfiniteJump()
    local success, result = pcall(function()
        isInfiniteJumpEnabled = not isInfiniteJumpEnabled
        if isInfiniteJumpEnabled then
            if infiniteJumpConnection then
                infiniteJumpConnection:Disconnect()
            end
            infiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
                local character = LocalPlayer.Character
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
            InfiniteJumpButton.Text = "Disable Infinite Jump"
            InfiniteJumpButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
            showNotification("Infinite Jump включён!", Color3.fromRGB(0, 255, 0))
        else
            if infiniteJumpConnection then
                infiniteJumpConnection:Disconnect()
                infiniteJumpConnection = nil
            end
            InfiniteJumpButton.Text = "Toggle Infinite Jump"
            InfiniteJumpButton.BackgroundColor3 = isDarkTheme and Color3.fromRGB(0, 200, 200) or Color3.fromRGB(100, 255, 255)
            showNotification("Infinite Jump выключен!", Color3.fromRGB(255, 0, 0))
        end
    end)
    if success then
        print("Infinite Jump " .. (isInfiniteJumpEnabled and "включён" or "выключен"))
    else
        warn("Ошибка Infinite Jump: " .. tostring(result))
        showNotification("Ошибка Infinite Jump: " .. tostring(result), Color3.fromRGB(255, 0, 0))
    end
end

InfiniteJumpButton.MouseButton1Click:Connect(toggleInfiniteJump)

-- WallHack
local isWallHackEnabled = false
local highlights = {}

local function applyHighlight(player)
    local success, result = pcall(function()
        if player == LocalPlayer then return end
        if highlights[player] then
            highlights[player]:Destroy()
            highlights[player] = nil
        end
        local character = player.Character
        if not character then return end
        local highlight = Instance.new("Highlight")
        highlight.Parent = character
        highlight.Adornee = character
        highlight.FillColor = Color3.fromRGB(128, 0, 128)
        highlight.OutlineColor = Color3.fromRGB(128, 0, 128)
        highlight.FillTransparency = 0.9
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlights[player] = highlight
        print("Highlight применён для " .. player.Name)
    end)
    if not success then
        warn("Ошибка WallHack: " .. tostring(result))
    end
end

local function removeHighlight(player)
    local success, result = pcall(function()
        if highlights[player] then
            highlights[player]:Destroy()
            highlights[player] = nil
            print("Highlight удалён для " .. player.Name)
        end
    end)
    if not success then
        warn("Ошибка удаления Highlight: " .. tostring(result))
    end
end

local function toggleWallHack()
    local success, result = pcall(function()
        isWallHackEnabled = not isWallHackEnabled
        if isWallHackEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                applyHighlight(player)
            end
            WallHackButton.Text = "Disable WallHack"
            WallHackButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
            showNotification("WallHack включён!", Color3.fromRGB(0, 255, 0))
        else
            for player, _ in pairs(highlights) do
                removeHighlight(player)
            end
            WallHackButton.Text = "Toggle WallHack"
            WallHackButton.BackgroundColor3 = isDarkTheme and Color3.fromRGB(128, 0, 128) or Color3.fromRGB(180, 100, 180)
            showNotification("WallHack выключен!", Color3.fromRGB(255, 0, 0))
        end
    end)
    if success then
        print("WallHack " .. (isWallHackEnabled and "включён" or "выключен"))
    else
        warn("Ошибка WallHack: " .. tostring(result))
    end
end

WallHackButton.MouseButton1Click:Connect(toggleWallHack)

-- Логика Noclip
local isNoclipEnabled = false
local noclipConnection = nil

local function setNoclip(enabled)
    local success, result = pcall(function()
        local character = LocalPlayer.Character
        if not character then
            showNotification("Персонаж не найден!", Color3.fromRGB(255, 0, 0))
            return
        end
        if enabled then
            if noclipConnection then
                noclipConnection:Disconnect()
            end
            noclipConnection = RunService.Stepped:Connect(function()
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
            showNotification("Noclip включён!", Color3.fromRGB(0, 255, 0))
        else
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            showNotification("Noclip выключен!", Color3.fromRGB(255, 0, 0))
        end
    end)
    if success then
        print("Noclip " .. (enabled and "включён" or "выключен"))
    else
        warn("Ошибка Noclip: " .. tostring(result))
        showNotification("Ошибка Noclip: " .. tostring(result), Color3.fromRGB(255, 0, 0))
    end
end

local function toggleNoclip()
    local success, result = pcall(function()
        isNoclipEnabled = not isNoclipEnabled
        setNoclip(isNoclipEnabled)
        NoclipButton.Text = isNoclipEnabled and "Disable Noclip" or "Toggle Noclip"
        NoclipButton.BackgroundColor3 = isNoclipEnabled and Color3.fromRGB(255, 100, 100) or
            (isDarkTheme and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(255, 200, 100))
    end)
    if not success then
        warn("Ошибка toggleNoclip: " .. tostring(result))
        showNotification("Ошибка toggleNoclip: " .. tostring(result), Color3.fromRGB(255, 0, 0))
    end
end

NoclipButton.MouseButton1Click:Connect(toggleNoclip)

-- Обновление SpeedHack и Noclip при появлении персонажа
table.insert(connections, LocalPlayer.CharacterAdded:Connect(function(character)
    if isSpeedHackEnabled then
        task.wait(0.5)
        local speed = tonumber(SpeedSettingsInput.Text) or defaultSpeed
        setSpeed(speed, false)
        if isAutoSpeedMaintainEnabled then
            if speedMaintainConnection then
                speedMaintainConnection:Disconnect()
            end
            speedMaintainConnection = RunService.Heartbeat:Connect(maintainSpeed)
        end
    end
    if isNoclipEnabled then
        task.wait(0.5)
        setNoclip(true)
    end
end))

-- Обработка новых игроков и респавна для WallHack
for _, player in ipairs(Players:GetPlayers()) do
    if isWallHackEnabled and player.Character then
        applyHighlight(player)
    end
    table.insert(connections, player.CharacterAdded:Connect(function(character)
        if isWallHackEnabled then
            task.wait(0.5)
            applyHighlight(player)
        end
    end))
end

table.insert(connections, Players.PlayerAdded:Connect(function(player)
    table.insert(connections, player.CharacterAdded:Connect(function(character)
        if isWallHackEnabled then
            task.wait(0.5)
            applyHighlight(player)
        end
    end))
end))

table.insert(connections, Players.PlayerRemoving:Connect(function(player)
    removeHighlight(player)
end))

-- Логика телепортации к игроку
local function updatePlayerList()
    for _, button in pairs(playerButtons) do
        if button then
            button:Destroy()
        end
    end
    playerButtons = {}
    PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)

    local players = Players:GetPlayers()
    for i, player in ipairs(players) do
        if player ~= LocalPlayer then
            local button = Instance.new("TextButton")
            button.Parent = PlayerList
            button.Size = UDim2.new(1, -10, 0, 30)
            button.BackgroundColor3 = isDarkTheme and Color3.fromRGB(100, 100, 100) or Color3.fromRGB(150, 150, 150)
            button.Text = player.Name
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.Font = Enum.Font.Gotham
            button.TextSize = 14
            button.ZIndex = 6
            button.AutoButtonColor = false

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 5)
            corner.Parent = button

            setupButtonFeedback(button)

            button.MouseButton1Click:Connect(function()
                local success, result = pcall(function()
                    if player.Character and player.Character.HumanoidRootPart and LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
                        showNotification("Телепортирован к " .. player.Name, Color3.fromRGB(0, 255, 0))
                    else
                        showNotification("Игрок или персонаж недоступен!", Color3.fromRGB(255, 0, 0))
                    end
                end)
                if not success then
                    warn("Ошибка телепортации: " .. tostring(result))
                    showNotification("Ошибка телепортации!", Color3.fromRGB(255, 0, 0))
                end
            end)

            table.insert(playerButtons, button)
        end
    end

    PlayerList.CanvasSize = UDim2.new(0, 0, 0, (#players - 1) * 35 + 30)
end

table.insert(connections, Players.PlayerAdded:Connect(updatePlayerList))
table.insert(connections, Players.PlayerRemoving:Connect(updatePlayerList))

TeleportButton.MouseButton1Click:Connect(function()
    animateTeleportPanelAppearance()
    updatePlayerList()
    showNotification("Открыт список игроков", Color3.fromRGB(0, 255, 0))
end)

TeleportCloseButton.MouseButton1Click:Connect(function()
    animateTeleportPanelDisappearance(function()
        updatePlayerList()
        showNotification("Список игроков закрыт", Color3.fromRGB(255, 0, 0))
    end)
end)

-- Очистка Noclip при закрытии
local function cleanupNoclip()
    local success, result = pcall(function()
        if isNoclipEnabled then
            setNoclip(false)
        end
    end)
    if not success then
        warn("Ошибка очистки Noclip: " .. tostring(result))
    end
end

-- Очистка Infinite Jump при закрытии
local function cleanupInfiniteJump()
    local success, result = pcall(function()
        if isInfiniteJumpEnabled then
            if infiniteJumpConnection then
                infiniteJumpConnection:Disconnect()
                infiniteJumpConnection = nil
            end
        end
    end)
    if not success then
        warn("Ошибка очистки Infinite Jump: " .. tostring(result))
    end
end

-- Очистка SpeedHack
local function cleanupSpeedHack()
    local success, result = pcall(function()
        if isSpeedHackEnabled then
            setSpeed(defaultSpeed, false)
        end
        if speedMaintainConnection then
            speedMaintainConnection:Disconnect()
            speedMaintainConnection = nil
        end
    end)
    if not success then
        warn("Ошибка очистки SpeedHack: " .. tostring(result))
    end
end

-- Обновлённая функция очистки
local function cleanup()
    cleanupNoclip()
    cleanupInfiniteJump()
    cleanupSpeedHack()
    for _, connection in ipairs(connections) do
        connection:Disconnect()
    end
    if ScreenGui then
        ScreenGui:Destroy()
    end
    if TeleportPanel then
        TeleportPanel:Destroy()
    end
    if SpeedSettingsPanel then
        SpeedSettingsPanel:Destroy()
    end
    if MenuSettingsPanel then
        MenuSettingsPanel:Destroy()
    end
    print("Скрипт полностью очищен")
end

game:BindToClose(cleanup)
