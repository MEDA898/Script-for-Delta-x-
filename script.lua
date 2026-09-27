--========================================================--
--                    MEDA HUB v3                        --
--       Modern UI / Русская настройка / Drag Opacity    --
--========================================================--

--// Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

--// Player
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--========================================================--
-- CONFIG
--========================================================--

local MENU_WIDTH = 440
local MENU_HEIGHT = 340

local PANEL_WIDTH = 300
local PANEL_HEIGHT = 340

local DEFAULT_SPEED = 16
local MIN_SPEED = 0
local MAX_SPEED = math.huge

local isDarkTheme = true
local allowOutOfBounds = false

--========================================================--
-- DRAG TRANSPARENCY
--========================================================--

local dragTransparency = 0.45

local MIN_DRAG_TRANSPARENCY = 0
local MAX_DRAG_TRANSPARENCY = 0.85

local isDraggingMenu = false
local dragTransparencyObjects = {}

--========================================================--
-- COLORS
--========================================================--

local Dark = {
    Background = Color3.fromRGB(12, 14, 20),
    Header = Color3.fromRGB(17, 19, 27),
    Surface = Color3.fromRGB(21, 24, 33),
    Surface2 = Color3.fromRGB(28, 32, 43),
    SurfaceHover = Color3.fromRGB(36, 40, 53),

    Text = Color3.fromRGB(245, 246, 250),
    SubText = Color3.fromRGB(145, 151, 166),

    Stroke = Color3.fromRGB(52, 58, 75),

    Accent = Color3.fromRGB(105, 88, 255),
    Accent2 = Color3.fromRGB(151, 105, 255),

    Green = Color3.fromRGB(45, 210, 125),
    Red = Color3.fromRGB(235, 70, 85),
    Orange = Color3.fromRGB(245, 180, 70),

    Input = Color3.fromRGB(18, 21, 29)
}

local Light = {
    Background = Color3.fromRGB(238, 240, 245),
    Header = Color3.fromRGB(248, 249, 252),
    Surface = Color3.fromRGB(250, 251, 253),
    Surface2 = Color3.fromRGB(227, 230, 237),
    SurfaceHover = Color3.fromRGB(216, 219, 228),

    Text = Color3.fromRGB(28, 30, 38),
    SubText = Color3.fromRGB(105, 110, 122),

    Stroke = Color3.fromRGB(204, 208, 218),

    Accent = Color3.fromRGB(91, 75, 220),
    Accent2 = Color3.fromRGB(124, 96, 235),

    Green = Color3.fromRGB(40, 175, 105),
    Red = Color3.fromRGB(220, 60, 75),
    Orange = Color3.fromRGB(220, 150, 55),

    Input = Color3.fromRGB(242, 243, 247)
}

local function C()
    return isDarkTheme and Dark or Light
end

--========================================================--
-- GUI
--========================================================--

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MedaHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

--========================================================--
-- UTILITY
--========================================================--

local function addCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = parent
    return c
end

local function addStroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or C().Stroke
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = parent
    return s
end

local function addGradient(parent, color1, color2, rotation)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(1, color2)
    })
    g.Rotation = rotation or 0
    g.Parent = parent
    return g
end

local function createLabel(parent, text, size, position, font, textSize)
    local label = Instance.new("TextLabel")
    label.Parent = parent
    label.BackgroundTransparency = 1
    label.Size = size
    label.Position = position
    label.Text = text
    label.TextColor3 = C().Text
    label.Font = font or Enum.Font.Gotham
    label.TextSize = textSize or 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    return label
end

local function tween(instance, info, properties)
    return TweenService:Create(instance, info, properties)
end

local FAST_TWEEN = TweenInfo.new(
    0.12,
    Enum.EasingStyle.Quart,
    Enum.EasingDirection.Out
)

local NORMAL_TWEEN = TweenInfo.new(
    0.22,
    Enum.EasingStyle.Quart,
    Enum.EasingDirection.Out
)

--========================================================--
-- NOTIFICATIONS
--========================================================--

local NotificationHolder = Instance.new("Frame")
NotificationHolder.Parent = ScreenGui
NotificationHolder.Size = UDim2.fromOffset(320, 400)
NotificationHolder.Position = UDim2.new(1, -335, 0, 20)
NotificationHolder.BackgroundTransparency = 1
NotificationHolder.ZIndex = 200

local NotificationLayout = Instance.new("UIListLayout")
NotificationLayout.Parent = NotificationHolder
NotificationLayout.Padding = UDim.new(0, 8)
NotificationLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
NotificationLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function showNotification(message, notificationColor)
    local holder = Instance.new("Frame")
    holder.Parent = NotificationHolder
    holder.Size = UDim2.fromOffset(300, 54)
    holder.BackgroundColor3 = C().Surface
    holder.BackgroundTransparency = 1
    holder.BorderSizePixel = 0
    holder.ZIndex = 201

    addCorner(holder, 12)
    addStroke(holder, C().Stroke, 1, 0.15)

    local accent = Instance.new("Frame")
    accent.Parent = holder
    accent.Size = UDim2.fromOffset(4, 34)
    accent.Position = UDim2.fromOffset(8, 10)
    accent.BackgroundColor3 = notificationColor or C().Accent
    accent.BorderSizePixel = 0
    accent.ZIndex = 202
    addCorner(accent, 3)

    local text = createLabel(
        holder,
        message,
        UDim2.new(1, -35, 1, 0),
        UDim2.fromOffset(22, 0),
        Enum.Font.GothamMedium,
        12
    )

    text.TextTransparency = 1
    text.ZIndex = 202

    tween(holder, NORMAL_TWEEN, {
        BackgroundTransparency = 0
    }):Play()

    tween(text, NORMAL_TWEEN, {
        TextTransparency = 0
    }):Play()

    task.delay(2.3, function()
        if holder and holder.Parent then
            local out = tween(holder, NORMAL_TWEEN, {
                BackgroundTransparency = 1,
                Size = UDim2.fromOffset(260, 0)
            })

            tween(text, NORMAL_TWEEN, {
                TextTransparency = 1
            }):Play()

            out:Play()

            out.Completed:Connect(function()
                if holder then
                    holder:Destroy()
                end
            end)
        end
    end)
end

--========================================================--
-- MAIN MENU
--========================================================--

local MenuFrame = Instance.new("Frame")
MenuFrame.Name = "MenuFrame"
MenuFrame.Parent = ScreenGui
MenuFrame.Size = UDim2.fromOffset(MENU_WIDTH, MENU_HEIGHT)
MenuFrame.Position = UDim2.new(
    0.5,
    -MENU_WIDTH / 2,
    0.5,
    -MENU_HEIGHT / 2
)
MenuFrame.BackgroundColor3 = C().Background
MenuFrame.BorderSizePixel = 0
MenuFrame.Active = true
MenuFrame.ClipsDescendants = true
MenuFrame.ZIndex = 10

addCorner(MenuFrame, 16)
addStroke(MenuFrame, C().Stroke, 1, 0.05)

--========================================================--
-- HEADER
--========================================================--

local HeaderFrame = Instance.new("Frame")
HeaderFrame.Name = "HeaderFrame"
HeaderFrame.Parent = MenuFrame
HeaderFrame.Size = UDim2.new(1, 0, 0, 68)
HeaderFrame.BackgroundColor3 = C().Header
HeaderFrame.BorderSizePixel = 0
HeaderFrame.ZIndex = 11
HeaderFrame.Active = true
addCorner(HeaderFrame, 16)

local HeaderBottom = Instance.new("Frame")
HeaderBottom.Parent = HeaderFrame
HeaderBottom.Size = UDim2.new(1, -30, 0, 2)
HeaderBottom.Position = UDim2.new(0, 15, 1, -2)
HeaderBottom.BackgroundColor3 = C().Accent
HeaderBottom.BorderSizePixel = 0
HeaderBottom.ZIndex = 13
addCorner(HeaderBottom, 2)
addGradient(HeaderBottom, C().Accent, C().Accent2, 0)

--========================================================--
-- LOGO
--========================================================--

local Logo = Instance.new("Frame")
Logo.Parent = HeaderFrame
Logo.Size = UDim2.fromOffset(40, 40)
Logo.Position = UDim2.fromOffset(14, 14)
Logo.BackgroundColor3 = C().Accent
Logo.BorderSizePixel = 0
Logo.ZIndex = 15
addCorner(Logo, 11)
addGradient(Logo, C().Accent, C().Accent2, 45)

local LogoText = createLabel(
    Logo,
    "M",
    UDim2.fromScale(1, 1),
    UDim2.fromScale(0, 0),
    Enum.Font.GothamBold,
    21
)
LogoText.TextColor3 = Color3.new(1, 1, 1)
LogoText.TextXAlignment = Enum.TextXAlignment.Center
LogoText.ZIndex = 16

--========================================================--
-- TITLE
--========================================================--

local HeaderLabel = createLabel(
    HeaderFrame,
    "MEDA HUB",
    UDim2.fromOffset(200, 24),
    UDim2.fromOffset(65, 9),
    Enum.Font.GothamBold,
    16
)
HeaderLabel.ZIndex = 15

local HeaderSub = createLabel(
    HeaderFrame,
    "Script v3  •  @meda898",
    UDim2.fromOffset(220, 20),
    UDim2.fromOffset(65, 33),
    Enum.Font.Gotham,
    11
)
HeaderSub.TextColor3 = C().SubText
HeaderSub.ZIndex = 15

--========================================================--
-- HEADER BUTTON
--========================================================--

local function makeHeaderButton(symbol, offset)
    local button = Instance.new("TextButton")
    button.Parent = HeaderFrame
    button.Size = UDim2.fromOffset(30, 30)
    button.Position = UDim2.new(1, offset, 0, 19)
    button.BackgroundColor3 = C().Surface2
    button.BorderSizePixel = 0
    button.Text = symbol
    button.TextColor3 = C().Text
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.AutoButtonColor = false
    button.ZIndex = 20
    addCorner(button, 8)
    addStroke(button, C().Stroke, 1, 0.25)
    return button
end

local MenuSettingsButton = makeHeaderButton("⚙", -157)
local ThemeButton = makeHeaderButton("☾", -120)
local MinimizeButton = makeHeaderButton("—", -83)
local CloseButton = makeHeaderButton("×", -46)

CloseButton.BackgroundColor3 = Color3.fromRGB(180, 55, 70)

--========================================================--
-- CONTENT
--========================================================--

local Content = Instance.new("ScrollingFrame")
Content.Parent = MenuFrame
Content.Size = UDim2.new(1, -30, 1, -84)
Content.Position = UDim2.fromOffset(15, 77)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ZIndex = 11
Content.ScrollingDirection = Enum.ScrollingDirection.Y
Content.ScrollBarThickness = 5
Content.ScrollBarImageColor3 = C().Accent
Content.ScrollBarImageTransparency = 0
Content.VerticalScrollBarInset = Enum.ScrollBarInset.Always
Content.CanvasSize = UDim2.fromOffset(0, 315)
Content.CanvasPosition = Vector2.new(0, 0)
Content.ElasticBehavior = Enum.ElasticBehavior.Never

local SectionTitle = createLabel(
    Content,
    "MOVEMENT",
    UDim2.new(1, 0, 0, 20),
    UDim2.fromOffset(2, 0),
    Enum.Font.GothamBold,
    10
)
SectionTitle.TextColor3 = C().SubText
SectionTitle.ZIndex = 12

--========================================================--
-- FEATURE BUTTON
--========================================================--

local featureData = {}

local function createFeatureButton(text, icon, x, y)
    local button = Instance.new("TextButton")
    button.Parent = Content
    button.Size = UDim2.fromOffset(198, 58)
    button.Position = UDim2.fromOffset(x, y)
    button.BackgroundColor3 = C().Surface
    button.BorderSizePixel = 0
    button.Text = ""
    button.AutoButtonColor = false
    button.ZIndex = 12

    addCorner(button, 11)
    addStroke(button, C().Stroke, 1, 0.2)

    local iconBox = Instance.new("Frame")
    iconBox.Parent = button
    iconBox.Size = UDim2.fromOffset(36, 36)
    iconBox.Position = UDim2.fromOffset(10, 11)
    iconBox.BackgroundColor3 = C().Surface2
    iconBox.BorderSizePixel = 0
    iconBox.ZIndex = 13
    addCorner(iconBox, 9)

    local iconLabel = createLabel(
        iconBox,
        icon,
        UDim2.fromScale(1, 1),
        UDim2.fromScale(0, 0),
        Enum.Font.GothamBold,
        16
    )
    iconLabel.TextXAlignment = Enum.TextXAlignment.Center
    iconLabel.TextColor3 = C().Accent
    iconLabel.ZIndex = 14

    local title = createLabel(
        button,
        text,
        UDim2.fromOffset(135, 21),
        UDim2.fromOffset(56, 8),
        Enum.Font.GothamBold,
        12
    )
    title.ZIndex = 14

    local status = createLabel(
        button,
        "●  OFF",
        UDim2.fromOffset(120, 18),
        UDim2.fromOffset(56, 31),
        Enum.Font.Gotham,
        10
    )
    status.TextColor3 = C().SubText
    status.ZIndex = 14

    featureData[button] = {
        Status = status,
        Icon = iconBox,
        Title = title
    }

    return button, status
end

--========================================================--
-- MAIN BUTTONS
--========================================================--

local ActivateButton, FlyStatus =
    createFeatureButton("Fly", "✈", 0, 29)

local WallHackButton, WallStatus =
    createFeatureButton("WallHack", "◈", 212, 29)

local SpeedHackButton, SpeedStatus =
    createFeatureButton("SpeedHack", "ϟ", 0, 96)

local NoclipButton, NoclipStatus =
    createFeatureButton("Noclip", "◇", 212, 96)

local InfiniteJumpButton, JumpStatus =
    createFeatureButton("Infinite Jump", "↑", 0, 163)

local TeleportButton, TeleportStatus =
    createFeatureButton("Teleport", "◎", 212, 163)

--========================================================--
-- CHECKPOINTS ENTRY
--========================================================--

local CheckpointButton = Instance.new("TextButton")
CheckpointButton.Parent = Content
CheckpointButton.Size = UDim2.fromOffset(198, 58)
CheckpointButton.Position = UDim2.fromOffset(212, 230)
CheckpointButton.BackgroundColor3 = C().Surface
CheckpointButton.BorderSizePixel = 0
CheckpointButton.Text = ""
CheckpointButton.AutoButtonColor = false
CheckpointButton.ZIndex = 12
addCorner(CheckpointButton, 11)
addStroke(CheckpointButton, C().Stroke, 1, 0.2)

local CheckpointIcon = Instance.new("Frame")
CheckpointIcon.Parent = CheckpointButton
CheckpointIcon.Size = UDim2.fromOffset(36, 36)
CheckpointIcon.Position = UDim2.fromOffset(10, 11)
CheckpointIcon.BackgroundColor3 = C().Surface2
CheckpointIcon.BorderSizePixel = 0
CheckpointIcon.ZIndex = 13
addCorner(CheckpointIcon, 9)
local CheckpointIconText = createLabel(CheckpointIcon,"⌖",UDim2.fromScale(1,1),UDim2.fromScale(0,0),Enum.Font.GothamBold,18)
CheckpointIconText.TextXAlignment = Enum.TextXAlignment.Center
CheckpointIconText.TextColor3 = C().Accent
CheckpointIconText.ZIndex = 14
local CheckpointTitle = createLabel(CheckpointButton,"Чекпоинты",UDim2.fromOffset(210,21),UDim2.fromOffset(56,8),Enum.Font.GothamBold,12)
CheckpointTitle.ZIndex = 14
local CheckpointStatus = createLabel(CheckpointButton,"Открыть маршрут",UDim2.fromOffset(220,18),UDim2.fromOffset(56,31),Enum.Font.Gotham,10)
CheckpointStatus.TextColor3 = C().SubText
CheckpointStatus.ZIndex = 14
local CheckpointSwitch = Instance.new("Frame")
CheckpointSwitch.Parent = CheckpointButton
CheckpointSwitch.Size = UDim2.fromOffset(46,24)
CheckpointSwitch.Position = UDim2.new(1,-58,0,17)
CheckpointSwitch.BackgroundColor3 = C().Surface2
CheckpointSwitch.BorderSizePixel = 0
CheckpointSwitch.ZIndex = 15
addCorner(CheckpointSwitch,12)
local CheckpointSwitchDot = Instance.new("Frame")
CheckpointSwitchDot.Parent = CheckpointSwitch
CheckpointSwitchDot.Size = UDim2.fromOffset(18,18)
CheckpointSwitchDot.Position = UDim2.fromOffset(3,3)
CheckpointSwitchDot.BackgroundColor3 = C().SubText
CheckpointSwitchDot.BorderSizePixel = 0
CheckpointSwitchDot.ZIndex = 16
addCorner(CheckpointSwitchDot,9)

FlyStatus.Text = "ЗАГРУЗИТЬ"
FlyStatus.TextColor3 = C().SubText

