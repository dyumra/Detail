repeat task.wait() until game:IsLoaded()

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local workspace = game.Workspace
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local GetReadyRemote = ReplicatedStorage:WaitForChild("GetReadyRemote")
local SkipHelicopterRemote = ReplicatedStorage:WaitForChild("SkipHelicopter")
local LMBRemote = ReplicatedStorage:WaitForChild("LMB")

-- ตัวแปรหลัก
local autoFarmActive, autoReadyActive, autoSkipHelicopterActive, flushAuraActive, espActive = false, false, false, false, false
local movementMode, espMode = "Teleport", "Highlight"
local visitedNPCs, pressCount, espObjects = {}, {}, {}
local espPlayer, espEnemies = true, true
local showHP, showDistance, showName = true, true, true

-- ==================== ESP ====================
local function clearESP()
    for _, obj in pairs(espObjects) do
        if obj and obj.Parent then obj:Destroy() end
    end
    espObjects = {}
end

local function createBillboard(model, humanoid)
    local hrp = model:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Name, billboard.Adornee = "DYHUB_ESP_Billboard", hrp
    billboard.Size, billboard.AlwaysOnTop, billboard.StudsOffset = UDim2.new(0,150,0,50), true, Vector3.new(0,3,0)
    billboard.Parent = workspace

    local textLabel = Instance.new("TextLabel")
    textLabel.Size, textLabel.BackgroundTransparency = UDim2.new(1,0,1,0), 1
    textLabel.TextColor3, textLabel.TextStrokeTransparency = Color3.new(1,0,0), 0
    textLabel.TextStrokeColor3, textLabel.Font, textLabel.TextScaled = Color3.new(0,0,0), Enum.Font.SourceSansBold, true
    textLabel.Parent = billboard

    local function updateText()
        local t = ""
        if showName then t = t .. (model.Name or "NPC") end
        if humanoid and humanoid.Health and humanoid.MaxHealth and showHP then
            t = t .. "\nHP: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
        end
        if showDistance and model:FindFirstChild("HumanoidRootPart") then
            t = t .. "\nDist: " .. math.floor((model.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
        end
        textLabel.Text = t
    end
    updateText()

    local conn
    conn = RunService.RenderStepped:Connect(function()
        if humanoid and humanoid.Health <= 0 then
            billboard:Destroy()
            if conn then conn:Disconnect() conn = nil end
        else updateText() end
    end)
    table.insert(espObjects, billboard)
end

local function applyESPToModel(model)
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    local isPlayer = Players:GetPlayerFromCharacter(model) ~= nil
    if (isPlayer and espPlayer) or (not isPlayer and espEnemies) then
        if espMode == "Highlight" then
            local highlight = Instance.new("Highlight")
            highlight.Adornee, highlight.FillColor, highlight.OutlineColor = model, Color3.fromRGB(255,0,0), Color3.fromRGB(255,255,255)
            highlight.Parent = workspace
            table.insert(espObjects, highlight)
            if humanoid then createBillboard(model, humanoid) end
        elseif espMode == "BoxHandle" then
            local hrp = model:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local box = Instance.new("BoxHandleAdornment")
            box.Adornee, box.AlwaysOnTop, box.ZIndex = hrp, true, 10
            box.Size, box.Color3, box.Transparency = Vector3.new(4,6,2), Color3.fromRGB(255,0,0), 0.5
            box.Parent = workspace.Terrain
            table.insert(espObjects, box)
            if humanoid then createBillboard(model, humanoid) end
        end
    end
end

task.spawn(function()
    while true do
        if espActive then
            pcall(function()
                local char = LocalPlayer.Character
                if char then applyESPToModel(char) end
                for _, npc in pairs(workspace:GetDescendants()) do
                    if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") then
                        local hum = npc:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 then applyESPToModel(npc) end
                    end
                end
            end)
        else clearESP() end
        task.wait(1)
    end
end)

-- ==================== ฟังก์ชันพื้นฐาน ====================
local function isVisited(npc)
    for _, v in ipairs(visitedNPCs) do if v == npc then return true end end
    return false
end
local function addVisited(npc) table.insert(visitedNPCs, npc) end
local function removeVisited(npc)
    for i,v in ipairs(visitedNPCs) do if v == npc then table.remove(visitedNPCs,i) break end end
    pressCount[npc] = nil
end

local function keepModifyProximityPrompts()
    spawn(function()
        while true do
            pcall(function()
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") then obj.HoldDuration = 0 end
                end
            end)
            task.wait(0.5)
        end
    end)
end
keepModifyProximityPrompts()

local function smoothTeleportTo(targetPos, duration)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = CFrame.new(targetPos)})
    tween:Play()
    tween.Completed:Wait()
