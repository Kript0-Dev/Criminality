local UI = {}

-- // Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")

local MainFrame
local Container

function UI.init()
	-- // UI
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "MyMenu"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = PlayerGui

	-- Frame
	MainFrame = Instance.new("Frame")
	MainFrame.Size = UDim2.fromOffset(300, 400)
	MainFrame.Position = UDim2.fromScale(0.05, 0.2)
	MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 25)
	MainFrame.Parent = ScreenGui

	local Corner = Instance.new("UICorner")
	Corner.Parent = MainFrame
	Corner.CornerRadius = UDim.new(0, 5)

	local Stroke = Instance.new("UIStroke")
	Stroke.Parent = MainFrame
	Stroke.Color = Color3.fromRGB(255,255,255)
	Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local ListLayout = Instance.new("UIListLayout")
	ListLayout.Parent = MainFrame
	ListLayout.SortOrder = Enum.SortOrder.Name

	-- Title Container
	local TitleBar = Instance.new("Frame")
	TitleBar.Name = "1_TitleContainer"
	TitleBar.Size = UDim2.new(1, 0, 0.1, 0)
	TitleBar.BackgroundTransparency = 1
	TitleBar.BorderSizePixel = 0
	TitleBar.Parent = MainFrame

	local TitleCorner = Instance.new("UICorner")
	TitleCorner.Parent = TitleBar
	TitleCorner.CornerRadius = UDim.new(0, 5)

	local TitleStroke = Instance.new("UIStroke")
	TitleStroke.Parent = TitleBar
	TitleStroke.Color = Color3.fromRGB(255,255,255)
	TitleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local TitlePadding = Instance.new("UIPadding")
	TitlePadding.Parent = TitleBar
	TitlePadding.PaddingLeft = UDim.new(0,5)
	TitlePadding.PaddingRight = UDim.new(0,5)

	-- Title and Close Button
	local Title = Instance.new("TextLabel")
	Title.Parent = TitleBar
	Title.Size = UDim2.fromScale(0.5, 1)
	Title.BackgroundTransparency = 1
	Title.TextColor3 = Color3.fromRGB(255,255,255)
	Title.Name = "Title"
	Title.Text = "[Kript0's HUB]"
	Title.Font = Enum.Font.Jura
	Title.FontFace.Bold = true
	Title.TextScaled = true
	Title.TextXAlignment = Enum.TextXAlignment.Left

	local CloseButton = Instance.new("TextButton")
	CloseButton.Parent = TitleBar
	CloseButton.Size = UDim2.fromScale(0.3, 1)
	CloseButton.AnchorPoint = Vector2.new(1, 0)
	CloseButton.Position = UDim2.fromScale(1,0)
	CloseButton.BackgroundTransparency = 1
	CloseButton.TextColor3 = Color3.fromRGB(255,255,255)
	CloseButton.Name = "CloseButton"
	CloseButton.Text = "Close [ P ]"
	CloseButton.Font = Enum.Font.Jura
	CloseButton.TextSize = 16
	CloseButton.TextXAlignment = Enum.TextXAlignment.Right
	
	CloseButton.MouseButton1Up:Connect(function()
		MainFrame.Visible = not MainFrame.Visible
	end)

	-- Container
	Container = Instance.new("ScrollingFrame")
	Container.Name = "2_Container"
	Container.Size = UDim2.new(1, 0, 0.9, 0)
	Container.BackgroundTransparency = 1
	Container.Parent = MainFrame
	Container.ScrollBarThickness = 6
	Container.ScrollBarImageColor3 = Color3.fromRGB(255,255,255)
	Container.ScrollBarImageTransparency = 0.9
	Container.ClipsDescendants = true
	Container.BorderSizePixel = 0

	local ContainerPadding = Instance.new("UIPadding")
	ContainerPadding.Parent = Container
	ContainerPadding.PaddingRight = UDim.new(0,7)
	ContainerPadding.PaddingTop = UDim.new(0,5)

	local ContainerLayout = Instance.new("UIListLayout")
	ContainerLayout.Parent = Container
	ContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ContainerLayout.Padding = UDim.new(0,1)

	-- Drag
	local dragging = false
	local dragStart
	local startPos

	MainFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = MainFrame.Position
		end
	end)

	MainFrame.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart

			MainFrame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)

	-- Open/Close
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end

		if input.KeyCode == Enum.KeyCode.P then
			MainFrame.Visible = not MainFrame.Visible
		end
	end)

	-- // Testing UI
end