--========================================================--
-- SPEED SETTINGS BUTTON
--========================================================--

local SpeedSettingsButton = Instance.new("TextButton")
SpeedSettingsButton.Parent = Content
SpeedSettingsButton.Size = UDim2.fromOffset(24, 24)
SpeedSettingsButton.Position = UDim2.fromOffset(173, 113)
SpeedSettingsButton.BackgroundColor3 = C().Surface2
SpeedSettingsButton.BorderSizePixel = 0
SpeedSettingsButton.Text = "⚙"
SpeedSettingsButton.TextColor3 = C().SubText
SpeedSettingsButton.Font = Enum.Font.GothamBold
SpeedSettingsButton.TextSize = 11
SpeedSettingsButton.AutoButtonColor = false
SpeedSettingsButton.ZIndex = 20
addCorner(SpeedSettingsButton, 7)

--========================================================--
-- WALLHACK SETTINGS BUTTON
--========================================================--

local WallHackSettingsButton = Instance.new("TextButton")
WallHackSettingsButton.Parent = Content
WallHackSettingsButton.Size = UDim2.fromOffset(24, 24)
WallHackSettingsButton.Position = UDim2.fromOffset(385, 46)
WallHackSettingsButton.BackgroundColor3 = C().Surface2
WallHackSettingsButton.BorderSizePixel = 0
WallHackSettingsButton.Text = "⚙"
WallHackSettingsButton.TextColor3 = C().SubText
WallHackSettingsButton.Font = Enum.Font.GothamBold
WallHackSettingsButton.TextSize = 11
WallHackSettingsButton.AutoButtonColor = false
WallHackSettingsButton.ZIndex = 20
addCorner(WallHackSettingsButton, 7)

--========================================================--
-- MINIMIZED
--========================================================--

local MinimizedContentLabel = Instance.new("TextButton")
MinimizedContentLabel.Parent = MenuFrame
MinimizedContentLabel.Size = UDim2.fromScale(1, 1)
MinimizedContentLabel.BackgroundTransparency = 1
MinimizedContentLabel.Text = "M"
MinimizedContentLabel.TextColor3 = Color3.new(1, 1, 1)
MinimizedContentLabel.Font = Enum.Font.GothamBold
MinimizedContentLabel.TextSize = 22
MinimizedContentLabel.TextXAlignment = Enum.TextXAlignment.Center
MinimizedContentLabel.TextYAlignment = Enum.TextYAlignment.Center
MinimizedContentLabel.AutoButtonColor = false
MinimizedContentLabel.Visible = false
MinimizedContentLabel.Active = true
MinimizedContentLabel.ZIndex = 30

--========================================================--
-- PANEL CREATOR
--========================================================--

local panelHeaders = {}

local function createPanel(name, title)
    local panel = Instance.new("Frame")
    panel.Name = name
    panel.Parent = ScreenGui
    panel.Size = UDim2.fromOffset(PANEL_WIDTH, PANEL_HEIGHT)
    panel.Position = UDim2.new(
        0.5,
        -PANEL_WIDTH / 2,
        0.5,
        -PANEL_HEIGHT / 2
    )
    panel.BackgroundColor3 = C().Background
    panel.BorderSizePixel = 0
    panel.Visible = false
    panel.Active = true
    panel.ClipsDescendants = true
    panel.ZIndex = 60

    addCorner(panel, 16)
    addStroke(panel, C().Stroke, 1, 0.05)

    local header = Instance.new("Frame")
    header.Parent = panel
    header.Size = UDim2.new(1, 0, 0, 58)
    header.BackgroundColor3 = C().Header
    header.BorderSizePixel = 0
    header.ZIndex = 61
    header.Active = true
    addCorner(header, 16)

    local line = Instance.new("Frame")
    line.Parent = header
    line.Size = UDim2.new(1, -28, 0, 2)
    line.Position = UDim2.new(0, 14, 1, -2)
    line.BackgroundColor3 = C().Accent
    line.BorderSizePixel = 0
    line.ZIndex = 63
    addCorner(line, 2)

    local titleLabel = createLabel(
        header,
        title,
        UDim2.new(1, -70, 1, 0),
        UDim2.fromOffset(16, 0),
        Enum.Font.GothamBold,
        15
    )
    titleLabel.ZIndex = 64

    local close = Instance.new("TextButton")
    close.Parent = header
    close.Size = UDim2.fromOffset(31, 31)
    close.Position = UDim2.new(1, -45, 0, 13)
    close.BackgroundColor3 = Color3.fromRGB(180, 55, 70)
    close.BorderSizePixel = 0
    close.Text = "×"
    close.TextColor3 = Color3.new(1, 1, 1)
    close.Font = Enum.Font.GothamBold
    close.TextSize = 16
    close.AutoButtonColor = false
    close.ZIndex = 65
    addCorner(close, 8)

    local body = Instance.new("ScrollingFrame")
    body.Parent = panel
    body.Size = UDim2.new(1, -24, 1, -74)
    body.Position = UDim2.fromOffset(12, 66)
    body.BackgroundTransparency = 1
    body.BorderSizePixel = 0
    body.ScrollBarThickness = 3
    body.ScrollBarImageColor3 = C().Accent
    body.CanvasSize = UDim2.new(0, 0, 0, 0)
    body.ZIndex = 62

    local layout = Instance.new("UIListLayout")
    layout.Parent = body
    layout.Padding = UDim.new(0, 5)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        body.CanvasSize = UDim2.fromOffset(
            0,
            layout.AbsoluteContentSize.Y + 8
        )
    end)

    panelHeaders[panel] = header

    return panel, header, close, body
end

--========================================================--
-- PANELS
--========================================================--

local TeleportPanel,
TeleportHeaderFrame,
TeleportCloseButton,
PlayerList =
    createPanel("TeleportPanel", "◎  TELEPORT")

local SpeedSettingsPanel,
SpeedSettingsHeaderFrame,
SpeedSettingsCloseButton,
SpeedSettingsList =
    createPanel("SpeedSettingsPanel", "ϟ  НАСТРОЙКИ СКОРОСТИ")

local WallHackSettingsPanel,
WallHackSettingsHeaderFrame,
WallHackSettingsCloseButton,
WallHackSettingsList =
    createPanel("WallHackSettingsPanel", "◈  НАСТРОЙКИ WALLHACK")

--========================================================--
-- WALLHACK SETTINGS / NICKNAMES
--========================================================--

local showNicknames = false
local showHealth = false
local nicknameDistance = 500

local NicknamesButton = Instance.new("TextButton")
NicknamesButton.Parent = WallHackSettingsList
NicknamesButton.Size = UDim2.new(1, -4, 0, 43)
NicknamesButton.BackgroundColor3 = C().Surface
NicknamesButton.BorderSizePixel = 0
NicknamesButton.Text = "Показывать никнеймы       ВЫКЛ"
NicknamesButton.TextColor3 = C().Text
NicknamesButton.Font = Enum.Font.GothamMedium
NicknamesButton.TextSize = 12
NicknamesButton.AutoButtonColor = false
NicknamesButton.ZIndex = 70
addCorner(NicknamesButton, 10)
addStroke(NicknamesButton, C().Stroke, 1, 0.15)

local NicknamesInfo = createLabel(
    WallHackSettingsList,
    "Username сверху • Display Name снизу",
    UDim2.new(1, -4, 0, 22),
    UDim2.fromOffset(0, 0),
    Enum.Font.Gotham,
    10
)
NicknamesInfo.TextColor3 = C().SubText
NicknamesInfo.ZIndex = 70

--========================================================--
-- HEALTH DISPLAY TOGGLE
--========================================================--

local HealthButton = Instance.new("TextButton")
HealthButton.Parent = WallHackSettingsList
HealthButton.Size = UDim2.new(1, -4, 0, 43)
HealthButton.BackgroundColor3 = C().Surface
HealthButton.BorderSizePixel = 0
HealthButton.Text = "Показывать здоровье       ВЫКЛ"
HealthButton.TextColor3 = C().Text
HealthButton.Font = Enum.Font.GothamMedium
HealthButton.TextSize = 12
HealthButton.AutoButtonColor = false
HealthButton.ZIndex = 70
addCorner(HealthButton, 10)
addStroke(HealthButton, C().Stroke, 1, 0.15)

local HealthInfo = createLabel(
    WallHackSettingsList,
    "Компактная полоска HP рядом с никнеймом",
    UDim2.new(1, -4, 0, 22),
    UDim2.fromOffset(0, 0),
    Enum.Font.Gotham,
    10
)
HealthInfo.TextColor3 = C().SubText
HealthInfo.ZIndex = 70

local MenuSettingsPanel,
MenuSettingsHeaderFrame,
MenuSettingsCloseButton,
MenuSettingsList =
    createPanel("MenuSettingsPanel", "⚙  НАСТРОЙКИ МЕНЮ")

local CheckpointPanel, CheckpointHeaderFrame, CheckpointCloseButton, CheckpointList =
    createPanel("CheckpointPanel", "⌖  ЧЕКПОИНТЫ")

--========================================================--
-- SPEED INPUT
--========================================================--

local SpeedSettingsInput = Instance.new("TextBox")
SpeedSettingsInput.Parent = SpeedSettingsList
SpeedSettingsInput.Size = UDim2.new(1, -4, 0, 45)
SpeedSettingsInput.BackgroundColor3 = C().Input
SpeedSettingsInput.BorderSizePixel = 0
SpeedSettingsInput.Text = "16"
SpeedSettingsInput.PlaceholderText = "Введите скорость..."
SpeedSettingsInput.PlaceholderColor3 = C().SubText
SpeedSettingsInput.TextColor3 = C().Text
SpeedSettingsInput.Font = Enum.Font.GothamMedium
SpeedSettingsInput.TextSize = 14
SpeedSettingsInput.ClearTextOnFocus = false
SpeedSettingsInput.ZIndex = 70
addCorner(SpeedSettingsInput, 10)
addStroke(SpeedSettingsInput, C().Stroke, 1, 0.15)

local SpeedInfo = createLabel(
    SpeedSettingsList,
    "Рекомендуемое значение: 16–100",
    UDim2.new(1, -4, 0, 20),
    UDim2.fromOffset(0, 0),
    Enum.Font.Gotham,
    10
)
SpeedInfo.TextColor3 = C().SubText

--========================================================--
-- AUTO SPEED
--========================================================--

local AutoSpeedMaintainButton = Instance.new("TextButton")
AutoSpeedMaintainButton.Parent = SpeedSettingsList
AutoSpeedMaintainButton.Size = UDim2.new(1, -4, 0, 43)
AutoSpeedMaintainButton.BackgroundColor3 = C().Surface
AutoSpeedMaintainButton.BorderSizePixel = 0
AutoSpeedMaintainButton.Text =
    "Автоматически сохранять скорость       ВЫКЛ"
AutoSpeedMaintainButton.TextColor3 = C().Text
AutoSpeedMaintainButton.Font = Enum.Font.GothamMedium
AutoSpeedMaintainButton.TextSize = 12
AutoSpeedMaintainButton.AutoButtonColor = false
AutoSpeedMaintainButton.ZIndex = 70
addCorner(AutoSpeedMaintainButton, 10)
addStroke(AutoSpeedMaintainButton, C().Stroke, 1, 0.15)

--========================================================--
-- MENU SETTINGS
--========================================================--

local OutOfBoundsButton = Instance.new("TextButton")
OutOfBoundsButton.Parent = MenuSettingsList
OutOfBoundsButton.Size = UDim2.new(1, -4, 0, 42)
OutOfBoundsButton.BackgroundColor3 = C().Surface
OutOfBoundsButton.BorderSizePixel = 0
OutOfBoundsButton.Text =
    "Перемещение за границы экрана       ВЫКЛ"
OutOfBoundsButton.TextColor3 = C().Text
OutOfBoundsButton.Font = Enum.Font.GothamMedium
OutOfBoundsButton.TextSize = 12
OutOfBoundsButton.AutoButtonColor = false
OutOfBoundsButton.ZIndex = 70
addCorner(OutOfBoundsButton, 10)
addStroke(OutOfBoundsButton, C().Stroke, 1, 0.15)

local OutOfBoundsDescription = createLabel(
    MenuSettingsList,
    "Позволяет перетаскивать меню за пределы экрана.",
    UDim2.new(1, -4, 0, 27),
    UDim2.fromOffset(0, 0),
    Enum.Font.Gotham,
    10
)
OutOfBoundsDescription.TextColor3 = C().SubText
OutOfBoundsDescription.TextWrapped = true
OutOfBoundsDescription.TextYAlignment = Enum.TextYAlignment.Top
OutOfBoundsDescription.ZIndex = 70

local TransparencyTitle = createLabel(
    MenuSettingsList,
    "Прозрачность при перетаскивании",
    UDim2.new(1, -55, 0, 25),
    UDim2.fromOffset(0, 0),
    Enum.Font.GothamMedium,
    13
)
TransparencyTitle.TextColor3 = C().Text
TransparencyTitle.ZIndex = 70

local TransparencyValue = createLabel(
    MenuSettingsList,
    "45%",
    UDim2.fromOffset(50, 25),
    UDim2.new(1, -50, 0, 0),
    Enum.Font.GothamBold,
    12
)
TransparencyValue.TextColor3 = C().Accent
TransparencyValue.TextXAlignment = Enum.TextXAlignment.Right
TransparencyValue.ZIndex = 70

local TransparencySlider = Instance.new("Frame")
TransparencySlider.Parent = MenuSettingsList
TransparencySlider.Size = UDim2.new(1, -4, 0, 38)
TransparencySlider.BackgroundColor3 = C().Surface
TransparencySlider.BorderSizePixel = 0
TransparencySlider.ZIndex = 70
addCorner(TransparencySlider, 10)

local TransparencySliderStroke = addStroke(
    TransparencySlider,
    C().Stroke,
    1,
    0.15
)

local SliderTrack = Instance.new("Frame")
SliderTrack.Parent = TransparencySlider
SliderTrack.Size = UDim2.new(1, -32, 0, 6)
SliderTrack.Position = UDim2.new(0, 16, 0.5, -3)
SliderTrack.BackgroundColor3 = C().Surface2
SliderTrack.BorderSizePixel = 0
SliderTrack.ZIndex = 71
addCorner(SliderTrack, 3)

local SliderFill = Instance.new("Frame")
SliderFill.Parent = SliderTrack
SliderFill.Size = UDim2.new(
    dragTransparency / MAX_DRAG_TRANSPARENCY,
    0,
    1,
    0
)
SliderFill.BackgroundColor3 = C().Accent
SliderFill.BorderSizePixel = 0
SliderFill.ZIndex = 72
addCorner(SliderFill, 3)

local SliderKnob = Instance.new("TextButton")
SliderKnob.Parent = SliderTrack
SliderKnob.Size = UDim2.fromOffset(24, 24)
SliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
SliderKnob.Position = UDim2.new(
    dragTransparency / MAX_DRAG_TRANSPARENCY,
    0,
    0.5,
    0
)
SliderKnob.BackgroundColor3 = C().Accent
SliderKnob.BorderSizePixel = 0
SliderKnob.Text = ""
SliderKnob.AutoButtonColor = false
SliderKnob.Active = true
SliderKnob.ZIndex = 74
addCorner(SliderKnob, 12)

local TransparencyDescription = createLabel(
    MenuSettingsList,
    "Чем выше значение — тем прозрачнее меню во время перетаскивания.",
    UDim2.new(1, -4, 0, 27),
    UDim2.fromOffset(0, 0),
    Enum.Font.Gotham,
    10
)
TransparencyDescription.TextColor3 = C().SubText
TransparencyDescription.TextWrapped = true
TransparencyDescription.TextYAlignment = Enum.TextYAlignment.Top
TransparencyDescription.ZIndex = 70

local openPanel
local closePanel

--========================================================--
-- CHECKPOINTS
--========================================================--

local checkpoints = {}
local checkpointRouteRunning = false
local checkpointCurrentIndex = 1
local checkpointRouteSpeed = 16
local checkpointFolder = Instance.new("Folder")
checkpointFolder.Name = "MedaCheckpoints"
checkpointFolder.Parent = workspace

local function createCheckpointAction(text)
    local b=Instance.new("TextButton")
    b.Parent=CheckpointList; b.Size=UDim2.new(1,-4,0,43); b.BackgroundColor3=C().Surface; b.BorderSizePixel=0
    b.Text=text; b.TextColor3=C().Text; b.Font=Enum.Font.GothamBold; b.TextSize=11; b.AutoButtonColor=false; b.ZIndex=70
    addCorner(b,10); addStroke(b,C().Stroke,1,0.15); return b
