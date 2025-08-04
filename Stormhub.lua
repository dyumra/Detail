repeat task.wait() until game:IsLoaded()

local Services = {
    Players = game:GetService("Players"),
    CoreGui = game:GetService("CoreGui"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    Workspace = workspace,
    RunService = game:GetService("RunService"),
    TweenService = game:GetService("TweenService"),
}

local LocalPlayer = Services.Players.LocalPlayer

local ExistingGui = Services.CoreGui:FindFirstChild("StormHubGUI")
if ExistingGui then ExistingGui:Destroy() end

local Gui = Instance.new("ScreenGui")
Gui.Name = "StormHubGUI"
Gui.ResetOnSpawn = false
Gui.Parent = Services.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 230, 0, 380)
MainFrame.Position = UDim2.new(0.05, 0, 0.22, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = Gui
MainFrame.AnchorPoint = Vector2.new(0, 0)

local corner = Instance.new("UICorner", MainFrame)
corner.CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", MainFrame)
stroke.Color = Color3.fromRGB(60, 130, 255)
stroke.Thickness = 2

local TitleLabel = Instance.new("TextLabel", MainFrame)
TitleLabel.Size = UDim2.new(1, 0, 0, 38)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "StormHub - SABL"
TitleLabel.TextSize = 18
TitleLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
TitleLabel.TextStrokeTransparency = 0.7

local ScrollFrame = Instance.new("ScrollingFrame", MainFrame)
ScrollFrame.Size = UDim2.new(1, -20, 1, -70)
ScrollFrame.Position = UDim2.new(0, 10, 0, 45)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local UIListLayout = Instance.new("UIListLayout", ScrollFrame)
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local FooterLabel = Instance.new("TextLabel", MainFrame)
FooterLabel.Size = UDim2.new(1, 0, 0, 22)
FooterLabel.Position = UDim2.new(0, 12, 1, -25)
FooterLabel.BackgroundTransparency = 1
FooterLabel.Font = Enum.Font.Gotham
FooterLabel.Text = "Script by StormHub | Upgrade by DYHUB™"
FooterLabel.TextSize = 11
FooterLabel.TextColor3 = Color3.fromRGB(170, 170, 170)
FooterLabel.TextXAlignment = Enum.TextXAlignment.Left

local function CreateButton(text, bgColor, borderColor, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 36)
    button.BackgroundColor3 = bgColor
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.Text = text
    button.Parent = ScrollFrame
    button.AutoButtonColor = false

    local btnCorner = Instance.new("UICorner", button)
    btnCorner.CornerRadius = UDim.new(0, 8)

    local btnStroke = Instance.new("UIStroke", button)
    btnStroke.Color = borderColor
    btnStroke.Thickness = 1.7

    local originalColor = bgColor
    local darkenedColor = Color3.new(
        math.clamp(originalColor.R - 0.12, 0, 1),
        math.clamp(originalColor.G - 0.12, 0, 1),
        math.clamp(originalColor.B - 0.12, 0, 1)
    )

    button.MouseButton1Click:Connect(function()
        local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tweenDown = Services.TweenService:Create(button, tweenInfo, {BackgroundColor3 = darkenedColor})
        local tweenUp = Services.TweenService:Create(button, tweenInfo, {BackgroundColor3 = originalColor})

        tweenDown:Play()
        tweenDown.Completed:Wait()
        pcall(callback)
        tweenUp:Play()
    end)

    return button
end

local toggleGuiBtn = Instance.new("TextButton", Gui)
toggleGuiBtn.Size = UDim2.new(0, 30, 0, 30)
toggleGuiBtn.Position = UDim2.new(1, -35, 0, 5)
toggleGuiBtn.AnchorPoint = Vector2.new(1, 0)
toggleGuiBtn.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
toggleGuiBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleGuiBtn.Font = Enum.Font.GothamBold
toggleGuiBtn.TextSize = 18
toggleGuiBtn.Text = "S"
toggleGuiBtn.AutoButtonColor = false

Instance.new("UICorner", toggleGuiBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", toggleGuiBtn).Color = Color3.fromRGB(100, 170, 255)

local guiVisible = true
toggleGuiBtn.MouseButton1Click:Connect(function()
    guiVisible = not guiVisible
    if guiVisible then
        Gui.Enabled = true
        Services.TweenService:Create(MainFrame, TweenInfo.new(0.3), {Position = UDim2.new(0.05, 0, 0.22, 0), BackgroundTransparency = 0}):Play()
        Services.TweenService:Create(ScrollFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    else
        local tweenOut = Services.TweenService:Create(MainFrame, TweenInfo.new(0.3), {Position = UDim2.new(0.05, 0, 0.22, 50), BackgroundTransparency = 1})
        tweenOut:Play()
        tweenOut.Completed:Wait()
    end
end)

local BaseCFrame
do
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    BaseCFrame = hrp.CFrame
end

local function EnableInstantPrompts()
    for _, obj in pairs(Services.Workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            obj.HoldDuration = 0
        end
    end
    Services.Workspace.DescendantAdded:Connect(function(newObj)
        if newObj:IsA("ProximityPrompt") then
            newObj.HoldDuration = 0
        end
    end)
end
pcall(EnableInstantPrompts)

local function MaintainWalkSpeed()
    while true do
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.WalkSpeed ~= 60 then
                humanoid.WalkSpeed = 60
            end
        end
        task.wait(0.1)
    end
end
coroutine.wrap(MaintainWalkSpeed)()

LocalPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = 60
end)

local AntiRagdollEnabled = true
local RagdollConnection = nil

local function EnableAntiRagdoll()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")

    RagdollConnection = humanoid.StateChanged:Connect(function(_, newState)
        local BlockedStates = {
            [Enum.HumanoidStateType.FallingDown] = true,
            [Enum.HumanoidStateType.Ragdoll] = true,
            [Enum.HumanoidStateType.Physics] = true,
            [Enum.HumanoidStateType.PlatformStanding] = true
        }
        if BlockedStates[newState] then
            task.delay(0.05, function()
                if humanoid:GetState() == newState then
                    humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
                end
            end)
        end
    end)
end

local function DisableAntiRagdoll()
    if RagdollConnection then
        RagdollConnection:Disconnect()
        RagdollConnection = nil
    end
end

local toggleAntiRagdollBtn
toggleAntiRagdollBtn = CreateButton("Anti-Ragdoll: Enabled", Color3.fromRGB(40, 180, 40), Color3.fromRGB(100, 255, 100), function()
    AntiRagdollEnabled = not AntiRagdollEnabled
    if AntiRagdollEnabled then
        toggleAntiRagdollBtn.Text = "Anti-Ragdoll: Enabled"
        toggleAntiRagdollBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
        EnableAntiRagdoll()
    else
        toggleAntiRagdollBtn.Text = "Anti-Ragdoll: Disabled"
        toggleAntiRagdollBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        DisableAntiRagdoll()
    end
end)

EnableAntiRagdoll()

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if AntiRagdollEnabled then
        EnableAntiRagdoll()
    else
        DisableAntiRagdoll()
    end
end)

CreateButton("Activate Luck Boost", Color3.fromRGB(40, 120, 200), Color3.fromRGB(100, 200, 255), function()
    Services.ReplicatedStorage.Events:FindFirstChild("AddServerLuck"):FireServer()
end)

CreateButton("Enable Summer Event", Color3.fromRGB(255, 150, 60), Color3.fromRGB(255, 200, 120), function()
    Services.ReplicatedStorage.Events.StartSummerEvent:FireServer()
end)

CreateButton("Enable Nel Event", Color3.fromRGB(180, 60, 255), Color3.fromRGB(220, 150, 255), function()
    Services.ReplicatedStorage.Events.StartNELEvent:FireServer()
end)

CreateButton("Enable Meme Event", Color3.fromRGB(90, 200, 100), Color3.fromRGB(150, 255, 150), function()
    Services.ReplicatedStorage.Events.StartMemeEvent:FireServer()
end)

CreateButton("Unlock All Doors", Color3.fromRGB(255, 90, 90), Color3.fromRGB(255, 140, 140), function()
    Services.ReplicatedStorage.Events.UnlockDoor:FireServer()
end)

CreateButton("Teleport to Base", Color3.fromRGB(60, 150, 255), Color3.fromRGB(120, 200, 255), function()
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = BaseCFrame
        end
    end
end)

local StealAllEnabled = false
local StealCoroutine
local StealButton

local function ToggleStealAll()
    if StealAllEnabled then
        StealAllEnabled = false
        if StealCoroutine then
            coroutine.close(StealCoroutine)
            StealCoroutine = nil
        end
        StealButton.Text = "Steal All: Disabled"
        StealButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    else
        StealAllEnabled = true
        StealButton.Text = "Steal All: Enabled"
        StealButton.BackgroundColor3 = Color3.fromRGB(40, 180, 40)

        StealCoroutine = coroutine.create(function()
            while StealAllEnabled do
                for _, prompt in pairs(Services.Workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") and prompt.ActionText == "Steal" then
                        if prompt.Enabled then
                            pcall(function()
                                prompt:InputHoldBegin()
                                prompt:InputHoldEnd()
                            end)
                        end
                    end
                end
                task.wait(1)
            end
        end)
        coroutine.resume(StealCoroutine)
    end
end

StealButton = CreateButton("Steal All: Disabled", Color3.fromRGB(180, 40, 40), Color3.fromRGB(255, 140, 140), ToggleStealAll)
