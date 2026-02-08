--[[
    LiquidLibrary - Roblox UI Library
    Monochrome Glass Design | INS key to toggle
]]

local LiquidLibrary = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Config (Black & White Theme)
local Config = {
    MainColor = Color3.fromRGB(15, 15, 15),
    AccentColor = Color3.fromRGB(255, 255, 255),
    GlassColor = Color3.fromRGB(25, 25, 25),
    TextColor = Color3.fromRGB(255, 255, 255),
    DimText = Color3.fromRGB(150, 150, 150),
    ToggleKey = Enum.KeyCode.Insert,
    AnimationSpeed = 0.25
}

-- Utility
local function Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then inst[k] = v end
    end
    if props.Parent then inst.Parent = props.Parent end
    return inst
end

local function Tween(obj, props, time, style, dir)
    local tween = TweenService:Create(obj, TweenInfo.new(time or Config.AnimationSpeed, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

local function AddCorner(parent, radius)
    return Create("UICorner", {CornerRadius = UDim.new(0, radius or 8), Parent = parent})
end

local function AddGlass(parent, transparency)
    local blur = Create("Frame", {
        Name = "Glass",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Config.GlassColor,
        BackgroundTransparency = transparency or 0.15,
        BorderSizePixel = 0,
        ZIndex = 0,
        Parent = parent
    })
    AddCorner(blur, 10)
    
    local stroke = Create("UIStroke", {
        Color = Color3.fromRGB(255, 255, 255),
        Transparency = 0.85,
        Thickness = 1,
        Parent = parent
    })
    
    -- Subtle inner glow
    local innerGlow = Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 60, 60)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(30, 30, 30)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
        }),
        Rotation = 90,
        Parent = blur
    })
    
    return blur
end

local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle = handle or frame
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Tween(frame, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.08)
        end
    end)
end

-- Hover animation helper
local function AddHover(element, hoverProps, normalProps)
    element.MouseEnter:Connect(function()
        Tween(element, hoverProps, 0.15)
    end)
    element.MouseLeave:Connect(function()
        Tween(element, normalProps, 0.15)
    end)
end