end
local CheckpointInfo=createLabel(CheckpointList,"Сохраняй позиции и запускай маршрут по кругу.",UDim2.new(1,-4,0,34),UDim2.fromOffset(0,0),Enum.Font.Gotham,10)
CheckpointInfo.TextColor3=C().SubText; CheckpointInfo.TextWrapped=true; CheckpointInfo.ZIndex=70
local CheckpointCountLabel=createLabel(CheckpointList,"Точек: 0",UDim2.new(1,-4,0,25),UDim2.fromOffset(0,0),Enum.Font.GothamBold,12)
CheckpointCountLabel.TextColor3=C().Accent; CheckpointCountLabel.ZIndex=70
local CheckpointAddButton=createCheckpointAction("+  ДОБАВИТЬ ТОЧКУ")
local CheckpointStartButton=createCheckpointAction("▶  ЗАПУСТИТЬ МАРШРУТ")
local CheckpointDeleteButton=createCheckpointAction("−  УДАЛИТЬ ПОСЛЕДНЮЮ")
local CheckpointClearButton=createCheckpointAction("⌫  ОЧИСТИТЬ ВСЕ")
local CheckpointSpeedTitle=createLabel(CheckpointList,"СКОРОСТЬ МАРШРУТА",UDim2.new(1,-4,0,22),UDim2.fromOffset(0,0),Enum.Font.GothamBold,10)
CheckpointSpeedTitle.TextColor3=C().SubText; CheckpointSpeedTitle.ZIndex=70
local CheckpointSpeedInput=Instance.new("TextBox")
CheckpointSpeedInput.Parent=CheckpointList; CheckpointSpeedInput.Size=UDim2.new(1,-4,0,43); CheckpointSpeedInput.BackgroundColor3=C().Input; CheckpointSpeedInput.BorderSizePixel=0
CheckpointSpeedInput.Text="16"; CheckpointSpeedInput.PlaceholderText="16 или inf"; CheckpointSpeedInput.PlaceholderColor3=C().SubText; CheckpointSpeedInput.TextColor3=C().Text; CheckpointSpeedInput.Font=Enum.Font.GothamMedium; CheckpointSpeedInput.TextSize=13; CheckpointSpeedInput.ClearTextOnFocus=false; CheckpointSpeedInput.ZIndex=70
addCorner(CheckpointSpeedInput,10); addStroke(CheckpointSpeedInput,C().Stroke,1,0.15)
local CheckpointSpeedHint=createLabel(CheckpointList,"1+ studs/sec • inf = мгновенное перемещение",UDim2.new(1,-4,0,25),UDim2.fromOffset(0,0),Enum.Font.Gotham,9)
CheckpointSpeedHint.TextColor3=C().SubText; CheckpointSpeedHint.ZIndex=70

local function checkpointRoot() local c=LocalPlayer.Character; return c and c:FindFirstChild("HumanoidRootPart") end
local function updateCheckpointUI()
    local n=#checkpoints; CheckpointCountLabel.Text="Точек: "..n
    CheckpointStatus.Text = n==0 and "Открыть маршрут" or (n==1 and "1 точка" or (n.." точек"))
    CheckpointSwitch.BackgroundColor3=checkpointRouteRunning and C().Green or C().Surface2
    CheckpointSwitchDot.BackgroundColor3=checkpointRouteRunning and Color3.new(1,1,1) or C().SubText
    CheckpointSwitchDot.Position=checkpointRouteRunning and UDim2.fromOffset(25,3) or UDim2.fromOffset(3,3)
    CheckpointStartButton.Text=checkpointRouteRunning and "■  ОСТАНОВИТЬ МАРШРУТ" or "▶  ЗАПУСТИТЬ МАРШРУТ"
end
local function createCheckpointMarker(index,pos)
    local m=Instance.new("Model"); m.Name="Checkpoint_"..index; m.Parent=checkpointFolder
    local p=Instance.new("Part"); p.Name="Marker"; p.Size=Vector3.new(3.5,.25,3.5); p.Position=pos-Vector3.new(0,2.7,0); p.Anchored=true; p.CanCollide=false; p.CanTouch=false; p.CanQuery=false; p.Material=Enum.Material.Neon; p.Color=C().Accent; p.Transparency=.15; p.Shape=Enum.PartType.Cylinder; p.Parent=m
    local b=Instance.new("Part"); b.Name="Beacon"; b.Size=Vector3.new(.18,5,.18); b.Position=pos-Vector3.new(0,.1,0); b.Anchored=true; b.CanCollide=false; b.CanTouch=false; b.CanQuery=false; b.Material=Enum.Material.Neon; b.Color=C().Accent; b.Transparency=.35; b.Parent=m
    local bg=Instance.new("BillboardGui"); bg.Name="Label"; bg.Adornee=b; bg.Size=UDim2.fromOffset(140,38); bg.StudsOffset=Vector3.new(0,2.9,0); bg.AlwaysOnTop=true; bg.MaxDistance=10000; bg.Parent=m
    local h=Instance.new("Frame"); h.Size=UDim2.fromScale(1,1); h.BackgroundColor3=C().Background; h.BackgroundTransparency=.15; h.BorderSizePixel=0; h.Parent=bg; addCorner(h,9); addStroke(h,C().Accent,1,.15)
    local l=createLabel(h,"CHECKPOINT "..index,UDim2.fromScale(1,1),UDim2.fromScale(0,0),Enum.Font.GothamBold,10); l.TextXAlignment=Enum.TextXAlignment.Center
    task.spawn(function() while m.Parent do local t=tween(p,TweenInfo.new(.7,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Transparency=.45}); t:Play(); t.Completed:Wait(); if not m.Parent then break end; local t2=tween(p,TweenInfo.new(.7,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Transparency=.15}); t2:Play(); t2.Completed:Wait() end end)
    return m
end
local function addCheckpoint() local r=checkpointRoot(); if not r then showNotification("Персонаж не найден",C().Red); return end; local i=#checkpoints+1; table.insert(checkpoints,{Position=r.Position,Marker=createCheckpointMarker(i,r.Position)}); updateCheckpointUI(); showNotification("Точка "..i.." добавлена",C().Green) end
local function removeLastCheckpoint() if #checkpoints==0 then showNotification("Нет точек для удаления",C().Red); return end; local cp=table.remove(checkpoints); if cp.Marker then cp.Marker:Destroy() end; updateCheckpointUI(); showNotification("Последняя точка удалена",C().Accent) end
local function clearCheckpoints() checkpointRouteRunning=false; checkpointCurrentIndex=1; for _,cp in ipairs(checkpoints) do if cp.Marker then cp.Marker:Destroy() end end; table.clear(checkpoints); updateCheckpointUI(); showNotification("Все чекпоинты очищены",C().Red) end
local function parseCheckpointSpeed(x) x=string.lower(tostring(x)):gsub("%s+",""); if x=="inf" or x=="infinity" or x=="∞" then return math.huge end; local n=tonumber(x); if not n or n<1 then return nil end; return n end
local function moveCheckpoint(target) local r=checkpointRoot(); if not r then return false end; if checkpointRouteSpeed==math.huge then r.CFrame=CFrame.new(target); return true end; local start=r.Position; local d=(target-start).Magnitude; if d<=.05 then return true end; local dur=d/checkpointRouteSpeed; local e=0; while e<dur do if not checkpointRouteRunning then return false end; local cur=checkpointRoot(); if not cur then return false end; e+=RunService.Heartbeat:Wait(); cur.CFrame=CFrame.new(start:Lerp(target,math.clamp(e/dur,0,1))) end; return true end
local function stopCheckpointRoute(silent) checkpointRouteRunning=false; checkpointCurrentIndex=1; updateCheckpointUI(); if not silent then showNotification("Маршрут остановлен",C().Red) end end
local function startCheckpointRoute() if checkpointRouteRunning then stopCheckpointRoute(false); return end; if #checkpoints<2 then showNotification("Нужно минимум 2 точки",C().Red); return end; local sp=parseCheckpointSpeed(CheckpointSpeedInput.Text); if not sp then showNotification("Введите скорость от 1 или inf",C().Red); return end; checkpointRouteSpeed=sp; checkpointRouteRunning=true; updateCheckpointUI(); showNotification("Маршрут запущен",C().Green); task.spawn(function() while checkpointRouteRunning do local cp=checkpoints[checkpointCurrentIndex]; if not cp then break end; CheckpointStatus.Text="Точка "..checkpointCurrentIndex.." / "..#checkpoints; if moveCheckpoint(cp.Position) then checkpointCurrentIndex=checkpointCurrentIndex+1; if checkpointCurrentIndex>#checkpoints then checkpointCurrentIndex=1 end else task.wait(.1) end; task.wait() end; if checkpointRouteRunning then stopCheckpointRoute(true) end end) end

CheckpointButton.MouseButton1Click:Connect(function() CheckpointPanel.Position=MenuFrame.Position; openPanel(CheckpointPanel) end)
CheckpointCloseButton.MouseButton1Click:Connect(function() closePanel(CheckpointPanel) end)
CheckpointAddButton.MouseButton1Click:Connect(addCheckpoint)
CheckpointStartButton.MouseButton1Click:Connect(startCheckpointRoute)
CheckpointDeleteButton.MouseButton1Click:Connect(removeLastCheckpoint)
CheckpointClearButton.MouseButton1Click:Connect(clearCheckpoints)
CheckpointSpeedInput.FocusLost:Connect(function(enter) if enter then local sp=parseCheckpointSpeed(CheckpointSpeedInput.Text); if sp then checkpointRouteSpeed=sp else CheckpointSpeedInput.Text=tostring(checkpointRouteSpeed); showNotification("Неверная скорость",C().Red) end end end)

--========================================================--
-- SLIDER
--========================================================--

local sliderDragging = false

local function updateTransparencySlider(inputX)
    local absolutePosition = SliderTrack.AbsolutePosition
    local absoluteSize = SliderTrack.AbsoluteSize

    local percent = math.clamp(
        (inputX - absolutePosition.X) / absoluteSize.X,
        0,
        1
    )

    dragTransparency = percent * MAX_DRAG_TRANSPARENCY

    SliderFill.Size = UDim2.new(
        percent,
        0,
        1,
        0
    )

    SliderKnob.Position = UDim2.new(
        percent,
        0,
        0.5,
        0
    )

    TransparencyValue.Text =
        tostring(
            math.floor(
                dragTransparency * 100 + 0.5
            )
        ) .. "%"

    if isDraggingMenu then
        for _, data in ipairs(dragTransparencyObjects) do
            local object = data.Object

            if object
                and object.Parent
                and object ~= HeaderFrame
                and not object:IsDescendantOf(HeaderFrame)
            then
                object.BackgroundTransparency =
                    dragTransparency
            end
        end
    end
end

SliderKnob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch
    then
        sliderDragging = true
        updateTransparencySlider(input.Position.X)
    end
end)

TransparencySlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch
    then
        sliderDragging = true
        updateTransparencySlider(input.Position.X)
    end
end)

--========================================================--
-- BUTTON FEEDBACK
--========================================================--

local function setupButtonFeedback(button)
    if not button then
        return
    end

    button.MouseEnter:Connect(function()
        if button.Parent then
            tween(button, FAST_TWEEN, {
                BackgroundColor3 = C().SurfaceHover
            }):Play()
        end
    end)

    button.MouseLeave:Connect(function()
        if button.Parent then
            tween(button, FAST_TWEEN, {
                BackgroundColor3 = C().Surface
            }):Play()
        end
    end)
end

for _, button in ipairs({
    ActivateButton,
    WallHackButton,
    SpeedHackButton,
    NoclipButton,
    InfiniteJumpButton,
    TeleportButton,
    CheckpointButton, CheckpointAddButton, CheckpointStartButton, CheckpointDeleteButton, CheckpointClearButton,

    SpeedSettingsButton,
    WallHackSettingsButton,
    NicknamesButton,
    HealthButton,

    AutoSpeedMaintainButton,
    OutOfBoundsButton,

    ThemeButton,
    MinimizeButton,
    CloseButton,
    MenuSettingsButton,

    TeleportCloseButton,
    SpeedSettingsCloseButton,
    WallHackSettingsCloseButton,
    MenuSettingsCloseButton,
    CheckpointCloseButton
}) do
    setupButtonFeedback(button)
end

--========================================================--
-- FEATURE STATE
--========================================================--

local isSpeedHackEnabled = false
local isWallHackEnabled = false
local isNoclipEnabled = false
local isInfiniteJumpEnabled = false

local function setFeatureState(button, enabled)
    local data = featureData[button]

    if not data then
        return
    end

    local iconLabel =
        data.Icon:FindFirstChildOfClass("TextLabel")

    if enabled then
        data.Status.Text = "●  ON"
        data.Status.TextColor3 = C().Green

        data.Icon.BackgroundColor3 =
            Color3.fromRGB(30, 65, 50)

        if iconLabel then
            iconLabel.TextColor3 = C().Green
        end
    else
        data.Status.Text = "●  OFF"
        data.Status.TextColor3 = C().SubText

        data.Icon.BackgroundColor3 =
            C().Surface2

        if iconLabel then
            iconLabel.TextColor3 = C().Accent
        end
    end
end

--========================================================--
-- DRAG TRANSPARENCY
--========================================================--

local function isInsideHeader(object, rootFrame)
    if not object or not rootFrame then
        return false
    end

    if rootFrame == MenuFrame then
        if object == HeaderFrame then
            return true
        end

        if object:IsDescendantOf(HeaderFrame) then
            return true
        end
    else
        local header = panelHeaders[rootFrame]

        if header then
            if object == header then
                return true
            end

            if object:IsDescendantOf(header) then
                return true
            end
        end
    end

    return false
end

local function collectDragTransparencyObjects(rootFrame)
    table.clear(dragTransparencyObjects)

    if not rootFrame then
        return
    end

    local function addObject(object)
        if not object:IsA("GuiObject") then
            return
        end

        if isInsideHeader(object, rootFrame) then
            return
        end

        if object.BackgroundTransparency >= 1 then
            return
        end

        table.insert(
            dragTransparencyObjects,
            {
                Object = object,
                OriginalTransparency =
                    object.BackgroundTransparency
            }
        )
    end

    addObject(rootFrame)

    for _, object in ipairs(rootFrame:GetDescendants()) do
        addObject(object)
    end
end

local function setDragTransparency(rootFrame, enabled)
    if not rootFrame then
        return
    end

    if enabled then
        collectDragTransparencyObjects(rootFrame)

        for _, data in ipairs(dragTransparencyObjects) do
            local object = data.Object

            if object
                and object.Parent
                and not isInsideHeader(object, rootFrame)
            then
                object.BackgroundTransparency =
                    math.clamp(
                        dragTransparency,
                        MIN_DRAG_TRANSPARENCY,
                        MAX_DRAG_TRANSPARENCY
                    )
            end
        end

        isDraggingMenu = true
    else
        for _, data in ipairs(dragTransparencyObjects) do
            local object = data.Object

            if object and object.Parent then
                object.BackgroundTransparency =
                    data.OriginalTransparency
            end
        end

        table.clear(dragTransparencyObjects)
        isDraggingMenu = false
    end
end

--========================================================--
-- DRAGGING
--========================================================--

local dragData = {
    active = false,
    frame = nil,
    startMouse = nil,
    startPosition = nil
}

local function clampPosition(frame, position)
    if allowOutOfBounds then
        return position
    end

    local viewport = ScreenGui.AbsoluteSize
    local size = frame.AbsoluteSize

    local x = math.clamp(
        position.X.Offset,
        0,
        math.max(0, viewport.X - size.X)
    )

    local y = math.clamp(
        position.Y.Offset,
        0,
        math.max(0, viewport.Y - size.Y)
    )

    return UDim2.fromOffset(x, y)
end

local function beginDrag(frame, input)
    if dragData.active then
        return
    end

    if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch
    then
        return
    end

    dragData.active = true
    dragData.frame = frame
    dragData.startMouse = input.Position

    local absolutePosition = frame.AbsolutePosition

    dragData.startPosition =
        UDim2.fromOffset(
            absolutePosition.X,
            absolutePosition.Y
        )

    setDragTransparency(frame, true)
end

local function updateDrag(input)
    if not dragData.active then
        return
    end

    if input.UserInputType ~= Enum.UserInputType.MouseMovement
        and input.UserInputType ~= Enum.UserInputType.Touch
    then
        return
    end

    if not dragData.frame then
        return
    end

    local delta =
        input.Position - dragData.startMouse

    local newPosition =
        UDim2.fromOffset(
            dragData.startPosition.X.Offset + delta.X,
            dragData.startPosition.Y.Offset + delta.Y
        )

    dragData.frame.Position =
        clampPosition(
            dragData.frame,
            newPosition
        )
end

local function endDrag()
    if dragData.frame then
        setDragTransparency(
            dragData.frame,
            false
        )
    end

    dragData.active = false
    dragData.frame = nil
    dragData.startMouse = nil
    dragData.startPosition = nil
end

--========================================================--
-- DRAG CONNECTIONS
--========================================================--

HeaderFrame.InputBegan:Connect(function(input)
    beginDrag(MenuFrame, input)
end)

MenuSettingsHeaderFrame.InputBegan:Connect(function(input)
    beginDrag(MenuSettingsPanel, input)
end)

