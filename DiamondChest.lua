
if not game:IsLoaded() then game.Loaded:Wait() end
if not game:IsLoaded() then repeat task.wait() until game:IsLoaded() end

if getgenv().RunScript == true then	return end
getgenv().RunScript = true

local queueScript = string.format([[
loadstring(game:HttpGet('https://raw.githubusercontent.com/dyumra/Detail/refs/heads/main/Somtank'))()
]])

queue_on_teleport(queueScript)

repeat wait(0.1) until game.Players
local TimeWaitLoadGame = 0
local player = game.Players.LocalPlayer
repeat
	wait(0.1)
	TimeWaitLoadGame = TimeWaitLoadGame + 0.1
	if TimeWaitLoadGame > 3 then
		player:Kick()
		wait(0.5)
		game:GetService("TeleportService"):Teleport(126509999114328)
	end
until game.Players and game.Players.LocalPlayer and game.Players.LocalPlayer.Character

local player = game.Players.LocalPlayer
local character = player.Character
local humanoid = character:FindFirstChildOfClass("Humanoid")
local HMNRT = character:FindFirstChild("HumanoidRootPart")
local Camera = workspace.CurrentCamera
local plrGui = player.PlayerGui

task.spawn(function()
	pcall(function()
		local OutTick = 0
		local LastPosition = HMNRT.Position
		local Stuck_Count = 0
		while wait(1) do
			OutTick = OutTick + 1
			print("OutTick "..OutTick)
			local Dis = (LastPosition - HMNRT.Position).Magnitude
			if Dis < 5 then
				Stuck_Count = Stuck_Count + 1
				print("Stuck "..Stuck_Count)
			end
			if OutTick >= 35 or Stuck_Count > 2 then
				player:Kick()
				wait(0.5)
				game:GetService("TeleportService"):Teleport(126509999114328)
			end
			LastPosition = HMNRT.Position
		end
	end)
end)


local function matchesAllowedKeyword(value, allowedKeywords)
	value = value:lower()
	for _, keyword in ipairs(allowedKeywords) do
		if string.find(value, keyword:lower()) then
			return true
		end
	end
	return false
end

if tonumber(game.PlaceId) == tonumber(79546208627805) then
	
	local TweenService = game:GetService("TweenService")
	local RunService = game:GetService("RunService")
	local Lighting = game:GetService("Lighting")
	local replicatedStorage = game:GetService("ReplicatedStorage")
	local UIS = game:GetService("UserInputService")
	local player = game.Players.LocalPlayer
	local character = player.Character
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local HMNRT = character:FindFirstChild("HumanoidRootPart")
	local Camera = workspace.CurrentCamera
	local plrGui = player.PlayerGui
	local Inventory = player:WaitForChild("Inventory")
	local HttpService = game:GetService("HttpService")
	local StageUI = nil
	
	local TeleporterAssets = plrGui:WaitForChild("TeleporterAssets")
	if plrGui:WaitForChild("Interface"):WaitForChild("EntryScreen") then
		plrGui:WaitForChild("Interface"):WaitForChild("EntryScreen").Visible = false
	end
	if TeleporterAssets:WaitForChild("Frame") then
		TeleporterAssets:WaitForChild("Frame").Visible = true
		local Frame = TeleporterAssets:WaitForChild("Frame")
		if Frame:FindFirstChild("TextLabel1") then
			local TextLabel1 = Frame:FindFirstChild("TextLabel1")
			TextLabel1.Text = "Auto-Farm Gem | DYHUB"
			TextLabel1.Visible = true
			TextLabel1.TextColor3 = Color3.new(1, 0, 0)
		end
		if Frame:FindFirstChild("TextLabel2") then
			local TextLabel2 = Frame:FindFirstChild("TextLabel2")
			TextLabel2.Text = "DYHUB (dsc.gg/dyhub)"
			TextLabel2.Visible = true
			TextLabel2.TextColor3 = Color3.new(1, 1, 1)
		end
		if Frame:FindFirstChild("TextLabel3") then
			local TextLabel3 = Frame:FindFirstChild("TextLabel3")
			TextLabel3.Text = "Status : Find every chest"
			TextLabel3.Visible = true
			TextLabel3.TextColor3 = Color3.new(1, 1, 1)
			StageUI = TextLabel3
		end
	end
	local VirtualInputManager = game:GetService("VirtualInputManager")
	local screenSize = workspace.CurrentCamera.ViewportSize
	local centerX = screenSize.X / 2
	local centerY = screenSize.Y / 2

	local function Click_Function()
		VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 0)
		wait(0.02)
		VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 0)
		wait(0.02)
	end
	wait(6)
	local Teleport = false
	repeat
		local GotoEnterPart = false
		if GotoEnterPart == false then
			for i=1,3 do
				if workspace:FindFirstChild("Teleporter"..i) then
					local Model_Teleport = workspace:FindFirstChild("Teleporter"..i)
					if Model_Teleport:FindFirstChild("BillboardHolder") then
						local BillboardHolder = Model_Teleport:FindFirstChild("BillboardHolder")
						local Players = BillboardHolder:FindFirstChild("BillboardGui"):FindFirstChild("Players")
						if Players.Text == "0/5" then
							for _, item in ipairs(Model_Teleport:GetChildren()) do
								if item.Name == "EnterPart" and GotoEnterPart == false then
									firetouchinterest(HMNRT, item, 0)
									GotoEnterPart = true
									wait(0.1)
								end
							end
						end
					end
				end
			end
		end
		if GotoEnterPart == true then
			GotoEnterPart = false
			local LobbyCreate = plrGui:FindFirstChild("Interface"):FindFirstChild("LobbyCreate")
			local ButtonList = LobbyCreate:FindFirstChild("ButtonList")
			local CreateButton = LobbyCreate:FindFirstChild("HeaderFrame"):FindFirstChild("CreateButton")
			local Buttin1 = nil
			if ButtonList and LobbyCreate then
				for _, item in ipairs(ButtonList:GetChildren()) do
					if item.Name ~= "Button1" then
						item:Destroy()
					else
						Buttin1 = item
					end
				end
				if Buttin1 and CreateButton then
					CreateButton.Position = UDim2.new(0.5, 0, 4.5, 0)
					if TeleporterAssets:WaitForChild("Frame") then
						TeleporterAssets:WaitForChild("Frame").Visible = false
					end
					for i=1,5 do
						Click_Function()
					end
					Buttin1.Visible = false
					if StageUI then
						StageUI.Text = "Status : Completed room creation"
					end
					for i=1,5 do
						Click_Function()
					end
					if TeleporterAssets:WaitForChild("Frame") then
						TeleporterAssets:WaitForChild("Frame").Visible = true
					end
					wait(30)
					game:GetService("TeleportService"):Teleport(79546208627805)

				end
			end
		end
		wait(0.1)
	until Teleport == true
