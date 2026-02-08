--[[
    LiquidLibrary - Roblox UI Library
    Liquid Glass Design | INS key to toggle
    © 2026
]]

local LiquidLibrary = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Config
local Config = {
    MainColor = Color3.fromRGB(20, 20, 35),
    AccentColor = Color3.fromRGB(100, 150, 255),
    GlassColor = Color3.fromRGB(40, 40, 60),
    TextColor = Color3.fromRGB(255, 255, 255),
    ToggleKey = Enum.KeyCode.Insert,
    AnimationSpeed = 0.3
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

local function Tween(obj, props, time)
    local tween = TweenService:Create(obj, TweenInfo.new(time or Config.AnimationSpeed, Enum.EasingStyle.Quart), props)
    tween:Play()
    return tween
end

local function AddCorner(parent, radius)
    return Create("UICorner", {CornerRadius = UDim.new(0, radius or 8), Parent = parent})
end

local function AddGlass(parent)
    local blur = Create("Frame", {
        Name = "Glass",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Config.GlassColor,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Parent = parent
    })
    AddCorner(blur, 10)
    
    local gradient = Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 200))
        }),
        Rotation = 45,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.7),
            NumberSequenceKeypoint.new(0.5, 0.85),
            NumberSequenceKeypoint.new(1, 0.7)
        }),
        Parent = blur
    })
    
    local stroke = Create("UIStroke", {
        Color = Color3.fromRGB(255, 255, 255),
        Transparency = 0.8,
        Thickness = 1.5,
        Parent = parent
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
            Tween(frame, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.05)
        end
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
        Size = UDim2.new(0, 500, 0, 350),
        Position = UDim2.new(0.5, -250, 0.5, -175),
        BackgroundColor3 = Config.MainColor,
        BorderSizePixel = 0,
        Parent = ScreenGui
    })
    AddCorner(MainFrame, 12)
    AddGlass(MainFrame)
    
    local TopBar = Create("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Parent = MainFrame
    })
    
    local Title = Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = title or "Liquid Library",
        TextColor3 = Config.TextColor,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar
    })
    
    -- Minimize Button
    local MinBtn = Create("TextButton", {
        Name = "Minimize",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -70, 0, 5),
        BackgroundColor3 = Color3.fromRGB(255, 200, 50),
        Text = "-",
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        Parent = TopBar
    })
    AddCorner(MinBtn, 6)
    
    -- Close Button
    local CloseBtn = Create("TextButton", {
        Name = "Close",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0, 5),
        BackgroundColor3 = Color3.fromRGB(255, 80, 80),
        Text = "×",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        Parent = TopBar
    })
    AddCorner(CloseBtn, 6)
    
    MakeDraggable(MainFrame, TopBar)
    
    -- Tab Container
    local TabHolder = Create("Frame", {
        Name = "TabHolder",
        Size = UDim2.new(0, 120, 1, -50),
        Position = UDim2.new(0, 10, 0, 45),
        BackgroundColor3 = Config.GlassColor,
        BackgroundTransparency = 0.5,
        Parent = MainFrame
    })
    AddCorner(TabHolder, 8)
    
    local TabList = Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        Parent = TabHolder
    })
    
    local TabPadding = Create("UIPadding", {
        PaddingTop = UDim.new(0, 5),
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5),
        Parent = TabHolder
    })
    
    -- Content Area
    local ContentArea = Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -150, 1, -55),
        Position = UDim2.new(0, 140, 0, 45),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
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
    
    -- Toggle visibility
    local function ToggleWindow()
        Window.Visible = not Window.Visible
        if Window.Visible then
            MainFrame.Visible = true
            Tween(MainFrame, {Size = UDim2.new(0, 500, 0, 350)}, 0.2)
        else
            Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.2).Completed:Wait()
            MainFrame.Visible = false
        end
    end
    
    -- Minimize
    local originalSize = UDim2.new(0, 500, 0, 350)
    MinBtn.MouseButton1Click:Connect(function()
        Window.Minimized = not Window.Minimized
        if Window.Minimized then
            Tween(MainFrame, {Size = UDim2.new(0, 500, 0, 40)}, 0.2)
        else
            Tween(MainFrame, {Size = originalSize}, 0.2)
        end
    end)
    
    -- Close
    CloseBtn.MouseButton1Click:Connect(function()
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.2).Completed:Wait()
        ScreenGui:Destroy()
    end)
    
    -- INS key toggle
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Config.ToggleKey then
            ToggleWindow()
        end
    end)
    
    -- Create Tab
    function Window:CreateTab(name, icon)
        local TabBtn = Create("TextButton", {
            Name = name,
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = Config.GlassColor,
            BackgroundTransparency = 0.5,
            Text = (icon or "📁") .. " " .. name,
            TextColor3 = Config.TextColor,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            Parent = TabHolder
        })
        AddCorner(TabBtn, 6)
        
        local TabContent = Create("ScrollingFrame", {
            Name = name .. "Content",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Config.AccentColor,
            Visible = false,
            Parent = ContentArea
        })
        
        local ContentList = Create("UIListLayout", {
            Padding = UDim.new(0, 8),
            Parent = TabContent
        })
        
        local ContentPadding = Create("UIPadding", {
            PaddingTop = UDim.new(0, 5),
            PaddingLeft = UDim.new(0, 5),
            PaddingRight = UDim.new(0, 5),
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
                Tween(t.Button, {BackgroundTransparency = 0.5}, 0.1)
            end
            TabContent.Visible = true
            Tween(TabBtn, {BackgroundTransparency = 0.2}, 0.1)
            Window.CurrentTab = Tab
        end)
        
        -- Select first tab
        if #Window.Tabs == 0 then
            TabContent.Visible = true
            TabBtn.BackgroundTransparency = 0.2
            Window.CurrentTab = Tab
        end
        
        table.insert(Window.Tabs, Tab)
        
        -- UI Elements
        function Tab:CreateButton(text, callback)
            local Btn = Create("TextButton", {
                Size = UDim2.new(1, -10, 0, 35),
                BackgroundColor3 = Config.AccentColor,
                Text = text,
                TextColor3 = Config.TextColor,
                TextSize = 14,
                Font = Enum.Font.GothamMedium,
                Parent = TabContent
            })
            AddCorner(Btn, 6)
            
            Btn.MouseEnter:Connect(function()
                Tween(Btn, {BackgroundColor3 = Config.AccentColor:Lerp(Color3.new(1,1,1), 0.2)}, 0.1)
            end)
            Btn.MouseLeave:Connect(function()
                Tween(Btn, {BackgroundColor3 = Config.AccentColor}, 0.1)
            end)
            Btn.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)
            return Btn
        end
        
        function Tab:CreateToggle(text, default, callback)
            local ToggleFrame = Create("Frame", {
                Size = UDim2.new(1, -10, 0, 35),
                BackgroundColor3 = Config.GlassColor,
                BackgroundTransparency = 0.3,
                Parent = TabContent
            })
            AddCorner(ToggleFrame, 6)
            
            local Label = Create("TextLabel", {
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Config.TextColor,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = ToggleFrame
            })
            
            local ToggleBtn = Create("Frame", {
                Size = UDim2.new(0, 44, 0, 22),
                Position = UDim2.new(1, -50, 0.5, -11),
                BackgroundColor3 = Color3.fromRGB(60, 60, 80),
                Parent = ToggleFrame
            })
            AddCorner(ToggleBtn, 11)
            
            local Circle = Create("Frame", {
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new(0, 2, 0.5, -9),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Parent = ToggleBtn
            })
            AddCorner(Circle, 9)
            
            local Toggled = default or false
            
            local function Update()
                if Toggled then
                    Tween(ToggleBtn, {BackgroundColor3 = Config.AccentColor}, 0.2)
                    Tween(Circle, {Position = UDim2.new(1, -20, 0.5, -9)}, 0.2)
                else
                    Tween(ToggleBtn, {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}, 0.2)
                    Tween(Circle, {Position = UDim2.new(0, 2, 0.5, -9)}, 0.2)
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
            
            return {Frame = ToggleFrame, SetValue = function(v) Toggled = v; Update() end}
        end
        
        function Tab:CreateSlider(text, min, max, default, callback)
            local SliderFrame = Create("Frame", {
                Size = UDim2.new(1, -10, 0, 50),
                BackgroundColor3 = Config.GlassColor,
                BackgroundTransparency = 0.3,
                Parent = TabContent
            })
            AddCorner(SliderFrame, 6)
            
            local Label = Create("TextLabel", {
                Size = UDim2.new(1, -60, 0, 20),
                Position = UDim2.new(0, 10, 0, 5),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Config.TextColor,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SliderFrame
            })
            
            local ValueLabel = Create("TextLabel", {
                Size = UDim2.new(0, 50, 0, 20),
                Position = UDim2.new(1, -55, 0, 5),
                BackgroundTransparency = 1,
                Text = tostring(default or min),
                TextColor3 = Config.AccentColor,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                Parent = SliderFrame
            })
            
            local SliderBG = Create("Frame", {
                Size = UDim2.new(1, -20, 0, 8),
                Position = UDim2.new(0, 10, 0, 32),
                BackgroundColor3 = Color3.fromRGB(40, 40, 60),
                Parent = SliderFrame
            })
            AddCorner(SliderBG, 4)
            
            local SliderFill = Create("Frame", {
                Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
                BackgroundColor3 = Config.AccentColor,
                Parent = SliderBG
            })
            AddCorner(SliderFill, 4)
            
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
                    SliderFill.Size = UDim2.new(pos, 0, 1, 0)
                    ValueLabel.Text = tostring(Value)
                    if callback then callback(Value) end
                end
            end)
            
            return {Frame = SliderFrame, GetValue = function() return Value end}
        end
        
        function Tab:CreateTextbox(placeholder, callback)
            local Textbox = Create("TextBox", {
                Size = UDim2.new(1, -10, 0, 35),
                BackgroundColor3 = Config.GlassColor,
                BackgroundTransparency = 0.3,
                Text = "",
                PlaceholderText = placeholder or "Enter text...",
                TextColor3 = Config.TextColor,
                PlaceholderColor3 = Color3.fromRGB(150, 150, 170),
                TextSize = 14,
                Font = Enum.Font.Gotham,
                ClearTextOnFocus = false,
                Parent = TabContent
            })
            AddCorner(Textbox, 6)
            
            Textbox.FocusLost:Connect(function(enter)
                if enter and callback then callback(Textbox.Text) end
            end)
            
            return Textbox
        end
        
        function Tab:CreateDropdown(text, options, callback)
            local DropFrame = Create("Frame", {
                Size = UDim2.new(1, -10, 0, 35),
                BackgroundColor3 = Config.GlassColor,
                BackgroundTransparency = 0.3,
                ClipsDescendants = true,
                Parent = TabContent
            })
            AddCorner(DropFrame, 6)
            
            local Label = Create("TextLabel", {
                Size = UDim2.new(1, -30, 0, 35),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Config.TextColor,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = DropFrame
            })
            
            local Arrow = Create("TextLabel", {
                Size = UDim2.new(0, 20, 0, 35),
                Position = UDim2.new(1, -25, 0, 0),
                BackgroundTransparency = 1,
                Text = "▼",
                TextColor3 = Config.TextColor,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                Parent = DropFrame
            })
            
            local Open = false
            local Selected = nil
            
            local OptionContainer = Create("Frame", {
                Size = UDim2.new(1, -10, 0, #options * 28),
                Position = UDim2.new(0, 5, 0, 38),
                BackgroundTransparency = 1,
                Parent = DropFrame
            })
            
            local OptionList = Create("UIListLayout", {Padding = UDim.new(0, 3), Parent = OptionContainer})
            
            for _, opt in ipairs(options) do
                local OptBtn = Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 25),
                    BackgroundColor3 = Config.AccentColor,
                    BackgroundTransparency = 0.5,
                    Text = opt,
                    TextColor3 = Config.TextColor,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    Parent = OptionContainer
                })
                AddCorner(OptBtn, 4)
                
                OptBtn.MouseButton1Click:Connect(function()
                    Selected = opt
                    Label.Text = text .. ": " .. opt
                    Open = false
                    Tween(DropFrame, {Size = UDim2.new(1, -10, 0, 35)}, 0.2)
                    Arrow.Text = "▼"
                    if callback then callback(opt) end
                end)
            end
            
            DropFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Open = not Open
                    if Open then
                        Tween(DropFrame, {Size = UDim2.new(1, -10, 0, 40 + #options * 28)}, 0.2)
                        Arrow.Text = "▲"
                    else
                        Tween(DropFrame, {Size = UDim2.new(1, -10, 0, 35)}, 0.2)
                        Arrow.Text = "▼"
                    end
                end
            end)
            
            return {Frame = DropFrame, GetSelected = function() return Selected end}
        end
        
        function Tab:CreateLabel(text)
            local Lbl = Create("TextLabel", {
                Size = UDim2.new(1, -10, 0, 25),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Config.TextColor,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = TabContent
            })
            return Lbl
        end
        
        function Tab:CreateKeybind(text, default, callback)
            local KeyFrame = Create("Frame", {
                Size = UDim2.new(1, -10, 0, 35),
                BackgroundColor3 = Config.GlassColor,
                BackgroundTransparency = 0.3,
                Parent = TabContent
            })
            AddCorner(KeyFrame, 6)
            
            local Label = Create("TextLabel", {
                Size = UDim2.new(1, -80, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Config.TextColor,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = KeyFrame
            })
            
            local KeyBtn = Create("TextButton", {
                Size = UDim2.new(0, 60, 0, 25),
                Position = UDim2.new(1, -70, 0.5, -12),
                BackgroundColor3 = Config.AccentColor,
                Text = default and default.Name or "None",
                TextColor3 = Config.TextColor,
                TextSize = 12,
                Font = Enum.Font.GothamMedium,
                Parent = KeyFrame
            })
            AddCorner(KeyBtn, 4)
            
            local CurrentKey = default
            local Listening = false
            
            KeyBtn.MouseButton1Click:Connect(function()
                Listening = true
                KeyBtn.Text = "..."
            end)
            
            UserInputService.InputBegan:Connect(function(input, processed)
                if Listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    CurrentKey = input.KeyCode
                    KeyBtn.Text = input.KeyCode.Name
                    Listening = false
                elseif not processed and CurrentKey and input.KeyCode == CurrentKey then
                    if callback then callback() end
                end
            end)
            
            return {Frame = KeyFrame, GetKey = function() return CurrentKey end}
        end
        
        function Tab:CreateColorPicker(text, default, callback)
            local ColorFrame = Create("Frame", {
                Size = UDim2.new(1, -10, 0, 35),
                BackgroundColor3 = Config.GlassColor,
                BackgroundTransparency = 0.3,
                Parent = TabContent
            })
            AddCorner(ColorFrame, 6)
            
            local Label = Create("TextLabel", {
                Size = UDim2.new(1, -50, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Config.TextColor,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = ColorFrame
            })
            
            local ColorPreview = Create("Frame", {
                Size = UDim2.new(0, 30, 0, 25),
                Position = UDim2.new(1, -40, 0.5, -12),
                BackgroundColor3 = default or Color3.fromRGB(255, 255, 255),
                Parent = ColorFrame
            })
            AddCorner(ColorPreview, 4)
            
            local CurrentColor = default or Color3.new(1, 1, 1)
            
            ColorFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local h, s, v = CurrentColor:ToHSV()
                    h = (h + 0.1) % 1
                    CurrentColor = Color3.fromHSV(h, s, v)
                    ColorPreview.BackgroundColor3 = CurrentColor
                    if callback then callback(CurrentColor) end
                end
            end)
            
            return {Frame = ColorFrame, GetColor = function() return CurrentColor end}
        end
        
        return Tab
    end
    
    function Window:Destroy()
        ScreenGui:Destroy()
    end
    
    function Window:SetVisible(visible)
        MainFrame.Visible = visible
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
    
    local NotifFrame = Create("Frame", {
        Size = UDim2.new(0, 280, 0, 70),
        Position = UDim2.new(1, 300, 1, -80 - (#ScreenGui:GetChildren() - 1) * 80),
        BackgroundColor3 = Config.MainColor,
        Parent = ScreenGui
    })
    AddCorner(NotifFrame, 8)
    AddGlass(NotifFrame)
    
    local Title = Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 25),
        Position = UDim2.new(0, 10, 0, 5),
        BackgroundTransparency = 1,
        Text = title or "Notification",
        TextColor3 = Config.AccentColor,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = NotifFrame
    })
    
    local Message = Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 35),
        Position = UDim2.new(0, 10, 0, 30),
        BackgroundTransparency = 1,
        Text = message or "",
        TextColor3 = Config.TextColor,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = NotifFrame
    })
    
    Tween(NotifFrame, {Position = UDim2.new(1, -290, 1, -80 - (#ScreenGui:GetChildren() - 1) * 80)}, 0.3)
    
    task.delay(duration or 3, function()
        Tween(NotifFrame, {Position = UDim2.new(1, 300, NotifFrame.Position.Y.Scale, NotifFrame.Position.Y.Offset)}, 0.3).Completed:Wait()
        NotifFrame:Destroy()
    end)
end

return LiquidLibrary
