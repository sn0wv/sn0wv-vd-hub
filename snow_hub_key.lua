```lua
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
KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
KeyFrame.BorderSizePixel = 0
KeyFrame.Parent = KeyGui
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", KeyFrame).Color = Color3.fromRGB(50, 50, 60)

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 32)
KeyTitle.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
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
KeyBox.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
KeyBox.BorderSizePixel = 0
KeyBox.PlaceholderText = "Paste key here..."
KeyBox.PlaceholderColor3 = Color3.fromRGB(80, 80, 90)
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
        ESPManiacColor = Color3.fromRGB(255, 50, 50),
        ESPManiacName = true,
        ESPManiacDist = true,
        ESPSurvivors = false,
        ESPSurvivorsKey = Enum.KeyCode.None,
        ESPSurvivorsColor = Color3.fromRGB(50, 200, 255),
        ESPSurvivorsName = true,
        ESPSurvivorsDist = true,
        ESPGenerators = false,
        ESPGeneratorsKey = Enum.KeyCode.None,
        ESPGeneratorsColor = Color3.fromRGB(255, 255, 50),
        ESPPallets = false,
        ESPPalletsKey = Enum.KeyCode.None,
        ESPPalletsColor = Color3.fromRGB(255, 150, 50),
        ESPWindows = false,
        ESPWindowsKey = Enum.KeyCode.None,
        ESPWindowsColor = Color3.fromRGB(200, 100, 255),
    }

    local ESPObjects = {}
    local MapESPObjects = {}
    local Character = LP.Character or LP.CharacterAdded:Wait()
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local ToggleBtns = {}

    LP.CharacterAdded:Connect(function(c)
        Character = c
        Humanoid = c:WaitForChild("Humanoid")
    end)

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SnowHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function()
        local old = LP:WaitForChild("PlayerGui"):FindFirstChild("SnowHub")
        if old then old:Destroy() end
    end)
    ScreenGui.Parent = LP:WaitForChild("PlayerGui")

    local MenuFrame = Instance.new("Frame")
    MenuFrame.Size = UDim2.new(0, 340, 0, 420)
    MenuFrame.Position = UDim2.new(0.5, -170, 0.5, -210)
    MenuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    MenuFrame.BorderSizePixel = 0
    MenuFrame.Visible = false
    MenuFrame.Parent = ScreenGui
    Instance.new("UICorner", MenuFrame).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", MenuFrame).Color = Color3.fromRGB(50, 50, 60)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 34)
    Title.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    Title.BorderSizePixel = 0
    Title.Text = "SNOW HUB"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.Parent = MenuFrame
    Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 8)

    local Container = Instance.new("ScrollingFrame")
    Container.Size = UDim2.new(1, -12, 1, -40)
    Container.Position = UDim2.new(0, 6, 0, 38)
    Container.BackgroundTransparency = 1
    Container.ScrollBarThickness = 3
    Container.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    Container.Parent = MenuFrame

    Instance.new("UIListLayout", Container).Padding = UDim.new(0, 4)
    Container:FindFirstChildOfClass("UIListLayout").SortOrder = Enum.SortOrder.LayoutOrder

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
        f.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
        f.BorderSizePixel = 0
        f.LayoutOrder = order
        f.Parent = Container
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)
        local t = Instance.new("TextLabel")
        t.Size = UDim2.new(1, -10, 1, 0)
        t.Position = UDim2.new(0, 10, 0, 0)
        t.BackgroundTransparency = 1
        t.Text = name
        t.TextColor3 = Color3.fromRGB(160, 160, 180)
        t.Font = Enum.Font.GothamBold
        t.TextSize = 11
        t.TextXAlignment = Enum.TextXAlignment.Left
        t.Parent = f
        AutoScroll()
    end

    local function CreateToggle(name, default, order, callback)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 0, 26)
        f.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
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
        btn.BackgroundColor3 = default and Color3.fromRGB(45, 150, 70) or Color3.fromRGB(50, 50, 58)
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
            btn.BackgroundColor3 = state and Color3.fromRGB(45, 150, 70) or Color3.fromRGB(50, 50, 58)
        end}

        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.Text = state and "ON" or "OFF"
            btn.BackgroundColor3 = state and Color3.fromRGB(45, 150, 70) or Color3.fromRGB(50, 50, 58)
            callback(state)
        end)
        AutoScroll()
    end

    local function CreateKeybind(name, default, order, callback)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 0, 26)
        f.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
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
        btn.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
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
                btn.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
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
        f.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
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
        btn.BackgroundColor3 = default and Color3.fromRGB(45, 150, 70) or Color3.fromRGB(42, 42, 50)
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
            btn.BackgroundColor3 = state and Color3.fromRGB(45, 150, 70) or Color3.fromRGB(42, 42, 50)
        end}

        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.Text = state and "ON" or "OFF"
            btn.BackgroundColor3 = state and Color3.fromRGB(45, 150, 70) or Color3.fromRGB(42, 42, 50)
            callback(state)
        end)
        AutoScroll()
    end

    local function CreateSlider(name, min, max, default, order, callback)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 0, 30)
        f.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
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
        bar.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
        bar.BorderSizePixel = 0
        bar.Parent = f
        Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 3)

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(80, 140, 240)
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
        f.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
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
        bb.Size = UDim2.new(0, 180, 0, 40)
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

    local function UpdateESP(player, color, label, showName, showDist)
        local esp = ESPObjects[player]
        if not esp then return end
        if not player.Character or not player.Character:FindFirstChild("Head") then
            RemoveESP(player)
            return
        end
        esp.Billboard.Parent = player.Character:FindFirstChild("Head")
        esp.NameLabel.Text = showName and (label.." ["..player.Name.."]") or label
        esp.NameLabel.TextColor3 = color
        esp.NameLabel.Visible = showName or true
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
    end

    local function CreateMapESP(obj, name, color)
        if MapESPObjects[obj] then return end
        local bb = Instance.new("BillboardGui")
        bb.Size = UDim2.new(0, 140, 0, 26)
        bb.StudsOffset = Vector3.new(0, 1.5, 0)
        bb.AlwaysOnTop = true
        bb.MaxDistance = 350
        bb.Parent = obj

        local lb = Instance.new("TextLabel")
        lb.Size = UDim2.new(1, 0, 1, 0)
        lb.BackgroundTransparency = 1
        lb.Text = name
        lb.TextColor3 = color
        lb.Font = Enum.Font.GothamBold
        lb.TextSize = 12
        lb.TextStrokeTransparency = 0.4
        lb.TextStrokeColor3 = Color3.new(0, 0, 0)
        lb.Parent = bb

        local hl = Instance.new("Highlight")
        hl.FillColor = color
        hl.FillTransparency = 0.75
        hl.OutlineColor = color
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = obj

        MapESPObjects[obj] = { Billboard = bb, Highlight = hl }
    end

    local function RemoveMapESP(obj)
        local e = MapESPObjects[obj]
        if e then
            if e.Billboard then e.Billboard:Destroy() end
            if e.Highlight then e.Highlight:Destroy() end
            MapESPObjects[obj] = nil
        end
    end

    local function FindPallets()
        local pals = {}
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") then
                local n = obj.Name:lower()
                if n:find("pallet") then
                    local primary = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                    if primary then table.insert(pals, primary) end
                end
            elseif obj:IsA("BasePart") then
                local n = obj.Name:lower()
                if n == "pallet" or n == "woodenpallet" or n == "pallet_part" then
                    table.insert(pals, obj)
                elseif obj.Parent and obj.Parent:IsA("Model") then
                    local pn = obj.Parent.Name:lower()
                    if pn:find("pallet") then
                        table.insert(pals, obj)
                    end
                end
            end
        end
        return pals
    end

    local function FindGenerators()
        local gens = {}
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                local n = obj.Name:lower()
                if n:find("generator") or n:find("gen") then
                    table.insert(gens, obj)
                end
            end
        end
        return gens
    end

    local function FindWindows()
        local wins = {}
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                local n = obj.Name:lower()
                if n:find("window") or n:find("glass") or n:find("windowbreak") then
                    table.insert(wins, obj)
                end
            end
        end
        return wins
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

    CreateSection("AVTO KINZHAL", 1)
    CreateToggle("Avto-kinzhal", false, 2, function(v) Config.AutoDagger = v end)
    CreateKeybind("Bind:", Enum.KeyCode.None, 3, function(k) Config.AutoDaggerKey = k end)
    CreateSlider("Range:", 5, 50, 15, 4, function(v) Config.AutoDaggerRange = v end)

    CreateSection("ESP - PLAYERS", 10)
    CreateToggle("Maniac", false, 11, function(v)
        Config.ESPManiac = v
        if not v then for p, _ in pairs(ESPObjects) do RemoveESP(p) end end
    end)
    CreateKeybind("Bind:", Enum.KeyCode.None, 12, function(k) Config.ESPManiacKey = k end)
    CreateColorPicker("Color:", Color3.fromRGB(255, 50, 50), 13, function(c) Config.ESPManiacColor = c end)
    CreateSubToggle("Show name", true, 14, 11, function(v) Config.ESPManiacName = v end)
    CreateSubToggle("Show distance", true, 15, 11, function(v) Config.ESPManiacDist = v end)

    CreateToggle("Survivors", false, 20, function(v)
        Config.ESPSurvivors = v
        if not v then for p, _ in pairs(ESPObjects) do RemoveESP(p) end end
    end)
    CreateKeybind("Bind:", Enum.KeyCode.None, 21, function(k) Config.ESPSurvivorsKey = k end)
    CreateColorPicker("Color:", Color3.fromRGB(50, 200, 255), 22, function(c) Config.ESPSurvivorsColor = c end)
    CreateSubToggle("Show name", true, 23, 20, function(v) Config.ESPSurvivorsName = v end)
    CreateSubToggle("Show distance", true, 24, 20, function(v) Config.ESPSurvivorsDist = v end)

    CreateSection("ESP - MAP", 30)
    CreateToggle("Generators", false, 31, function(v)
        Config.ESPGenerators = v
        if not v then
            for obj, _ in pairs(MapESPObjects) do
                local n = obj.Name:lower()
                if n:find("generator") or n:find("gen") then RemoveMapESP(obj) end
            end
        end
    end)
    CreateKeybind("Bind:", Enum.KeyCode.None, 32, function(k) Config.ESPGeneratorsKey = k end)
    CreateColorPicker("Color:", Color3.fromRGB(255, 255, 50), 33, function(c) Config.ESPGeneratorsColor = c end)

    CreateToggle("Pallets", false, 40, function(v)
        Config.ESPPallets = v
        if not v then
            for obj, _ in pairs(MapESPObjects) do
                local n = obj.Name:lower()
                if n:find("pallet") then RemoveMapESP(obj) end
            end
        end
    end)
    CreateKeybind("Bind:", Enum.KeyCode.None, 41, function(k) Config.ESPPalletsKey = k end)
    CreateColorPicker("Color:", Color3.fromRGB(255, 150, 50), 42, function(c) Config.ESPPalletsColor = c end)

    CreateToggle("Windows", false, 50, function(v)
        Config.ESPWindows = v
        if not v then
            for obj, _ in pairs(MapESPObjects) do
                local n = obj.Name:lower()
                if n:find("window") or n:find("glass") then RemoveMapESP(obj) end
            end
        end
    end)
    CreateKeybind("Bind:", Enum.KeyCode.None, 51, function(k) Config.ESPWindowsKey = k end)
    CreateColorPicker("Color:", Color3.fromRGB(200, 100, 255), 52, function(c) Config.ESPWindowsColor = c end)

    CreateSection("KEYBINDS", 60)
    local KBLabels = {}
    local function CreateKBInfo(name, order)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 0, 22)
        f.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
        f.BorderSizePixel = 0
        f.LayoutOrder = order
        f.Parent = Container
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)

        local t = Instance.new("TextLabel")
        t.Size = UDim2.new(0.55, 0, 1, 0)
        t.Position = UDim2.new(0, 10, 0, 0)
        t.BackgroundTransparency = 1
        t.Text = name
        t.TextColor3 = Color3.fromRGB(150, 150, 165)
        t.Font = Enum.Font.Gotham
        t.TextSize = 11
        t.TextXAlignment = Enum.TextXAlignment.Left
        t.Parent = f

        local v = Instance.new("TextLabel")
        v.Size = UDim2.new(0.4, -10, 1, 0)
        v.Position = UDim2.new(0.55, 0, 0, 0)
        v.BackgroundTransparency = 1
        v.Text = "[ NONE ]"
        v.TextColor3 = Color3.fromRGB(255, 200, 80)
        v.Font = Enum.Font.GothamBold
        v.TextSize = 11
        v.TextXAlignment = Enum.TextXAlignment.Right
        v.Parent = f

        KBLabels[name] = v
        AutoScroll()
    end

    CreateKBInfo("Menu:", 61)
    KBLabels["Menu:"].Text = "[ RightShift ]"
    CreateKBInfo("Avto-kinzhal:", 62)
    CreateKBInfo("Maniac:", 63)
    CreateKBInfo("Survivors:", 64)
    CreateKBInfo("Generators:", 65)
    CreateKBInfo("Pallets:", 66)
    CreateKBInfo("Windows:", 67)

    local function UpdateKBLabels()
        local function KN(k)
            if k == Enum.KeyCode.None then return "[ NONE ]" end
            return "[ " .. k.Name .. " ]"
        end
        KBLabels["Avto-kinzhal:"].Text = KN(Config.AutoDaggerKey)
        KBLabels["Maniac:"].Text = KN(Config.ESPManiacKey)
        KBLabels["Survivors:"].Text = KN(Config.ESPSurvivorsKey)
        KBLabels["Generators:"].Text = KN(Config.ESPGeneratorsKey)
        KBLabels["Pallets:"].Text = KN(Config.ESPPalletsKey)
        KBLabels["Windows:"].Text = KN(Config.ESPWindowsKey)
    end

    local KeyMap = {
        {key = "AutoDaggerKey",   config = "AutoDagger",   toggle = "Avto-kinzhal"},
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
                    for p, _ in pairs(ESPObjects) do RemoveESP(p) end
                end
                return
            end
        end
    end)

    RunService.Heartbeat:Connect(function()
        pcall(function()
            AutoDaggerTick()
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
                        UpdateESP(player, Config.ESPManiacColor, "MANIAC", Config.ESPManiacName, Config.ESPManiacDist)
                    elseif not isM and Config.ESPSurvivors then
                        CreateESP(player)
                        UpdateESP(player, Config.ESPSurvivorsColor, "SURV", Config.ESPSurvivorsName, Config.ESPSurvivorsDist)
                    else
                        RemoveESP(player)
                    end
                else
                    RemoveESP(player)
                end
            end
            if Config.ESPGenerators then
                for _, obj in pairs(FindGenerators()) do
                    if not MapESPObjects[obj] then CreateMapESP(obj, "GEN", Config.ESPGeneratorsColor) end
                end
            end
            if Config.ESPPallets then
                for _, obj in pairs(FindPallets()) do
                    if not MapESPObjects[obj] then CreateMapESP(obj, "PAL", Config.ESPPalletsColor) end
                end
            end
            if Config.ESPWindows then
                for _, obj in pairs(FindWindows()) do
                    if not MapESPObjects[obj] then CreateMapESP(obj, "WIN", Config.ESPWindowsColor) end
                end
            end
            if not Config.ESPGenerators and not Config.ESPPallets and not Config.ESPWindows then
                for obj, _ in pairs(MapESPObjects) do RemoveMapESP(obj) end
            end
        end)
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
```
