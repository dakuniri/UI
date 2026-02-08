--[[
    ███╗   ███╗ █████╗  ██████╗    ██╗   ██╗██╗
    ████╗ ████║██╔══██╗██╔════╝    ██║   ██║██║
    ██╔████╔██║███████║██║         ██║   ██║██║
    ██║╚██╔╝██║██╔══██║██║         ██║   ██║██║
    ██║ ╚═╝ ██║██║  ██║╚██████╗    ╚██████╔╝██║
    ╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝     ╚═════╝ ╚═╝
    
    Mac UI Library - v1.5.0
    Acrylic Glass - 透明感のあるUIライブラリ
]]

local MacUI = {}
MacUI.__index = MacUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer

-- macOSカラーテーマ（透明感重視）
local Theme = {
    Background = Color3.fromRGB(20, 20, 25),
    Surface = Color3.fromRGB(35, 35, 42),
    Accent = Color3.fromRGB(88, 166, 255),
    AccentDark = Color3.fromRGB(60, 120, 200),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(140, 145, 160),
    Border = Color3.fromRGB(80, 85, 100),
    Red = Color3.fromRGB(255, 95, 87),
    Yellow = Color3.fromRGB(255, 189, 46),
    Green = Color3.fromRGB(39, 201, 63),
    Glow = Color3.fromRGB(88, 166, 255)
}

local Settings = {
    AnimSpeed = 0.25,
    Transparency = 0.45,
    AcrylicBlur = 0.6
}

local GlobalElements = {
    ScreenGui = nil,
    MainFrame = nil
}

-- ユーティリティ
local function Tween(obj, props, time)
    local tween = TweenService:Create(obj, TweenInfo.new(time or Settings.AnimSpeed, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

local function AddCorner(obj, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 10)
    corner.Parent = obj
    return corner
end

local function AddStroke(obj, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Theme.Border
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0.6
    stroke.Parent = obj
    return stroke
end

local function AddGlow(obj, color)
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.Size = UDim2.new(1, 40, 1, 40)
    glow.Position = UDim2.new(0, -20, 0, -20)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://5028857084"
    glow.ImageColor3 = color or Theme.Glow
    glow.ImageTransparency = 0.9
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(24, 24, 276, 276)
    glow.ZIndex = 0
    glow.Parent = obj
    return glow
end

local function AddGradient(obj, colors)
    local gradient = Instance.new("UIGradient")
    gradient.Color = colors or ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 65, 80)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 38, 50))
    })
    gradient.Rotation = 45
    gradient.Parent = obj
    return gradient
end

