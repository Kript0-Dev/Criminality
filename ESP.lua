local ESP = {}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ESP_Enabled = false
local Highlight_Table = {}
local DealersFolder = workspace:WaitForChild("Map"):WaitForChild("Shopz")

-- // Weapon List
ESP.WeaponList = {
	{[1] = "AKS-74U", 	[2] = 30, 	[3] = Color3.fromRGB(254, 254, 162)},
	{[1] = "Corruptis", [2] = 120, 	[3] = Color3.fromRGB(113, 34, 204)},
	{[1] = "SCAR-H-1", 	[2] = 30, 	[3] = Color3.fromRGB(254, 254, 162)},
	{[1] = "Tommy", 	[2] = 30, 	[3] = Color3.fromRGB(254, 254, 162)},
	{[1] = "RPG-7", 	[2] = 30, 	[3] = Color3.fromRGB(254, 254, 162)},
	{[1] = "Mare", 		[2] = 30, 	[3] = Color3.fromRGB(254, 254, 162)},
	{[1] = "Deagle", 	[2] = 30, 	[3] = Color3.fromRGB(254, 254, 162)},
}


function ESP.init()

	-- // Functions
	local function createHighlight(player)
		if player == LocalPlayer then return end
		
		local character = player.Character
		if not character then return end
		
		local old_highlight = Highlight_Table[player]
		if old_highlight then
			old_highlight:Destroy()
		end
		
		local Highlight = Instance.new("Highlight")
		Highlight.FillTransparency = 1
		Highlight.OutlineTransparency = 0.5
		Highlight.Enabled = ESP_Enabled
		Highlight.Parent = character

        if LocalPlayer:IsFriendsWithAsync(player.UserId) then
            Highlight.OutlineColor = Color3.fromRGB(30, 144, 255)
        end
		
		Highlight_Table[player] = Highlight
	end
	
	local function setupPlayer(player)

		player.CharacterAdded:Connect(function()
			task.wait()
			createHighlight(player)
		end)

		if player.Character then
			createHighlight(player)
		end
	end
	
	for _, player in ipairs(Players:GetPlayers()) do
		setupPlayer(player)
	end

	Players.PlayerAdded:Connect(setupPlayer)

	-- Handle leaving players
	Players.PlayerRemoving:Connect(function(player)
		local highlight = Highlight_Table[player]

		if highlight then highlight:Destroy() end
		
		highlight = nil
	end)

	-- Rebel Dealer Detector
	local Shopz = workspace:WaitForChild("Map"):WaitForChild("Shopz", 5)
	Shopz.ChildAdded:Connect(function(child)
		if child.Name == "RebelDealer" then
			local Highlight = Instance.new("Highlight")
			Highlight.FillTransparency = 1
			Highlight.Enabled = ESP_Enabled
			Highlight.OutlineColor = Color3.fromRGB(68, 122, 66)
			Highlight.Enabled = true
			Highlight.Parent = child
		end
	end
)
end

function ESP.ToggleESP(State:boolean)
	ESP_Enabled = State
	
	for _, highlight in pairs(Highlight_Table) do
		highlight.Enabled = State
	end
end

function ESP.MarkPlayer(partialName:string)
	partialName = partialName:lower()
	
	for _, player in ipairs(Players:GetPlayers()) do
		if player.Name:lower():sub(1, #partialName) == partialName then
			
			-- Player found
			Highlight_Table[player].OutlineColor = Color3.fromRGB(255, 150, 150)
			Highlight_Table[player].OutlineTransparency = 0
		end
	end
	
	return nil
end

function ESP.MarkFriends()
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			if LocalPlayer:IsFriendsWithAsync(player.UserId) then
				-- The player is friend
				if Highlight_Table[player] then
					Highlight_Table[player].OutlineColor = Color3.fromRGB(30, 144, 255)
					Highlight_Table[player].OutlineTransparency = 0
				end
			end
		end
	end
	
	return nil
end

function ESP.ResetESP()
	for _, highlight in pairs(Highlight_Table) do
		highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	end
end

function ESP.FindWeapon(weaponData)
	for _, dealer in pairs(DealersFolder:GetDescendants()) do
		if dealer.Name == "Dealer" then 
			if dealer.CurrentStocks[weaponData[1]].Value ~= 0 then
				local Highlight = Instance.new("Highlight")
				Highlight.FillTransparency = 1
				Highlight.Enabled = ESP_Enabled
				Highlight.OutlineColor = weaponData[3]
				Highlight.Enabled = true
				Highlight.Parent = dealer

				task.spawn(function()
					task.wait(weaponData[2])
					Highlight:Destroy()
				end)
			end
		end
	end
end

--[[
function ESP.FindCorruptis()
	for _, dealer in pairs(DealersFolder:GetDescendants()) do
		if dealer.Name == "Dealer" then 
			if dealer.CurrentStocks["Corruptis"].Value ~= 0 then
				local Highlight = Instance.new("Highlight")
				Highlight.FillTransparency = 1
				Highlight.Enabled = ESP_Enabled
				Highlight.OutlineColor = Color3.fromRGB(113, 34, 204)
				Highlight.Enabled = true
				Highlight.Parent = dealer

				task.spawn(function()
					task.wait(120)
					Highlight:Destroy()
				end)
			end
		end
	end
end

function ESP.FindAKSU()
	for _, dealer in pairs(DealersFolder:GetDescendants()) do
		if dealer.Name == "Dealer" then 
			if dealer.CurrentStocks["AKS-74U"].Value ~= 0 then
				local Highlight = Instance.new("Highlight")
				Highlight.FillTransparency = 1
				Highlight.Enabled = ESP_Enabled
				Highlight.OutlineColor = Color3.fromRGB(254, 254, 162)
				Highlight.Enabled = true
				Highlight.Parent = dealer

				task.spawn(function()
					task.wait(30)
					Highlight:Destroy()
				end)
			end
		end
	end
end
]]--

return ESP