-- Main Library
function LiquidLibrary:CreateWindow(title)
    local ScreenGui = Create("ScreenGui", {
        Name = "LiquidLibrary",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = game:GetService("CoreGui")
    })
    
    local MainFrame = Create("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Config.MainColor,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = ScreenGui
    })
    AddCorner(MainFrame, 12)
    AddGlass(MainFrame, 0.1)
    
    -- Opening animation
    Tween(MainFrame, {Size = UDim2.new(0, 520, 0, 380)}, 0.4, Enum.EasingStyle.Back)
    
    local TopBar = Create("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundTransparency = 1,
        ZIndex = 2,
        Parent = MainFrame
    })
    
    local Title = Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 18, 0, 0),
        BackgroundTransparency = 1,
        Text = title or "Liquid Library",
        TextColor3 = Config.TextColor,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 2,
        Parent = TopBar
    })
    
    -- Minimize Button
    local MinBtn = Create("TextButton", {
        Name = "Minimize",
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -68, 0, 8),
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        BackgroundTransparency = 0.3,
        Text = "-",
        TextColor3 = Config.TextColor,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        ZIndex = 2,
        Parent = TopBar
    })
    AddCorner(MinBtn, 6)
    AddHover(MinBtn, {BackgroundTransparency = 0}, {BackgroundTransparency = 0.3})
    
    -- Close Button
    local CloseBtn = Create("TextButton", {
        Name = "Close",
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -35, 0, 8),
        BackgroundColor3 = Color3.fromRGB(80, 80, 80),
        BackgroundTransparency = 0.3,
        Text = "x",
        TextColor3 = Config.TextColor,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        ZIndex = 2,
        Parent = TopBar
    })
    AddCorner(CloseBtn, 6)
    AddHover(CloseBtn, {BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(200, 60, 60)}, {BackgroundTransparency = 0.3, BackgroundColor3 = Color3.fromRGB(80, 80, 80)})
    
    -- Separator line
    local Separator = Create("Frame", {
        Size = UDim2.new(1, -20, 0, 1),
        Position = UDim2.new(0, 10, 0, 44),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.9,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = MainFrame
    })
    
    MakeDraggable(MainFrame, TopBar)
    
    -- Tab Container
    local TabHolder = Create("Frame", {
        Name = "TabHolder",
        Size = UDim2.new(0, 130, 1, -60),
        Position = UDim2.new(0, 10, 0, 52),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BackgroundTransparency = 0.5,
        ZIndex = 2,
        Parent = MainFrame
    })
    AddCorner(TabHolder, 8)
    
    local TabList = Create("UIListLayout", {
        Padding = UDim.new(0, 4),
        Parent = TabHolder
    })
    
    local TabPadding = Create("UIPadding", {
        PaddingTop = UDim.new(0, 6),
        PaddingLeft = UDim.new(0, 6),
        PaddingRight = UDim.new(0, 6),
        Parent = TabHolder
    })
    
    -- Content Area
    local ContentArea = Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -160, 1, -62),
        Position = UDim2.new(0, 150, 0, 52),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex = 2,
        Parent = MainFrame
    })
    
    local Window = {
        Gui = ScreenGui,
        Main = MainFrame,
        Tabs = {},
        CurrentTab = nil,
        Visible = true,
        Minimized = false
    }
    
    -- Toggle visibility with animation
    local function ToggleWindow()
        Window.Visible = not Window.Visible
        if Window.Visible then
            MainFrame.Visible = true
            MainFrame.Size = UDim2.new(0, 0, 0, 0)
            Tween(MainFrame, {Size = UDim2.new(0, 520, 0, 380)}, 0.3, Enum.EasingStyle.Back)
        else
            Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.25, Enum.EasingStyle.Quint).Completed:Wait()
            MainFrame.Visible = false
        end
    end
    
    -- Minimize with animation
    local originalSize = UDim2.new(0, 520, 0, 380)
    MinBtn.MouseButton1Click:Connect(function()
        Window.Minimized = not Window.Minimized
        if Window.Minimized then
            Tween(MainFrame, {Size = UDim2.new(0, 520, 0, 45)}, 0.25, Enum.EasingStyle.Quint)
        else
            Tween(MainFrame, {Size = originalSize}, 0.25, Enum.EasingStyle.Quint)
        end
    end)
    
    -- Close with animation
    CloseBtn.MouseButton1Click:Connect(function()
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.25, Enum.EasingStyle.Quint).Completed:Wait()
        ScreenGui:Destroy()
    end)
    
    -- INS key toggle
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Config.ToggleKey then
            ToggleWindow()
        end
    end)
    
    -- Create Tab
    function Window:CreateTab(name)
        local TabBtn = Create("TextButton", {
            Name = name,
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            BackgroundTransparency = 0.6,
            Text = name,
            TextColor3 = Config.DimText,
            TextSize = 13,
            Font = Enum.Font.GothamMedium,
            ZIndex = 3,
            Parent = TabHolder
        })
        AddCorner(TabBtn, 6)
        
        local TabContent = Create("ScrollingFrame", {
            Name = name .. "Content",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100),
            ScrollBarImageTransparency = 0.5,
            Visible = false,
            ZIndex = 3,
            Parent = ContentArea
        })
        
        local ContentList = Create("UIListLayout", {
            Padding = UDim.new(0, 6),
            Parent = TabContent
        })
        
        local ContentPadding = Create("UIPadding", {
            PaddingTop = UDim.new(0, 4),
            PaddingRight = UDim.new(0, 8),
            Parent = TabContent
        })
        
        ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 10)
        end)
        
        local Tab = {
            Button = TabBtn,
            Content = TabContent
        }
        
        TabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(Window.Tabs) do
                t.Content.Visible = false
                Tween(t.Button, {BackgroundTransparency = 0.6, TextColor3 = Config.DimText}, 0.15)
            end
            TabContent.Visible = true
            Tween(TabBtn, {BackgroundTransparency = 0.2, TextColor3 = Config.TextColor}, 0.15)
            Window.CurrentTab = Tab
        end)
        
        -- Hover effect
        TabBtn.MouseEnter:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(TabBtn, {BackgroundTransparency = 0.4}, 0.1)
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(TabBtn, {BackgroundTransparency = 0.6}, 0.1)
            end
        end)
        
        -- Select first tab
        if #Window.Tabs == 0 then
            TabContent.Visible = true
            TabBtn.BackgroundTransparency = 0.2
            TabBtn.TextColor3 = Config.TextColor
            Window.CurrentTab = Tab
        end
        
        table.insert(Window.Tabs, Tab)
        
        -- UI Elements
        function Tab:CreateButton(text, callback)
            local Btn = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 34),
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                BackgroundTransparency = 0.4,
                Text = text,
                TextColor3 = Config.TextColor,
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                ZIndex = 4,
                Parent = TabContent
            })
            AddCorner(Btn, 6)
            
            local stroke = Create("UIStroke", {
                Color = Color3.fromRGB(255, 255, 255),
                Transparency = 0.92,
                Thickness = 1,
                Parent = Btn
            })
            
            Btn.MouseEnter:Connect(function()
                Tween(Btn, {BackgroundTransparency = 0.2, BackgroundColor3 = Color3.fromRGB(70, 70, 70)}, 0.15)
                Tween(stroke, {Transparency = 0.8}, 0.15)
            end)
            Btn.MouseLeave:Connect(function()
                Tween(Btn, {BackgroundTransparency = 0.4, BackgroundColor3 = Color3.fromRGB(50, 50, 50)}, 0.15)
                Tween(stroke, {Transparency = 0.92}, 0.15)
            end)
            Btn.MouseButton1Click:Connect(function()
                -- Click animation
                Tween(Btn, {Size = UDim2.new(1, -4, 0, 32)}, 0.08)
                task.wait(0.08)
                Tween(Btn, {Size = UDim2.new(1, 0, 0, 34)}, 0.08)
                if callback then callback() end
            end)
            return Btn
        end
        
        function Tab:CreateToggle(text, default, callback)
            local ToggleFrame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 34),
                BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                BackgroundTransparency = 0.4,
                ZIndex = 4,
                Parent = TabContent
            })
            AddCorner(ToggleFrame, 6)
            
            local Label = Create("TextLabel", {
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Config.TextColor,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 4,
                Parent = ToggleFrame
            })
            
            local ToggleBtn = Create("Frame", {
                Size = UDim2.new(0, 40, 0, 20),
                Position = UDim2.new(1, -50, 0.5, -10),
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                ZIndex = 4,
                Parent = ToggleFrame
            })
            AddCorner(ToggleBtn, 10)
            
            local Circle = Create("Frame", {
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(0, 2, 0.5, -8),
                BackgroundColor3 = Color3.fromRGB(150, 150, 150),
                ZIndex = 5,
                Parent = ToggleBtn
            })
            AddCorner(Circle, 8)
            
            local Toggled = default or false
            
            local function Update()
                if Toggled then
                    Tween(ToggleBtn, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
                    Tween(Circle, {Position = UDim2.new(1, -18, 0.5, -8), BackgroundColor3 = Color3.fromRGB(20, 20, 20)}, 0.2)
                else
                    Tween(ToggleBtn, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}, 0.2)
                    Tween(Circle, {Position = UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Color3.fromRGB(150, 150, 150)}, 0.2)
                end
                if callback then callback(Toggled) end
            end
            
            if default then Update() end
            
            ToggleFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Toggled = not Toggled
                    Update()
                end
            end)
            
            return {Frame = ToggleFrame, SetValue = function(v) Toggled = v; Update() end, GetValue = function() return Toggled end}
        end
        
        function Tab:CreateSlider(text, min, max, default, callback)
            local SliderFrame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 48),
                BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                BackgroundTransparency = 0.4,
                ZIndex = 4,
                Parent = TabContent
            })
            AddCorner(SliderFrame, 6)
            
            local Label = Create("TextLabel", {
                Size = UDim2.new(1, -55, 0, 20),
                Position = UDim2.new(0, 12, 0, 4),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Config.TextColor,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 4,
                Parent = SliderFrame
            })
            
            local ValueLabel = Create("TextLabel", {
                Size = UDim2.new(0, 45, 0, 20),
                Position = UDim2.new(1, -52, 0, 4),
                BackgroundTransparency = 1,
                Text = tostring(default or min),
                TextColor3 = Config.DimText,
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 4,
                Parent = SliderFrame
            })
            
            local SliderBG = Create("Frame", {
                Size = UDim2.new(1, -24, 0, 6),
                Position = UDim2.new(0, 12, 0, 32),
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                ZIndex = 4,
                Parent = SliderFrame
            })
            AddCorner(SliderBG, 3)
            
            local SliderFill = Create("Frame", {
                Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                ZIndex = 5,
                Parent = SliderBG
            })
            AddCorner(SliderFill, 3)
            
            local SliderKnob = Create("Frame", {
                Size = UDim2.new(0, 12, 0, 12),
                Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                ZIndex = 6,
                Parent = SliderBG
            })
            AddCorner(SliderKnob, 6)
            
            local Value = default or min
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
            
            RunService.RenderStepped:Connect(function()
                if Dragging then
                    local pos = (Mouse.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X
                    pos = math.clamp(pos, 0, 1)
                    Value = math.floor(min + (max - min) * pos)
                    Tween(SliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.05)
                    Tween(SliderKnob, {Position = UDim2.new(pos, -6, 0.5, -6)}, 0.05)
                    ValueLabel.Text = tostring(Value)
                    if callback then callback(Value) end
                end
            end)
            
            return {Frame = SliderFrame, GetValue = function() return Value end}
        end
        
        function Tab:CreateTextbox(placeholder, callback)
            local Textbox = Create("TextBox", {
                Size = UDim2.new(1, 0, 0, 34),
                BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                BackgroundTransparency = 0.3,
                Text = "",
                PlaceholderText = placeholder or "Enter text...",
                TextColor3 = Config.TextColor,
                PlaceholderColor3 = Config.DimText,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                ClearTextOnFocus = false,
                ZIndex = 4,
                Parent = TabContent
            })
            AddCorner(Textbox, 6)
            
            local stroke = Create("UIStroke", {
                Color = Color3.fromRGB(255, 255, 255),
                Transparency = 0.92,
                Thickness = 1,
                Parent = Textbox
            })
            
            Textbox.Focused:Connect(function()
                Tween(stroke, {Transparency = 0.7}, 0.15)
            end)
            
            Textbox.FocusLost:Connect(function(enter)
                Tween(stroke, {Transparency = 0.92}, 0.15)
                if enter and callback then callback(Textbox.Text) end
            end)
            
            return Textbox
        end
        
        function Tab:CreateDropdown(text, options, callback)
            local DropFrame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 34),
                BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                BackgroundTransparency = 0.4,
                ClipsDescendants = true,
                ZIndex = 4,
                Parent = TabContent
            })
            AddCorner(DropFrame, 6)
            
            local Label = Create("TextLabel", {
                Size = UDim2.new(1, -30, 0, 34),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Config.TextColor,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 4,
                Parent = DropFrame
            })
            
            local Arrow = Create("TextLabel", {
                Size = UDim2.new(0, 20, 0, 34),
                Position = UDim2.new(1, -25, 0, 0),
                BackgroundTransparency = 1,
                Text = "v",
                TextColor3 = Config.DimText,
                TextSize = 12,
                Font = Enum.Font.GothamBold,
                ZIndex = 4,
                Parent = DropFrame
            })
            
            local Open = false
            local Selected = nil
            
            local OptionContainer = Create("Frame", {
                Size = UDim2.new(1, -12, 0, #options * 28),
                Position = UDim2.new(0, 6, 0, 38),
                BackgroundTransparency = 1,
                ZIndex = 5,
                Parent = DropFrame
            })
            
            local OptionList = Create("UIListLayout", {Padding = UDim.new(0, 2), Parent = OptionContainer})
            
            for _, opt in ipairs(options) do
                local OptBtn = Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 26),
                    BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                    BackgroundTransparency = 0.5,
                    Text = opt,
                    TextColor3 = Config.TextColor,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    ZIndex = 5,
                    Parent = OptionContainer
                })
                AddCorner(OptBtn, 4)
                
                OptBtn.MouseEnter:Connect(function()
                    Tween(OptBtn, {BackgroundTransparency = 0.2}, 0.1)
                end)
                OptBtn.MouseLeave:Connect(function()
                    Tween(OptBtn, {BackgroundTransparency = 0.5}, 0.1)
                end)
                
                OptBtn.MouseButton1Click:Connect(function()
                    Selected = opt
                    Label.Text = text .. ": " .. opt
                    Open = false
                    Tween(DropFrame, {Size = UDim2.new(1, 0, 0, 34)}, 0.2)
                    Tween(Arrow, {Rotation = 0}, 0.2)
                    if callback then callback(opt) end
                end)
            end
            
            DropFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and input.Position.Y < DropFrame.AbsolutePosition.Y + 34 then
                    Open = not Open
                    if Open then
                        Tween(DropFrame, {Size = UDim2.new(1, 0, 0, 42 + #options * 28)}, 0.2)
                        Tween(Arrow, {Rotation = 180}, 0.2)
                    else
                        Tween(DropFrame, {Size = UDim2.new(1, 0, 0, 34)}, 0.2)
                        Tween(Arrow, {Rotation = 0}, 0.2)
                    end
                end
            end)
            
            return {Frame = DropFrame, GetSelected = function() return Selected end}
        end
        
        function Tab:CreateLabel(text)
            local Lbl = Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 22),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Config.DimText,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 4,
                Parent = TabContent
            })
            
            local padding = Create("UIPadding", {
                PaddingLeft = UDim.new(0, 4),
                Parent = Lbl
            })
            
            return Lbl
        end
        
        function Tab:CreateKeybind(text, default, callback)
            local KeyFrame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 34),
                BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                BackgroundTransparency = 0.4,
                ZIndex = 4,
                Parent = TabContent
            })
            AddCorner(KeyFrame, 6)
            
            local Label = Create("TextLabel", {
                Size = UDim2.new(1, -70, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Config.TextColor,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 4,
                Parent = KeyFrame
            })
            
            local KeyBtn = Create("TextButton", {
                Size = UDim2.new(0, 55, 0, 24),
                Position = UDim2.new(1, -62, 0.5, -12),
                BackgroundColor3 = Color3.fromRGB(60, 60, 60),
                BackgroundTransparency = 0.3,
                Text = default and default.Name or "None",
                TextColor3 = Config.TextColor,
                TextSize = 11,
                Font = Enum.Font.GothamMedium,
                ZIndex = 5,
                Parent = KeyFrame
            })
            AddCorner(KeyBtn, 4)
            
            local CurrentKey = default
            local Listening = false
            
            KeyBtn.MouseButton1Click:Connect(function()
                Listening = true
                KeyBtn.Text = "..."
                Tween(KeyBtn, {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}, 0.1)
            end)
            
            UserInputService.InputBegan:Connect(function(input, processed)
                if Listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    CurrentKey = input.KeyCode
                    KeyBtn.Text = input.KeyCode.Name
                    Listening = false
                    Tween(KeyBtn, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}, 0.1)
                elseif not processed and CurrentKey and input.KeyCode == CurrentKey then
                    if callback then callback() end
                end
            end)
            
            return {Frame = KeyFrame, GetKey = function() return CurrentKey end}
        end
        
        function Tab:CreateSeparator()
            local Sep = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 1),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 0.9,
                ZIndex = 4,
                Parent = TabContent
            })
            return Sep
        end
        
        return Tab
    end
    
    function Window:Destroy()
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.25).Completed:Wait()
        ScreenGui:Destroy()
    end
    
    function Window:SetVisible(visible)
        if visible then
            MainFrame.Visible = true
            Tween(MainFrame, {Size = UDim2.new(0, 520, 0, 380)}, 0.3, Enum.EasingStyle.Back)
        else
            Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.25).Completed:Wait()
            MainFrame.Visible = false
        end
        Window.Visible = visible
    end
    
    return Window