CheckpointHeaderFrame.InputBegan:Connect(function(input) beginDrag(CheckpointPanel,input) end)

SpeedSettingsHeaderFrame.InputBegan:Connect(function(input)
    beginDrag(SpeedSettingsPanel, input)
end)

WallHackSettingsHeaderFrame.InputBegan:Connect(function(input)
    beginDrag(WallHackSettingsPanel, input)
end)

TeleportHeaderFrame.InputBegan:Connect(function(input)
    beginDrag(TeleportPanel, input)
end)

UserInputService.InputChanged:Connect(function(input)
    if sliderDragging then
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        then
            updateTransparencySlider(input.Position.X)
        end
    end

    updateDrag(input)
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch
    then
        sliderDragging = false

        if dragData.active then
            endDrag()
        end
    end
end)

--========================================================--
-- POSITION
--========================================================--

local savedPosition

local function savePosition()
    savedPosition = MenuFrame.Position
end

local function loadPosition()
    if savedPosition then
        MenuFrame.Position = savedPosition
    end
end

loadPosition()

--========================================================--
-- PANEL ANIMATIONS
--========================================================--

openPanel = function(panel)
    if not panel then
        return
    end

    panel.Visible = true

    local targetSize =
        UDim2.fromOffset(
            PANEL_WIDTH,
            PANEL_HEIGHT
        )

    panel.Size =
        UDim2.fromOffset(0, 0)

    tween(panel, NORMAL_TWEEN, {
        Size = targetSize
    }):Play()
end

closePanel = function(panel)
    if not panel then
        return
    end

    local closeTween = tween(
        panel,
        NORMAL_TWEEN,
        {
            Size = UDim2.fromOffset(0, 0)
        }
    )

    closeTween:Play()

    closeTween.Completed:Connect(function()
        if panel then
            panel.Visible = false
            panel.Size =
                UDim2.fromOffset(
                    PANEL_WIDTH,
                    PANEL_HEIGHT
                )
        end
    end)
end

--========================================================--
-- CLOSE MAIN MENU
--========================================================--

local function closeMainMenu()
    if dragData.active then
        endDrag()
    end

    savePosition()

    TeleportPanel.Visible = false
    SpeedSettingsPanel.Visible = false
    WallHackSettingsPanel.Visible = false
    MenuSettingsPanel.Visible = false
    CheckpointPanel.Visible = false

    local closeTween = tween(
        MenuFrame,
        NORMAL_TWEEN,
        {
            Size = UDim2.fromOffset(0, 0)
        }
    )

    closeTween:Play()

    closeTween.Completed:Connect(function()
        if not MenuFrame then
            return
        end

        MenuFrame.Visible = false

        MenuFrame.Size =
            UDim2.fromOffset(
                MENU_WIDTH,
                MENU_HEIGHT
            )

        HeaderFrame.Visible = true
        Content.Visible = true
        MinimizedContentLabel.Visible = false
    end)

    showNotification(
        "Меню закрыто",
        C().Accent
    )
end

--========================================================--
-- MAIN CLOSE BUTTON
--========================================================--

CloseButton.MouseButton1Click:Connect(function()
    closeMainMenu()
end)

--========================================================--
-- THEME
--========================================================--

-- Forward declarations: applyTheme() uses these tables below.
local nicknameGuis = {}
local healthConnections = {}

local function applyTheme()
    local t = C()

    MenuFrame.BackgroundColor3 = t.Background
    HeaderFrame.BackgroundColor3 = t.Header

    HeaderLabel.TextColor3 = t.Text
    HeaderSub.TextColor3 = t.SubText
    SectionTitle.TextColor3 = t.SubText

    HeaderBottom.BackgroundColor3 = t.Accent
    Logo.BackgroundColor3 = t.Accent

    for button, data in pairs(featureData) do
        if button and button.Parent then
            button.BackgroundColor3 = t.Surface

            if data.Icon then
                data.Icon.BackgroundColor3 = t.Surface2
            end

            if data.Title then
                data.Title.TextColor3 = t.Text
            end
        end
    end

    SpeedSettingsButton.BackgroundColor3 = t.Surface2
    SpeedSettingsButton.TextColor3 = t.SubText

    WallHackSettingsButton.BackgroundColor3 = t.Surface2
    WallHackSettingsButton.TextColor3 = t.SubText

    NicknamesButton.BackgroundColor3 = t.Surface
    NicknamesButton.TextColor3 = showNicknames and t.Green or t.Text

    HealthButton.BackgroundColor3 = t.Surface
    HealthButton.TextColor3 = showHealth and t.Green or t.Text

    SpeedSettingsInput.BackgroundColor3 = t.Input
    SpeedSettingsInput.TextColor3 = t.Text

    AutoSpeedMaintainButton.BackgroundColor3 = t.Surface
    AutoSpeedMaintainButton.TextColor3 = t.Text

    OutOfBoundsButton.BackgroundColor3 = t.Surface

    OutOfBoundsDescription.TextColor3 = t.SubText

    OutOfBoundsButton.TextColor3 =
        allowOutOfBounds and t.Green or t.Text

    TransparencyTitle.TextColor3 = t.Text
    TransparencyValue.TextColor3 = t.Accent
    TransparencyDescription.TextColor3 = t.SubText

    TransparencySlider.BackgroundColor3 = t.Surface
    TransparencySliderStroke.Color = t.Stroke
    SliderTrack.BackgroundColor3 = t.Surface2
    SliderFill.BackgroundColor3 = t.Accent
    SliderKnob.BackgroundColor3 = t.Accent

    for _, panel in ipairs({
        TeleportPanel,
        SpeedSettingsPanel,
        WallHackSettingsPanel,
        MenuSettingsPanel,
        CheckpointPanel
    }) do
        panel.BackgroundColor3 = t.Background
    end

    for _, header in ipairs({
        TeleportHeaderFrame,
        SpeedSettingsHeaderFrame,
        WallHackSettingsHeaderFrame,
        MenuSettingsHeaderFrame,
        CheckpointHeaderFrame
    }) do
        header.BackgroundColor3 = t.Header
    end

    CheckpointButton.BackgroundColor3=t.Surface
    CheckpointIcon.BackgroundColor3=t.Surface2
    CheckpointIconText.TextColor3=t.Accent
    CheckpointTitle.TextColor3=t.Text
    CheckpointStatus.TextColor3=checkpointRouteRunning and t.Green or t.SubText
    CheckpointSwitch.BackgroundColor3=checkpointRouteRunning and t.Green or t.Surface2
    CheckpointSwitchDot.BackgroundColor3=checkpointRouteRunning and Color3.new(1,1,1) or t.SubText
    CheckpointInfo.TextColor3=t.SubText
    CheckpointCountLabel.TextColor3=t.Accent
    CheckpointSpeedTitle.TextColor3=t.SubText
    CheckpointSpeedInput.BackgroundColor3=t.Input
    CheckpointSpeedInput.TextColor3=t.Text
    CheckpointSpeedHint.TextColor3=t.SubText
    for _,b in ipairs({CheckpointAddButton,CheckpointStartButton,CheckpointDeleteButton,CheckpointClearButton}) do b.BackgroundColor3=t.Surface; b.TextColor3=t.Text end

    ThemeButton.Text =
        isDarkTheme and "☾" or "☀"

    FlyStatus.Text = "ЗАГРУЗИТЬ"
    FlyStatus.TextColor3 = t.SubText

    setFeatureState(
        WallHackButton,
        isWallHackEnabled
    )

    setFeatureState(
        SpeedHackButton,
        isSpeedHackEnabled
    )

    setFeatureState(
        NoclipButton,
        isNoclipEnabled
    )

    setFeatureState(
        InfiniteJumpButton,
        isInfiniteJumpEnabled
    )

    for _, gui in pairs(nicknameGuis) do
        if gui and gui.Parent then
            local holder = gui:FindFirstChild("Holder")
            if holder then
                local username = holder:FindFirstChild("Username")
                local displayName = holder:FindFirstChild("DisplayName")
                local healthBackground = holder:FindFirstChild("HealthBackground")
                local healthFill = healthBackground and healthBackground:FindFirstChild("HealthFill")

                holder.BackgroundColor3 = t.Background

                if username then
                    username.TextColor3 = t.Text
                end

                if displayName then
                    displayName.TextColor3 = t.SubText
                end

                if healthBackground then
                    healthBackground.BackgroundColor3 = t.Surface2
                end

                if healthFill then
                    healthFill.BackgroundColor3 = t.Green
                end
            end
        end
    end
end

--========================================================--
-- THEME BUTTON
--========================================================--

ThemeButton.MouseButton1Click:Connect(function()
    isDarkTheme = not isDarkTheme

    applyTheme()

    showNotification(
        isDarkTheme
            and "Тёмная тема включена"
            or "Светлая тема включена",
        C().Accent
    )
end)

--========================================================--
-- FLY
--========================================================--

ActivateButton.MouseButton1Click:Connect(function()
    FlyStatus.Text = "ЗАГРУЗКА..."
    FlyStatus.TextColor3 = C().Accent

    showNotification(
        "Загрузка Fly...",
        C().Accent
    )

    local success, result = pcall(function()
        local source = game:HttpGet(
            "https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"
        )

        local flyScript = loadstring(source)

        if not flyScript then
            error("loadstring вернул nil")
        end

        return flyScript()
    end)

    if success then
        FlyStatus.Text = "ЗАГРУЗИТЬ"
        FlyStatus.TextColor3 = C().SubText

        showNotification(
            "Fly успешно загружен",
            C().Green
        )
    else
        FlyStatus.Text = "ЗАГРУЗИТЬ"
        FlyStatus.TextColor3 = C().SubText

        showNotification(
            "Ошибка загрузки Fly",
            C().Red
        )

        warn(
            "[MEDA HUB] Fly error:",
            result
        )
    end
end)

--========================================================--
-- MENU SETTINGS
--========================================================--

MenuSettingsButton.MouseButton1Click:Connect(function()
    savePosition()

    MenuFrame.Visible = false

    MenuSettingsPanel.Position =
        MenuFrame.Position

    openPanel(MenuSettingsPanel)

    showNotification(
        "Настройки меню открыты",
        C().Accent
    )
end)

MenuSettingsCloseButton.MouseButton1Click:Connect(function()
    local pos =
        MenuSettingsPanel.Position

    closePanel(MenuSettingsPanel)

    task.delay(0.23, function()
        MenuFrame.Position = pos
        MenuFrame.Visible = true
        savePosition()
    end)

    showNotification(
        "Настройки меню закрыты",
        C().Accent
    )
end)

--========================================================--
-- OUT OF BOUNDS
--========================================================--

OutOfBoundsButton.MouseButton1Click:Connect(function()
    allowOutOfBounds =
        not allowOutOfBounds

    OutOfBoundsButton.Text =
        "Перемещение за границы экрана       "
        ..
        (
            allowOutOfBounds
                and "ВКЛ"
                or "ВЫКЛ"
        )

    OutOfBoundsButton.TextColor3 =
        allowOutOfBounds
            and C().Green
            or C().Text

    showNotification(
        allowOutOfBounds
            and "Перемещение за границы включено"
            or "Перемещение за границы выключено",

        allowOutOfBounds
            and C().Green
            or C().Red
    )
end)

--========================================================--
-- MINIMIZE
--========================================================--

local minimizedMouseStart = nil

MinimizeButton.MouseButton1Click:Connect(function()
    HeaderFrame.Visible = false
    Content.Visible = false

    MinimizedContentLabel.Visible = true

    tween(MenuFrame, NORMAL_TWEEN, {
        Size = UDim2.fromOffset(64, 64)
    }):Play()
end)

MinimizedContentLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch
    then
        minimizedMouseStart = input.Position
        beginDrag(MenuFrame, input)
    end
end)

MinimizedContentLabel.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch
    then
        if minimizedMouseStart then
            local distance =
                (
                    input.Position -
                    minimizedMouseStart
                ).Magnitude

            if distance < 8 then
                MinimizedContentLabel.Visible = false
                HeaderFrame.Visible = true
                Content.Visible = true

                tween(MenuFrame, NORMAL_TWEEN, {
                    Size = UDim2.fromOffset(
                        MENU_WIDTH,
                        MENU_HEIGHT
                    )
                }):Play()
            end
        end

        minimizedMouseStart = nil
    end
end)

--========================================================--
-- SPEEDHACK
--========================================================--

local isAutoSpeedMaintainEnabled = false
local speedMaintainConnection = nil

local function setSpeed(speed, notify)
    local character = LocalPlayer.Character

    local humanoid =
        character
        and character:FindFirstChildOfClass("Humanoid")

    if not humanoid then
        if notify then
            showNotification(
                "Персонаж не найден",
                C().Red
            )
        end
        return
    end

    humanoid.WalkSpeed = speed

    if notify then
        showNotification(
            "Скорость установлена: " .. tostring(speed),
            C().Green
        )
    end
end

local function maintainSpeed()
    if not isSpeedHackEnabled
        or not isAutoSpeedMaintainEnabled
    then
        return
    end

    local character = LocalPlayer.Character

    local humanoid =
        character
        and character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        local speed =
            tonumber(SpeedSettingsInput.Text)
            or DEFAULT_SPEED

        humanoid.WalkSpeed = speed
    end
end

local function stopSpeedMaintain()
    if speedMaintainConnection then
        speedMaintainConnection:Disconnect()
        speedMaintainConnection = nil
    end
end

local function startSpeedMaintain()
    stopSpeedMaintain()

    if isSpeedHackEnabled
        and isAutoSpeedMaintainEnabled
    then
        speedMaintainConnection =
            RunService.Heartbeat:Connect(
                maintainSpeed
            )
    end
end

local function toggleSpeedHack()
    isSpeedHackEnabled =
        not isSpeedHackEnabled

    if isSpeedHackEnabled then
        local speed =
            tonumber(SpeedSettingsInput.Text)
            or DEFAULT_SPEED

        speed = math.clamp(
            speed,
            MIN_SPEED,
            MAX_SPEED
        )

        SpeedSettingsInput.Text =
            tostring(speed)

        setSpeed(speed, true)
        startSpeedMaintain()

        setFeatureState(
            SpeedHackButton,
            true
        )
    else
        setSpeed(
            DEFAULT_SPEED,
            true
        )

        stopSpeedMaintain()

        setFeatureState(
            SpeedHackButton,
            false
        )
    end
end

SpeedHackButton.MouseButton1Click:Connect(
    toggleSpeedHack
)

--========================================================--
-- SPEED SETTINGS
--========================================================--

SpeedSettingsButton.MouseButton1Click:Connect(function()
    openPanel(SpeedSettingsPanel)

    showNotification(
        "Настройки скорости открыты",
        C().Accent
    )
end)

SpeedSettingsCloseButton.MouseButton1Click:Connect(function()
    closePanel(SpeedSettingsPanel)

    showNotification(
        "Настройки скорости закрыты",
        C().Accent
    )
end)

SpeedSettingsInput.FocusLost:Connect(function(enterPressed)
    if not enterPressed then
        return
    end

    local speed =
        tonumber(SpeedSettingsInput.Text)

    if not speed then
        SpeedSettingsInput.Text =
            tostring(DEFAULT_SPEED)

        showNotification(
            "Введите правильное число",
            C().Red
        )

        return
    end

    speed = math.clamp(
        speed,
        MIN_SPEED,
        MAX_SPEED
    )

    SpeedSettingsInput.Text =
        tostring(speed)

    if isSpeedHackEnabled then
        setSpeed(speed, true)
    end
end)

AutoSpeedMaintainButton.MouseButton1Click:Connect(function()
    isAutoSpeedMaintainEnabled =
        not isAutoSpeedMaintainEnabled

    AutoSpeedMaintainButton.Text =
        "Автоматически сохранять скорость       "
        ..
        (
            isAutoSpeedMaintainEnabled
                and "ВКЛ"
                or "ВЫКЛ"
        )

    AutoSpeedMaintainButton.TextColor3 =
        isAutoSpeedMaintainEnabled
            and C().Green
            or C().Text

    if isAutoSpeedMaintainEnabled then
        startSpeedMaintain()
    else
        stopSpeedMaintain()
    end

    showNotification(
        isAutoSpeedMaintainEnabled
            and "Автосохранение скорости включено"
            or "Автосохранение скорости выключено",

        isAutoSpeedMaintainEnabled
            and C().Green
            or C().Red
    )
end)

--========================================================--
-- WALLHACK SETTINGS
--========================================================--

WallHackSettingsButton.MouseButton1Click:Connect(function()
    openPanel(WallHackSettingsPanel)

    showNotification(
        "Настройки WallHack открыты",
        C().Accent
    )
end)

WallHackSettingsCloseButton.MouseButton1Click:Connect(function()
    closePanel(WallHackSettingsPanel)

    showNotification(
        "Настройки WallHack закрыты",
        C().Accent
    )
end)

--========================================================--
-- INFINITE JUMP
--========================================================--

