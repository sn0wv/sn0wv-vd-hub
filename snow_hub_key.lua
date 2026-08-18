-- SNOW HUB
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer

local ValidKeys = {115, 110, 48, 87, 95, 68, 101, 86, 33}

local function CheckKey(input)
    if #input ~= #ValidKeys then return false end
    for i = 1, #ValidKeys do
        if string.byte(input, i) ~= ValidKeys[i] then return false end
    end
    return true
end

local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "SnowKey"
KeyGui.ResetOnSpawn = false
KeyGui.Parent = LP:WaitForChild("PlayerGui")

local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 300, 0, 190)
KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -95)
KeyFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
KeyFrame.BorderSizePixel = 0
KeyFrame.Parent = KeyGui
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", KeyFrame).Color = Color3.fromRGB(40, 40, 50)

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 32)
KeyTitle.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
KeyTitle.BorderSizePixel = 0
KeyTitle.Text = "SNOW HUB"
KeyTitle.TextColor3 = Color3.new(1, 1, 1)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 14
KeyTitle.Parent = KeyFrame
Instance.new("UICorner", KeyTitle).CornerRadius = UDim.new(0, 8)

local KeyLabel = Instance.new("TextLabel")
KeyLabel.Size = UDim2.new(1, -20, 0, 20)
KeyLabel.Position = UDim2.new(0, 10, 0, 38)
KeyLabel.BackgroundTransparency = 1
KeyLabel.Text = "Enter key:"
KeyLabel.TextColor3 = Color3.fromRGB(160, 160, 180)
KeyLabel.Font = Enum.Font.Gotham
KeyLabel.TextSize = 12
KeyLabel.TextXAlignment = Enum.TextXAlignment.Left
KeyLabel.Parent = KeyFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(1, -20, 0, 28)
KeyBox.Position = UDim2.new(0, 10, 0, 60)
KeyBox.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
KeyBox.BorderSizePixel = 0
KeyBox.PlaceholderText = "Paste key here..."
KeyBox.PlaceholderColor3 = Color3.fromRGB(60, 60, 70)
KeyBox.TextColor3 = Color3.new(1, 1, 1)
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 12
KeyBox.ClearTextOnFocus = false
KeyBox.Parent = KeyFrame
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 5)

local KeyBtn = Instance.new("TextButton")
KeyBtn.Size = UDim2.new(1, -20, 0, 28)
KeyBtn.Position = UDim2.new(0, 10, 0, 94)
KeyBtn.BackgroundColor3 = Color3.fromRGB(45, 140, 70)
KeyBtn.BorderSizePixel = 0
KeyBtn.Text = "ENTER"
KeyBtn.TextColor3 = Color3.new(1, 1, 1)
KeyBtn.Font = Enum.Font.GothamBold
KeyBtn.TextSize = 13
KeyBtn.Parent = KeyFrame
Instance.new("UICorner", KeyBtn).CornerRadius = UDim.new(0, 5)

local KeyStatus = Instance.new("TextLabel")
KeyStatus.Size = UDim2.new(1, -20, 0, 18)
KeyStatus.Position = UDim2.new(0, 10, 0, 128)
KeyStatus.BackgroundTransparency = 1
KeyStatus.Text = ""
KeyStatus.TextColor3 = Color3.fromRGB(255, 70, 70)
KeyStatus.Font = Enum.Font.GothamBold
KeyStatus.TextSize = 11
KeyStatus.Parent = KeyFrame