end

-- Notification System
function LiquidLibrary:Notify(title, message, duration)
    local ScreenGui = game:GetService("CoreGui"):FindFirstChild("LiquidNotifications") or Create("ScreenGui", {
        Name = "LiquidNotifications",
        ResetOnSpawn = false,
        Parent = game:GetService("CoreGui")
    })
    
    local existingCount = #ScreenGui:GetChildren()
    
    local NotifFrame = Create("Frame", {
        Size = UDim2.new(0, 260, 0, 0),
        Position = UDim2.new(1, 10, 1, -10 - existingCount * 75),
        AnchorPoint = Vector2.new(1, 1),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BackgroundTransparency = 0.1,
        ClipsDescendants = true,
        Parent = ScreenGui
    })
    AddCorner(NotifFrame, 8)
    
    local stroke = Create("UIStroke", {
        Color = Color3.fromRGB(255, 255, 255),
        Transparency = 0.9,
        Thickness = 1,
        Parent = NotifFrame
    })
    
    local Title = Create("TextLabel", {
        Size = UDim2.new(1, -16, 0, 22),
        Position = UDim2.new(0, 10, 0, 8),
        BackgroundTransparency = 1,
        Text = title or "Notification",
        TextColor3 = Config.TextColor,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = NotifFrame
    })
    
    local Message = Create("TextLabel", {
        Size = UDim2.new(1, -16, 0, 30),
        Position = UDim2.new(0, 10, 0, 30),
        BackgroundTransparency = 1,
        Text = message or "",
        TextColor3 = Config.DimText,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = NotifFrame
    })
    
    -- Slide in animation
    Tween(NotifFrame, {Size = UDim2.new(0, 260, 0, 65), Position = UDim2.new(1, -10, 1, -10 - existingCount * 75)}, 0.3, Enum.EasingStyle.Back)
    
    task.delay(duration or 3, function()
        Tween(NotifFrame, {Size = UDim2.new(0, 260, 0, 0), BackgroundTransparency = 1}, 0.25).Completed:Wait()
        NotifFrame:Destroy()
    end)
end

return LiquidLibrary