end
local function instantTeleportTo(targetPos)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    char:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(targetPos)
end
local function teleportToTarget(pos,dur)
    if movementMode=="CFrame" then smoothTeleportTo(pos,dur or 0.5) else instantTeleportTo(pos) end
end

local function ensureGroundBelow(pos)
    local ray = Ray.new(pos, Vector3.new(0,-50,0))
    local hit = workspace:FindPartOnRay(ray)
    if not hit then
        local part = Instance.new("Part")
        part.Size, part.Anchored, part.CanCollide, part.Position, part.Transparency, part.Name, part.Parent = Vector3.new(5,1,5), true, true, pos-Vector3.new(0,3,0), 1, "DYHUB_GroundTemp", workspace
        task.delay(5,function() part:Destroy() end)
    end
end

local function isValidNPC(npc)
    if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") then
        local hum = npc:FindFirstChildOfClass("Humanoid")
        if hum and not Players:GetPlayerFromCharacter(npc) then
            return hum.Health > 0
        end
    end
    return false
end

-- ==================== Auto Farm ====================
local function startAutoFarm()
    task.spawn(function()
        while autoFarmActive do
            pcall(function()
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                local closestNPC, closestPrompt, shortest = nil, nil, 1000
                for _, npc in pairs(workspace:GetDescendants()) do
                    if isValidNPC(npc) then
                        for _, prompt in pairs(npc:GetDescendants()) do
                            if prompt:IsA("ProximityPrompt") and prompt.ActionText=="Flush" then
                                local dist = (prompt.Parent.Position-hrp.Position).Magnitude
                                if dist < shortest then closestNPC, closestPrompt, shortest = npc, prompt, dist end
                            end
                        end
                    end
                end

                if closestNPC and closestPrompt then
                    ensureGroundBelow(closestNPC.HumanoidRootPart.Position)
                    teleportToTarget(closestNPC.HumanoidRootPart.Position + Vector3.new(0,3,0),0.5)
                    while closestNPC:FindFirstChildOfClass("Humanoid") and closestNPC.HumanoidRootPart and closestNPC.HumanoidRootPart.Parent and closestNPC:FindFirstChildOfClass("Humanoid").Health>0 do
                        closestPrompt:InputHoldBegin()
                        task.wait(0.05)
                        closestPrompt:InputHoldEnd()
                        task.wait(0.15)
                    end
                else
                    local targetNPC, lastDist = nil, 1000
                    for _, npc in pairs(workspace:GetDescendants()) do
                        if isValidNPC(npc) then
                            local dist = (npc.HumanoidRootPart.Position-hrp.Position).Magnitude
                            if dist<lastDist then targetNPC,lastDist = npc,dist end
                        end
                    end
                    if targetNPC then
                        ensureGroundBelow(targetNPC.HumanoidRootPart.Position)
                        while targetNPC:FindFirstChildOfClass("Humanoid") and targetNPC.HumanoidRootPart and targetNPC:FindFirstChildOfClass("Humanoid").Health>0 do
                            teleportToTarget(targetNPC.HumanoidRootPart.Position+Vector3.new(0,3,0),0.5)
                            LMBRemote:FireServer()
                            task.wait(0.1)
                        end
                    end
                end
            end)
            task.wait(0.05)
        end
    end)
end

