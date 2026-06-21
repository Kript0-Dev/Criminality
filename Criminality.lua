local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kript0-Dev/Criminality/refs/heads/main/UIFramework.lua"))()
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kript0-Dev/Criminality/refs/heads/main/ESP.lua"))()
local Aimlock = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kript0-Dev/Criminality/refs/heads/main/Aimlock.lua"))()
local Misc =  loadstring(game:HttpGet("https://raw.githubusercontent.com/Kript0-Dev/Criminality/refs/heads/main/Misc.lua"))()

-- Start
UI.init()
ESP.init()
Aimlock.init()
Misc.init()

----------- ESP Section -----------
local SectionESP = UI.createSection("ESP", "ESP")
local ToggleESP = UI.createToggleButton("ESP", false, SectionESP, function(state)
    ESP.ToggleESP(state)
end)
local SelectESP = UI.createTextBox("Select", "Write player's name:",SectionESP, function(partialName)
    ESP.MarkPlayer(partialName)
end)
local ResetESP = UI.createButton("Reset", "Reset ESP", SectionESP, function()
    ESP.ResetESP()
end)
--[[
local FindAKSU = UI.createButton("FindAksu", "Find AKS-74U", SectionESP,function()
    ESP.FindAKSU()
end)
local FindCorruptis = UI.createButton("FindCorruptis", "Find Corruptis", SectionESP,function()
    ESP.FindCorruptis()
end)
]]--
local MarkFriends= UI.createButton("MarkFriends", "Mark Friends", SectionESP,function()
    ESP.MarkFriends()
end)

----------- Find Weapons Section -----------
local FindWeapons = UI.createSection("FindWeapons", "Find Weapons")
for i, weaponData in ipairs(ESP.WeaponList) do
    UI.createButton("Find"..weaponData[1], "Find "..weaponData[1], FindWeapons, function()
        ESP.FindWeapon(weaponData)
    end)
end


--[[
----------- Aimlock Section -----------
local SectionAimlock = UI.createSection("Aimlock", "Aimlock")

local ToggleAimlock = UI.createToggleButton("Aimlock", false, SectionAimlock, function(state)
    --Aimlock.ToggleAimlock(state)
end)

local NoRecoil = UI.createToggleButton("NoRecoil", false, SectionAimlock, function(state)
    Aimlock.NoRecoil(state)
end)
]]--


----------- Player Section -----------
local SectionPlayer = UI.createSection("Player", "Player")
local EnableFOV = UI.createToggleButton("EnableFOV", false, SectionPlayer, function(state)
    Misc.ToggleFOV(state)
end)
local SelectFieldOfView = UI.createTextBox("Select", "Field of View:", SectionPlayer, function(text)
    Misc.FieldOfView(text)
end)
local EasyLockpick = UI.createToggleButton("EasyLockpicks", false, SectionPlayer, function(state)
    Misc.Easylockpick(state)
end)
local AntiFlash = UI.createToggleButton("Anti-Flashbang", false, SectionPlayer, function(state)
    Misc.AntiFlashbang(state)
end)
local RemoveCascoUI = UI.createButton("RemoveHelmetUI", "Remove Helmet UI", SectionPlayer, function()
    Misc.RemoveHelmetUI()
end)
 
----------- Misc Section -----------
local SectionMisc = UI.createSection("Misc", "Misc")
local BetterLight = UI.createToggleButton("Better Light", false, SectionMisc, function(state)
    Misc.BetterLight(state)
end)
local OpenInfYeld = UI.createButton("OpenInfYeld", "Open Infinite Yeld", SectionMisc, function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)
local OpenEQRHub = UI.createButton("OpenEQRHub", "Open EQR Hub", SectionMisc, function()
    loadstring(game:HttpGet("https://pastebin.com/raw/eWYrQFFy"))()
end)