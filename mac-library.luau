--[[
    ███╗   ███╗ █████╗  ██████╗    ██╗   ██╗██╗
    ████╗ ████║██╔══██╗██╔════╝    ██║   ██║██║
    ██╔████╔██║███████║██║         ██║   ██║██║
    ██║╚██╔╝██║██╔══██║██║         ██║   ██║██║
    ██║ ╚═╝ ██║██║  ██║╚██████╗    ╚██████╔╝██║
    ╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝     ╚═════╝ ╚═╝
    
    Mac UI Library - v1.0.0
    macOSスタイルのクリーンなUIライブラリ
]]

local MacUI = {}
MacUI.__index = MacUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer

-- macOSカラーテーマ
local Theme = {
    Background = Color3.fromRGB(30, 30, 30),
    Surface = Color3.fromRGB(45, 45, 45),
    Accent = Color3.fromRGB(0, 122, 255),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(170, 170, 170),
    Border = Color3.fromRGB(60, 60, 60),
    Red = Color3.fromRGB(255, 95, 87),
    Yellow = Color3.fromRGB(255, 189, 46),
    Green = Color3.fromRGB(39, 201, 63)
}

local Settings = {
    AnimSpeed = 0.2
}

local GlobalElements = {
    ScreenGui = nil,
    MainFrame = nil
}

