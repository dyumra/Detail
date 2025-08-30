if not game:IsLoaded() then game.Loaded:Wait() end
if not game:IsLoaded() then repeat task.wait() until game:IsLoaded() end

if getgenv().RunScript == true then	return end
getgenv().RunScript = true

local queueScript = string.format([[
loadstring(game:HttpGet('https://raw.githubusercontent.com/dyumra/Detail/refs/heads/main/V2FarmChest.lua'))()
]])

queue_on_teleport(queueScript)