else
	local DiamondCount = plrGui:WaitForChild("Interface"):WaitForChild("DiamondCount"):FindFirstChild("Count")
	local Map = workspace:WaitForChild("Map")
	local InnerTouchZone = Map:WaitForChild("Campground"):WaitForChild("MainFire"):WaitForChild("InnerTouchZone")
	local RemoteEvents = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents")
	local RequestStartDraggingItem = RemoteEvents:FindFirstChild("RequestStartDraggingItem")
	local StopDraggingItem = RemoteEvents:FindFirstChild("StopDraggingItem")
	local RequestTakeDiamonds = RemoteEvents:FindFirstChild("RequestTakeDiamonds")
	local FastBring_Delay = 0.17
	local Bring_HipHeight = 6
	local StartCountDiamon = tonumber(DiamondCount.Text)
	local Items = workspace:WaitForChild("Items")
	
	if workspace:FindFirstChild("Map"):FindFirstChild("Boundaries") then
		workspace:FindFirstChild("Map"):FindFirstChild("Boundaries"):Destroy()
	end
	
	game.Workspace.Gravity = 0
	
	task.spawn(function()
		while wait(3) do
			game:GetService("StarterGui"):SetCore("SendNotification", {Title = "You now have Gem",Text = "💎 Gem: "..tonumber(DiamondCount.Text),Duration = 3})
		end
	end)
	
	local function BringItemWithItem2(item2)
		pcall(function()
			humanoid.HipHeight = Bring_HipHeight
			HMNRT.CFrame = CFrame.new(item2.PrimaryPart.Position) * CFrame.new(0,Bring_HipHeight,0)
			wait(FastBring_Delay)
			wait(FastBring_Delay)
			wait(FastBring_Delay)
			RequestStartDraggingItem:FireServer(item2)
			wait(FastBring_Delay)
			wait(FastBring_Delay)
			wait(FastBring_Delay)
			item2.PrimaryPart.CFrame = InnerTouchZone.CFrame * CFrame.new(0,15,0)
			wait(FastBring_Delay)
			HMNRT.CFrame = CFrame.new(InnerTouchZone.Position) * CFrame.new(0,Bring_HipHeight,0)
			wait(FastBring_Delay)
			wait(FastBring_Delay)
			wait(FastBring_Delay)
			StopDraggingItem:FireServer(item2)
			wait(FastBring_Delay)
			StopDraggingItem:FireServer(item2)
			wait(FastBring_Delay)
			humanoid.HipHeight = 0
		end)
	end
	for _, item2 in ipairs(Items:GetChildren()) do
		if matchesAllowedKeyword(item2.Name, {"Diamond Chest"}) then
			pcall(function()
				repeat
					wait(0.1)
				until item2.PrimaryPart.ProximityAttachment.ProximityInteraction
				local Prox = item2.PrimaryPart.ProximityAttachment.ProximityInteraction
				humanoid.HipHeight = 16
				HMNRT.CFrame = CFrame.new(item2.PrimaryPart.Position) * CFrame.new(0,16,0)
				wait(0.2)
				fireproximityprompt(Prox)
				wait(0.2)
				humanoid.HipHeight = 0
			end)
		end
	end
	for _, Model in ipairs(Items:GetChildren()) do
		if Model.Name == "Diamond" then
			pcall(function()
				if Model.PrimaryPart then
					wait(0.1)
					HMNRT.CFrame = Model.PrimaryPart.CFrame
					wait(0.1)
					RequestStartDraggingItem:FireServer(Model)
					wait(0.1)
					RequestTakeDiamonds:FireServer(Model)
					wait(0.1)
					StopDraggingItem:FireServer(Model)
				end
			end)
		end
	end
	wait(2)
	player:Kick()
	wait(0.5)
	game:GetService("TeleportService"):Teleport(126509999114328)
end
