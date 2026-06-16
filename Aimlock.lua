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

local LERP_SPEED = 0.6

-- // Module functions

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
			if lockConnection then
				lockConnection:Disconnect()
				lockConnection = nil
			end
			return
		end

		local targetPart = lockedTarget:FindFirstChild("HumanoidRootPart")
		if not targetPart then return end

		local targetPosition = targetPart.Position + Vector3.new(0, 0.5, 0)

		local currentCFrame = camera.CFrame
		local targetCFrame = CFrame.lookAt(currentCFrame.Position, targetPosition)

		camera.CFrame = currentCFrame:Lerp(targetCFrame, LERP_SPEED)
	end

	-- Apply functions
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if not AimlockEnabled then return end

		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			if hasWeaponEquipped() then
				lockedTarget = getClosestCharacterToAim()
					if lockedTarget then
                		camera.CameraType = Enum.CameraType.Scriptable
                   
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
            
			camera.CameraType = Enum.CameraType.Custom
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

return Aimlock