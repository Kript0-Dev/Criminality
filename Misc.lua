local Misc = {}

-- // Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

-- // Functions
function Misc.init()

end

function Misc.BetterLight(state:boolean)
    if state then

    else

    end
end

function Misc.RemoveHelmetUI()
    if not PlayerGui then return end

end

function Misc.AntiFlashbang(state)
    local FlashUI

    PlayerGui.ChildAdded:Connect(function(Child: Instance)
        if Child.Name == "FlasedGUI" then
            FlashUI = Child
        end
    end)

    if state then
        FlashUI:Destroy()  
        FlashUI = nil
    end
end

return Misc