-- メイン
function MacUI:CreateWindow(Config)
    Config = Config or {}
    Config.Title = Config.Title or "Mac UI"
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MacUI_" .. math.random(1000, 9999)
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    GlobalElements.ScreenGui = ScreenGui
    
    pcall(function()
        ScreenGui.Parent = CoreGui
    end)
    if not ScreenGui.Parent then
        ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    end
    
    -- 画面サイズ検出
    local ViewportSize = workspace.CurrentCamera.ViewportSize
    local ScreenWidth = ViewportSize.X
    local ScreenHeight = ViewportSize.Y
    local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    
    -- レスポンシブサイズ計算
    local WindowWidth = math.clamp(ScreenWidth * 0.75, 320, 650)
    local WindowHeight = math.clamp(ScreenHeight * 0.65, 250, 400)
    local SidebarWidth = math.clamp(WindowWidth * 0.24, 100, 160)
    
    -- アクリルブラーレイヤー1 (最背面)
    local AcrylicLayer1 = Instance.new("Frame")
    AcrylicLayer1.Name = "AcrylicLayer1"
    AcrylicLayer1.Size = UDim2.new(0, WindowWidth + 20, 0, WindowHeight + 20)
    AcrylicLayer1.Position = UDim2.new(0.5, -(WindowWidth + 20) / 2, 0.5, -(WindowHeight + 20) / 2)
    AcrylicLayer1.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    AcrylicLayer1.BackgroundTransparency = 0.3
    AcrylicLayer1.BorderSizePixel = 0
    AcrylicLayer1.ZIndex = 0
    AcrylicLayer1.Parent = ScreenGui
    AddCorner(AcrylicLayer1, 18)
    
    -- アクリルブラーレイヤー2
    local AcrylicLayer2 = Instance.new("Frame")
    AcrylicLayer2.Name = "AcrylicLayer2"
    AcrylicLayer2.Size = UDim2.new(0, WindowWidth + 10, 0, WindowHeight + 10)
    AcrylicLayer2.Position = UDim2.new(0.5, -(WindowWidth + 10) / 2, 0.5, -(WindowHeight + 10) / 2)
    AcrylicLayer2.BackgroundColor3 = Color3.fromRGB(25, 28, 35)
    AcrylicLayer2.BackgroundTransparency = 0.5
    AcrylicLayer2.BorderSizePixel = 0
    AcrylicLayer2.ZIndex = 1
    AcrylicLayer2.Parent = ScreenGui
    AddCorner(AcrylicLayer2, 16)
    
    -- メインウィンドウ
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, WindowWidth, 0, WindowHeight)
    MainFrame.Position = UDim2.new(0.5, -WindowWidth / 2, 0.5, -WindowHeight / 2)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BackgroundTransparency = Settings.Transparency
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    GlobalElements.MainFrame = MainFrame
    GlobalElements.AcrylicLayer1 = AcrylicLayer1
    GlobalElements.AcrylicLayer2 = AcrylicLayer2
    GlobalElements.WindowWidth = WindowWidth
    GlobalElements.WindowHeight = WindowHeight
    GlobalElements.SidebarWidth = SidebarWidth
    AddCorner(MainFrame, 14)
    AddStroke(MainFrame, Color3.fromRGB(100, 105, 120), 1, 0.4)
    
    -- モバイル用トグルボタン
    local MobileToggle
    local UIVisible = true
    
    if IsMobile then
        MobileToggle = Instance.new("TextButton")
        MobileToggle.Name = "MobileToggle"
        MobileToggle.Size = UDim2.new(0, 50, 0, 50)
        MobileToggle.Position = UDim2.new(0, 10, 0, 10)
        MobileToggle.BackgroundColor3 = Theme.Accent
        MobileToggle.BackgroundTransparency = 0.3
        MobileToggle.Text = "MC"
        MobileToggle.TextColor3 = Theme.Text
        MobileToggle.TextSize = 16
        MobileToggle.Font = Enum.Font.GothamBold
        MobileToggle.ZIndex = 100
        MobileToggle.Parent = ScreenGui
        AddCorner(MobileToggle, 12)
        AddStroke(MobileToggle, Theme.Border, 1, 0.5)
        
        MobileToggle.MouseButton1Click:Connect(function()
            UIVisible = not UIVisible
            MainFrame.Visible = UIVisible
            AcrylicLayer1.Visible = UIVisible
            AcrylicLayer2.Visible = UIVisible
            Tween(MobileToggle, {BackgroundTransparency = UIVisible and 0.3 or 0.6}, 0.2)
        end)
    end
    
    -- アンビエントグロー
    local AmbientGlow = Instance.new("Frame")
    AmbientGlow.Size = UDim2.new(1, 60, 1, 60)
    AmbientGlow.Position = UDim2.new(0, -30, 0, -30)
    AmbientGlow.BackgroundColor3 = Theme.Accent
    AmbientGlow.BackgroundTransparency = 0.95
    AmbientGlow.BorderSizePixel = 0
    AmbientGlow.ZIndex = 0
    AmbientGlow.Parent = MainFrame
    AddCorner(AmbientGlow, 30)
    
    -- タイトルバー (ガラス風)
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 36)
    TitleBar.BackgroundColor3 = Theme.Surface
    TitleBar.BackgroundTransparency = 0.3
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 14)
    TitleCorner.Parent = TitleBar
    
    AddGradient(TitleBar, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 58, 70)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 42, 52))
    }))
    
    -- タイトルバー下部の角を埋める
    local TitleFill = Instance.new("Frame")
    TitleFill.Size = UDim2.new(1, 0, 0, 14)
    TitleFill.Position = UDim2.new(0, 0, 1, -14)
    TitleFill.BackgroundColor3 = Theme.Surface
    TitleFill.BackgroundTransparency = 0.3
    TitleFill.BorderSizePixel = 0
    TitleFill.Parent = TitleBar
    
    -- 信号機ボタン (macOS風、グロー付き)
    local function CreateTrafficButton(color, position, callback, glowColor)
        local btnContainer = Instance.new("Frame")
        btnContainer.Size = UDim2.new(0, 20, 0, 20)
        btnContainer.Position = position + UDim2.new(0, -4, 0, -4)
        btnContainer.BackgroundTransparency = 1
        btnContainer.Parent = TitleBar
        
        -- グロー
        local glow = Instance.new("Frame")
        glow.Size = UDim2.new(0, 20, 0, 20)
        glow.Position = UDim2.new(0, 0, 0, 0)
        glow.BackgroundColor3 = glowColor or color
        glow.BackgroundTransparency = 0.9
        glow.BorderSizePixel = 0
        glow.Parent = btnContainer
        AddCorner(glow, 10)
        
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 12, 0, 12)
        btn.Position = UDim2.new(0, 4, 0, 4)
        btn.BackgroundColor3 = color
        btn.Text = ""
        btn.Parent = btnContainer
        AddCorner(btn, 6)
        
        -- 内側のハイライト
        local highlight = Instance.new("Frame")
        highlight.Size = UDim2.new(0.6, 0, 0.3, 0)
        highlight.Position = UDim2.new(0.2, 0, 0.15, 0)
        highlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        highlight.BackgroundTransparency = 0.7
        highlight.BorderSizePixel = 0
        highlight.Parent = btn
        AddCorner(highlight, 3)
        
        btn.MouseEnter:Connect(function()
            Tween(glow, {BackgroundTransparency = 0.6, Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(0, -2, 0, -2)}, 0.15)
            Tween(btn, {Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 3, 0, 3)}, 0.15)
        end)
        btn.MouseLeave:Connect(function()
            Tween(glow, {BackgroundTransparency = 0.9, Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 0, 0, 0)}, 0.15)
            Tween(btn, {Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(0, 4, 0, 4)}, 0.15)
        end)
        btn.MouseButton1Click:Connect(callback)
        
        return btn
    end
    
    local Minimized = false
    local OriginalSize = UDim2.new(0, 650, 0, 400)
    local OriginalAcrylic1Size = UDim2.new(0, 670, 0, 420)
    local OriginalAcrylic2Size = UDim2.new(0, 660, 0, 410)
    
    -- 閉じるボタン（赤）
    CreateTrafficButton(Theme.Red, UDim2.new(0, 14, 0, 12), function()
        Tween(AcrylicLayer1, {BackgroundTransparency = 1, Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        Tween(AcrylicLayer2, {BackgroundTransparency = 1, Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.3).Completed:Connect(function()
            ScreenGui:Destroy()
        end)
    end, Color3.fromRGB(255, 120, 120))
    
    -- 最小化ボタン（黄）
    CreateTrafficButton(Theme.Yellow, UDim2.new(0, 36, 0, 12), function()
        Minimized = not Minimized
        if Minimized then
            Tween(MainFrame, {Size = UDim2.new(0, 650, 0, 36)}, 0.25)
            Tween(AcrylicLayer1, {Size = UDim2.new(0, 670, 0, 56)}, 0.25)
            Tween(AcrylicLayer2, {Size = UDim2.new(0, 660, 0, 46)}, 0.25)
        else
            Tween(MainFrame, {Size = OriginalSize}, 0.25)
            Tween(AcrylicLayer1, {Size = OriginalAcrylic1Size}, 0.25)
            Tween(AcrylicLayer2, {Size = OriginalAcrylic2Size}, 0.25)
        end
    end, Color3.fromRGB(255, 210, 100))
    
    -- 最大化ボタン（緑）
    CreateTrafficButton(Theme.Green, UDim2.new(0, 58, 0, 12), function()
        if MainFrame.Size == OriginalSize then
            Tween(MainFrame, {Size = UDim2.new(0, 900, 0, 550), Position = UDim2.new(0.5, -450, 0.5, -275)}, 0.3)
            Tween(AcrylicLayer1, {Size = UDim2.new(0, 920, 0, 570), Position = UDim2.new(0.5, -460, 0.5, -285)}, 0.3)
            Tween(AcrylicLayer2, {Size = UDim2.new(0, 910, 0, 560), Position = UDim2.new(0.5, -455, 0.5, -280)}, 0.3)
        else
            Tween(MainFrame, {Size = OriginalSize, Position = UDim2.new(0.5, -325, 0.5, -200)}, 0.3)
            Tween(AcrylicLayer1, {Size = OriginalAcrylic1Size, Position = UDim2.new(0.5, -335, 0.5, -210)}, 0.3)
            Tween(AcrylicLayer2, {Size = OriginalAcrylic2Size, Position = UDim2.new(0.5, -330, 0.5, -205)}, 0.3)
        end
    end, Color3.fromRGB(100, 230, 120))
    
    -- タイトル
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, 0, 1, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Config.Title
    TitleLabel.TextColor3 = Theme.Text
    TitleLabel.TextSize = 14
    TitleLabel.Font = Enum.Font.GothamMedium
    TitleLabel.Parent = TitleBar
    
    -- ドラッグ
    local dragging, dragStart, startPos
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            AcrylicLayer1.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X - 10, startPos.Y.Scale, startPos.Y.Offset + delta.Y - 10)
            AcrylicLayer2.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X - 5, startPos.Y.Scale, startPos.Y.Offset + delta.Y - 5)
        end
    end)
    
    -- サイドバー（ガラス風）
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, SidebarWidth, 1, -36)
    Sidebar.Position = UDim2.new(0, 0, 0, 36)
    Sidebar.BackgroundColor3 = Theme.Surface
    Sidebar.BackgroundTransparency = 0.5
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    
    AddGradient(Sidebar, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 52, 65)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 37, 48))
    }))
    
    local SidebarList = Instance.new("UIListLayout")
    SidebarList.Padding = UDim.new(0, 6)
    SidebarList.Parent = Sidebar
    
    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.PaddingTop = UDim.new(0, 10)
    SidebarPadding.PaddingLeft = UDim.new(0, 10)
    SidebarPadding.PaddingRight = UDim.new(0, 10)
    SidebarPadding.Parent = Sidebar
    
    -- 区切り線
    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(0, 1, 1, -36)
    Divider.Position = UDim2.new(0, SidebarWidth, 0, 36)
    Divider.BackgroundColor3 = Theme.Border
    Divider.BackgroundTransparency = 0.7
    Divider.BorderSizePixel = 0
    Divider.Parent = MainFrame
    
    -- コンテンツエリア
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -SidebarWidth, 1, -36)
    ContentArea.Position = UDim2.new(0, SidebarWidth, 0, 36)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainFrame
    
    local Window = {}
    local Tabs = {}
    local CurrentTab = nil
    
    -- タブ作成
    function Window:CreateTab(Name)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = Name
        TabButton.Size = UDim2.new(1, 0, 0, 36)
        TabButton.BackgroundColor3 = Theme.Accent
        TabButton.BackgroundTransparency = 1
        TabButton.Text = ""
        TabButton.Parent = Sidebar
        AddCorner(TabButton, 8)
        
        -- アイコン風インジケーター
        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 4, 0, 20)
        Indicator.Position = UDim2.new(0, 0, 0.5, -10)
        Indicator.BackgroundColor3 = Theme.Accent
        Indicator.BackgroundTransparency = 1
        Indicator.BorderSizePixel = 0
        Indicator.Parent = TabButton
        AddCorner(Indicator, 2)
        
        local TabLabel = Instance.new("TextLabel")
        TabLabel.Size = UDim2.new(1, -16, 1, 0)
        TabLabel.Position = UDim2.new(0, 16, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = Name
        TabLabel.TextColor3 = Theme.SubText
        TabLabel.TextSize = 13
        TabLabel.Font = Enum.Font.GothamMedium
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabButton
        
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = Name .. "Content"
        TabContent.Size = UDim2.new(1, -24, 1, -24)
        TabContent.Position = UDim2.new(0, 12, 0, 12)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 3
        TabContent.ScrollBarImageColor3 = Theme.Accent
        TabContent.ScrollBarImageTransparency = 0.3
        TabContent.Visible = false
        TabContent.Parent = ContentArea
        
        local ContentList = Instance.new("UIListLayout")
        ContentList.Padding = UDim.new(0, 10)
        ContentList.Parent = TabContent
        
        ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 20)
        end)
        
        local Tab = {Button = TabButton, Content = TabContent, Label = TabLabel, Indicator = Indicator}
        
        TabButton.MouseEnter:Connect(function()
            if CurrentTab ~= Tab then
                Tween(TabButton, {BackgroundTransparency = 0.85}, 0.15)
                Tween(TabLabel, {TextColor3 = Theme.Text}, 0.15)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if CurrentTab ~= Tab then
                Tween(TabButton, {BackgroundTransparency = 1}, 0.15)
                Tween(TabLabel, {TextColor3 = Theme.SubText}, 0.15)
            end
        end)
        
        TabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(Tabs) do
                t.Content.Visible = false
                Tween(t.Button, {BackgroundTransparency = 1}, 0.2)
                Tween(t.Label, {TextColor3 = Theme.SubText}, 0.2)
                Tween(t.Indicator, {BackgroundTransparency = 1}, 0.2)
            end
            TabContent.Visible = true
            Tween(TabButton, {BackgroundTransparency = 0.75}, 0.2)
            Tween(TabLabel, {TextColor3 = Theme.Text}, 0.2)
            Tween(Indicator, {BackgroundTransparency = 0}, 0.2)
            CurrentTab = Tab
        end)
        
        if #Tabs == 0 then
            TabContent.Visible = true
            TabButton.BackgroundTransparency = 0.75
            TabLabel.TextColor3 = Theme.Text
            Indicator.BackgroundTransparency = 0
            CurrentTab = Tab
        end
        
        table.insert(Tabs, Tab)
        
        local TabInit = {}
        
        -- ボタン (モダンスタイル)
        function TabInit:CreateButton(Text, Callback)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 0, 40)
            Button.BackgroundColor3 = Theme.Surface
            Button.BackgroundTransparency = 0.4
            Button.Text = Text
            Button.TextColor3 = Theme.Text
            Button.TextSize = 13
            Button.Font = Enum.Font.GothamMedium
            Button.Parent = TabContent
            AddCorner(Button, 10)
            AddStroke(Button, Theme.Border, 1, 0.7)
            
            Button.MouseEnter:Connect(function()
                Tween(Button, {BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0.3}, 0.2)
            end)
            Button.MouseLeave:Connect(function()
                Tween(Button, {BackgroundColor3 = Theme.Surface, BackgroundTransparency = 0.4}, 0.2)
            end)
            Button.MouseButton1Click:Connect(function()
                Tween(Button, {BackgroundTransparency = 0.1}, 0.1)
                task.wait(0.1)
                Tween(Button, {BackgroundTransparency = 0.3}, 0.1)
                pcall(Callback)
            end)
            
            return Button
        end
        
        -- トグル (iOS風)
        function TabInit:CreateToggle(Text, Default, Callback)
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 40)
            Frame.BackgroundColor3 = Theme.Surface
            Frame.BackgroundTransparency = 0.4
            Frame.Parent = TabContent
            AddCorner(Frame, 10)
            AddStroke(Frame, Theme.Border, 1, 0.7)
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -70, 1, 0)
            Label.Position = UDim2.new(0, 14, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = Text
            Label.TextColor3 = Theme.Text
            Label.TextSize = 13
            Label.Font = Enum.Font.GothamMedium
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame
            
            local ToggleBG = Instance.new("Frame")
            ToggleBG.Size = UDim2.new(0, 48, 0, 26)
            ToggleBG.Position = UDim2.new(1, -58, 0.5, -13)
            ToggleBG.BackgroundColor3 = Default and Theme.Green or Color3.fromRGB(70, 75, 90)
            ToggleBG.Parent = Frame
            AddCorner(ToggleBG, 13)
            
            local Knob = Instance.new("Frame")
            Knob.Size = UDim2.new(0, 22, 0, 22)
            Knob.Position = Default and UDim2.new(1, -24, 0.5, -11) or UDim2.new(0, 2, 0.5, -11)
            Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Knob.Parent = ToggleBG
            AddCorner(Knob, 11)
            
            -- 影
            local KnobShadow = Instance.new("Frame")
            KnobShadow.Size = UDim2.new(1, 4, 1, 4)
            KnobShadow.Position = UDim2.new(0, -2, 0, 0)
            KnobShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            KnobShadow.BackgroundTransparency = 0.85
            KnobShadow.ZIndex = 0
            KnobShadow.Parent = Knob
            AddCorner(KnobShadow, 13)
            
            local Enabled = Default or false
            
            local ToggleBtn = Instance.new("TextButton")
            ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
            ToggleBtn.BackgroundTransparency = 1
            ToggleBtn.Text = ""
            ToggleBtn.Parent = Frame
            
            ToggleBtn.MouseButton1Click:Connect(function()
                Enabled = not Enabled
                Tween(ToggleBG, {BackgroundColor3 = Enabled and Theme.Green or Color3.fromRGB(70, 75, 90)}, 0.25)
                Tween(Knob, {Position = Enabled and UDim2.new(1, -24, 0.5, -11) or UDim2.new(0, 2, 0.5, -11)}, 0.25)
                pcall(function() Callback(Enabled) end)
            end)
            
            return Frame
        end
        
        -- スライダー
        function TabInit:CreateSlider(Text, Min, Max, Default, Callback)
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 55)
            Frame.BackgroundColor3 = Theme.Surface
            Frame.BackgroundTransparency = 0.4
            Frame.Parent = TabContent
            AddCorner(Frame, 10)
            AddStroke(Frame, Theme.Border, 1, 0.7)
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0.6, 0, 0, 22)
            Label.Position = UDim2.new(0, 14, 0, 6)
            Label.BackgroundTransparency = 1
            Label.Text = Text
            Label.TextColor3 = Theme.Text
            Label.TextSize = 13
            Label.Font = Enum.Font.GothamMedium
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(0.4, -14, 0, 22)
            ValueLabel.Position = UDim2.new(0.6, 0, 0, 6)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text = tostring(Default)
            ValueLabel.TextColor3 = Theme.Accent
            ValueLabel.TextSize = 13
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Parent = Frame
            
            local SliderBG = Instance.new("Frame")
            SliderBG.Size = UDim2.new(1, -28, 0, 6)
            SliderBG.Position = UDim2.new(0, 14, 0, 38)
            SliderBG.BackgroundColor3 = Color3.fromRGB(50, 55, 70)
            SliderBG.Parent = Frame
            AddCorner(SliderBG, 3)
            
            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
            Fill.BackgroundColor3 = Theme.Accent
            Fill.Parent = SliderBG
            AddCorner(Fill, 3)
            
            -- グローエフェクト
            local FillGlow = Instance.new("Frame")
            FillGlow.Size = UDim2.new(1, 8, 1, 8)
            FillGlow.Position = UDim2.new(0, -4, 0, -4)
            FillGlow.BackgroundColor3 = Theme.Accent
            FillGlow.BackgroundTransparency = 0.8
            FillGlow.ZIndex = 0
            FillGlow.Parent = Fill
            AddCorner(FillGlow, 5)
            
            local Dragging = false
            
            SliderBG.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = true
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local pos = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
                    local value = math.floor(Min + (Max - Min) * pos)
                    Tween(Fill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.05)
                    ValueLabel.Text = tostring(value)
                    pcall(function() Callback(value) end)
                end
            end)
            
            return Frame
        end
        
        -- ドロップダウン
        function TabInit:CreateDropdown(Text, Options, Default, Callback)
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 40)
            Frame.BackgroundColor3 = Theme.Surface
            Frame.BackgroundTransparency = 0.4
            Frame.ClipsDescendants = true
            Frame.Parent = TabContent
            AddCorner(Frame, 10)
            AddStroke(Frame, Theme.Border, 1, 0.7)
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0.5, 0, 0, 40)
            Label.Position = UDim2.new(0, 14, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = Text
            Label.TextColor3 = Theme.Text
            Label.TextSize = 13
            Label.Font = Enum.Font.GothamMedium
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame
            
            local Selected = Instance.new("TextLabel")
            Selected.Size = UDim2.new(0.5, -44, 0, 40)
            Selected.Position = UDim2.new(0.5, 0, 0, 0)
            Selected.BackgroundTransparency = 1
            Selected.Text = Default or Options[1]
            Selected.TextColor3 = Theme.Accent
            Selected.TextSize = 13
            Selected.Font = Enum.Font.GothamMedium
            Selected.TextXAlignment = Enum.TextXAlignment.Right
            Selected.Parent = Frame
            
            local Arrow = Instance.new("TextLabel")
            Arrow.Size = UDim2.new(0, 24, 0, 40)
            Arrow.Position = UDim2.new(1, -28, 0, 0)
            Arrow.BackgroundTransparency = 1
            Arrow.Text = "▼"
            Arrow.TextColor3 = Theme.SubText
            Arrow.TextSize = 10
            Arrow.Font = Enum.Font.GothamBold
            Arrow.Parent = Frame
            
            local isOpen = false
            
            local OptionsContainer = Instance.new("Frame")
            OptionsContainer.Size = UDim2.new(1, -14, 0, #Options * 34)
            OptionsContainer.Position = UDim2.new(0, 7, 0, 46)
            OptionsContainer.BackgroundTransparency = 1
            OptionsContainer.Parent = Frame
            
            local OptList = Instance.new("UIListLayout")
            OptList.Padding = UDim.new(0, 4)
            OptList.Parent = OptionsContainer
            
            for _, opt in ipairs(Options) do
                local OptBtn = Instance.new("TextButton")
                OptBtn.Size = UDim2.new(1, 0, 0, 30)
                OptBtn.BackgroundColor3 = Theme.Background
                OptBtn.BackgroundTransparency = 0.3
                OptBtn.Text = opt
                OptBtn.TextColor3 = Theme.Text
                OptBtn.TextSize = 12
                OptBtn.Font = Enum.Font.Gotham
                OptBtn.Parent = OptionsContainer
                AddCorner(OptBtn, 6)
                
                OptBtn.MouseEnter:Connect(function()
                    Tween(OptBtn, {BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0.5}, 0.15)
                end)
                OptBtn.MouseLeave:Connect(function()
                    Tween(OptBtn, {BackgroundColor3 = Theme.Background, BackgroundTransparency = 0.3}, 0.15)
                end)
                
                OptBtn.MouseButton1Click:Connect(function()
                    Selected.Text = opt
                    isOpen = false
                    Tween(Frame, {Size = UDim2.new(1, 0, 0, 40)}, 0.25)
                    Tween(Arrow, {Rotation = 0}, 0.25)
                    pcall(function() Callback(opt) end)
                end)
            end
            
            local DropBtn = Instance.new("TextButton")
            DropBtn.Size = UDim2.new(1, 0, 0, 40)
            DropBtn.BackgroundTransparency = 1
            DropBtn.Text = ""
            DropBtn.Parent = Frame
            
            DropBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    Tween(Frame, {Size = UDim2.new(1, 0, 0, 54 + #Options * 34)}, 0.25)
                    Tween(Arrow, {Rotation = 180}, 0.25)
                else
                    Tween(Frame, {Size = UDim2.new(1, 0, 0, 40)}, 0.25)
                    Tween(Arrow, {Rotation = 0}, 0.25)
                end
            end)
            
            return Frame
        end
        
        -- ラベル
        function TabInit:CreateLabel(Text)
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, 0, 0, 30)
            Label.BackgroundTransparency = 1
            Label.Text = Text
            Label.TextColor3 = Theme.SubText
            Label.TextSize = 12
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = TabContent
            return Label
        end
        
        -- セクション
        function TabInit:CreateSection(Text)
            local Section = Instance.new("TextLabel")
            Section.Size = UDim2.new(1, 0, 0, 30)
            Section.BackgroundTransparency = 1
            Section.Text = Text
            Section.TextColor3 = Theme.Accent
            Section.TextSize = 15
            Section.Font = Enum.Font.GothamBold
            Section.TextXAlignment = Enum.TextXAlignment.Left
            Section.Parent = TabContent
            return Section
        end
        
        -- 段落（文字サイズ変更可能）
        function TabInit:CreateParagraph(Text, TextSize)
            TextSize = TextSize or 12
            local Paragraph = Instance.new("TextLabel")
            Paragraph.Size = UDim2.new(1, 0, 0, 0)
            Paragraph.AutomaticSize = Enum.AutomaticSize.Y
            Paragraph.BackgroundTransparency = 1
            Paragraph.Text = Text
            Paragraph.TextColor3 = Theme.SubText
            Paragraph.TextSize = TextSize
            Paragraph.Font = Enum.Font.Gotham
            Paragraph.TextXAlignment = Enum.TextXAlignment.Left
            Paragraph.TextWrapped = true
            Paragraph.Parent = TabContent
            return Paragraph
        end
        
        -- 数値入力
        function TabInit:CreateInput(Text, Placeholder, Callback)
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 40)
            Frame.BackgroundColor3 = Theme.Surface
            Frame.BackgroundTransparency = 0.4
            Frame.Parent = TabContent
            AddCorner(Frame, 10)
            AddStroke(Frame, Theme.Border, 1, 0.7)
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0.5, 0, 1, 0)
            Label.Position = UDim2.new(0, 14, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = Text
            Label.TextColor3 = Theme.Text
            Label.TextSize = 13
            Label.Font = Enum.Font.GothamMedium
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame
            
            local InputBox = Instance.new("TextBox")
            InputBox.Size = UDim2.new(0.45, -14, 0, 28)
            InputBox.Position = UDim2.new(0.5, 0, 0.5, -14)
            InputBox.BackgroundColor3 = Theme.Background
            InputBox.BackgroundTransparency = 0.3
            InputBox.Text = ""
            InputBox.PlaceholderText = Placeholder or "入力..."
            InputBox.TextColor3 = Theme.Text
            InputBox.PlaceholderColor3 = Theme.SubText
            InputBox.TextSize = 13
            InputBox.Font = Enum.Font.Gotham
            InputBox.ClearTextOnFocus = false
            InputBox.Parent = Frame
            AddCorner(InputBox, 6)
            
            InputBox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    pcall(function() Callback(InputBox.Text) end)
                end
            end)
            
            return Frame
        end
        
        -- グラフ
        function TabInit:CreateGraph(Title, Data)
            Data = Data or {0, 0, 0, 0, 0}
            
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 120)
            Frame.BackgroundColor3 = Theme.Surface
            Frame.BackgroundTransparency = 0.4
            Frame.Parent = TabContent
            AddCorner(Frame, 10)
            AddStroke(Frame, Theme.Border, 1, 0.7)
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -20, 0, 24)
            Label.Position = UDim2.new(0, 10, 0, 6)
            Label.BackgroundTransparency = 1
            Label.Text = Title
            Label.TextColor3 = Theme.Text
            Label.TextSize = 13
            Label.Font = Enum.Font.GothamMedium
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame
            
            local GraphContainer = Instance.new("Frame")
            GraphContainer.Size = UDim2.new(1, -20, 0, 70)
            GraphContainer.Position = UDim2.new(0, 10, 0, 35)
            GraphContainer.BackgroundTransparency = 1
            GraphContainer.Parent = Frame
            
            local BarLayout = Instance.new("UIListLayout")
            BarLayout.FillDirection = Enum.FillDirection.Horizontal
            BarLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
            BarLayout.Padding = UDim.new(0, 6)
            BarLayout.Parent = GraphContainer
            
            local Bars = {}
            local maxValue = math.max(unpack(Data), 1)
            
            for i, value in ipairs(Data) do
                local BarFrame = Instance.new("Frame")
                BarFrame.Size = UDim2.new(1 / #Data, -6, 1, 0)
                BarFrame.BackgroundTransparency = 1
                BarFrame.Parent = GraphContainer
                
                local Bar = Instance.new("Frame")
                Bar.Size = UDim2.new(1, 0, value / maxValue, 0)
                Bar.Position = UDim2.new(0, 0, 1 - (value / maxValue), 0)
                Bar.BackgroundColor3 = Theme.Accent
                Bar.Parent = BarFrame
                AddCorner(Bar, 4)
                
                Bars[i] = Bar
            end
            
            local GraphObj = {Frame = Frame, Bars = Bars, Data = Data}
            
            function GraphObj:Update(NewData)
                self.Data = NewData
                local max = math.max(unpack(NewData), 1)
                for i, bar in ipairs(self.Bars) do
                    local val = NewData[i] or 0
                    Tween(bar, {
                        Size = UDim2.new(1, 0, val / max, 0),
                        Position = UDim2.new(0, 0, 1 - (val / max), 0)
                    }, 0.2)
                end
            end
            
            return GraphObj
        end
        
        -- スクリプト実行
        function TabInit:CreateExecutor(Title)
            Title = Title or "Script Executor"
            
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 140)
            Frame.BackgroundColor3 = Theme.Surface
            Frame.BackgroundTransparency = 0.4
            Frame.Parent = TabContent
            AddCorner(Frame, 10)
            AddStroke(Frame, Theme.Border, 1, 0.7)
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -20, 0, 24)
            Label.Position = UDim2.new(0, 10, 0, 6)
            Label.BackgroundTransparency = 1
            Label.Text = Title
            Label.TextColor3 = Theme.Text
            Label.TextSize = 13
            Label.Font = Enum.Font.GothamMedium
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame
            
            local InputBox = Instance.new("TextBox")
            InputBox.Size = UDim2.new(1, -20, 0, 65)
            InputBox.Position = UDim2.new(0, 10, 0, 32)
            InputBox.BackgroundColor3 = Theme.Background
            InputBox.BackgroundTransparency = 0.2
            InputBox.Text = ""
            InputBox.PlaceholderText = "print('Hello World')"
            InputBox.TextColor3 = Theme.Text
            InputBox.PlaceholderColor3 = Theme.SubText
            InputBox.TextSize = 12
            InputBox.Font = Enum.Font.Code
            InputBox.TextXAlignment = Enum.TextXAlignment.Left
            InputBox.TextYAlignment = Enum.TextYAlignment.Top
            InputBox.ClearTextOnFocus = false
            InputBox.MultiLine = true
            InputBox.TextWrapped = true
            InputBox.Parent = Frame
            AddCorner(InputBox, 6)
            
            local ExecButton = Instance.new("TextButton")
            ExecButton.Size = UDim2.new(1, -20, 0, 30)
            ExecButton.Position = UDim2.new(0, 10, 0, 102)
            ExecButton.BackgroundColor3 = Theme.Accent
            ExecButton.BackgroundTransparency = 0.3
            ExecButton.Text = "▶ Execute"
            ExecButton.TextColor3 = Theme.Text
            ExecButton.TextSize = 13
            ExecButton.Font = Enum.Font.GothamBold
            ExecButton.Parent = Frame
            AddCorner(ExecButton, 6)
            
            ExecButton.MouseEnter:Connect(function()
                Tween(ExecButton, {BackgroundTransparency = 0.1}, 0.15)
            end)
            ExecButton.MouseLeave:Connect(function()
                Tween(ExecButton, {BackgroundTransparency = 0.3}, 0.15)
            end)
            
            ExecButton.MouseButton1Click:Connect(function()
                local script = InputBox.Text
                if script and script ~= "" then
                    local success, err = pcall(function()
                        loadstring(script)()
                    end)
                    if not success then
                        warn("[Executor Error] " .. tostring(err))
                    end
                end
            end)
            
            return Frame
        end
        
        return TabInit
    end
    
    -- 通知 (モダンスタイル)
    function Window:Notify(Config)
        Config = Config or {}
        Config.Title = Config.Title or "Notification"
        Config.Content = Config.Content or ""
        Config.Duration = Config.Duration or 3
        
        local Notif = Instance.new("Frame")
        Notif.Size = UDim2.new(0, 300, 0, 0)
        Notif.Position = UDim2.new(1, -310, 1, -10)
        Notif.AnchorPoint = Vector2.new(0, 1)
        Notif.BackgroundColor3 = Theme.Surface
        Notif.BackgroundTransparency = 0.1
        Notif.ClipsDescendants = true
        Notif.Parent = ScreenGui
        AddCorner(Notif, 12)
        AddStroke(Notif, Theme.Border, 1, 0.6)
        AddGradient(Notif)
        
        -- アクセントライン
        local AccentLine = Instance.new("Frame")
        AccentLine.Size = UDim2.new(0, 3, 1, -16)
        AccentLine.Position = UDim2.new(0, 8, 0, 8)
        AccentLine.BackgroundColor3 = Theme.Accent
        AccentLine.BorderSizePixel = 0
        AccentLine.Parent = Notif
        AddCorner(AccentLine, 2)
        
        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, -30, 0, 24)
        Title.Position = UDim2.new(0, 20, 0, 10)
        Title.BackgroundTransparency = 1
        Title.Text = Config.Title
        Title.TextColor3 = Theme.Text
        Title.TextSize = 14
        Title.Font = Enum.Font.GothamBold
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = Notif
        
        local Content = Instance.new("TextLabel")
        Content.Size = UDim2.new(1, -30, 0, 30)
        Content.Position = UDim2.new(0, 20, 0, 35)
        Content.BackgroundTransparency = 1
        Content.Text = Config.Content
        Content.TextColor3 = Theme.SubText
        Content.TextSize = 12
        Content.Font = Enum.Font.Gotham
        Content.TextXAlignment = Enum.TextXAlignment.Left
        Content.TextWrapped = true
        Content.Parent = Notif
        
        Tween(Notif, {Size = UDim2.new(0, 300, 0, 75)}, 0.35)
        
        task.delay(Config.Duration, function()
            Tween(Notif, {Size = UDim2.new(0, 300, 0, 0), BackgroundTransparency = 1}, 0.25).Completed:Connect(function()
                Notif:Destroy()
            end)
        end)
    end
    
    return Window
end

return MacUI