-- ユーティリティ
local function Tween(obj, props, time)
    local tween = TweenService:Create(obj, TweenInfo.new(time or Settings.AnimSpeed, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

local function AddCorner(obj, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 10)
    corner.Parent = obj
    return corner
end

local function AddStroke(obj, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Theme.Border
    stroke.Thickness = thickness or 1
    stroke.Transparency = 0.5
    stroke.Parent = obj
    return stroke
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
    
    -- メインウィンドウ
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 650, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -325, 0.5, -200)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    GlobalElements.MainFrame = MainFrame
    AddCorner(MainFrame, 12)
    AddStroke(MainFrame, Theme.Border)
    
    -- タイトルバー (macOSスタイル)
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 32)
    TitleBar.BackgroundColor3 = Theme.Surface
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 12)
    TitleCorner.Parent = TitleBar
    
    -- タイトルバー下部の角を埋める
    local TitleFill = Instance.new("Frame")
    TitleFill.Size = UDim2.new(1, 0, 0, 12)
    TitleFill.Position = UDim2.new(0, 0, 1, -12)
    TitleFill.BackgroundColor3 = Theme.Surface
    TitleFill.BorderSizePixel = 0
    TitleFill.Parent = TitleBar
    
    -- 信号機ボタン (赤・黄・緑)
    local function CreateTrafficButton(color, position, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 12, 0, 12)
        btn.Position = position
        btn.BackgroundColor3 = color
        btn.Text = ""
        btn.Parent = TitleBar
        AddCorner(btn, 6)
        
        btn.MouseEnter:Connect(function()
            Tween(btn, {Size = UDim2.new(0, 14, 0, 14), Position = position + UDim2.new(0, -1, 0, -1)}, 0.1)
        end)
        btn.MouseLeave:Connect(function()
            Tween(btn, {Size = UDim2.new(0, 12, 0, 12), Position = position}, 0.1)
        end)
        btn.MouseButton1Click:Connect(callback)
        
        return btn
    end
    
    local Minimized = false
    local OriginalSize = UDim2.new(0, 650, 0, 400)
    
    -- 閉じるボタン（赤）
    CreateTrafficButton(Theme.Red, UDim2.new(0, 12, 0, 10), function()
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.3).Completed:Connect(function()
            ScreenGui:Destroy()
        end)
    end)
    
    -- 最小化ボタン（黄）
    CreateTrafficButton(Theme.Yellow, UDim2.new(0, 32, 0, 10), function()
        Minimized = not Minimized
        if Minimized then
            Tween(MainFrame, {Size = UDim2.new(0, 650, 0, 32)}, 0.2)
        else
            Tween(MainFrame, {Size = OriginalSize}, 0.2)
        end
    end)
    
    -- 最大化ボタン（緑）
    CreateTrafficButton(Theme.Green, UDim2.new(0, 52, 0, 10), function()
        if MainFrame.Size == OriginalSize then
            Tween(MainFrame, {Size = UDim2.new(0, 900, 0, 550), Position = UDim2.new(0.5, -450, 0.5, -275)}, 0.3)
        else
            Tween(MainFrame, {Size = OriginalSize, Position = UDim2.new(0.5, -325, 0.5, -200)}, 0.3)
        end
    end)
    
    -- タイトル
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, 0, 1, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Config.Title
    TitleLabel.TextColor3 = Theme.Text
    TitleLabel.TextSize = 13
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
        end
    end)
    
    -- サイドバー
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 150, 1, -32)
    Sidebar.Position = UDim2.new(0, 0, 0, 32)
    Sidebar.BackgroundColor3 = Theme.Surface
    Sidebar.BackgroundTransparency = 0.3
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    
    local SidebarList = Instance.new("UIListLayout")
    SidebarList.Padding = UDim.new(0, 4)
    SidebarList.Parent = Sidebar
    
    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.PaddingTop = UDim.new(0, 8)
    SidebarPadding.PaddingLeft = UDim.new(0, 8)
    SidebarPadding.PaddingRight = UDim.new(0, 8)
    SidebarPadding.Parent = Sidebar
    
    -- コンテンツエリア
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -150, 1, -32)
    ContentArea.Position = UDim2.new(0, 150, 0, 32)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainFrame
    
    local Window = {}
    local Tabs = {}
    local CurrentTab = nil
    
    -- タブ作成
    function Window:CreateTab(Name)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = Name
        TabButton.Size = UDim2.new(1, 0, 0, 32)
        TabButton.BackgroundColor3 = Theme.Accent
        TabButton.BackgroundTransparency = 1
        TabButton.Text = "  " .. Name
        TabButton.TextColor3 = Theme.SubText
        TabButton.TextSize = 13
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.Parent = Sidebar
        AddCorner(TabButton, 6)
        
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = Name .. "Content"
        TabContent.Size = UDim2.new(1, -20, 1, -20)
        TabContent.Position = UDim2.new(0, 10, 0, 10)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Theme.Accent
        TabContent.Visible = false
        TabContent.Parent = ContentArea
        
        local ContentList = Instance.new("UIListLayout")
        ContentList.Padding = UDim.new(0, 8)
        ContentList.Parent = TabContent
        
        ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 10)
        end)
        
        local Tab = {Button = TabButton, Content = TabContent}
        
        TabButton.MouseEnter:Connect(function()
            if CurrentTab ~= Tab then
                Tween(TabButton, {BackgroundTransparency = 0.8}, 0.1)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if CurrentTab ~= Tab then
                Tween(TabButton, {BackgroundTransparency = 1}, 0.1)
            end
        end)
        
        TabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(Tabs) do
                t.Content.Visible = false
                Tween(t.Button, {BackgroundTransparency = 1, TextColor3 = Theme.SubText}, 0.15)
            end
            TabContent.Visible = true
            Tween(TabButton, {BackgroundTransparency = 0.7, TextColor3 = Theme.Text}, 0.15)
            CurrentTab = Tab
        end)
        
        if #Tabs == 0 then
            TabContent.Visible = true
            TabButton.BackgroundTransparency = 0.7
            TabButton.TextColor3 = Theme.Text
            CurrentTab = Tab
        end
        
        table.insert(Tabs, Tab)
        
        local TabInit = {}
        
        -- ボタン
        function TabInit:CreateButton(Text, Callback)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 0, 36)
            Button.BackgroundColor3 = Theme.Surface
            Button.Text = Text
            Button.TextColor3 = Theme.Text
            Button.TextSize = 13
            Button.Font = Enum.Font.Gotham
            Button.Parent = TabContent
            AddCorner(Button, 8)
            
            Button.MouseEnter:Connect(function()
                Tween(Button, {BackgroundColor3 = Theme.Accent}, 0.15)
            end)
            Button.MouseLeave:Connect(function()
                Tween(Button, {BackgroundColor3 = Theme.Surface}, 0.15)
            end)
            Button.MouseButton1Click:Connect(function()
                pcall(Callback)
            end)
            
            return Button
        end
        
        -- トグル
        function TabInit:CreateToggle(Text, Default, Callback)
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 36)
            Frame.BackgroundColor3 = Theme.Surface
            Frame.Parent = TabContent
            AddCorner(Frame, 8)
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -60, 1, 0)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = Text
            Label.TextColor3 = Theme.Text
            Label.TextSize = 13
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame
            
            local ToggleBG = Instance.new("Frame")
            ToggleBG.Size = UDim2.new(0, 44, 0, 24)
            ToggleBG.Position = UDim2.new(1, -52, 0.5, -12)
            ToggleBG.BackgroundColor3 = Default and Theme.Green or Color3.fromRGB(80, 80, 80)
            ToggleBG.Parent = Frame
            AddCorner(ToggleBG, 12)
            
            local Knob = Instance.new("Frame")
            Knob.Size = UDim2.new(0, 20, 0, 20)
            Knob.Position = Default and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
            Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Knob.Parent = ToggleBG
            AddCorner(Knob, 10)
            
            local Enabled = Default or false
            
            local ToggleBtn = Instance.new("TextButton")
            ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
            ToggleBtn.BackgroundTransparency = 1
            ToggleBtn.Text = ""
            ToggleBtn.Parent = Frame
            
            ToggleBtn.MouseButton1Click:Connect(function()
                Enabled = not Enabled
                Tween(ToggleBG, {BackgroundColor3 = Enabled and Theme.Green or Color3.fromRGB(80, 80, 80)}, 0.2)
                Tween(Knob, {Position = Enabled and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)}, 0.2)
                pcall(function() Callback(Enabled) end)
            end)
            
            return Frame
        end
        
        -- スライダー
        function TabInit:CreateSlider(Text, Min, Max, Default, Callback)
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 50)
            Frame.BackgroundColor3 = Theme.Surface
            Frame.Parent = TabContent
            AddCorner(Frame, 8)
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0.6, 0, 0, 20)
            Label.Position = UDim2.new(0, 12, 0, 6)
            Label.BackgroundTransparency = 1
            Label.Text = Text
            Label.TextColor3 = Theme.Text
            Label.TextSize = 13
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(0.4, -12, 0, 20)
            ValueLabel.Position = UDim2.new(0.6, 0, 0, 6)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text = tostring(Default)
            ValueLabel.TextColor3 = Theme.Accent
            ValueLabel.TextSize = 13
            ValueLabel.Font = Enum.Font.GothamMedium
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Parent = Frame
            
            local SliderBG = Instance.new("Frame")
            SliderBG.Size = UDim2.new(1, -24, 0, 4)
            SliderBG.Position = UDim2.new(0, 12, 0, 35)
            SliderBG.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            SliderBG.Parent = Frame
            AddCorner(SliderBG, 2)
            
            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
            Fill.BackgroundColor3 = Theme.Accent
            Fill.Parent = SliderBG
            AddCorner(Fill, 2)
            
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
                    Fill.Size = UDim2.new(pos, 0, 1, 0)
                    ValueLabel.Text = tostring(value)
                    pcall(function() Callback(value) end)
                end
            end)
            
            return Frame
        end
        
        -- ドロップダウン
        function TabInit:CreateDropdown(Text, Options, Default, Callback)
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 36)
            Frame.BackgroundColor3 = Theme.Surface
            Frame.ClipsDescendants = true
            Frame.Parent = TabContent
            AddCorner(Frame, 8)
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0.5, 0, 0, 36)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = Text
            Label.TextColor3 = Theme.Text
            Label.TextSize = 13
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame
            
            local Selected = Instance.new("TextLabel")
            Selected.Size = UDim2.new(0.5, -40, 0, 36)
            Selected.Position = UDim2.new(0.5, 0, 0, 0)
            Selected.BackgroundTransparency = 1
            Selected.Text = Default or Options[1]
            Selected.TextColor3 = Theme.Accent
            Selected.TextSize = 13
            Selected.Font = Enum.Font.Gotham
            Selected.TextXAlignment = Enum.TextXAlignment.Right
            Selected.Parent = Frame
            
            local Arrow = Instance.new("TextLabel")
            Arrow.Size = UDim2.new(0, 20, 0, 36)
            Arrow.Position = UDim2.new(1, -25, 0, 0)
            Arrow.BackgroundTransparency = 1
            Arrow.Text = ">"
            Arrow.TextColor3 = Theme.SubText
            Arrow.TextSize = 12
            Arrow.Font = Enum.Font.GothamBold
            Arrow.Rotation = 90
            Arrow.Parent = Frame
            
            local isOpen = false
            
            local OptionsContainer = Instance.new("Frame")
            OptionsContainer.Size = UDim2.new(1, -10, 0, #Options * 30)
            OptionsContainer.Position = UDim2.new(0, 5, 0, 40)
            OptionsContainer.BackgroundTransparency = 1
            OptionsContainer.Parent = Frame
            
            local OptList = Instance.new("UIListLayout")
            OptList.Padding = UDim.new(0, 2)
            OptList.Parent = OptionsContainer
            
            for _, opt in ipairs(Options) do
                local OptBtn = Instance.new("TextButton")
                OptBtn.Size = UDim2.new(1, 0, 0, 28)
                OptBtn.BackgroundColor3 = Theme.Background
                OptBtn.BackgroundTransparency = 0.5
                OptBtn.Text = opt
                OptBtn.TextColor3 = Theme.Text
                OptBtn.TextSize = 12
                OptBtn.Font = Enum.Font.Gotham
                OptBtn.Parent = OptionsContainer
                AddCorner(OptBtn, 6)
                
                OptBtn.MouseButton1Click:Connect(function()
                    Selected.Text = opt
                    isOpen = false
                    Tween(Frame, {Size = UDim2.new(1, 0, 0, 36)}, 0.2)
                    Tween(Arrow, {Rotation = 90}, 0.2)
                    pcall(function() Callback(opt) end)
                end)
            end
            
            local DropBtn = Instance.new("TextButton")
            DropBtn.Size = UDim2.new(1, 0, 0, 36)
            DropBtn.BackgroundTransparency = 1
            DropBtn.Text = ""
            DropBtn.Parent = Frame
            
            DropBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    Tween(Frame, {Size = UDim2.new(1, 0, 0, 44 + #Options * 30)}, 0.2)
                    Tween(Arrow, {Rotation = -90}, 0.2)
                else
                    Tween(Frame, {Size = UDim2.new(1, 0, 0, 36)}, 0.2)
                    Tween(Arrow, {Rotation = 90}, 0.2)
                end
            end)
            
            return Frame
        end
        
        -- ラベル
        function TabInit:CreateLabel(Text)
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, 0, 0, 28)
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
            Section.Size = UDim2.new(1, 0, 0, 28)
            Section.BackgroundTransparency = 1
            Section.Text = Text
            Section.TextColor3 = Theme.Accent
            Section.TextSize = 14
            Section.Font = Enum.Font.GothamBold
            Section.TextXAlignment = Enum.TextXAlignment.Left
            Section.Parent = TabContent
            return Section
        end
        
        return TabInit
    end
    
    -- 通知
    function Window:Notify(Config)
        Config = Config or {}
        Config.Title = Config.Title or "Notification"
        Config.Content = Config.Content or ""
        Config.Duration = Config.Duration or 3
        
        local Notif = Instance.new("Frame")
        Notif.Size = UDim2.new(0, 280, 0, 0)
        Notif.Position = UDim2.new(1, -290, 1, -10)
        Notif.AnchorPoint = Vector2.new(0, 1)
        Notif.BackgroundColor3 = Theme.Surface
        Notif.ClipsDescendants = true
        Notif.Parent = ScreenGui
        AddCorner(Notif, 10)
        AddStroke(Notif, Theme.Border)
        
        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, -20, 0, 22)
        Title.Position = UDim2.new(0, 10, 0, 8)
        Title.BackgroundTransparency = 1
        Title.Text = Config.Title
        Title.TextColor3 = Theme.Text
        Title.TextSize = 14
        Title.Font = Enum.Font.GothamBold
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = Notif
        
        local Content = Instance.new("TextLabel")
        Content.Size = UDim2.new(1, -20, 0, 25)
        Content.Position = UDim2.new(0, 10, 0, 30)
        Content.BackgroundTransparency = 1
        Content.Text = Config.Content
        Content.TextColor3 = Theme.SubText
        Content.TextSize = 12
        Content.Font = Enum.Font.Gotham
        Content.TextXAlignment = Enum.TextXAlignment.Left
        Content.TextWrapped = true
        Content.Parent = Notif
        
        Tween(Notif, {Size = UDim2.new(0, 280, 0, 65)}, 0.3)
        
        task.delay(Config.Duration, function()
            Tween(Notif, {Size = UDim2.new(0, 280, 0, 0)}, 0.2).Completed:Connect(function()
                Notif:Destroy()
            end)
        end)
    end
    
    return Window
end

return MacUI