local function StartHub()
    KeyGui:Destroy()

    local Config = {
        MenuOpen = false,
        AutoDagger = false,
        AutoDaggerKey = Enum.KeyCode.None,
        AutoDaggerRange = 15,
        ESPManiac = false,
        ESPManiacKey = Enum.KeyCode.None,
        ESPSurvivors = false,
        ESPSurvivorsKey = Enum.KeyCode.None,
        ESPSurvivorsName = true,
        ESPSurvivorsDist = true,
        ESPGenerators = false,
        ESPGeneratorsKey = Enum.KeyCode.None,
        ESPPallets = false,
        ESPPalletsKey = Enum.KeyCode.None,
        ESPWindows = false,
        ESPWindowsKey = Enum.KeyCode.None,
        ESPColor = Color3.fromRGB(255, 50, 50),
        MenuColor = Color3.fromRGB(80, 140, 240),
        Speed = false,
        SpeedKey = Enum.KeyCode.None,
        SpeedVal = 24,
        Jump = false,
        JumpKey = Enum.KeyCode.None,
        JumpVal = 80,
        Noclip = false,
        NoclipKey = Enum.KeyCode.None,
    }

    local ESPObjects = {}
    local ESPType = {}
    local MapESPObjects = {}
    local Character = LP.Character or LP.CharacterAdded:Wait()
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local ToggleBtns = {}
    local ScreenGui, MenuFrame, Title, Container, KBFrame, KBTitle, KBStroke, KBContainer
    local KBRows, KBLabels = {}, {}
    local SectionLabels = {}
    local AllElements = {}

    local function RemoveESPByType(t)
        for p, esp in pairs(ESPObjects) do
            if ESPType[p] == t then
                if esp.Billboard then esp.Billboard:Destroy() end
                if esp.Highlight then esp.Highlight:Destroy() end
                ESPObjects[p] = nil
                ESPType[p] = nil
            end
        end
    end

    LP.CharacterAdded:Connect(function(c)
        Character = c
        Humanoid = c:WaitForChild("Humanoid")
        if Config.Noclip then
            task.spawn(function()
                while Config.Noclip and Character and Character.Parent do
                    for _, part in pairs(Character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end)

    local function BuildUI()
        ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "SnowHub"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        pcall(function()
            local old = LP:WaitForChild("PlayerGui"):FindFirstChild("SnowHub")
            if old then old:Destroy() end
        end)
        ScreenGui.Parent = LP:WaitForChild("PlayerGui")

        MenuFrame = Instance.new("Frame")
        MenuFrame.Size = UDim2.new(0, 340, 0, 420)
        MenuFrame.Position = UDim2.new(0.5, -170, 0.5, -210)
        MenuFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
        MenuFrame.BorderSizePixel = 0
        MenuFrame.Visible = Config.MenuOpen
        MenuFrame.Parent = ScreenGui
        Instance.new("UICorner", MenuFrame).CornerRadius = UDim.new(0, 8)
        local MenuStrokeInst = Instance.new("UIStroke", MenuFrame)
        MenuStrokeInst.Color = Config.MenuColor
        MenuStrokeInst.Thickness = 1
        AllElements.menuStroke = MenuStrokeInst

        Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, 0, 0, 34)
        Title.BackgroundColor3 = Color3.new(Config.MenuColor.R * 0.3, Config.MenuColor.G * 0.3, Config.MenuColor.B * 0.3)
        Title.BorderSizePixel = 0
        Title.Text = "SNOW HUB"
        Title.TextColor3 = Color3.new(1, 1, 1)
        Title.Font = Enum.Font.GothamBold
        Title.TextSize = 14
        Title.Parent = MenuFrame
        Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 8)
        AllElements.title = Title

        Container = Instance.new("ScrollingFrame")
        Container.Size = UDim2.new(1, -12, 1, -40)
        Container.Position = UDim2.new(0, 6, 0, 38)
        Container.BackgroundTransparency = 1
        Container.ScrollBarThickness = 3
        Container.ScrollBarImageColor3 = Config.MenuColor
        Container.CanvasSize = UDim2.new(0, 0, 0, 0)
        Container.Parent = MenuFrame
        AllElements.container = Container

        Instance.new("UIListLayout", Container).Padding = UDim.new(0, 4)
        Container:FindFirstChildOfClass("UIListLayout").SortOrder = Enum.SortOrder.LayoutOrder
    end

    local function AutoScroll()
        local total = 0
        for _, child in pairs(Container:GetChildren()) do
            if child:IsA("Frame") then total = total + child.Size.Y.Offset + 4 end
        end
        Container.CanvasSize = UDim2.new(0, 0, 0, total + 8)
    end

    local function CreateSection(name, order)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 0, 24)
        f.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
        f.BorderSizePixel = 0
        f.LayoutOrder = order
        f.Parent = Container
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)
        local t = Instance.new("TextLabel")
        t.Size = UDim2.new(1, -10, 1, 0)
        t.Position = UDim2.new(0, 10, 0, 0)
        t.BackgroundTransparency = 1
        t.Text = name
        t.TextColor3 = Config.MenuColor
        t.Font = Enum.Font.GothamBold
        t.TextSize = 11
        t.TextXAlignment = Enum.TextXAlignment.Left
        t.Parent = f
        SectionLabels[name] = t
        AutoScroll()
    end

    local function CreateToggle(name, default, order, callback)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 0, 26)
        f.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
        f.BorderSizePixel = 0
        f.LayoutOrder = order
        f.Parent = Container
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)

        local t = Instance.new("TextLabel")
        t.Size = UDim2.new(0.65, 0, 1, 0)
        t.Position = UDim2.new(0, 10, 0, 0)
        t.BackgroundTransparency = 1
        t.Text = name
        t.TextColor3 = Color3.fromRGB(200, 200, 210)
        t.Font = Enum.Font.Gotham
        t.TextSize = 12
        t.TextXAlignment = Enum.TextXAlignment.Left
        t.Parent = f

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 44, 0, 18)
        btn.Position = UDim2.new(1, -54, 0.5, -9)
        btn.BackgroundColor3 = default and Color3.fromRGB(45, 150, 70) or Color3.fromRGB(28, 28, 32)
        btn.BorderSizePixel = 0
        btn.Text = default and "ON" or "OFF"
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        btn.Parent = f
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

        local state = default
        ToggleBtns[name] = {btn = btn, getState = function() return state end, setState = function(s)
            state = s
            btn.Text = state and "ON" or "OFF"
            btn.BackgroundColor3 = state and Color3.fromRGB(45, 150, 70) or Color3.fromRGB(28, 28, 32)
        end}

        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.Text = state and "ON" or "OFF"
            btn.BackgroundColor3 = state and Color3.fromRGB(45, 150, 70) or Color3.fromRGB(28, 28, 32)
            callback(state)
        end)
        AutoScroll()
    end

    local function CreateKeybind(name, default, order, callback)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 0, 26)
        f.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
        f.BorderSizePixel = 0
        f.LayoutOrder = order
        f.Parent = Container
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)

        local t = Instance.new("TextLabel")
        t.Size = UDim2.new(0.5, 0, 1, 0)
        t.Position = UDim2.new(0, 10, 0, 0)
        t.BackgroundTransparency = 1
        t.Text = name
        t.TextColor3 = Color3.fromRGB(160, 160, 175)
        t.Font = Enum.Font.Gotham
        t.TextSize = 11
        t.TextXAlignment = Enum.TextXAlignment.Left
        t.Parent = f

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 80, 0, 18)
        btn.Position = UDim2.new(1, -90, 0.5, -9)
        btn.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
        btn.BorderSizePixel = 0
        btn.Text = default == Enum.KeyCode.None and "[ NONE ]" or "[ "..default.Name.." ]"
        btn.TextColor3 = Color3.fromRGB(180, 180, 200)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        btn.Parent = f
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

        local listening = false
        local currentKey = default
        btn.MouseButton1Click:Connect(function()
            if listening then return end
            listening = true
            btn.Text = "[ ... ]"
            btn.BackgroundColor3 = Color3.fromRGB(140, 110, 30)
            local conn
            conn = UserInputService.InputBegan:Connect(function(input, gpe)
                if gpe then return end
                if input.KeyCode == Enum.KeyCode.Escape then
                    currentKey = Enum.KeyCode.None
                    btn.Text = "[ NONE ]"
                else
                    currentKey = input.KeyCode
                    btn.Text = "[ "..input.KeyCode.Name.." ]"
                end
                btn.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
                listening = false
                conn:Disconnect()
                callback(currentKey)
            end)
        end)
        AutoScroll()
    end

    local function CreateSubToggle(name, default, order, parentOrder, callback)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 0, 22)
        f.BackgroundColor3 = Color3.fromRGB(10, 10, 13)
        f.BorderSizePixel = 0
        f.LayoutOrder = order
        f.Parent = Container
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 4)

        local t = Instance.new("TextLabel")
        t.Size = UDim2.new(0.7, -8, 1, 0)
        t.Position = UDim2.new(0, 16, 0, 0)
        t.BackgroundTransparency = 1
        t.Text = name
        t.TextColor3 = Color3.fromRGB(150, 150, 165)
        t.Font = Enum.Font.Gotham
        t.TextSize = 11
        t.TextXAlignment = Enum.TextXAlignment.Left
        t.Parent = f

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 38, 0, 16)
        btn.Position = UDim2.new(1, -48, 0.5, -8)
        btn.BackgroundColor3 = default and Color3.fromRGB(45, 150, 70) or Color3.fromRGB(24, 24, 28)
        btn.BorderSizePixel = 0
        btn.Text = default and "ON" or "OFF"
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 9
        btn.Parent = f
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 3)

        local state = default
        ToggleBtns[name] = {btn = btn, getState = function() return state end, setState = function(s)
            state = s
            btn.Text = state and "ON" or "OFF"
            btn.BackgroundColor3 = state and Color3.fromRGB(45, 150, 70) or Color3.fromRGB(24, 24, 28)
        end}

        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.Text = state and "ON" or "OFF"
            btn.BackgroundColor3 = state and Color3.fromRGB(45, 150, 70) or Color3.fromRGB(24, 24, 28)
            callback(state)
        end)
        AutoScroll()
    end

    local function CreateSlider(name, min, max, default, order, callback)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 0, 30)
        f.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
        f.BorderSizePixel = 0
        f.LayoutOrder = order
        f.Parent = Container
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)

        local t = Instance.new("TextLabel")
        t.Size = UDim2.new(0.5, 0, 0, 16)
        t.Position = UDim2.new(0, 10, 0, 2)
        t.BackgroundTransparency = 1
        t.Text = name
        t.TextColor3 = Color3.fromRGB(200, 200, 210)
        t.Font = Enum.Font.Gotham
        t.TextSize = 11
        t.TextXAlignment = Enum.TextXAlignment.Left
        t.Parent = f

        local val = Instance.new("TextLabel")
        val.Size = UDim2.new(0.3, 0, 0, 16)
        val.Position = UDim2.new(0.7, 0, 0, 2)
        val.BackgroundTransparency = 1
        val.Text = tostring(default)
        val.TextColor3 = Color3.fromRGB(255, 200, 80)
        val.Font = Enum.Font.GothamBold
        val.TextSize = 11
        val.Parent = f

        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(1, -20, 0, 6)
        bar.Position = UDim2.new(0, 10, 0, 20)
        bar.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
        bar.BorderSizePixel = 0
        bar.Parent = f
        Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 3)

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = Config.MenuColor
        fill.BorderSizePixel = 0
        fill.Parent = bar
        Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 3)

        local dragging = false
        bar.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
        end)
        UserInputService.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
        UserInputService.InputChanged:Connect(function(inp)
            if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
                local rel = math.clamp((inp.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                local v = math.floor(min + (max - min) * rel)
                fill.Size = UDim2.new(rel, 0, 1, 0)
                val.Text = tostring(v)
                callback(v)
            end
        end)
        AutoScroll()
        callback(default)
    end

    local function CreateColorPicker(name, default, order, callback)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 0, 26)
        f.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
        f.BorderSizePixel = 0
        f.LayoutOrder = order
        f.Parent = Container
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)

        local t = Instance.new("TextLabel")
        t.Size = UDim2.new(0.5, 0, 1, 0)
        t.Position = UDim2.new(0, 10, 0, 0)
        t.BackgroundTransparency = 1
        t.Text = name
        t.TextColor3 = Color3.fromRGB(160, 160, 175)
        t.Font = Enum.Font.Gotham
        t.TextSize = 11
        t.TextXAlignment = Enum.TextXAlignment.Left
        t.Parent = f

        local presets = {
            Color3.fromRGB(255, 50, 50),
            Color3.fromRGB(50, 200, 255),
            Color3.fromRGB(255, 255, 50),
            Color3.fromRGB(255, 150, 50),
            Color3.fromRGB(200, 100, 255),
            Color3.fromRGB(50, 255, 100),
            Color3.fromRGB(255, 255, 255),
            Color3.fromRGB(255, 100, 200),
        }

        local currentColor = default
        local buttons = {}
        local startX = -#presets * 18 - 6
        for i, c in ipairs(presets) do
            local cb = Instance.new("TextButton")
            cb.Size = UDim2.new(0, 14, 0, 14)
            cb.Position = UDim2.new(1, startX + (i - 1) * 18, 0.5, -7)
            cb.BackgroundColor3 = c
            cb.BorderSizePixel = i == 1 and 2 or 0
            cb.BorderColor3 = Color3.new(1, 1, 1)
            cb.Text = ""
            cb.Parent = f
            Instance.new("UICorner", cb).CornerRadius = UDim.new(0, 3)
            buttons[i] = cb

            cb.MouseButton1Click:Connect(function()
                currentColor = c
                callback(c)
                for j, b in ipairs(buttons) do
                    b.BorderSizePixel = j == i and 2 or 0
                end
            end)
        end
        AutoScroll()
    end

    local function CreateESP(player)
        if ESPObjects[player] then return end
        local esp = {}
        local bb = Instance.new("BillboardGui")
        bb.Size = UDim2.new(0, 160, 0, 34)
        bb.StudsOffset = Vector3.new(0, 2.5, 0)
        bb.AlwaysOnTop = true
        bb.LightInfluence = 0
        bb.MaxDistance = 500
        bb.Parent = player.Character and player.Character:FindFirstChild("Head")

        local nl = Instance.new("TextLabel")
        nl.Size = UDim2.new(1, 0, 0.5, 0)
        nl.BackgroundTransparency = 1
        nl.Font = Enum.Font.GothamBold
        nl.TextSize = 13
        nl.TextStrokeTransparency = 0.4
        nl.TextStrokeColor3 = Color3.new(0, 0, 0)
        nl.Parent = bb

        local dl = Instance.new("TextLabel")
        dl.Size = UDim2.new(1, 0, 0.5, 0)
        dl.Position = UDim2.new(0, 0, 0.5, 0)
        dl.BackgroundTransparency = 1
        dl.Font = Enum.Font.Gotham
        dl.TextSize = 11
        dl.TextStrokeTransparency = 0.4
        dl.TextStrokeColor3 = Color3.new(0, 0, 0)
        dl.Parent = bb

        esp.Billboard = bb
        esp.NameLabel = nl
        esp.DistLabel = dl

        local hl = Instance.new("Highlight")
        hl.FillTransparency = 0.7
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = player.Character

        esp.Highlight = hl
        ESPObjects[player] = esp
    end

    local function RemoveESP(player)
        local esp = ESPObjects[player]
        if esp then
            if esp.Billboard then esp.Billboard:Destroy() end
            if esp.Highlight then esp.Highlight:Destroy() end
            ESPObjects[player] = nil
        end
    end

    local function UpdateESP(player, color, showName, showDist, espType)
        local esp = ESPObjects[player]
        if not esp then return end
        if not player.Character or not player.Character:FindFirstChild("Head") then
            if esp.Billboard then esp.Billboard:Destroy() end
            if esp.Highlight then esp.Highlight:Destroy() end
            ESPObjects[player] = nil
            ESPType[player] = nil
            return
        end
        esp.Billboard.Parent = player.Character:FindFirstChild("Head")
        esp.NameLabel.Text = showName and player.Name or ""
        esp.NameLabel.TextColor3 = color
        esp.Highlight.FillColor = color
        esp.Highlight.OutlineColor = color
        esp.Highlight.Parent = player.Character
        if showDist and Character and Character:FindFirstChild("Head") then
            local dist = math.floor((player.Character.Head.Position - Character.Head.Position).Magnitude)
            esp.DistLabel.Text = dist.."m"
            esp.DistLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            esp.DistLabel.Visible = true
        else
            esp.DistLabel.Visible = false
        end
        ESPType[player] = espType
    end

    local function CreateMapESP(obj, color)
        if MapESPObjects[obj] then return end
        local hl = Instance.new("Highlight")
        hl.FillColor = color
        hl.FillTransparency = 0.75
        hl.OutlineColor = color
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = obj
        MapESPObjects[obj] = { Highlight = hl }
    end

    local function RemoveMapESP(obj)
        local e = MapESPObjects[obj]
        if e then
            if e.Highlight then e.Highlight:Destroy() end
            MapESPObjects[obj] = nil
        end
    end

    local MapScanCache = {}
    local MapScanTime = 0
    local MAP_SCAN_INTERVAL = 2

    local function FindPallets()
        local pals = {}
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") then
                local n = obj.Name:lower()
                if n:find("pallet") or n:find("plank") or n:find("wood") then
                    local primary = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                    if primary then table.insert(pals, primary) end
                end
            elseif obj:IsA("BasePart") then
                local n = obj.Name:lower()
                if n:find("pallet") or n:find("plank") then
                    table.insert(pals, obj)
                end
            end
        end
        return pals
    end

    local function FindGenerators()
        local gens = {}
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") then
                local n = obj.Name:lower()
                if n:find("generator") or n:find("gen") or n:find("gens") then
                    local primary = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                    if primary then table.insert(gens, primary) end
                end
            elseif obj:IsA("BasePart") then
                local n = obj.Name:lower()
                if n:find("generator") or n == "gen" then
                    table.insert(gens, obj)
                end
            end
        end
        return gens
    end

    local function FindWindows()
        local wins = {}
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") then
                local n = obj.Name:lower()
                if n:find("window") or n:find("barricade") or n:find("board") or n:find("vault") or n:find("break") then
                    local primary = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                    if primary then table.insert(wins, primary) end
                end
            elseif obj:IsA("BasePart") then
                local n = obj.Name:lower()
                if n:find("window") or n:find("barricade") or n:find("board") or n:find("vault") or n:find("break") or n:find("glass") then
                    table.insert(wins, obj)
                end
            end
        end
        return wins
    end

    local function ScanMapObjects()
        local now = tick()
        if now - MapScanTime < MAP_SCAN_INTERVAL then return MapScanCache end
        MapScanTime = now
        MapScanCache = {
            pallets = Config.ESPPallets and FindPallets() or {},
            generators = Config.ESPGenerators and FindGenerators() or {},
            windows = Config.ESPWindows and FindWindows() or {},
        }
        return MapScanCache
    end

    local function GetDagger()
        local bp = LP:FindFirstChild("Backpack")
        local ch = LP.Character
        if ch then
            for _, t in pairs(ch:GetChildren()) do
                if t:IsA("Tool") then
                    local n = t.Name:lower()
                    if n:find("dagger") or n:find("knife") or n:find("blade") or n:find("sword") then return t end
                end
            end
        end
        if bp then
            for _, t in pairs(bp:GetChildren()) do
                if t:IsA("Tool") then
                    local n = t.Name:lower()
                    if n:find("dagger") or n:find("knife") or n:find("blade") or n:find("sword") then return t end
                end
            end
        end
        return nil
    end

    local function IsSwinging(tool)
        if not tool then return false end
        local anim = tool:FindFirstChildOfClass("Animator")
        if not anim then
            local ctrl = tool:FindFirstChildOfClass("AnimationController")
            if ctrl then anim = ctrl:FindFirstChildOfClass("Animator") end
        end
        if anim then
            for _, track in pairs(anim:GetPlayingAnimationTracks()) do
                if track and track.IsPlaying then
                    local n = (track.Animation and track.Animation.Name or ""):lower()
                    if n:find("attack") or n:find("swing") or n:find("hit") or n:find("stab") or n:find("slash") or n:find("kill") or n:find("heavy") or n:find("light") then
                        return true
                    end
                end
            end
        end
        return false
    end

    local function GetManiac()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local h = p.Character:FindFirstChildOfClass("Humanoid")
                local hd = p.Character:FindFirstChild("Head")
                if h and hd and h.Health > 0 then
                    local t = p.Character:FindFirstChildOfClass("Tool")
                    if t then
                        local n = t.Name:lower()
                        if n:find("knife") or n:find("dagger") or n:find("blade") or n:find("axe") or n:find("hammer") or n:find("bat") or n:find("sword") or n:find("weapon") or n:find("kill") then
                            return p, t
                        end
                    end
                end
            end
        end
        return nil, nil
    end

    local daggerCooldown = false
    local function AutoDaggerTick()
        if not Config.AutoDagger then return end
        if daggerCooldown then return end
        if not Character or not Character.Parent then return end
        if Humanoid and Humanoid.Health <= 0 then return end
        local maniac, weapon = GetManiac()
        if maniac and weapon then
            local head = maniac.Character and maniac.Character:FindFirstChild("Head")
            local myHead = Character:FindFirstChild("Head")
            if head and myHead then
                local dist = (head.Position - myHead.Position).Magnitude
                if dist <= Config.AutoDaggerRange and IsSwinging(weapon) then
                    daggerCooldown = true
                    local dagger = GetDagger()
                    if dagger then
                        if dagger.Parent ~= Character then
                            Humanoid:EquipTool(dagger)
                            task.wait(0.05)
                        end
                        dagger:Activate()
                    end
                    task.wait(0.25)
                    daggerCooldown = false
                end
            end
        end
    end

    local function SyncToggle(name, val)
        local t = ToggleBtns[name]
        if t then t.setState(val) end
    end

    local function ApplyMenuColor(c)
        Config.MenuColor = c
        if AllElements.menuStroke then AllElements.menuStroke.Color = c end
        if AllElements.title then AllElements.title.BackgroundColor3 = Color3.new(c.R * 0.3, c.G * 0.3, c.B * 0.3) end
        if AllElements.container then AllElements.container.ScrollBarImageColor3 = c end
        for _, label in pairs(SectionLabels) do
            label.TextColor3 = c
        end
        if KBStroke then KBStroke.Color = c end
        if KBTitle then KBTitle.BackgroundColor3 = Color3.new(c.R * 0.3, c.G * 0.3, c.B * 0.3) end
        if KBContainer then KBContainer.ScrollBarImageColor3 = c end
    end

    BuildUI()

    CreateSection("COMBAT", 1)
    CreateToggle("Auto-kinzhal", false, 2, function(v) Config.AutoDagger = v end)
    CreateKeybind("Bind:", Enum.KeyCode.None, 3, function(k) Config.AutoDaggerKey = k end)
    CreateSlider("Range:", 5, 50, 15, 4, function(v) Config.AutoDaggerRange = v end)

    CreateSection("MOVEMENT", 10)
    CreateToggle("Speed", false, 11, function(v) Config.Speed = v end)
    CreateKeybind("Bind:", Enum.KeyCode.None, 111, function(k) Config.SpeedKey = k end)
    CreateSlider("Speed:", 16, 100, 24, 12, function(v) Config.SpeedVal = v end)
    CreateToggle("Jump", false, 13, function(v) Config.Jump = v end)
    CreateKeybind("Bind:", Enum.KeyCode.None, 113, function(k) Config.JumpKey = k end)
    CreateSlider("Jump:", 50, 200, 80, 14, function(v) Config.JumpVal = v end)
    CreateToggle("Noclip", false, 15, function(v) Config.Noclip = v end)
    CreateKeybind("Bind:", Enum.KeyCode.None, 115, function(k) Config.NoclipKey = k end)

    CreateSection("ESP - PLAYERS", 20)
    CreateToggle("Maniac", false, 21, function(v)
        Config.ESPManiac = v
        if not v then RemoveESPByType("maniac") end
    end)
    CreateKeybind("Bind:", Enum.KeyCode.None, 22, function(k) Config.ESPManiacKey = k end)
    CreateSubToggle("Show name", true, 23, 21, function(v) Config.ESPManiacName = v end)
    CreateSubToggle("Show distance", true, 24, 21, function(v) Config.ESPManiacDist = v end)

    CreateToggle("Survivors", false, 30, function(v)
        Config.ESPSurvivors = v
        if not v then RemoveESPByType("survivor") end
    end)
    CreateKeybind("Bind:", Enum.KeyCode.None, 31, function(k) Config.ESPSurvivorsKey = k end)
    CreateSubToggle("Show name", true, 32, 30, function(v) Config.ESPSurvivorsName = v end)
    CreateSubToggle("Show distance", true, 33, 30, function(v) Config.ESPSurvivorsDist = v end)

    CreateSection("ESP - MAP", 40)
    CreateToggle("Generators", false, 41, function(v)
        Config.ESPGenerators = v
        if not v then
            for obj, _ in pairs(MapESPObjects) do RemoveMapESP(obj) end
            MapScanCache = {}
        end
    end)
    CreateKeybind("Bind:", Enum.KeyCode.None, 42, function(k) Config.ESPGeneratorsKey = k end)

    CreateToggle("Pallets", false, 50, function(v)
        Config.ESPPallets = v
        if not v then
            for obj, _ in pairs(MapESPObjects) do RemoveMapESP(obj) end
            MapScanCache = {}
        end
    end)
    CreateKeybind("Bind:", Enum.KeyCode.None, 51, function(k) Config.ESPPalletsKey = k end)

    CreateToggle("Windows", false, 60, function(v)
        Config.ESPWindows = v
        if not v then
            for obj, _ in pairs(MapESPObjects) do RemoveMapESP(obj) end
            MapScanCache = {}
        end
    end)
    CreateKeybind("Bind:", Enum.KeyCode.None, 61, function(k) Config.ESPWindowsKey = k end)

    CreateSection("COLOR", 70)
    CreateColorPicker("ESP Color:", Color3.fromRGB(255, 50, 50), 71, function(c)
        Config.ESPColor = c
        for _, esp in pairs(ESPObjects) do
            if esp.NameLabel then esp.NameLabel.TextColor3 = c end
            if esp.Highlight then esp.Highlight.FillColor = c; esp.Highlight.OutlineColor = c end
        end
        for _, esp in pairs(MapESPObjects) do
            if esp.Highlight then esp.Highlight.FillColor = c; esp.Highlight.OutlineColor = c end
        end
    end)
    CreateColorPicker("Menu Color:", Color3.fromRGB(80, 140, 240), 72, function(c)
        ApplyMenuColor(c)
    end)

    CreateSection("DEBUG", 90)
    CreateToggle("Scan names", false, 91, function(v)
        if not v then return end
        print("[SNOW HUB] === WORKSPACE SCAN ===")
        local found = {}
        for _, obj in pairs(Workspace:GetDescendants()) do
            local n = obj.Name:lower()
            if n:find("pallet") or n:find("plank") or n:find("board") or n:find("window") or n:find("vault") or n:find("barricade") or n:find("generator") or n:find("gen") or n:find("break") then
                local path = obj:GetFullName()
                if not found[path] then
                    found[path] = true
                    print(string.format("  [%s] %s (%s) Parent: %s", obj.ClassName, obj.Name, path, obj.Parent and obj.Parent.Name or "?"))
                end
            end
        end
        print("[SNOW HUB] === SCAN DONE ===")
        ToggleBtns["Scan names"].setState(false)
    end)

    local KeyMap = {
        {key = "AutoDaggerKey",   config = "AutoDagger",   toggle = "Auto-kinzhal"},
        {key = "SpeedKey",        config = "Speed",        toggle = "Speed"},
        {key = "JumpKey",         config = "Jump",         toggle = "Jump"},
        {key = "NoclipKey",       config = "Noclip",       toggle = "Noclip"},
        {key = "ESPManiacKey",    config = "ESPManiac",    toggle = "Maniac"},
        {key = "ESPSurvivorsKey", config = "ESPSurvivors", toggle = "Survivors"},
        {key = "ESPGeneratorsKey",config = "ESPGenerators",toggle = "Generators"},
        {key = "ESPPalletsKey",   config = "ESPPallets",   toggle = "Pallets"},
        {key = "ESPWindowsKey",   config = "ESPWindows",   toggle = "Windows"},
    }

    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.RightShift then
            Config.MenuOpen = not Config.MenuOpen
            MenuFrame.Visible = Config.MenuOpen
            UserInputService.MouseIconEnabled = Config.MenuOpen
            if Config.MenuOpen then
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            else
                UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
            end
            return
        end
        for _, km in ipairs(KeyMap) do
            local k = Config[km.key]
            if k ~= Enum.KeyCode.None and input.KeyCode == k then
                Config[km.config] = not Config[km.config]
                SyncToggle(km.toggle, Config[km.config])
                if not Config[km.config] then
                    if km.config == "ESPManiac" then RemoveESPByType("maniac")
                    elseif km.config == "ESPSurvivors" then RemoveESPByType("survivor")
                    end
                end
                return
            end
        end
    end)

    RunService.Heartbeat:Connect(function()
        pcall(function()
            AutoDaggerTick()

            if Config.Speed and Humanoid then
                Humanoid.WalkSpeed = Config.SpeedVal
            elseif not Config.Speed and Humanoid then
                Humanoid.WalkSpeed = 16
            end
            if Config.Jump and Humanoid then
                Humanoid.JumpPower = Config.JumpVal
            elseif not Config.Jump and Humanoid then
                Humanoid.JumpPower = 50
            end
            if Config.Noclip and Character then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end

            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LP and player.Character and player.Character:FindFirstChild("Head") then
                    local tool = player.Character:FindFirstChildOfClass("Tool")
                    local isM = false
                    if tool then
                        local n = tool.Name:lower()
                        isM = n:find("knife") or n:find("dagger") or n:find("blade") or n:find("axe") or n:find("hammer") or n:find("bat") or n:find("sword") or n:find("weapon") or n:find("kill")
                    end
                    if isM and Config.ESPManiac then
                        CreateESP(player)
                        UpdateESP(player, Config.ESPColor, Config.ESPManiacName, Config.ESPManiacDist, "maniac")
                    elseif not isM and Config.ESPSurvivors then
                        CreateESP(player)
                        UpdateESP(player, Config.ESPColor, Config.ESPSurvivorsName, Config.ESPSurvivorsDist, "survivor")
                    else
                        if ESPType[player] == "maniac" and not Config.ESPManiac then RemoveESP(player)
                        elseif ESPType[player] == "survivor" and not Config.ESPSurvivors then RemoveESP(player)
                        elseif not isM and not Config.ESPSurvivors then RemoveESP(player)
                        elseif isM and not Config.ESPManiac then RemoveESP(player)
                        end
                    end
                else
                    RemoveESP(player)
                end
            end

            local scan = ScanMapObjects()
            if Config.ESPGenerators then
                for _, obj in pairs(scan.generators) do
                    if not MapESPObjects[obj] then CreateMapESP(obj, Config.ESPColor) end
                end
            end
            if Config.ESPPallets then
                for _, obj in pairs(scan.pallets) do
                    if not MapESPObjects[obj] then CreateMapESP(obj, Config.ESPColor) end
                end
            end
            if Config.ESPWindows then
                for _, obj in pairs(scan.windows) do
                    if not MapESPObjects[obj] then CreateMapESP(obj, Config.ESPColor) end
                end
            end
            if not Config.ESPGenerators and not Config.ESPPallets and not Config.ESPWindows then
                for obj, _ in pairs(MapESPObjects) do RemoveMapESP(obj) end
                MapScanCache = {}
            end
        end)
    end)

    KBFrame = Instance.new("Frame")
    KBFrame.Name = "KeybindsWindow"
    KBFrame.Size = UDim2.new(0, 200, 0, 0)
    KBFrame.Position = UDim2.new(0, 20, 0.5, -100)
    KBFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
    KBFrame.BorderSizePixel = 0
    KBFrame.Parent = ScreenGui
    Instance.new("UICorner", KBFrame).CornerRadius = UDim.new(0, 8)
    KBStroke = Instance.new("UIStroke", KBFrame)
    KBStroke.Color = Config.MenuColor

    KBTitle = Instance.new("TextLabel")
    KBTitle.Size = UDim2.new(1, 0, 0, 26)
    KBTitle.BackgroundColor3 = Color3.new(Config.MenuColor.R * 0.3, Config.MenuColor.G * 0.3, Config.MenuColor.B * 0.3)
    KBTitle.BorderSizePixel = 0
    KBTitle.Text = "KEYBINDS"
    KBTitle.TextColor3 = Color3.new(1, 1, 1)
    KBTitle.Font = Enum.Font.GothamBold
    KBTitle.TextSize = 12
    KBTitle.Parent = KBFrame
    Instance.new("UICorner", KBTitle).CornerRadius = UDim.new(0, 8)

    local KBDragging = false
    local KBDragStart = nil
    local KBStartPos = nil
    KBTitle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            KBDragging = true
            KBDragStart = input.Position
            KBStartPos = KBFrame.Position
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            KBDragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if KBDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - KBDragStart
            KBFrame.Position = UDim2.new(KBStartPos.X.Scale, KBStartPos.X.Offset + delta.X, KBStartPos.Y.Scale, KBStartPos.Y.Offset + delta.Y)
        end
    end)

    KBContainer = Instance.new("ScrollingFrame")
    KBContainer.Size = UDim2.new(1, -10, 1, -30)
    KBContainer.Position = UDim2.new(0, 5, 0, 28)
    KBContainer.BackgroundTransparency = 1
    KBContainer.ScrollBarThickness = 2
    KBContainer.ScrollBarImageColor3 = Config.MenuColor
    KBContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    KBContainer.Parent = KBFrame
    Instance.new("UIListLayout", KBContainer).Padding = UDim.new(0, 2)
    KBContainer:FindFirstChildOfClass("UIListLayout").SortOrder = Enum.SortOrder.LayoutOrder

    local KBEntryMap = {
        {name = "Auto-kinzhal", configKey = "AutoDagger", keyField = "AutoDaggerKey"},
        {name = "Speed",        configKey = "Speed",      keyField = "SpeedKey"},
        {name = "Jump",         configKey = "Jump",       keyField = "JumpKey"},
        {name = "Noclip",       configKey = "Noclip",     keyField = "NoclipKey"},
        {name = "Maniac",       configKey = "ESPManiac",  keyField = "ESPManiacKey"},
        {name = "Survivors",    configKey = "ESPSurvivors", keyField = "ESPSurvivorsKey"},
        {name = "Generators",   configKey = "ESPGenerators", keyField = "ESPGeneratorsKey"},
        {name = "Pallets",      configKey = "ESPPallets", keyField = "ESPPalletsKey"},
        {name = "Windows",      configKey = "ESPWindows", keyField = "ESPWindowsKey"},
    }

    local function KN(k)
        if k == Enum.KeyCode.None then return "[ NONE ]" end
        return "[ " .. k.Name .. " ]"
    end

    local function RebuildKeybinds()
        for _, child in pairs(KBContainer:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
        KBRows = {}
        KBLabels = {}

        local order = 1
        AddKBRowStatic("Menu", "[ RightShift ]", order)
        order = order + 1

        for _, entry in ipairs(KBEntryMap) do
            if Config[entry.keyField] ~= Enum.KeyCode.None then
                AddKBRowActive(entry.name, entry.configKey, entry.keyField, order)
                order = order + 1
            end
        end

        KBFrame.Size = UDim2.new(0, 200, 0, (order - 1) * 22 + 34)
    end

    function AddKBRowStatic(name, keyText, order)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 0, 20)
        f.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
        f.BorderSizePixel = 0
        f.LayoutOrder = order
        f.Parent = KBContainer
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 3)

        local t = Instance.new("TextLabel")
        t.Size = UDim2.new(0.55, 0, 1, 0)
        t.Position = UDim2.new(0, 6, 0, 0)
        t.BackgroundTransparency = 1
        t.Text = name
        t.TextColor3 = Color3.fromRGB(150, 150, 165)
        t.Font = Enum.Font.Gotham
        t.TextSize = 10
        t.TextXAlignment = Enum.TextXAlignment.Left
        t.Parent = f

        local v = Instance.new("TextLabel")
        v.Size = UDim2.new(0.4, -6, 1, 0)
        v.Position = UDim2.new(0.55, 0, 0, 0)
        v.BackgroundTransparency = 1
        v.Text = keyText
        v.TextColor3 = Color3.fromRGB(255, 255, 255)
        v.Font = Enum.Font.GothamBold
        v.TextSize = 10
        v.TextXAlignment = Enum.TextXAlignment.Right
        v.Parent = f
    end

    function AddKBRowActive(name, configKey, keyField, order)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 0, 20)
        f.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
        f.BorderSizePixel = 0
        f.LayoutOrder = order
        f.Parent = KBContainer
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 3)

        local t = Instance.new("TextLabel")
        t.Size = UDim2.new(0.55, 0, 1, 0)
        t.Position = UDim2.new(0, 6, 0, 0)
        t.BackgroundTransparency = 1
        t.Text = name
        t.TextColor3 = Color3.fromRGB(150, 150, 165)
        t.Font = Enum.Font.Gotham
        t.TextSize = 10
        t.TextXAlignment = Enum.TextXAlignment.Left
        t.Parent = f

        local v = Instance.new("TextLabel")
        v.Size = UDim2.new(0.4, -6, 1, 0)
        v.Position = UDim2.new(0.55, 0, 0, 0)
        v.BackgroundTransparency = 1
        v.Text = KN(Config[keyField])
        v.TextColor3 = Color3.fromRGB(255, 255, 255)
        v.Font = Enum.Font.GothamBold
        v.TextSize = 10
        v.TextXAlignment = Enum.TextXAlignment.Right
        v.Parent = f

        KBRows[name] = {frame = f, label = t, valueLabel = v, configKey = configKey, keyField = keyField}
    end

    RebuildKeybinds()

    task.spawn(function()
        while ScreenGui and ScreenGui.Parent do
            for name, row in pairs(KBRows) do
                if row.configKey then
                    local active = Config[row.configKey]
                    local keyField = row.keyField
                    if keyField then row.valueLabel.Text = KN(Config[keyField]) end
                    if active then
                        row.frame.BackgroundColor3 = Color3.new(Config.MenuColor.R * 0.4, Config.MenuColor.G * 0.4, Config.MenuColor.B * 0.4)
                        row.valueLabel.TextColor3 = Color3.new(1, 1, 1)
                        row.label.TextColor3 = Color3.new(1, 1, 1)
                    else
                        row.frame.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
                        row.valueLabel.TextColor3 = Color3.fromRGB(100, 100, 110)
                        row.label.TextColor3 = Color3.fromRGB(150, 150, 165)
                    end
                end
            end
            task.wait(0.15)
        end
    end)

    print("[SNOW HUB] Loaded! Right Shift = menu")
end

KeyBtn.MouseButton1Click:Connect(function()
    local key = KeyBox.Text
    if CheckKey(key) then
        KeyStatus.Text = "Access granted!"
        KeyStatus.TextColor3 = Color3.fromRGB(50, 200, 80)
        task.wait(0.5)
        StartHub()
    else
        KeyStatus.Text = "Wrong key!"
        KeyStatus.TextColor3 = Color3.fromRGB(255, 70, 70)
    end
end)

KeyBox.FocusLost:Connect(function(enter)
    if enter then
        KeyBtn:Activate()
    end
end)