local infiniteJumpConnection = nil

local function toggleInfiniteJump()
    isInfiniteJumpEnabled =
        not isInfiniteJumpEnabled

    if isInfiniteJumpEnabled then
        if infiniteJumpConnection then
            infiniteJumpConnection:Disconnect()
        end

        infiniteJumpConnection =
            UserInputService.JumpRequest:Connect(
                function()
                    local character =
                        LocalPlayer.Character

                    local humanoid =
                        character
                        and character:FindFirstChildOfClass(
                            "Humanoid"
                        )

                    if humanoid then
                        humanoid:ChangeState(
                            Enum.HumanoidStateType.Jumping
                        )
                    end
                end
            )

        setFeatureState(
            InfiniteJumpButton,
            true
        )

        showNotification(
            "Бесконечный прыжок включён",
            C().Green
        )
    else
        if infiniteJumpConnection then
            infiniteJumpConnection:Disconnect()
            infiniteJumpConnection = nil
        end

        setFeatureState(
            InfiniteJumpButton,
            false
        )

        showNotification(
            "Бесконечный прыжок выключен",
            C().Red
        )
    end
end

InfiniteJumpButton.MouseButton1Click:Connect(
    toggleInfiniteJump
)

--========================================================--
-- NOCLIP
--========================================================--

local noclipConnection = nil

local function setNoclip(enabled)
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end

    local character =
        LocalPlayer.Character

    if not character then
        return
    end

    if enabled then
        noclipConnection =
            RunService.Stepped:Connect(
                function()
                    local currentCharacter =
                        LocalPlayer.Character

                    if not currentCharacter then
                        return
                    end

                    for _, part in ipairs(
                        currentCharacter:GetDescendants()
                    ) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            )
    else
        for _, part in ipairs(
            character:GetDescendants()
        ) do
            if part:IsA("BasePart") then
                if part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
    end
end

local function toggleNoclip()
    isNoclipEnabled =
        not isNoclipEnabled

    setNoclip(isNoclipEnabled)

    setFeatureState(
        NoclipButton,
        isNoclipEnabled
    )

    showNotification(
        isNoclipEnabled
            and "Noclip включён"
            or "Noclip выключен",

        isNoclipEnabled
            and C().Green
            or C().Red
    )
end

NoclipButton.MouseButton1Click:Connect(
    toggleNoclip
)

--========================================================--
-- NICKNAME / HEALTH SYSTEM
--========================================================--

local function disconnectHealthConnection(player)
    local connection = healthConnections[player]

    if connection then
        connection:Disconnect()
        healthConnections[player] = nil
    end
end

local function getHealthColor(percent)
    percent = math.clamp(percent, 0, 1)

    if percent <= 0.25 then
        return C().Red
    elseif percent <= 0.55 then
        return Color3.fromRGB(245, 180, 70)
    else
        return C().Green
    end
end

local function updateNicknameHealth(player)
    if not showHealth then
        return
    end

    local gui = nicknameGuis[player]

    if not gui or not gui.Parent then
        return
    end

    local holder = gui:FindFirstChild("Holder")

    if not holder then
        return
    end

    local healthBackground =
        holder:FindFirstChild("HealthBackground")

    local healthFill =
        healthBackground
        and healthBackground:FindFirstChild("HealthFill")

    local healthText =
        holder:FindFirstChild("HealthText")

    local character = player.Character

    local humanoid =
        character
        and character:FindFirstChildOfClass("Humanoid")

    if not humanoid
        or humanoid.MaxHealth <= 0
    then
        if healthBackground then
            healthBackground.Visible = false
        end

        if healthText then
            healthText.Visible = false
        end

        return
    end

    local percent =
        math.clamp(
            humanoid.Health / humanoid.MaxHealth,
            0,
            1
        )

    if healthBackground then
        healthBackground.Visible = true
    end

    if healthText then
        healthText.Visible = true
        healthText.Text =
            tostring(math.floor(humanoid.Health + 0.5))
            .. " HP"
        healthText.TextColor3 =
            getHealthColor(percent)
    end

    if healthFill then
        healthFill.BackgroundColor3 =
            getHealthColor(percent)

        healthFill.Size =
            UDim2.new(
                percent,
                0,
                1,
                0
            )
    end
end

local function connectNicknameHealth(player)
    disconnectHealthConnection(player)

    if not showHealth then
        return
    end

    local character = player.Character

    if not character then
        return
    end

    local humanoid =
        character:FindFirstChildOfClass("Humanoid")

    if not humanoid then
        return
    end

    healthConnections[player] =
        humanoid.HealthChanged:Connect(
            function()
                updateNicknameHealth(player)
            end
        )

    updateNicknameHealth(player)
end

local function removeNickname(player)
    disconnectHealthConnection(player)

    local gui = nicknameGuis[player]

    if gui then
        gui:Destroy()
        nicknameGuis[player] = nil
    end

    local character = player.Character

    if character then
        local old =
            character:FindFirstChild("MedaNickname")

        if old then
            old:Destroy()
        end
    end
end

local function createNickname(player)
    if player == LocalPlayer then
        return
    end

    removeNickname(player)

    local character = player.Character

    if not character then
        return
    end

    local head =
        character:FindFirstChild("Head")

    if not head then
        return
    end

    local gui = Instance.new("BillboardGui")
    gui.Name = "MedaNickname"
    gui.Adornee = head
    gui.Parent = character
    gui.AlwaysOnTop = true
    gui.MaxDistance = nicknameDistance

    -- Немного увеличили ширину, чтобы HP выглядело компактно
    -- и не раздувало сам блок.
    gui.Size = UDim2.fromOffset(220, 50)
    gui.StudsOffset = Vector3.new(0, 2.8, 0)

    local holder = Instance.new("Frame")
    holder.Name = "Holder"
    holder.Parent = gui
    holder.Size = UDim2.fromScale(1, 1)
    holder.BackgroundColor3 = C().Background
    holder.BackgroundTransparency = 0.12
    holder.BorderSizePixel = 0

    addCorner(holder, 9)
    addStroke(holder, C().Accent, 1, 0.15)

    local glow = Instance.new("Frame")
    glow.Parent = holder
    glow.Size = UDim2.new(1, 6, 1, 6)
    glow.Position = UDim2.fromOffset(-3, -3)
    glow.BackgroundColor3 = C().Accent
    glow.BackgroundTransparency = 0.88
    glow.BorderSizePixel = 0
    glow.ZIndex = 0
    addCorner(glow, 11)

    local username = createLabel(
        holder,
        "@" .. player.Name,
        UDim2.new(1, -18, 0, 17),
        UDim2.fromOffset(12, 3),
        Enum.Font.GothamBold,
        11
    )
    username.Name = "Username"
    username.TextColor3 = C().Text
    username.TextTruncate = Enum.TextTruncate.AtEnd
    username.ZIndex = 2

    local displayName = createLabel(
        holder,
        player.DisplayName,
        UDim2.new(1, -18, 0, 15),
        UDim2.fromOffset(12, 20),
        Enum.Font.GothamMedium,
        9
    )
    displayName.Name = "DisplayName"
    displayName.TextColor3 = C().SubText
    displayName.TextTruncate = Enum.TextTruncate.AtEnd
    displayName.ZIndex = 2

    --====================================================--
    -- COMPACT HEALTH BAR
    --====================================================--

    local healthBackground = Instance.new("Frame")
    healthBackground.Name = "HealthBackground"
    healthBackground.Parent = holder
    healthBackground.Size = UDim2.new(1, -70, 0, 6)
    healthBackground.Position = UDim2.fromOffset(12, 39)
    healthBackground.BackgroundColor3 = C().Surface2
    healthBackground.BorderSizePixel = 0
    healthBackground.Visible = showHealth
    healthBackground.ZIndex = 3
    addCorner(healthBackground, 3)

    local healthFill = Instance.new("Frame")
    healthFill.Name = "HealthFill"
    healthFill.Parent = healthBackground
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.BackgroundColor3 = C().Green
    healthFill.BorderSizePixel = 0
    healthFill.ZIndex = 4
    addCorner(healthFill, 3)

    local healthText = createLabel(
        holder,
        "100 HP",
        UDim2.fromOffset(48, 16),
        UDim2.new(1, -58, 0, 34),
        Enum.Font.GothamBold,
        8
    )
    healthText.Name = "HealthText"
    healthText.TextXAlignment = Enum.TextXAlignment.Right
    healthText.TextColor3 = C().Green
    healthText.Visible = showHealth
    healthText.ZIndex = 4

    nicknameGuis[player] = gui

    if showHealth then
        connectNicknameHealth(player)
    end
end

local function refreshNicknames()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if showNicknames and isWallHackEnabled then
                createNickname(player)
            else
                removeNickname(player)
            end
        end
    end
end

NicknamesButton.MouseButton1Click:Connect(function()
    showNicknames = not showNicknames

    if showNicknames then
        NicknamesButton.Text =
            "Показывать никнеймы       ВКЛ"
        NicknamesButton.TextColor3 = C().Green
    else
        NicknamesButton.Text =
            "Показывать никнеймы       ВЫКЛ"
        NicknamesButton.TextColor3 = C().Text
    end

    refreshNicknames()

    showNotification(
        showNicknames
            and "Никнеймы включены"
            or "Никнеймы выключены",
        showNicknames
            and C().Green
            or C().Red
    )
end)

--========================================================--
-- HEALTH TOGGLE
--========================================================--

HealthButton.MouseButton1Click:Connect(function()
    showHealth = not showHealth

    if showHealth then
        HealthButton.Text =
            "Показывать здоровье       ВКЛ"
        HealthButton.TextColor3 = C().Green

        for player, gui in pairs(nicknameGuis) do
            if gui and gui.Parent then
                local holder = gui:FindFirstChild("Holder")

                if holder then
                    local healthBackground =
                        holder:FindFirstChild("HealthBackground")

                    local healthText =
                        holder:FindFirstChild("HealthText")

                    if healthBackground then
                        healthBackground.Visible = true
                    end

                    if healthText then
                        healthText.Visible = true
                    end
                end
            end

            if showNicknames and isWallHackEnabled then
                connectNicknameHealth(player)
            end
        end

        showNotification(
            "Показ здоровья включён",
            C().Green
        )
    else
        HealthButton.Text =
            "Показывать здоровье       ВЫКЛ"
        HealthButton.TextColor3 = C().Text

        for player, gui in pairs(nicknameGuis) do
            disconnectHealthConnection(player)

            if gui and gui.Parent then
                local holder = gui:FindFirstChild("Holder")

                if holder then
                    local healthBackground =
                        holder:FindFirstChild("HealthBackground")

                    local healthText =
                        holder:FindFirstChild("HealthText")

                    if healthBackground then
                        healthBackground.Visible = false
                    end

                    if healthText then
                        healthText.Visible = false
                    end
                end
            end
        end

        showNotification(
            "Показ здоровья выключен",
            C().Red
        )
    end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)

        if showNicknames and isWallHackEnabled then
            createNickname(player)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    removeNickname(player)
end)

--========================================================--
-- WALLHACK
--========================================================--

local highlights = {}

local function removeHighlight(player)
    local highlight =
        highlights[player]

    if highlight then
        highlight:Destroy()
        highlights[player] = nil
    end
end

local function applyHighlight(player)
    if player == LocalPlayer then
        return
    end

    removeHighlight(player)

    local character =
        player.Character

    if not character then
        return
    end

    local highlight =
        Instance.new("Highlight")

    highlight.Name = "MedaHighlight"
    highlight.Adornee = character
    highlight.Parent = character

    highlight.FillColor = C().Accent
    highlight.OutlineColor = C().Accent2

    highlight.FillTransparency = 0.82
    highlight.OutlineTransparency = 0

    highlight.DepthMode =
        Enum.HighlightDepthMode.AlwaysOnTop

    highlights[player] = highlight
end

local function refreshHighlights()
    for _, player in ipairs(
        Players:GetPlayers()
    ) do
        if player ~= LocalPlayer then
            if isWallHackEnabled then
                applyHighlight(player)
            else
                removeHighlight(player)
            end
        end
    end
end

local function toggleWallHack()
    isWallHackEnabled =
        not isWallHackEnabled

    if isWallHackEnabled then
        refreshHighlights()

        setFeatureState(
            WallHackButton,
            true
        )

        showNotification(
            "WallHack включён",
            C().Green
        )

        if showNicknames then
            refreshNicknames()
        end
    else
        for player in pairs(highlights) do
            removeHighlight(player)
        end

        setFeatureState(
            WallHackButton,
            false
        )

        -- Никнеймы и HP завязаны на состояние WallHack.
        refreshNicknames()

        showNotification(
            "WallHack выключен",
            C().Red
        )
    end
end

WallHackButton.MouseButton1Click:Connect(
    toggleWallHack
)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)

        if isWallHackEnabled then
            applyHighlight(player)
        end

        if isWallHackEnabled and showNicknames then
            createNickname(player)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    removeHighlight(player)
end)

for _, player in ipairs(
    Players:GetPlayers()
) do
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            task.wait(0.5)

            if isWallHackEnabled then
                applyHighlight(player)
            end

            if isWallHackEnabled and showNicknames then
                createNickname(player)
            end
        end)
    end
end

-- Keep nicknames synchronized with WallHack state.
task.spawn(function()
    while true do
        task.wait(0.25)

        if showNicknames and isWallHackEnabled then
            refreshNicknames()
        end
    end
end)

--========================================================--
-- TELEPORT
--========================================================--

local playerButtons = {}

local function createPlayerButton(player)
    local button =
        Instance.new("TextButton")

    button.Size =
        UDim2.new(1, -4, 0, 46)

    button.BackgroundColor3 =
        C().Surface

    button.BorderSizePixel = 0
    button.Text = ""
    button.AutoButtonColor = false
    button.ZIndex = 70

    addCorner(button, 10)

    addStroke(
        button,
        C().Stroke,
        1,
        0.2
    )

    local avatar =
        Instance.new("Frame")

    avatar.Parent = button
    avatar.Size =
        UDim2.fromOffset(30, 30)

    avatar.Position =
        UDim2.fromOffset(8, 8)

    avatar.BackgroundColor3 =
        C().Accent

    avatar.BorderSizePixel = 0
    avatar.ZIndex = 71

    addCorner(avatar, 9)

    local avatarText =
        createLabel(
            avatar,
            string.sub(
                player.Name,
                1,
                1
            ):upper(),
            UDim2.fromScale(1, 1),
            UDim2.fromScale(0, 0),
            Enum.Font.GothamBold,
            13
        )

    avatarText.TextXAlignment =
        Enum.TextXAlignment.Center

    avatarText.TextColor3 =
        Color3.new(1, 1, 1)

    avatarText.ZIndex = 72

    local avatarImage =
        Instance.new("ImageLabel")

    avatarImage.Parent = avatar
    avatarImage.Size =
        UDim2.fromScale(1, 1)
    avatarImage.Position =
        UDim2.fromScale(0, 0)
    avatarImage.BackgroundTransparency = 1
    avatarImage.BorderSizePixel = 0
    avatarImage.Image = ""
    avatarImage.ScaleType = Enum.ScaleType.Crop
    avatarImage.ZIndex = 73

    addCorner(avatarImage, 9)

    task.spawn(function()
        local ok, content =
            pcall(function()
                local image, ready =
                    Players:GetUserThumbnailAsync(
                        player.UserId,
                        Enum.ThumbnailType.HeadShot,
                        Enum.ThumbnailSize.Size100x100
                    )

                return image
            end)

        if ok and content and avatarImage.Parent then
            avatarImage.Image = content
            avatarText.Visible = false
        end
    end)

    local nameLabel =
        createLabel(
            button,
            player.Name,
            UDim2.new(1, -80, 1, 0),
            UDim2.fromOffset(48, 0),
            Enum.Font.GothamMedium,
            12
        )

    nameLabel.ZIndex = 71

    local arrow =
        createLabel(
            button,
            "→",
            UDim2.fromOffset(30, 46),
            UDim2.new(1, -38, 0, 0),
            Enum.Font.GothamBold,
            17
        )

    arrow.TextXAlignment =
        Enum.TextXAlignment.Center

    arrow.TextColor3 =
        C().Accent

    arrow.ZIndex = 71

    return button
end

local function updatePlayerList()
    for _, button in ipairs(
        playerButtons
    ) do
        if button then
            button:Destroy()
        end
    end

    table.clear(playerButtons)

    for _, player in ipairs(
        Players:GetPlayers()
    ) do
        if player ~= LocalPlayer then
            local button =
                createPlayerButton(player)

            button.Parent = PlayerList

            setupButtonFeedback(button)

            button.MouseButton1Click:Connect(
                function()
                    local myCharacter =
                        LocalPlayer.Character

                    local targetCharacter =
                        player.Character

                    local myRoot =
                        myCharacter
                        and myCharacter:FindFirstChild(
                            "HumanoidRootPart"
                        )

                    local targetRoot =
                        targetCharacter
                        and targetCharacter:FindFirstChild(
                            "HumanoidRootPart"
                        )

                    if myRoot and targetRoot then
                        myRoot.CFrame =
                            targetRoot.CFrame
                            + Vector3.new(
                                0,
                                3,
                                0
                            )

                        showNotification(
                            "Телепорт к "
                                .. player.Name,
                            C().Green
                        )
                    else
                        showNotification(
                            "Игрок недоступен",
                            C().Red
                        )
                    end
                end
            )

            table.insert(
                playerButtons,
                button
            )
        end
    end