function UI.createSection(Name:string): Frame
	local Section = Instance.new("Frame")
	Section.Size = UDim2.new(1, 0, 0, 30)
	Section.BackgroundTransparency = 1
	Section.Parent = Container
	Section.Name = Name
	Section.AutomaticSize = Enum.AutomaticSize.Y

	local SectionStroke = Instance.new("UIStroke")
	SectionStroke.Color = Color3.fromRGB(255,255,255)
	SectionStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local SectionPadding = Instance.new("UIPadding")
	SectionPadding.PaddingRight = UDim.new(0,5)
	SectionPadding.PaddingTop = UDim.new(0,5)
	SectionPadding.PaddingBottom = UDim.new(0,5)
	SectionPadding.PaddingLeft = UDim.new(0,5)

	local SectionLayout = Instance.new("UIListLayout")
	SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
	SectionLayout.Padding = UDim.new(0,5)

	SectionStroke.Parent = Section
	SectionPadding.Parent = Section
	SectionLayout.Parent = Section
	Section.Parent = Container

	return Section
end

function UI.createSectionTitle(Text:string, parentTo: Frame): TextLabel
	local SectionTitle = Instance.new("TextLabel")
	SectionTitle.Size = UDim2.new(1,0,0,20)
	SectionTitle.BackgroundTransparency = 1
	SectionTitle.TextColor3 = Color3.fromRGB(255,255,255)
	SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
	SectionTitle.TextSize = 20
	SectionTitle.FontFace.Bold = true
	SectionTitle.Font = Enum.Font.Jura
	SectionTitle.Text = Text

	SectionTitle.Parent = parentTo

	return SectionTitle
end

function UI.createToggleButton(Name:string, defaultState:boolean, parentTo, callback)
	-- Variables
	local state = defaultState

	-- Create Button
	local Button = Instance.new("TextButton")
	Button.Size = UDim2.new(1,0,0,20)
	Button.BackgroundTransparency = 0.9
	Button.TextColor3 = Color3.fromRGB(255,255,255)
	Button.TextXAlignment = Enum.TextXAlignment.Left
	Button.Font = Enum.Font.Jura
	Button.TextSize = 18
	Button.RichText = true
	Button.Name = Name

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 3)
	Corner.Parent = Button

	local function updateText()
		local statusText = state
			and '<font color="rgb(152,251,152)">ON</font>' 
			or 	'<font color="rgb(255,182,193)">OFF</font>'

		Button.Text = string.format(
			"%s : %s",
			Name,
			statusText
		)
	end

	updateText()
	Button.Parent = parentTo

	-- Press event
	Button.MouseButton1Up:Connect(function()
		state = not state
		updateText()
		callback(state)
	end)

	return Button
end

function UI.createTextBox(Name:string, DefaultText:string, parentTo, callback)
	
	local TextBox = Instance.new("TextBox")
	TextBox.Size = UDim2.new(1,0,0,20)
	TextBox.BackgroundTransparency = 0.9
	TextBox.TextColor3 = Color3.fromRGB(255,255,255)
	TextBox.TextXAlignment = Enum.TextXAlignment.Left
	TextBox.Font = Enum.Font.Jura
	TextBox.TextSize = 18
	TextBox.RichText = true
	TextBox.Name = Name
	TextBox.PlaceholderText = DefaultText
	TextBox.Text = ""
	TextBox.PlaceholderColor3 = Color3.fromRGB(152,152,152)
	TextBox.Parent = parentTo
	
	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 3)
	Corner.Parent = TextBox
	
	TextBox.FocusLost:Connect(function(enterPressed)
		if not enterPressed then return end
		
		local text = TextBox.Text
		
		callback(text)
		TextBox.Text = ""
		TextBox.PlaceholderText = DefaultText
	end)
	
	return TextBox
end

function UI.createButton(Name:string, DefaultText:string, parentTo, callback)
	-- Create Button
	local Button = Instance.new("TextButton")
	Button.Size = UDim2.new(1,0,0,20)
	Button.BackgroundTransparency = 0.9
	Button.TextColor3 = Color3.fromRGB(255,255,255)
	Button.TextXAlignment = Enum.TextXAlignment.Left
	Button.Font = Enum.Font.Jura
	Button.TextSize = 18
	Button.RichText = true
	Button.Name = Name
	Button.Text = DefaultText

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 3)
	Corner.Parent = Button


	Button.Parent = parentTo

	-- Press event
	Button.MouseButton1Up:Connect(function()
		callback()
	end)

	return Button
end

return UI