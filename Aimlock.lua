local Aimlock = {}

-- // Variables
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

local lockedTarget = nil
local lockConnection = nil

local AimlockEnabled = false

local LERP_SPEED = 0.9

-- // Functions
local function LockMouse(boolean:boolean)
    if boolean then 
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    else
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    end
end

-- // Module functions
----------- AIMLOCK -----------
function Aimlock.init()
	-- Functions
	local function hasWeaponEquipped()
		if not player.Character then return false end
		return player.Character:FindFirstChildOfClass("Tool") ~= nil
	end


	local function isTargetVisible(targetChar)
		if not targetChar or not targetChar.Parent then return false end

		local rootPart = targetChar:FindFirstChild("HumanoidRootPart")
		if not rootPart then return false end

		local startPos = camera.CFrame.Position
		local targetPos = rootPart.Position + Vector3.new(0, 1.5, 0)

		local direction = (targetPos - startPos).Unit
		local distance = (targetPos - startPos).Magnitude

		local raycastParams = RaycastParams.new()
		raycastParams.FilterDescendantsInstances = {player.Character, targetChar}
		raycastParams.FilterType = Enum.RaycastFilterType.Exclude
		raycastParams.IgnoreWater = true

		local result = Workspace:Raycast(startPos, direction * distance, raycastParams)

		return result == nil
	end

	local function getClosestCharacterToAim()
		local mousePos = UserInputService:GetMouseLocation()
		local closestChar = nil
		local closestDist = math.huge

		for _, otherPlayer in ipairs(Players:GetPlayers()) do
			if otherPlayer ~= player and otherPlayer.Character then
				local char = otherPlayer.Character
				local rootPart = char:FindFirstChild("HumanoidRootPart")
				local humanoid = char:FindFirstChildOfClass("Humanoid")

				if rootPart and humanoid and humanoid.Health > 0 then
					local screenPos, onScreen = camera:WorldToScreenPoint(rootPart.Position)

					if onScreen then
						local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude

						-- Solo considerar si está visible
						if dist < closestDist and isTargetVisible(char) then
							closestDist = dist
							closestChar = char
						end
					end
				end
			end
		end

		return closestChar
	end

	local function updateCameraLock()
	if not lockedTarget or not lockedTarget.Parent then return end
	if not hasWeaponEquipped() then
		lockedTarget = nil
		return
	end

	if not isTargetVisible(lockedTarget) then
		lockedTarget = nil
		return
	end

	local targetPart = lockedTarget:FindFirstChild("HumanoidRootPart")
	local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

	if not targetPart or not rootPart then return end

	local targetPosition = targetPart.Position + Vector3.new(0, 1.5, 0)

	-- Posición actual de la cámara (Roblox la actualiza automáticamente)
	local cameraPos = camera.CFrame.Position

	local desired = CFrame.lookAt(cameraPos, targetPosition)

	camera.CFrame = camera.CFrame:Lerp(desired, LERP_SPEED)
end

	-- Apply functions
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if not AimlockEnabled then return end

		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			if hasWeaponEquipped() then
				lockedTarget = getClosestCharacterToAim()
					if lockedTarget then         
                        LockMouse(true)      
                    	if not lockConnection then
                    		lockConnection = RunService.RenderStepped:Connect(updateCameraLock)
                		end
                	end
				end
			end
		end)
	end

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			lockedTarget = nil
			if lockConnection then
				lockConnection:Disconnect()
				lockConnection = nil
			end
            LockMouse(false)
		end
	end)

	-- Clean-up
	player.CharacterAdded:Connect(function()
		lockedTarget = nil
		if lockConnection then
			lockConnection:Disconnect()
			lockConnection = nil
		end
        camera.CameraType = Enum.CameraType.Custom
	end)

	player.CharacterRemoving:Connect(function()
		lockedTarget = nil
		if lockConnection then
			lockConnection:Disconnect()
			lockConnection = nil
		end
	end)

function Aimlock.ToggleAimlock(State:boolean)
	AimlockEnabled = State
end


----------- NO RECOIL -----------
local NoRecoil_Enabled = false
local NoRecoil_Connections = {}
local GlobalOriginalValues = {}
local WeaponCache = {}

local Settings = {
    GunMods = {
        NoRecoil = true,
        Spread = true,
        SpreadAmount = 0
    }
}

local function cacheWeapons()
    WeaponCache = {}
    for _, v in pairs(getgc(true)) do
        if type(v) == 'table' and rawget(v, 'EquipTime') then
            table.insert(WeaponCache, v)
            
            if not GlobalOriginalValues[v] then
                GlobalOriginalValues[v] = {
                    Recoil = v.Recoil,
                    CameraRecoilingEnabled = v.CameraRecoilingEnabled,
                    AngleX_Min = v.AngleX_Min,
                    AngleX_Max = v.AngleX_Max,
                    AngleY_Min = v.AngleY_Min,
                    AngleY_Max = v.AngleY_Max,
                    AngleZ_Min = v.AngleZ_Min,
                    AngleZ_Max = v.AngleZ_Max,
                    Spread = v.Spread
                }
            end
        end
    end
end

local function applyGunMods()
    for _, weapon in ipairs(WeaponCache) do
        if Settings.GunMods.NoRecoil then
            weapon.Recoil = 0
            weapon.CameraRecoilingEnabled = false
            weapon.AngleX_Min = 0
            weapon.AngleX_Max = 0
            weapon.AngleY_Min = 0
            weapon.AngleY_Max = 0
            weapon.AngleZ_Min = 0
            weapon.AngleZ_Max = 0
        end

        if Settings.GunMods.Spread then
            weapon.Spread = Settings.GunMods.SpreadAmount
        end
    end
end

local function resetGunMods()
    for weapon, values in pairs(GlobalOriginalValues) do
        weapon.Recoil = values.Recoil
        weapon.CameraRecoilingEnabled = values.CameraRecoilingEnabled
        weapon.AngleX_Min = values.AngleX_Min
        weapon.AngleX_Max = values.AngleX_Max
        weapon.AngleY_Min = values.AngleY_Min
        weapon.AngleY_Max = values.AngleY_Max
        weapon.AngleZ_Min = values.AngleZ_Min
        weapon.AngleZ_Max = values.AngleZ_Max
        weapon.Spread = values.Spread
    end
end

local function handleWeapon(weapon)
    if NoRecoil_Enabled then
        task.wait(0.1)
        cacheWeapons()
        applyGunMods()
    end
end

local function onCharacterAdded_nr(character)
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Tool") then
            handleWeapon(child)
        end
    end

    table.insert(NoRecoil_Connections, character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            handleWeapon(child)
        end
    end))

    local humanoid = character:WaitForChild("Humanoid", 2)
    if humanoid then
        table.insert(NoRecoil_Connections, humanoid.Died:Connect(function()
            if NoRecoil_Enabled then
                task.wait(1.5)
                cacheWeapons()
                applyGunMods()
            end
        end))
    end
end

function Aimlock.NoRecoil(state)
	if state then
		NoRecoil_Enabled = true
		cacheWeapons()
		applyGunMods()

		table.insert(NoRecoil_Connections, player.CharacterAdded:Connect(onCharacterAdded_nr))

		if player.Character then
			onCharacterAdded_nr(player.Character)
		end
	else
		if not NoRecoil_Enabled then return end

		NoRecoil_Enabled = false
		resetGunMods()

		for _, connection in ipairs(NoRecoil_Connections) do
			connection:Disconnect()
		end
		NoRecoil_Connections = {}
	end
end

return Aimlock