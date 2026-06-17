local Misc = {}

-- // Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

-- // Functions
function Misc.init()
    -- ADMIN KICK --

    local staffPlayers = {
        groups = {
            [4165692] = { -- crimcorp
                ["Tester"] = true, ["Contributor"] = true, ["Tester+"] = true,
                ["Developer"] = true, ["Developer+"] = true, ["Community Manager"] = true,
                ["Manager"] = true, ["Owner"] = true
            },
            [32406137] = { -- staff thing
                ["Junior"] = true, ["Moderator"] = true, ["Senior"] = true,
                ["Administrator"] = true, ["Manager"] = true, ["Holder"] = true
            },
            [8024440] = { -- r3shape fanclub
                ["zzzz"] = true, ["reshape enjoyer"] = true,
                ["i heart reshape"] = true, ["reshape superfan"] = true
            },
            [14927228] = { -- War Room
                ["♞"] = true
            }
        },
        users = { 
            3294804378, 93676120, 54087314, 81275825, 140837601, 1229486091, 46567801,
            418086275, 29706395, 3717066084, 1424338327, 5046662686, 5046661126, 
            5046659439, 418199326, 1024216621, 1810535041, 63238912, 111250044, 
            63315426, 730176906, 141193516, 194512073, 193945439, 412741116, 
            195538733, 102045519, 955294, 957835150, 25689921, 366613818, 
            281593651, 455275714, 208929505, 96783330, 156152502, 93281166, 
            959606619, 142821118, 632886139, 175931803, 122209625, 278097946, 
            142989311, 1517131734, 446849296, 87189764, 67180844, 9212846, 
            47352513, 48058122, 155413858, 10497435, 513615792, 55893752, 
            55476024, 151691292, 136584758, 16983447, 3111449, 94693025, 
            271400893, 5005262660, 295331237, 64489098, 244844600, 114332275, 
            25048901, 69262878, 50801509, 92504899, 42066711, 50585425, 
            31365111, 166406495, 2457253857, 29761878, 21831137, 948293345, 
            439942262, 38578487, 1163048, 7713309208, 3659305297, 15598614, 
            34616594, 626833004, 198610386, 153835477, 3923114296, 3937697838, 
            102146039, 119861460, 371665775, 1206543842, 93428604, 1863173316, 
            90814576, 374665997, 423005063, 140172831, 42662179, 9066859, 
            438805620, 14855669, 727189337, 1871290386, 608073286
        }
    }

    local function hasTracker(player)
        if not player or not player:IsA("Player") then return false, nil end
        for _, child in ipairs(player:GetChildren()) do
            if typeof(child.Name) == "string" and child.Name:sub(-8) == "Tracker$" then
                local trackedName = child.Name:sub(1, -9)
                if Players:FindFirstChild(trackedName) then
                    return true, trackedName
                end
            end
        end
        return false, nil
    end

    local function isStaff(player)
        if not player or not player:IsA("Player") then return false end

        for groupID, roles in pairs(staffPlayers.groups) do
            local success, rank = pcall(function() return player:GetRankInGroup(groupID) end)
            if success and rank and rank > 0 then
                local success2, roleName = pcall(function() return player:GetRoleInGroup(groupID) end)
                if success2 and roleName and roles[roleName] then
                    return true, roleName, groupID
                end
            end
        end

        for _, id in ipairs(staffPlayers.users) do
            if player.UserId == id then
                return true, "UserID", id
            end
        end

        return false
    end

    local function kickPlayer()
        if LocalPlayer then
            LocalPlayer:Kick("Staff joined")
        end
    end

    local function checkCurrentStaff()
        local staffFound = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local isPlayerStaff = isStaff(player)
                local hasTrack = hasTracker(player)

                if isPlayerStaff or hasTrack then
                    table.insert(staffFound, {Name = player.Name,})
                end
            end
        end

        if #staffFound > 0 then
            kickPlayer()
            return true
        end
        return false
    end

    local function onPlayerAdded(player)
        if player == LocalPlayer then return end
        
        local isPlayerStaff = isStaff(player)
        local hasTrack = hasTracker(player)

        if isPlayerStaff or hasTrack then
            kickPlayer()
        end
    end

    Players.PlayerAdded:Connect(onPlayerAdded)

    task.spawn(function()
        task.wait(2)
        if checkCurrentStaff() then
            --print("Staff found - Kicked")
        else
            --print("No staff found")
        end
    end)
end

----------- BETTER LIGHT -----------
local BetterLight_Enabled = false
local BetterLight_Connection = nil
local OriginalValues = nil

function Misc.BetterLight(state)
    if state then
        if BetterLight_Enabled then return end
        
        BetterLight_Enabled = true
        
        if not OriginalValues then
            OriginalValues = {
                ClockTime = Lighting.ClockTime,
                Brightness = Lighting.Brightness,
                Ambient = Lighting.Ambient,
                OutdoorAmbient = Lighting.OutdoorAmbient,
                ColorShift_Top = Lighting.ColorShift_Top,
                FogStart = Lighting.FogStart,
                FogEnd = Lighting.FogEnd,
            }
        end
        
        Lighting.ClockTime = 12
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
        Lighting.FogStart = 0
        Lighting.FogEnd = 100000
        
        if BetterLight_Connection then
            BetterLight_Connection:Disconnect()
        end
        
        BetterLight_Connection = RunService.RenderStepped:Connect(function()
            if not BetterLight_Enabled then return end
            
            Lighting.ClockTime = 12
            Lighting.Brightness = 2
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
            Lighting.FogStart = 0
            Lighting.FogEnd = 100000
        end)
        
    else
        if not BetterLight_Enabled then return end
        
        BetterLight_Enabled = false
        
        if BetterLight_Connection then
            BetterLight_Connection:Disconnect()
            BetterLight_Connection = nil
        end
        
        if OriginalValues then
            Lighting.ClockTime = OriginalValues.ClockTime
            Lighting.Brightness = OriginalValues.Brightness
            Lighting.Ambient = OriginalValues.Ambient
            Lighting.OutdoorAmbient = OriginalValues.OutdoorAmbient
            Lighting.ColorShift_Top = OriginalValues.ColorShift_Top
            Lighting.FogStart = OriginalValues.FogStart
            Lighting.FogEnd = OriginalValues.FogEnd
        end
    end
end

----------- REMOVE HELMET UI -----------
function Misc.RemoveHelmetUI()
    local helmetUI = PlayerGui:FindFirstChild("HelmetOverlayGUI")

    if helmetUI then
        helmetUI.Enabled = false
    end
end

----------- ANTI FLASHBANG -----------
function Misc.AntiFlashbang(state)
    local FlashUI

    PlayerGui.ChildAdded:Connect(function(Child)
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
        PlayerGui.ChildAdded:Connect(function(child)
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

----------- FOV HANDLE -----------
local FovEnabled = false
local FovConnection = nil

function Misc.ToggleFOV(state)
    FovEnabled = state
end

function Misc.FieldOfView(text)
    local fov = tonumber(text)
    if not fov then return end

    local originalFov = workspace.CurrentCamera.FieldOfView

    if FovEnabled then
        FovConnection = RunService.RenderStepped:Connect(function()
            workspace.CurrentCamera.FieldOfView = fov
        end)
    else
        if FovConnection then
            FovConnection:Disconnect()
            FovConnection = nil
        end
        workspace.CurrentCamera.FieldOfView = originalFov
    end
end

return Misc