end

TeleportButton.MouseButton1Click:Connect(
    function()
        updatePlayerList()

        openPanel(TeleportPanel)

        showNotification(
            "Список игроков открыт",
            C().Accent
        )
    end
)

TeleportCloseButton.MouseButton1Click:Connect(
    function()
        closePanel(TeleportPanel)
    end
)

Players.PlayerAdded:Connect(
    function()
        if TeleportPanel.Visible then
            updatePlayerList()
        end
    end
)

Players.PlayerRemoving:Connect(
    function()
        if TeleportPanel.Visible then
            updatePlayerList()
        end
    end
)

--========================================================--
-- CHARACTER RESPAWN
--========================================================--

LocalPlayer.CharacterAdded:Connect(
    function()
        task.wait(0.5)

        if checkpointRouteRunning then stopCheckpointRoute(true) end

        if isSpeedHackEnabled then
            local speed =
                tonumber(
                    SpeedSettingsInput.Text
                )
                or DEFAULT_SPEED

            setSpeed(
                speed,
                false
            )

            startSpeedMaintain()
        end

        if isNoclipEnabled then
            setNoclip(true)
        end
    end
)

--========================================================--
-- CHECKPOINT CLEANUP
--========================================================--

ScreenGui.Destroying:Connect(function() checkpointRouteRunning=false; if checkpointFolder and checkpointFolder.Parent then checkpointFolder:Destroy() end end)

--========================================================--
-- INITIAL STATE
--========================================================--

setFeatureState(
    WallHackButton,
    false
)

setFeatureState(
    SpeedHackButton,
    false
)

setFeatureState(
    NoclipButton,
    false
)

setFeatureState(
    InfiniteJumpButton,
    false
)

FlyStatus.Text = "ЗАГРУЗИТЬ"
FlyStatus.TextColor3 = C().SubText

NicknamesButton.Text =
    "Показывать никнеймы       ВЫКЛ"
NicknamesButton.TextColor3 = C().Text

HealthButton.Text =
    "Показывать здоровье       ВЫКЛ"
HealthButton.TextColor3 = C().Text

OutOfBoundsButton.Text =
    "Перемещение за границы экрана       ВЫКЛ"

AutoSpeedMaintainButton.Text =
    "Автоматически сохранять скорость       ВЫКЛ"

updateCheckpointUI()

TransparencyValue.Text =
    tostring(
        math.floor(
            dragTransparency * 100 + 0.5
        )
    ) .. "%"
    
    

applyTheme()

print("[MEDA HUB] v3 loaded successfully")


--========================================================--
--                 SERVER HOP EXTENSION                   --
--              OPTIMIZED / LOW-LAG VERSION              --
--========================================================--

