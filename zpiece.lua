-- 🔐 Anti Direct Execution
local player = game:GetService("Players").LocalPlayer
if getgenv().DYHUBTHEBEST ~= "Join Our dsc.gg/dyhub" or getgenv().Credit ~= "@akirabr737" then
	player:Kick("❌ Delete Credit.\n\nYou must run the loader properly.\n\nUsage:\ngetgenv().DYHUBTHEBEST = \"Join Our dsc.gg/dyhub\"\ngetgenv().Credit = \"@akirabr737")
	return
end

-- ✅ Passed verification
print("[DYHUB] Loader verified. Welcome,", player.Name)

-- Services
local g = game
local s = g.GetService
local plr = s(g, "Players").LocalPlayer
local rep = s(g, "ReplicatedStorage")

-- UI Base
local gui = Instance.new("ScreenGui", plr:WaitForChild("PlayerGui"))
gui.Name = "TestPowersFishing"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 120)
frame.Position = UDim2.new(0.5, -120, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- UI Effects
local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(80, 80, 120)
stroke.Thickness = 1.5

local gradient = Instance.new("UIGradient", frame)
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 20)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 35))
}
gradient.Rotation = 45

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Font = Enum.Font.FredokaOne
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(180, 180, 255)
title.TextStrokeTransparency = 0.7
title.Text = "🎣 DYHUB - Auto Fishing"

-- Toggle Button
local toggle = false

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0.85, 0, 0, 40)
button.Position = UDim2.new(0.075, 0, 0.5, 0)
button.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
button.Font = Enum.Font.GothamBold
button.TextSize = 14
button.TextColor3 = Color3.new(1, 1, 1)
button.Text = "Fishing [OFF]"
button.AutoButtonColor = false

-- Button Style
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)

local btnStroke = Instance.new("UIStroke", button)
btnStroke.Color = Color3.fromRGB(100, 100, 150)
btnStroke.Thickness = 1.5

local btnShadow = Instance.new("ImageLabel", button)
btnShadow.BackgroundTransparency = 1
btnShadow.Size = UDim2.new(1, 10, 1, 10)
btnShadow.Position = UDim2.new(0, -5, 0, -5)
btnShadow.Image = "rbxassetid://1316045217"
btnShadow.ImageTransparency = 0.8
btnShadow.ScaleType = Enum.ScaleType.Slice
btnShadow.SliceCenter = Rect.new(10, 10, 118, 118)
btnShadow.ZIndex = -1

-- Toggle Logic
button.MouseButton1Click:Connect(function()
	toggle = not toggle
	button.Text = toggle and "Fishing [ON]" or "Fishing [OFF]"
	button.BackgroundColor3 = toggle and Color3.fromRGB(40, 130, 60) or Color3.fromRGB(50, 50, 65)
	btnStroke.Color = toggle and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(100, 100, 150)
end)

-- ⚡ Fast Fire Loop (100x per sec)
task.spawn(function()
	while true do
		if toggle then
			for i = 1, 1000 do
				task.spawn(function()
					pcall(function()
						rep.Remote.Other.fishing:FireServer("reward")
					end)
				end)
			end
		end
		task.wait(3)
	end
end)
