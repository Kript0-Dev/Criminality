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

function Misc.BetterLight()
    Lighting.EnvironmentDiffuseScale = 1
    Lighting.EnvironmentSpecularScale = 1
    Lighting.ExposureCompensation = 2

    if Lighting:FindFirstAncestorOfClass("Atmosphere") then Lighting:FindFirstAncestorOfClass("Atmosphere"):Destroy() end
    if Lighting:FindFirstAncestorOfClass("Clouds")     then Lighting:FindFirstAncestorOfClass("Clouds"):Destroy()     end
end

function Misc.RemoveHelmetUI()
    local hellmetUI = PlayerGui:FindFirstChild("HelmetOverlayGUI")

    if hellmetUI then
        hellmetUI.Enabled = false
    end
end

function Misc.AntiFlashbang(state)
    local FlashUI

    PlayerGui.ChildAdded:Connect(function(Child: Instance)
        if Child.Name == "FlasedGUI" then
            FlashUI = Child
        end
    end)

    if state and FlashUI ~= nil then
        FlashUI:Destroy()  
        FlashUI = nil
    end
end

function Misc.Easylockpick(state)
    local lockpickUI

    if state then
        PlayerGui.ChildAdded:Connect(function(child: Instance)
            if child.Name == "LockpickGUI" then
                task.wait()

                lockpickUI = child
                
                local u1 = lockpickUI:FindFirstChild("MF"):FindFirstChild("LP_Frame"):FindFirstChild("Frames"):FindFirstChild("B1"):FindFirstChild("Bar")
                local u2 = lockpickUI:FindFirstChild("MF"):FindFirstChild("LP_Frame"):FindFirstChild("Frames"):FindFirstChild("B2"):FindFirstChild("Bar")
                local u3 = lockpickUI:FindFirstChild("MF"):FindFirstChild("LP_Frame"):FindFirstChild("Frames"):FindFirstChild("B3"):FindFirstChild("Bar")

                u1.Size = UDim2.new(0, 35, 0, 300)
                u2.Size = UDim2.new(0, 35, 0, 300)
                u3.Size = UDim2.new(0, 35, 0, 300)
            end
        end)
    end
end

return Misc