local serverHopExtensionOk, serverHopExtensionError = xpcall(function()

    local ServerHopHttpService = game:GetService("HttpService")
    local ServerHopTeleportService = game:GetService("TeleportService")

    local SERVER_HOP_FILE = "MedaHub_Favorites.json"
    local SERVER_HOP_API =
        "https://games.roblox.com/v1/games/"
        .. tostring(game.PlaceId)
        .. "/servers/Public"

    -- Получаем максимум 100 серверов, но одновременно рисуем
    -- только SERVER_HOP_ROWS_PER_PAGE GUI-строк.
    local SERVER_HOP_PAGE_LIMIT = 100
    local SERVER_HOP_MAX_PAGES = 2
    local SERVER_HOP_ROWS_PER_PAGE = 20

    local serverHopSortMode = "DESC"
    local serverHopTab = "SERVERS"
    local serverHopPage = 1

    local serverHopServers = {}
    local serverHopFavoriteServers = {}
    local serverHopRows = {}
    local serverHopLoading = false

    --====================================================--
    -- FAVORITES STORAGE
    --====================================================--

    local function serverHopFileAvailable()
        return type(isfile) == "function"
            and type(readfile) == "function"
            and type(writefile) == "function"
    end

    local function saveServerHopFavorites()
        if not serverHopFileAvailable() then
            return false
        end

        local data = {}

        for serverId, serverData in pairs(serverHopFavoriteServers) do
            table.insert(data, {
                id = serverId,
                name =
                    serverData.name
                    or ("Server " .. string.sub(serverId, 1, 8)),
                savedAt = serverData.savedAt or os.time()
            })
        end

        return pcall(function()
            writefile(
                SERVER_HOP_FILE,
                ServerHopHttpService:JSONEncode(data)
            )
        end)
    end

    local function loadServerHopFavorites()
        table.clear(serverHopFavoriteServers)

        if not serverHopFileAvailable() then
            return
        end

        local fileExists = false

        local existsSuccess, existsResult = pcall(function()
            return isfile(SERVER_HOP_FILE)
        end)

        if existsSuccess and existsResult then
            fileExists = true
        end

        if not fileExists then
            return
        end

        local success, result = pcall(function()
            return ServerHopHttpService:JSONDecode(
                readfile(SERVER_HOP_FILE)
            )
        end)

        if not success or type(result) ~= "table" then
            return
        end

        for _, serverData in ipairs(result) do
            if type(serverData) == "table"
                and type(serverData.id) == "string"
                and serverData.id ~= ""
            then
                serverHopFavoriteServers[serverData.id] = {
                    name =
                        serverData.name
                        or (
                            "Server "
                            .. string.sub(serverData.id, 1, 8)
                        ),
                    savedAt = serverData.savedAt or os.time()
                }
            end
        end
    end

    loadServerHopFavorites()

    --====================================================--
    -- PANEL
    --====================================================--

    local ServerHopPanel,
        ServerHopHeaderFrame,
        ServerHopCloseButton,
        ServerHopList =
        createPanel("ServerHopPanel", "⇄  SERVER HOP")

    local ServerHopInfo = createLabel(
        ServerHopList,
        "Загрузка списка серверов...",
        UDim2.new(1, -4, 0, 20),
        UDim2.fromOffset(0, 0),
        Enum.Font.Gotham,
        10
    )

    ServerHopInfo.TextColor3 = C().SubText
    ServerHopInfo.ZIndex = 70

    --====================================================--
    -- CURRENT SERVER (PINNED)
    --====================================================--

    local ServerHopCurrentCard = Instance.new("Frame")
    ServerHopCurrentCard.Parent = ServerHopList
    ServerHopCurrentCard.Size = UDim2.new(1, -4, 0, 86)
    ServerHopCurrentCard.BackgroundColor3 = C().Surface
    ServerHopCurrentCard.BorderSizePixel = 0
    ServerHopCurrentCard.ZIndex = 70
    addCorner(ServerHopCurrentCard, 10)
    addStroke(ServerHopCurrentCard, C().Accent, 1, 0.15)

    local ServerHopCurrentTitle = createLabel(ServerHopCurrentCard, "ТЕКУЩИЙ СЕРВЕР", UDim2.new(1, -165, 0, 21), UDim2.fromOffset(10, 5), Enum.Font.GothamBold, 11)
    ServerHopCurrentTitle.TextColor3 = C().Text
    ServerHopCurrentTitle.ZIndex = 73

    local ServerHopCurrentPlayers = createLabel(ServerHopCurrentCard, "●  ИГРОКОВ  N/A", UDim2.new(0.62, 0, 0, 20), UDim2.fromOffset(10, 29), Enum.Font.GothamBold, 10)
    ServerHopCurrentPlayers.TextColor3 = C().Accent
    ServerHopCurrentPlayers.ZIndex = 73

    local ServerHopCurrentPing = createLabel(ServerHopCurrentCard, "PING  N/A", UDim2.fromOffset(105, 18), UDim2.new(1, -220, 0, 28), Enum.Font.GothamBold, 9)
    ServerHopCurrentPing.TextColor3 = C().SubText
    ServerHopCurrentPing.TextXAlignment = Enum.TextXAlignment.Right
    ServerHopCurrentPing.ZIndex = 73

    local ServerHopCurrentId = createLabel(ServerHopCurrentCard, "#CURRENT", UDim2.fromOffset(110, 15), UDim2.fromOffset(10, 58), Enum.Font.Gotham, 8)
    ServerHopCurrentId.TextColor3 = C().SubText
    ServerHopCurrentId.ZIndex = 73

    local ServerHopCurrentFavorite = Instance.new("TextButton")
    ServerHopCurrentFavorite.Parent = ServerHopCurrentCard
    ServerHopCurrentFavorite.Size = UDim2.fromOffset(27, 27)
    ServerHopCurrentFavorite.Position = UDim2.new(1, -145, 0, 5)
    ServerHopCurrentFavorite.BackgroundColor3 = C().Surface2
    ServerHopCurrentFavorite.BorderSizePixel = 0
    ServerHopCurrentFavorite.Text = "☆"
    ServerHopCurrentFavorite.TextColor3 = C().SubText
    ServerHopCurrentFavorite.Font = Enum.Font.GothamBold
    ServerHopCurrentFavorite.TextSize = 16
    ServerHopCurrentFavorite.AutoButtonColor = false
    ServerHopCurrentFavorite.ZIndex = 75
    addCorner(ServerHopCurrentFavorite, 7)

    local ServerHopCurrentPlayersButton = Instance.new("TextButton")
    ServerHopCurrentPlayersButton.Parent = ServerHopCurrentCard
    ServerHopCurrentPlayersButton.Size = UDim2.fromOffset(27, 27)
    ServerHopCurrentPlayersButton.Position = UDim2.new(1, -110, 0, 5)
    ServerHopCurrentPlayersButton.BackgroundColor3 = C().Surface2
    ServerHopCurrentPlayersButton.BorderSizePixel = 0
    ServerHopCurrentPlayersButton.Text = "👥"
    ServerHopCurrentPlayersButton.TextColor3 = C().Text
    ServerHopCurrentPlayersButton.Font = Enum.Font.GothamBold
    ServerHopCurrentPlayersButton.TextSize = 13
    ServerHopCurrentPlayersButton.AutoButtonColor = false
    ServerHopCurrentPlayersButton.ZIndex = 75
    addCorner(ServerHopCurrentPlayersButton, 7)

    local ServerHopCurrentJoin = Instance.new("TextButton")
    ServerHopCurrentJoin.Parent = ServerHopCurrentCard
    ServerHopCurrentJoin.Size = UDim2.fromOffset(55, 27)
    ServerHopCurrentJoin.Position = UDim2.new(1, -60, 0, 46)
    ServerHopCurrentJoin.BackgroundColor3 = C().Surface2
    ServerHopCurrentJoin.BorderSizePixel = 0
    ServerHopCurrentJoin.Text = "ТЕКУЩИЙ"
    ServerHopCurrentJoin.TextColor3 = C().SubText
    ServerHopCurrentJoin.Font = Enum.Font.GothamBold
    ServerHopCurrentJoin.TextSize = 7
    ServerHopCurrentJoin.AutoButtonColor = false
    ServerHopCurrentJoin.Active = false
    ServerHopCurrentJoin.ZIndex = 75
    addCorner(ServerHopCurrentJoin, 7)

    --====================================================--
    -- TABS
    --====================================================--

    local ServerHopTabs = Instance.new("Frame")
    ServerHopTabs.Parent = ServerHopList
    ServerHopTabs.Size = UDim2.new(1, -4, 0, 38)
    ServerHopTabs.BackgroundTransparency = 1
    ServerHopTabs.BorderSizePixel = 0
    ServerHopTabs.ZIndex = 70

    local ServerHopServersTab = Instance.new("TextButton")
    ServerHopServersTab.Parent = ServerHopTabs
    ServerHopServersTab.Size = UDim2.new(0.5, -3, 1, 0)
    ServerHopServersTab.Position = UDim2.fromOffset(0, 0)
    ServerHopServersTab.BackgroundColor3 = C().Accent
    ServerHopServersTab.BorderSizePixel = 0
    ServerHopServersTab.Text = "СЕРВЕРЫ"
    ServerHopServersTab.TextColor3 = Color3.new(1, 1, 1)
    ServerHopServersTab.Font = Enum.Font.GothamBold
    ServerHopServersTab.TextSize = 10
    ServerHopServersTab.AutoButtonColor = false
    ServerHopServersTab.ZIndex = 71

    addCorner(ServerHopServersTab, 9)

    local ServerHopFavoritesTab = Instance.new("TextButton")
    ServerHopFavoritesTab.Parent = ServerHopTabs
    ServerHopFavoritesTab.Size = UDim2.new(0.5, -3, 1, 0)
    ServerHopFavoritesTab.Position = UDim2.new(0.5, 3, 0, 0)
    ServerHopFavoritesTab.BackgroundColor3 = C().Surface
    ServerHopFavoritesTab.BorderSizePixel = 0
    ServerHopFavoritesTab.Text = "★  ИЗБРАННОЕ"
    ServerHopFavoritesTab.TextColor3 = C().Text
    ServerHopFavoritesTab.Font = Enum.Font.GothamBold
    ServerHopFavoritesTab.TextSize = 10
    ServerHopFavoritesTab.AutoButtonColor = false
    ServerHopFavoritesTab.ZIndex = 71

    addCorner(ServerHopFavoritesTab, 9)
    addStroke(ServerHopFavoritesTab, C().Stroke, 1, 0.15)

    --====================================================--
    -- SORT / REFRESH
    --====================================================--

    local ServerHopSortFrame = Instance.new("Frame")
    ServerHopSortFrame.Parent = ServerHopList
    ServerHopSortFrame.Size = UDim2.new(1, -4, 0, 38)
    ServerHopSortFrame.BackgroundTransparency = 1
    ServerHopSortFrame.BorderSizePixel = 0
    ServerHopSortFrame.ZIndex = 70

    local ServerHopSortPlayersMore = Instance.new("TextButton")
    ServerHopSortPlayersMore.Parent = ServerHopSortFrame
    ServerHopSortPlayersMore.Size = UDim2.new(0.5, -3, 1, 0)
    ServerHopSortPlayersMore.Position = UDim2.fromOffset(0, 0)
    ServerHopSortPlayersMore.BackgroundColor3 = C().Surface
    ServerHopSortPlayersMore.BorderSizePixel = 0
    ServerHopSortPlayersMore.Text = "↑  БОЛЬШЕ ИГРОКОВ"
    ServerHopSortPlayersMore.TextColor3 = C().Text
    ServerHopSortPlayersMore.Font = Enum.Font.GothamBold
    ServerHopSortPlayersMore.TextSize = 9
    ServerHopSortPlayersMore.AutoButtonColor = false
    ServerHopSortPlayersMore.ZIndex = 71

    addCorner(ServerHopSortPlayersMore, 9)
    addStroke(ServerHopSortPlayersMore, C().Stroke, 1, 0.15)

    local ServerHopSortPlayersLess = Instance.new("TextButton")
    ServerHopSortPlayersLess.Parent = ServerHopSortFrame
    ServerHopSortPlayersLess.Size = UDim2.new(0.5, -3, 1, 0)
    ServerHopSortPlayersLess.Position = UDim2.new(0.5, 3, 0, 0)
    ServerHopSortPlayersLess.BackgroundColor3 = C().Surface
    ServerHopSortPlayersLess.BorderSizePixel = 0
    ServerHopSortPlayersLess.Text = "↓  МЕНЬШЕ ИГРОКОВ"
    ServerHopSortPlayersLess.TextColor3 = C().Text
    ServerHopSortPlayersLess.Font = Enum.Font.GothamBold
    ServerHopSortPlayersLess.TextSize = 9
    ServerHopSortPlayersLess.AutoButtonColor = false
    ServerHopSortPlayersLess.ZIndex = 71

    addCorner(ServerHopSortPlayersLess, 9)
    addStroke(ServerHopSortPlayersLess, C().Stroke, 1, 0.15)

    local ServerHopRefreshButton = Instance.new("TextButton")
    ServerHopRefreshButton.Parent = ServerHopList
    ServerHopRefreshButton.Size = UDim2.new(1, -4, 0, 38)
    ServerHopRefreshButton.BackgroundColor3 = C().Accent
    ServerHopRefreshButton.BorderSizePixel = 0
    ServerHopRefreshButton.Text = "↻  ОБНОВИТЬ"
    ServerHopRefreshButton.TextColor3 = Color3.new(1, 1, 1)
    ServerHopRefreshButton.Font = Enum.Font.GothamBold
    ServerHopRefreshButton.TextSize = 11
    ServerHopRefreshButton.AutoButtonColor = false
    ServerHopRefreshButton.ZIndex = 70

    addCorner(ServerHopRefreshButton, 9)

    --====================================================--
    -- PAGINATION
    --====================================================--

    local ServerHopPagination = Instance.new("Frame")
    ServerHopPagination.Parent = ServerHopList
    ServerHopPagination.Size = UDim2.new(1, -4, 0, 34)
    ServerHopPagination.BackgroundTransparency = 1
    ServerHopPagination.BorderSizePixel = 0
    ServerHopPagination.ZIndex = 70

    local ServerHopPrevButton = Instance.new("TextButton")
    ServerHopPrevButton.Parent = ServerHopPagination
    ServerHopPrevButton.Size = UDim2.fromOffset(70, 30)
    ServerHopPrevButton.Position = UDim2.fromOffset(0, 2)
    ServerHopPrevButton.BackgroundColor3 = C().Surface
    ServerHopPrevButton.BorderSizePixel = 0
    ServerHopPrevButton.Text = "‹ НАЗАД"
    ServerHopPrevButton.TextColor3 = C().Text
    ServerHopPrevButton.Font = Enum.Font.GothamBold
    ServerHopPrevButton.TextSize = 9
    ServerHopPrevButton.AutoButtonColor = false
    ServerHopPrevButton.ZIndex = 71

    addCorner(ServerHopPrevButton, 8)
    addStroke(ServerHopPrevButton, C().Stroke, 1, 0.15)

    local ServerHopPageLabel = createLabel(
        ServerHopPagination,
        "1 / 1",
        UDim2.new(1, -160, 1, 0),
        UDim2.fromOffset(80, 0),
        Enum.Font.GothamBold,
        9
    )

    ServerHopPageLabel.TextColor3 = C().SubText
    ServerHopPageLabel.TextXAlignment = Enum.TextXAlignment.Center
    ServerHopPageLabel.ZIndex = 71

    local ServerHopNextButton = Instance.new("TextButton")
    ServerHopNextButton.Parent = ServerHopPagination
    ServerHopNextButton.Size = UDim2.fromOffset(70, 30)
    ServerHopNextButton.Position = UDim2.new(1, -70, 0, 2)
    ServerHopNextButton.BackgroundColor3 = C().Surface
    ServerHopNextButton.BorderSizePixel = 0
    ServerHopNextButton.Text = "ВПЕРЁД ›"
    ServerHopNextButton.TextColor3 = C().Text
    ServerHopNextButton.Font = Enum.Font.GothamBold
    ServerHopNextButton.TextSize = 9
    ServerHopNextButton.AutoButtonColor = false
    ServerHopNextButton.ZIndex = 71

    addCorner(ServerHopNextButton, 8)
    addStroke(ServerHopNextButton, C().Stroke, 1, 0.15)

    --====================================================--
    -- DYNAMIC CONTAINER
    --====================================================--

    local ServerHopDynamicContainer = Instance.new("Frame")
    ServerHopDynamicContainer.Parent = ServerHopList
    ServerHopDynamicContainer.Size = UDim2.new(1, -4, 0, 0)
    ServerHopDynamicContainer.BackgroundTransparency = 1
    ServerHopDynamicContainer.BorderSizePixel = 0
    ServerHopDynamicContainer.AutomaticSize = Enum.AutomaticSize.Y
    ServerHopDynamicContainer.ZIndex = 70

    local ServerHopDynamicLayout = Instance.new("UIListLayout")
    ServerHopDynamicLayout.Parent = ServerHopDynamicContainer
    ServerHopDynamicLayout.Padding = UDim.new(0, 5)
    ServerHopDynamicLayout.SortOrder = Enum.SortOrder.LayoutOrder

    --====================================================--
    -- HELPERS
    --====================================================--

    local function serverHopShortId(id)
        if not id then
            return "Unknown"
        end

        return string.sub(id, 1, 8)
    end

    local function serverHopDisplayName(server)
        if server.name and server.name ~= "" then
            return server.name
        end

        return "Server " .. serverHopShortId(server.id)
    end

    local function serverHopIsFavorite(serverId)
        return serverHopFavoriteServers[serverId] ~= nil
    end

    local function serverHopPingColor(ping)
        ping = tonumber(ping)

        if not ping then
            return C().SubText
        end

        if ping <= 80 then
            return C().Green
        elseif ping <= 150 then
            return C().Orange
        end

        return C().Red
    end

    local function serverHopPingText(server)
        local ping = tonumber(server.ping)

        if ping then
            return "PING  " .. tostring(math.floor(ping + 0.5)) .. " ms"
        end

        return "PING  N/A"
    end

    local function serverHopGetCurrentPing()
        local success, value = pcall(function()
            local stats = game:GetService("Stats")
            local network = stats:FindFirstChild("Network")
            local serverStats = network and network:FindFirstChild("ServerStatsItem")
            local dataPing = serverStats and serverStats:FindFirstChild("Data Ping")
            if not dataPing then return nil end
            return tonumber(dataPing:GetValue())
        end)
        return success and value or nil
    end

    local function serverHopBuildCurrentServer()
        return {
            id = game.JobId,
            name = "ТЕКУЩИЙ СЕРВЕР",
            playing = #Players:GetPlayers(),
            maxPlayers = Players.MaxPlayers,
            ping = serverHopGetCurrentPing(),
            isCurrent = true
        }
    end

    local function serverHopUpdateCurrentCard()
        local current = serverHopBuildCurrentServer()
        local count = tonumber(current.playing) or 0
        local maxCount = tonumber(current.maxPlayers) or "?"
        ServerHopCurrentPlayers.Text = "●  " .. tostring(count) .. " / " .. tostring(maxCount) .. " ИГРОКОВ"
        ServerHopCurrentPing.Text = serverHopPingText(current)
        ServerHopCurrentPing.TextColor3 = serverHopPingColor(current.ping)
        ServerHopCurrentId.Text = "#" .. serverHopShortId(current.id)
        local favorite = serverHopIsFavorite(current.id)
        ServerHopCurrentFavorite.Text = favorite and "★" or "☆"
        ServerHopCurrentFavorite.TextColor3 = favorite and C().Orange or C().SubText
    end

    local function serverHopSetFavorite(server)
        if not server or not server.id then
            return
        end

        if serverHopFavoriteServers[server.id] then
            serverHopFavoriteServers[server.id] = nil
            saveServerHopFavorites()

            showNotification(
                "Сервер удалён из избранного",
                C().Red
            )
        else
            serverHopFavoriteServers[server.id] = {
                name = serverHopDisplayName(server),
                savedAt = os.time()
            }

            saveServerHopFavorites()

            showNotification(
                "Сервер добавлен в избранное",
                C().Green
            )
        end
    end

    local serverHopOpenPlayers

    ServerHopCurrentFavorite.MouseButton1Click:Connect(function()
        serverHopSetFavorite(serverHopBuildCurrentServer())
        serverHopUpdateCurrentCard()
    end)

    ServerHopCurrentPlayersButton.MouseButton1Click:Connect(function()
        serverHopOpenPlayers(serverHopBuildCurrentServer())
    end)

    setupButtonFeedback(ServerHopCurrentFavorite)
    setupButtonFeedback(ServerHopCurrentPlayersButton)

    local function serverHopTeleport(serverId)
        if not serverId or serverId == "" then
            showNotification("Некорректный ID сервера", C().Red)
            return
        end

        if serverId == game.JobId then
            showNotification("Это текущий сервер", C().Orange)
            return
        end

        showNotification(
            "Подключение к серверу...",
            C().Accent
        )

        local success, errorMessage = pcall(function()
            ServerHopTeleportService:TeleportToPlaceInstance(
                game.PlaceId,
                serverId,
                LocalPlayer
            )
        end)

        if not success then
            showNotification(
                "Не удалось подключиться",
                C().Red
            )

            warn(
                "[MEDA HUB] Server Hop error:",
                errorMessage
            )
        end
    end

    local function serverHopClearRows()
        for _, row in ipairs(serverHopRows) do
            if row and row.Parent then
                row:Destroy()
            end
        end

        table.clear(serverHopRows)
    end

    local function serverHopGetFavoriteList()
        local list = {}

        for serverId, savedData in pairs(serverHopFavoriteServers) do
            local currentData = nil

            if serverId == game.JobId then
                currentData = serverHopBuildCurrentServer()
            end

            for _, server in ipairs(serverHopServers) do
                if server.id == serverId then
                    currentData = server
                    break
                end
            end

            if currentData then
                table.insert(list, currentData)
            else
                table.insert(list, {
                    id = serverId,
                    name =
                        savedData.name
                        or ("Server " .. serverHopShortId(serverId)),
                    playing = nil,
                    maxPlayers = nil,
                    ping = nil
                })
            end
        end

        table.sort(list, function(a, b)
            return tostring(a.name) < tostring(b.name)
        end)

        return list
    end

    --====================================================--
    -- SERVER ROW
    --====================================================--

    local ServerHopPlayersPanel,
        ServerHopPlayersHeaderFrame,
        ServerHopPlayersCloseButton,
        ServerHopPlayersList =
        createPanel("ServerHopPlayersPanel", "ИГРОКИ СЕРВЕРА")

    local ServerHopPlayersInfo = createLabel(
        ServerHopPlayersList, "Выберите сервер",
        UDim2.new(1, -4, 0, 24), UDim2.fromOffset(0, 0),
        Enum.Font.Gotham, 10
    )
    ServerHopPlayersInfo.TextColor3 = C().SubText
    ServerHopPlayersInfo.ZIndex = 90

    local ServerHopPlayersDynamic = Instance.new("Frame")
    ServerHopPlayersDynamic.Parent = ServerHopPlayersList
    ServerHopPlayersDynamic.Size = UDim2.new(1, -4, 0, 0)
    ServerHopPlayersDynamic.BackgroundTransparency = 1
    ServerHopPlayersDynamic.BorderSizePixel = 0
    ServerHopPlayersDynamic.AutomaticSize = Enum.AutomaticSize.Y
    ServerHopPlayersDynamic.ZIndex = 90

    local ServerHopPlayersLayout = Instance.new("UIListLayout")
    ServerHopPlayersLayout.Parent = ServerHopPlayersDynamic
    ServerHopPlayersLayout.Padding = UDim.new(0, 4)
    ServerHopPlayersLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local function serverHopClearPlayerRows()
        for _, child in ipairs(ServerHopPlayersDynamic:GetChildren()) do
            if child:IsA("GuiObject") then child:Destroy() end
        end
    end

    local function serverHopAddPlayerRow(playerData)
        local row = Instance.new("Frame")
        row.Parent = ServerHopPlayersDynamic
        row.Size = UDim2.new(1, 0, 0, 46)
        row.BackgroundColor3 = C().Surface
        row.BorderSizePixel = 0
        row.ZIndex = 91
        addCorner(row, 8)
        addStroke(row, C().Stroke, 1, 0.15)

        local avatar = Instance.new("ImageLabel")
        avatar.Parent = row
        avatar.Size = UDim2.fromOffset(36, 36)
        avatar.Position = UDim2.fromOffset(5, 5)
        avatar.BackgroundColor3 = C().Surface2
        avatar.BorderSizePixel = 0
        avatar.Image = playerData.avatar or ""
        avatar.ZIndex = 92
        addCorner(avatar, 18)

        local display = playerData.displayName or playerData.name or "Unknown"
        local username = playerData.name and ("@" .. playerData.name) or ""
        local label = createLabel(
            row, display .. (username ~= "" and ("  " .. username) or ""),
            UDim2.new(1, -50, 1, 0), UDim2.fromOffset(48, 0),
            Enum.Font.GothamBold, 10
        )
        label.TextColor3 = C().Text
        label.TextTruncate = Enum.TextTruncate.AtEnd
        label.ZIndex = 92
    end

    serverHopOpenPlayers = function(server)
        serverHopClearPlayerRows()
        openPanel(ServerHopPlayersPanel)

        if server.id == game.JobId or server.isCurrent then
            local currentPlayers = Players:GetPlayers()
            ServerHopPlayersInfo.Text = "Игроков: " .. tostring(#currentPlayers)
            for _, player in ipairs(currentPlayers) do
                local avatar = ""
                pcall(function()
                    avatar = Players:GetUserThumbnailAsync(
                        player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48
                    )
                end)
                serverHopAddPlayerRow({
                    name = player.Name, displayName = player.DisplayName, avatar = avatar
                })
            end
            return
        end

        ServerHopPlayersInfo.Text = "Игроки удалённого сервера недоступны через стандартный API Roblox"
        local note = createLabel(
            ServerHopPlayersDynamic,
            "Roblox отдаёт для удалённых публичных серверов количество игроков, но не их имена/ID. Поэтому показывать выдуманный список было бы неправильно.",
            UDim2.new(1, 0, 0, 80), UDim2.fromOffset(0, 0),
            Enum.Font.Gotham, 10
        )
        note.TextColor3 = C().SubText
        note.TextWrapped = true
        note.TextXAlignment = Enum.TextXAlignment.Center
        note.TextYAlignment = Enum.TextYAlignment.Center
        note.ZIndex = 91
    end

    ServerHopPlayersCloseButton.MouseButton1Click:Connect(function()
        closePanel(ServerHopPlayersPanel)
    end)
    ServerHopPlayersHeaderFrame.InputBegan:Connect(function(input)
        beginDrag(ServerHopPlayersPanel, input)
    end)
    ServerHopPlayersPanel.Visible = false

    local function createServerHopRow(server)
        local row = Instance.new("Frame")
        row.Parent = ServerHopDynamicContainer
        row.Size = UDim2.new(1, 0, 0, 82)
        row.BackgroundColor3 = C().Surface
        row.BorderSizePixel = 0
        row.ZIndex = 71

        addCorner(row, 10)
        addStroke(row, C().Stroke, 1, 0.15)

        local nameLabel = createLabel(
            row,
            serverHopDisplayName(server),
            UDim2.new(1, -165, 0, 21),
            UDim2.fromOffset(10, 5),
            Enum.Font.GothamBold,
            11
        )

        nameLabel.TextColor3 = C().Text
        nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
        nameLabel.ZIndex = 73

        -- Более заметное количество игроков.
        local playerCount = tonumber(server.playing)

        local playersLabel = createLabel(
            row,
            playerCount
                and (
                    "●  "
                    .. tostring(playerCount)
                    .. " / "
                    .. tostring(tonumber(server.maxPlayers) or "?")
                    .. " ИГРОКОВ"
                )
                or "●  ИГРОКОВ  N/A",
            UDim2.new(0.62, 0, 0, 20),
            UDim2.fromOffset(10, 29),
            Enum.Font.GothamBold,
            10
        )

        playersLabel.TextColor3 = C().Accent
        playersLabel.ZIndex = 73

        local pingLabel = createLabel(
            row,
            serverHopPingText(server),
            UDim2.fromOffset(50, 18),
            UDim2.new(1, -115, 0, 28),
            Enum.Font.GothamBold,
            9
        )

        pingLabel.TextColor3 = serverHopPingColor(server.ping)
        pingLabel.TextXAlignment = Enum.TextXAlignment.Right
        pingLabel.ZIndex = 73

        local idLabel = createLabel(
            row,
            "#" .. serverHopShortId(server.id),
            UDim2.fromOffset(100, 15),
            UDim2.fromOffset(10, 58),
            Enum.Font.Gotham,
            8
        )

        idLabel.TextColor3 = C().SubText
        idLabel.ZIndex = 73

        local favoriteButton = Instance.new("TextButton")
        favoriteButton.Parent = row
        favoriteButton.Size = UDim2.fromOffset(27, 27)
        favoriteButton.Position = UDim2.new(1, -145, 0, 5)
        favoriteButton.BackgroundColor3 = C().Surface2
        favoriteButton.BorderSizePixel = 0
        favoriteButton.Text =
            serverHopIsFavorite(server.id)
            and "★"
            or "☆"
        favoriteButton.TextColor3 =
            serverHopIsFavorite(server.id)
            and C().Orange
            or C().SubText
        favoriteButton.Font = Enum.Font.GothamBold
        favoriteButton.TextSize = 16
        favoriteButton.AutoButtonColor = false
        favoriteButton.ZIndex = 75

        addCorner(favoriteButton, 7)

        favoriteButton.MouseButton1Click:Connect(function()
            serverHopSetFavorite(server)

            favoriteButton.Text =
                serverHopIsFavorite(server.id)
                and "★"
                or "☆"

            favoriteButton.TextColor3 =
                serverHopIsFavorite(server.id)
                and C().Orange
                or C().SubText

            if serverHopTab == "FAVORITES" then
                task.defer(function()
                    if ServerHopPanel.Visible then
                        -- Только при открытой вкладке избранного.
                        serverHopClearRows()
                        -- render defined below; schedule through flag.
                        serverHopPage = 1
                        local list = serverHopGetFavoriteList()

                        local startIndex =
                            ((serverHopPage - 1) * SERVER_HOP_ROWS_PER_PAGE)
                            + 1

                        local endIndex =
                            math.min(
                                startIndex + SERVER_HOP_ROWS_PER_PAGE - 1,
                                #list
                            )

                        for index = startIndex, endIndex do
                            createServerHopRow(list[index])
                        end
                    end
                end)
            end
        end)

        local joinButton = Instance.new("TextButton")
        joinButton.Parent = row
        joinButton.Size = UDim2.fromOffset(55, 27)
        joinButton.Position = UDim2.new(1, -60, 0, 46)
        joinButton.BackgroundColor3 = C().Accent
        joinButton.BorderSizePixel = 0
        joinButton.Text = "JOIN"
        joinButton.TextColor3 = Color3.new(1, 1, 1)
        joinButton.Font = Enum.Font.GothamBold
        joinButton.TextSize = 8
        joinButton.AutoButtonColor = false
        joinButton.ZIndex = 75

        addCorner(joinButton, 7)

        joinButton.MouseButton1Click:Connect(function()
            serverHopTeleport(server.id)
        end)

        setupButtonFeedback(favoriteButton)
        setupButtonFeedback(joinButton)

        table.insert(serverHopRows, row)

        return row
    end

    --====================================================--
    -- SORT
    --====================================================--

    local function serverHopSortServers()
        table.sort(serverHopServers, function(a, b)
            local aPlayers = tonumber(a.playing) or 0
            local bPlayers = tonumber(b.playing) or 0

            if aPlayers == bPlayers then
                return tostring(a.id) < tostring(b.id)
            end

            if serverHopSortMode == "DESC" then
                return aPlayers > bPlayers
            end

            return aPlayers < bPlayers
        end)
    end

    --====================================================--
    -- RENDER ONLY CURRENT PAGE
    --====================================================--

    local function serverHopGetCurrentList()
        if serverHopTab == "FAVORITES" then
            return serverHopGetFavoriteList()
        end

        return serverHopServers
    end

    local function serverHopRender()
        serverHopClearRows()

        local list = serverHopGetCurrentList()
        local totalPages =
            math.max(
                1,
                math.ceil(#list / SERVER_HOP_ROWS_PER_PAGE)
            )

        if serverHopPage > totalPages then
            serverHopPage = totalPages
        end

        if serverHopPage < 1 then
            serverHopPage = 1
        end

        local startIndex =
            ((serverHopPage - 1) * SERVER_HOP_ROWS_PER_PAGE)
            + 1

        local endIndex =
            math.min(
                startIndex + SERVER_HOP_ROWS_PER_PAGE - 1,
                #list
            )

        if #list == 0 then
            local emptyLabel = createLabel(
                ServerHopDynamicContainer,
                serverHopTab == "FAVORITES"
                    and "Нет сохранённых серверов"
                    or "Серверы не найдены",
                UDim2.new(1, 0, 0, 50),
                UDim2.fromOffset(0, 0),
                Enum.Font.GothamBold,
                10
            )

            emptyLabel.TextColor3 = C().SubText
            emptyLabel.TextXAlignment = Enum.TextXAlignment.Center
            emptyLabel.ZIndex = 72

            table.insert(serverHopRows, emptyLabel)
        else
            for index = startIndex, endIndex do
                createServerHopRow(list[index])
            end
        end

        ServerHopPageLabel.Text =
            tostring(serverHopPage)
            .. " / "
            .. tostring(totalPages)

        ServerHopPrevButton.BackgroundColor3 =
            serverHopPage > 1
            and C().Surface
            or C().Surface2

        ServerHopNextButton.BackgroundColor3 =
            serverHopPage < totalPages
            and C().Surface
            or C().Surface2

        if serverHopTab == "FAVORITES" then
            ServerHopInfo.Text =
                "Избранных серверов: "
                .. tostring(#list)
        else
            ServerHopInfo.Text =
                "Серверов: "
                .. tostring(#list)
                .. "  •  Страница "
                .. tostring(serverHopPage)
                .. "/"
                .. tostring(totalPages)
        end
    end

    --====================================================--
    -- HTTP
    --====================================================--

    local function serverHopHttpGet(url)
        local requestFunction =
            (syn and syn.request)
            or (http and http.request)
            or (http_request)
            or (request)

        if type(requestFunction) == "function" then
            local success, response = pcall(function()
                return requestFunction({
                    Url = url,
                    Method = "GET"
                })
            end)

            if success and type(response) == "table" then
                local body =
                    response.Body
                    or response.body

                if type(body) == "string" and body ~= "" then
                    return body
                end
            end
        end

        if type(game.HttpGet) == "function" then
            return game:HttpGet(url)
        end

        error("HTTP request function is unavailable")
    end

    --====================================================--
    -- FETCH
    --====================================================--

    local function serverHopFetchServers()
        if serverHopLoading then
            return
        end

        serverHopLoading = true

        ServerHopRefreshButton.Text = "↻  ЗАГРУЗКА..."
        ServerHopRefreshButton.Active = false
        ServerHopInfo.Text = "Получение списка серверов..."

        local fetchedServers = {}
        local cursor = nil

        local success, errorMessage = pcall(function()

            for page = 1, SERVER_HOP_MAX_PAGES do

                local url =
                    SERVER_HOP_API
                    .. "?sortOrder=Desc"
                    .. "&excludeFullGames=false"
                    .. "&limit="
                    .. tostring(SERVER_HOP_PAGE_LIMIT)

                if cursor and cursor ~= "" then
                    url =
                        url
                        .. "&cursor="
                        .. ServerHopHttpService:UrlEncode(cursor)
                end

                local response = serverHopHttpGet(url)
                local decoded =
                    ServerHopHttpService:JSONDecode(response)

                if type(decoded) ~= "table" then
                    break
                end

                if type(decoded.data) == "table" then
                    for _, server in ipairs(decoded.data) do
                        if type(server) == "table"
                            and type(server.id) == "string"
                            and server.id ~= game.JobId
                        then
                            fetchedServers[server.id] = {
                                id = server.id,
                                name =
                                    server.name
                                    or (
                                        "Server "
                                        .. serverHopShortId(server.id)
                                    ),
                                playing =
                                    tonumber(server.playing) or 0,
                                maxPlayers =
                                    tonumber(server.maxPlayers) or 0,
                                -- Roblox public server endpoint can
                                -- provide the server's reported ping.
                                ping =
                                    tonumber(server.ping)
                            }
                        end
                    end
                end

                cursor = decoded.nextPageCursor

                if not cursor or cursor == "" then
                    break
                end

                -- Маленькая пауза между страницами, чтобы не
                -- забивать главный поток.
                task.wait(0.1)
            end
        end)

        if not success then
            serverHopLoading = false
            ServerHopRefreshButton.Text = "↻  ОБНОВИТЬ"
            ServerHopRefreshButton.Active = true
            ServerHopInfo.Text = "Ошибка получения серверов"

            showNotification(
                "Не удалось получить серверы",
                C().Red
            )

            warn(
                "[MEDA HUB] Server list error:",
                errorMessage
            )

            return
        end

        table.clear(serverHopServers)

        -- Текущий сервер отображается отдельной закреплённой карточкой сверху.
        for _, server in pairs(fetchedServers) do
            table.insert(serverHopServers, server)
        end

        serverHopSortServers()

        serverHopPage = 1
        serverHopRender()

        serverHopLoading = false

        ServerHopRefreshButton.Text = "↻  ОБНОВИТЬ"
        ServerHopRefreshButton.Active = true

        showNotification(
            "Список серверов обновлён",
            C().Green
        )
    end

    --====================================================--
    -- TAB UPDATE
    --====================================================--

    local function serverHopUpdateTabs()
        if serverHopTab == "SERVERS" then
            ServerHopServersTab.BackgroundColor3 = C().Accent
            ServerHopServersTab.TextColor3 = Color3.new(1, 1, 1)

            ServerHopFavoritesTab.BackgroundColor3 = C().Surface
            ServerHopFavoritesTab.TextColor3 = C().Text

            ServerHopSortFrame.Visible = true
        else
            ServerHopServersTab.BackgroundColor3 = C().Surface
            ServerHopServersTab.TextColor3 = C().Text

            ServerHopFavoritesTab.BackgroundColor3 = C().Accent
            ServerHopFavoritesTab.TextColor3 = Color3.new(1, 1, 1)

            ServerHopSortFrame.Visible = false
        end
    end

    --====================================================--
    -- CONTROLS
    --====================================================--

    ServerHopServersTab.MouseButton1Click:Connect(function()
        serverHopTab = "SERVERS"
        serverHopPage = 1

        serverHopUpdateTabs()
        serverHopRender()
    end)

    ServerHopFavoritesTab.MouseButton1Click:Connect(function()
        serverHopTab = "FAVORITES"
        serverHopPage = 1

        serverHopUpdateTabs()
        serverHopRender()
    end)

    ServerHopSortPlayersMore.MouseButton1Click:Connect(function()
        serverHopSortMode = "DESC"
        serverHopPage = 1

        serverHopSortServers()
        serverHopRender()
    end)

    ServerHopSortPlayersLess.MouseButton1Click:Connect(function()
        serverHopSortMode = "ASC"
        serverHopPage = 1

        serverHopSortServers()
        serverHopRender()
    end)

    ServerHopPrevButton.MouseButton1Click:Connect(function()
        if serverHopPage > 1 then
            serverHopPage = serverHopPage - 1
            serverHopRender()
        end
    end)

    ServerHopNextButton.MouseButton1Click:Connect(function()
        local list = serverHopGetCurrentList()

        local totalPages =
            math.max(
                1,
                math.ceil(#list / SERVER_HOP_ROWS_PER_PAGE)
            )

        if serverHopPage < totalPages then
            serverHopPage = serverHopPage + 1
            serverHopRender()
        end
    end)

    ServerHopRefreshButton.MouseButton1Click:Connect(function()
        task.spawn(serverHopFetchServers)
    end)

    ServerHopCloseButton.MouseButton1Click:Connect(function()
        closePanel(ServerHopPanel)
        MenuFrame.Visible = true
    end)

    Players.PlayerAdded:Connect(function()
        serverHopUpdateCurrentCard()
        if ServerHopPlayersPanel.Visible then
            local current = serverHopBuildCurrentServer()
            serverHopOpenPlayers(current)
        end
    end)

    Players.PlayerRemoving:Connect(function()
        task.defer(serverHopUpdateCurrentCard)
        if ServerHopPlayersPanel.Visible then
            task.defer(function()
                local current = serverHopBuildCurrentServer()
                serverHopOpenPlayers(current)
            end)
        end
    end)

    ServerHopHeaderFrame.InputBegan:Connect(function(input)
        beginDrag(ServerHopPanel, input)
    end)

    --====================================================--
    -- MAIN MENU BUTTON
    --====================================================--

    local ServerHopButton = Instance.new("TextButton")
    ServerHopButton.Parent = Content
    ServerHopButton.Size = UDim2.fromOffset(198, 58)
    ServerHopButton.Position = UDim2.fromOffset(0, 230)
    ServerHopButton.BackgroundColor3 = C().Surface
    ServerHopButton.BorderSizePixel = 0
    ServerHopButton.Text = ""
    ServerHopButton.AutoButtonColor = false
    ServerHopButton.ZIndex = 12

    addCorner(ServerHopButton, 11)
    addStroke(
        ServerHopButton,
        C().Stroke,
        1,
        0.2
    )

    local ServerHopIcon = Instance.new("Frame")
    ServerHopIcon.Parent = ServerHopButton
    ServerHopIcon.Size = UDim2.fromOffset(36, 36)
    ServerHopIcon.Position = UDim2.fromOffset(10, 11)
    ServerHopIcon.BackgroundColor3 = C().Surface2
    ServerHopIcon.BorderSizePixel = 0
    ServerHopIcon.ZIndex = 13

    addCorner(ServerHopIcon, 9)

    local ServerHopIconText = createLabel(
        ServerHopIcon,
        "⇄",
        UDim2.fromScale(1, 1),
        UDim2.fromScale(0, 0),
        Enum.Font.GothamBold,
        17
    )

    ServerHopIconText.TextXAlignment =
        Enum.TextXAlignment.Center
    ServerHopIconText.TextColor3 = C().Accent
    ServerHopIconText.ZIndex = 14

    local ServerHopTitle = createLabel(
        ServerHopButton,
        "Server Hop",
        UDim2.fromOffset(125, 21),
        UDim2.fromOffset(56, 8),
        Enum.Font.GothamBold,
        12
    )

    ServerHopTitle.ZIndex = 14

    local ServerHopStatus = createLabel(
        ServerHopButton,
        "Список серверов",
        UDim2.fromOffset(125, 18),
        UDim2.fromOffset(56, 31),
        Enum.Font.Gotham,
        10
    )

    ServerHopStatus.TextColor3 = C().SubText
    ServerHopStatus.ZIndex = 14

    setupButtonFeedback(ServerHopButton)

    ServerHopButton.MouseButton1Click:Connect(function()
        MenuFrame.Visible = false
        openPanel(ServerHopPanel)
        serverHopUpdateCurrentCard()

        -- Открытие панели больше не рендерит сотни объектов.
        -- Рисуем только текущую страницу и параллельно обновляем данные.
        serverHopTab = "SERVERS"
        serverHopPage = 1
        serverHopUpdateTabs()
        serverHopRender()

        task.spawn(serverHopFetchServers)
    end)

    --====================================================--
    -- THEME SUPPORT
    --====================================================--

    ThemeButton.MouseButton1Click:Connect(function()
        task.defer(function()
            if not ServerHopPanel
                or not ServerHopPanel.Parent
            then
                return
            end

            ServerHopPanel.BackgroundColor3 =
                C().Background

            ServerHopHeaderFrame.BackgroundColor3 =
                C().Header

            ServerHopInfo.TextColor3 =
                C().SubText

            ServerHopServersTab.BackgroundColor3 =
                serverHopTab == "SERVERS"
                and C().Accent
                or C().Surface

            ServerHopServersTab.TextColor3 =
                serverHopTab == "SERVERS"
                and Color3.new(1, 1, 1)
                or C().Text

            ServerHopFavoritesTab.BackgroundColor3 =
                serverHopTab == "FAVORITES"
                and C().Accent
                or C().Surface

            ServerHopFavoritesTab.TextColor3 =
                serverHopTab == "FAVORITES"
                and Color3.new(1, 1, 1)
                or C().Text

            ServerHopSortPlayersMore.BackgroundColor3 =
                C().Surface

            ServerHopSortPlayersMore.TextColor3 =
                C().Text

            ServerHopSortPlayersLess.BackgroundColor3 =
                C().Surface

            ServerHopSortPlayersLess.TextColor3 =
                C().Text

            ServerHopRefreshButton.BackgroundColor3 =
                C().Accent

            ServerHopPrevButton.BackgroundColor3 =
                C().Surface

            ServerHopNextButton.BackgroundColor3 =
                C().Surface

            ServerHopIcon.BackgroundColor3 =
                C().Surface2

            ServerHopIconText.TextColor3 =
                C().Accent

            ServerHopTitle.TextColor3 =
                C().Text

            ServerHopStatus.TextColor3 =
                C().SubText

            ServerHopPlayersPanel.BackgroundColor3 =
                C().Background

            ServerHopPlayersHeaderFrame.BackgroundColor3 =
                C().Header

            ServerHopPlayersInfo.TextColor3 =
                C().SubText
            ServerHopCurrentCard.BackgroundColor3 = C().Surface
            ServerHopCurrentTitle.TextColor3 = C().Text
            ServerHopCurrentPlayers.TextColor3 = C().Accent
            ServerHopCurrentPing.TextColor3 = serverHopPingColor(serverHopBuildCurrentServer().ping)
            ServerHopCurrentId.TextColor3 = C().SubText
            ServerHopCurrentFavorite.BackgroundColor3 = C().Surface2
            ServerHopCurrentPlayersButton.BackgroundColor3 = C().Surface2
            ServerHopCurrentPlayersButton.TextColor3 = C().Text
            ServerHopCurrentJoin.BackgroundColor3 = C().Surface2
            ServerHopCurrentJoin.TextColor3 = C().SubText

            -- Перерисовываем максимум 20 строк.
            serverHopRender()
        end)
    end)

    setupButtonFeedback(
        ServerHopServersTab
    )

    setupButtonFeedback(
        ServerHopFavoritesTab
    )

    setupButtonFeedback(
        ServerHopSortPlayersMore
    )

    setupButtonFeedback(
        ServerHopSortPlayersLess
    )

    setupButtonFeedback(
        ServerHopRefreshButton
    )

    setupButtonFeedback(
        ServerHopPrevButton
    )

    setupButtonFeedback(
        ServerHopNextButton
    )

    serverHopUpdateTabs()

    serverHopUpdateCurrentCard()
    ServerHopPanel.Visible = false
    ServerHopStatus.Text = "Список серверов"

    print(
        "[MEDA HUB] Optimized Server Hop extension loaded"
    )

end, debug.traceback)

if not serverHopExtensionOk then
    warn(
        "[MEDA HUB] Server Hop failed to initialize:",
        serverHopExtensionError
    )
end