-- ==================== Flush Aura ====================
local function flushAura()
    task.spawn(function()
        while flushAuraActive do
            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, prompt in pairs(workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") and prompt.ActionText=="Flush" then
                        local dist = (prompt.Parent.Position-hrp.Position).Magnitude
                        if dist<=1000 then
                            ensureGroundBelow(prompt.Parent.Position)
                            pcall(function() prompt:InputHoldBegin() task.wait(0.05) prompt:InputHoldEnd() end)
                            task.wait(0.1)
                        end
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end

-- ==================== Auto Ready / Skip Helicopter ====================
local function sendReady(value) GetReadyRemote:FireServer("1",value) end
local function startAutoReady()
    task.spawn(function()
        sendReady(true)
        while autoReadyActive do
            local char = LocalPlayer.Character
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health<=0 then sendReady(true) end
            task.wait(1)
        end
        sendReady(false)
    end)
end

local function startAutoSkipHelicopter()
    task.spawn(function()
        while autoSkipHelicopterActive do
            pcall(function() SkipHelicopterRemote:FireServer() end)
            task.wait(1)
        end
    end)
end

-- ==================== Auto Reset / Rejoin ====================
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(2)
    if autoFarmActive then startAutoFarm() end
    if flushAuraActive then flushAura() end
    if autoReadyActive then startAutoReady() end
    if autoSkipHelicopterActive then startAutoSkipHelicopter() end
end)

-- ==================== GUI ====================
local Confirmed = false
WindUI:Popup({
    Title = "DYHUB Loaded! - ST : Blockade Battlefront",
    Icon = "star",
    IconThemed = true,
    Content = "DYHUB TEAM - Join us at dsc.gg/dyhub",
    Buttons = {
        { Title = "Cancel", Variant = "Secondary", Callback = function() end },
        { Title = "Continue", Icon = "arrow-right", Callback = function() Confirmed=true end, Variant = "Primary" }
    }
})
repeat task.wait() until Confirmed

local Window = WindUI:CreateWindow({
    Title = "DYHUB - ST : Blockade Battlefront (v2.4)",
    IconThemed = true,
    Icon = "star",
    Author = "DYHUB (dsc.gg/dyhub)",
    Size = UDim2.fromOffset(650,450),
    Transparent = true,
    Theme = "Dark",
})

Window:EditOpenButton({Title="DYHUB - Open", Icon="monitor", CornerRadius=UDim.new(0,6), StrokeThickness=2, Color=ColorSequence.new(Color3.fromRGB(30,30,30),Color3.fromRGB(255,255,255)), Draggable=true})

-- ==================== Tabs ====================
local MainTab = Window:Tab({Title="Main", Icon="rocket"})
MainTab:Section({Title="Core", Icon="star"})
MainTab:Dropdown({Title="Movement", Values={"Teleport","CFrame"}, Default=movementMode, Multi=false, Callback=function(val) movementMode=val end})
MainTab:Toggle({Title="Auto Farm", Default=false, Callback=function(val) autoFarmActive=val if val then startAutoFarm() end end})
MainTab:Toggle({Title="Flush Aura", Default=false, Callback=function(val) flushAuraActive=val if val then flushAura() end end})
MainTab:Toggle({Title="Auto Ready", Default=false, Callback=function(val) autoReadyActive=val if val then startAutoReady() end end})
MainTab:Toggle({Title="Auto Skip Helicopter", Default=false, Callback=function(val) autoSkipHelicopterActive=val if val then startAutoSkipHelicopter() end end})

local ESPTab = Window:Tab({Title="ESP", Icon="eye"})
ESPTab:Section({Title="ESP Settings", Icon="eye"})
ESPTab:Toggle({Title="Enable ESP", Default=false, Callback=function(val) espActive=val end})
ESPTab:Toggle({Title="ESP Players", Default=true, Callback=function(val) espPlayer=val end})
ESPTab:Toggle({Title="ESP Enemies", Default=true, Callback=function(val) espEnemies=val end})
ESPTab:Toggle({Title="Show HP", Default=true, Callback=function(val) showHP=val end})
ESPTab:Toggle({Title="Show Distance", Default=true, Callback=function(val) showDistance=val end})
ESPTab:Toggle({Title="Show Name", Default=true, Callback=function(val) showName=val end})
ESPTab:Dropdown({Title="ESP Mode", Values={"Highlight","BoxHandle"}, Default=espMode, Multi=false, Callback=function(val) espMode=val end})

Window:SelectTab(1)
