--[[
    Mac UI Sample Script v1.6.0
    全機能デモ
]]

local MacUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/dakuniri/UI/refs/heads/main/mac-library.luau"))()

-- SaveManager設定
MacUI.SaveManager:SetFolder("MacUI_Config")

local Window = MacUI:CreateWindow({
    Title = "Mac UI v1.6.0"
})

-- 現在のコンフィグ名
local CurrentConfig = "default"

-- 設定データをロード
local function LoadSettings()
    return MacUI.SaveManager:Load(CurrentConfig) or {
        WalkSpeed = 16,
        JumpPower = 50,
        GodMode = false,
        Noclip = false,
        Fullbright = false,
        FOV = 70
    }
end

local Settings = LoadSettings()

-- General Tab
local GeneralTab = Window:CreateTab("General")

GeneralTab:CreateSection("Player Controls")

GeneralTab:CreateToggle("God Mode", Settings.GodMode, function(v)
    Settings.GodMode = v
    pcall(function()
        local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.MaxHealth = v and math.huge or 100
            hum.Health = v and math.huge or 100
        end
    end)
end)

GeneralTab:CreateToggle("Noclip", Settings.Noclip, function(v)
    Settings.Noclip = v
    _G.NoclipEnabled = v
end)

GeneralTab:CreateSlider("WalkSpeed", 16, 500, Settings.WalkSpeed, function(v)
    Settings.WalkSpeed = v
    pcall(function()
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = v
    end)
end)

GeneralTab:CreateSlider("JumpPower", 50, 500, Settings.JumpPower, function(v)
    Settings.JumpPower = v
    pcall(function()
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = v
    end)
end)

GeneralTab:CreateSection("Actions")

GeneralTab:CreateButton("Respawn", function()
    game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health = 0
end)

GeneralTab:CreateButton("Rejoin", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
end)

-- Teleport Tab
local TeleportTab = Window:CreateTab("Teleport")

TeleportTab:CreateSection("Quick Teleport")

TeleportTab:CreateButton("TP to Mouse", function()
    pcall(function()
        local mouse = game.Players.LocalPlayer:GetMouse()
        game.Players.LocalPlayer.Character:MoveTo(mouse.Hit.Position)
    end)
end)

TeleportTab:CreateSection("Coordinates")

TeleportTab:CreateInput("X Position", "0", function(val)
    _G.TpX = tonumber(val) or 0
end)

TeleportTab:CreateInput("Y Position", "0", function(val)
    _G.TpY = tonumber(val) or 0
end)

TeleportTab:CreateInput("Z Position", "0", function(val)
    _G.TpZ = tonumber(val) or 0
end)

TeleportTab:CreateButton("Teleport to Coords", function()
    pcall(function()
        game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(_G.TpX or 0, _G.TpY or 0, _G.TpZ or 0))
    end)
end)

-- Executor Tab
local ExecutorTab = Window:CreateTab("Executor")

ExecutorTab:CreateSection("Script Execution")

ExecutorTab:CreateExecutor("Lua Executor")

-- Visual Tab
local VisualTab = Window:CreateTab("Visual")

VisualTab:CreateSection("Lighting")

VisualTab:CreateToggle("Fullbright", Settings.Fullbright, function(v)
    Settings.Fullbright = v
    pcall(function()
        local l = game:GetService("Lighting")
        l.Brightness = v and 2 or 1
        l.GlobalShadows = not v
    end)
end)

VisualTab:CreateSlider("FOV", 70, 120, Settings.FOV, function(v)
    Settings.FOV = v
    pcall(function()
        workspace.CurrentCamera.FieldOfView = v
    end)
end)

VisualTab:CreateSlider("Time", 0, 24, 12, function(v)
    pcall(function()
        game:GetService("Lighting").ClockTime = v
    end)
end)

-- Stats Tab
local StatsTab = Window:CreateTab("Stats")

StatsTab:CreateSection("Performance")

local Graph = StatsTab:CreateGraph("FPS History", {60, 55, 58, 60, 62})

StatsTab:CreateButton("Update Graph", function()
    local newData = {}
    for i = 1, 5 do
        newData[i] = math.random(30, 60)
    end
    Graph:Update(newData)
end)

StatsTab:CreateSection("Player Info")

StatsTab:CreateLabel("ユーザー: " .. game.Players.LocalPlayer.Name)

-- Settings Tab
local SettingsTab = Window:CreateTab("Settings")

SettingsTab:CreateSection("Config Selection")

-- コンフィグ一覧を取得
local function GetConfigList()
    local list = MacUI.SaveManager:GetConfigs()
    if #list == 0 then
        list = {"default"}
    end
    return list
end

SettingsTab:CreateDropdown("Select Config", GetConfigList(), CurrentConfig, function(name)
    CurrentConfig = name
    MacUI.SaveManager:SetConfig(name)
    Window:Notify({Title = "Config", Content = name .. " を選択", Duration = 2})
end)

SettingsTab:CreateInput("New Config Name", "myconfig", function(name)
    if name and name ~= "" then
        CurrentConfig = name
        MacUI.SaveManager:SetConfig(name)
        Window:Notify({Title = "Config", Content = name .. " を作成準備", Duration = 2})
    end
end)

SettingsTab:CreateSection("Config Actions")

SettingsTab:CreateButton("💾 Save Config", function()
    local success = MacUI.SaveManager:Save(Settings, CurrentConfig)
    if success then
        Window:Notify({Title = "Success", Content = CurrentConfig .. " を保存しました", Duration = 2})
    else
        Window:Notify({Title = "Error", Content = "保存に失敗しました", Duration = 2})
    end
end)

SettingsTab:CreateButton("📂 Load Config", function()
    local data = MacUI.SaveManager:Load(CurrentConfig)
    if data then
        Settings = data
        Window:Notify({Title = "Success", Content = CurrentConfig .. " を読込 (再起動で反映)", Duration = 3})
    else
        Window:Notify({Title = "Info", Content = "保存データがありません", Duration = 2})
    end
end)

SettingsTab:CreateButton("🗑️ Delete Config", function()
    MacUI.SaveManager:Delete(CurrentConfig)
    Window:Notify({Title = "Deleted", Content = CurrentConfig .. " を削除", Duration = 2})
end)

SettingsTab:CreateSection("Window Controls")

SettingsTab:CreateLabel("🔴 閉じる | 🟡 最小化 | 🟢 最大化 | 📱 MC")

Window:Notify({Title = "Welcome", Content = "Mac UI v1.6.0 loaded!", Duration = 3})
