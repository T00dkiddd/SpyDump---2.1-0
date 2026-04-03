local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")

local LocalPlayer = Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(0,100,0,40)
Toggle.Position = UDim2.new(1,-120,0.5,-20)
Toggle.Text = ">_"
Toggle.BackgroundColor3 = Color3.fromRGB(10,10,10)
Toggle.TextColor3 = Color3.fromRGB(200,200,200)
Toggle.Parent = ScreenGui
Instance.new("UICorner", Toggle)

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0,320,0,260)
Main.Position = UDim2.new(0.5,-160,0.5,-130)
Main.BackgroundColor3 = Color3.fromRGB(15,15,15)
Main.BackgroundTransparency = 0.15
Main.Visible = false
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main)

local Layout = Instance.new("UIListLayout", Main)
Layout.Padding = UDim.new(0,6)

local Padding = Instance.new("UIPadding", Main)
Padding.PaddingLeft = UDim.new(0,10)
Padding.PaddingTop = UDim.new(0,10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,30)
Title.Text = "SPYDUMP 2.1-0"
Title.Font = Enum.Font.Code
Title.TextColor3 = Color3.fromRGB(0,200,120)
Title.BackgroundTransparency = 1
Title.Parent = Main

local function smoothOpen(frame, size, pos)
	frame.Size = UDim2.new(0,0,0,0)
	frame.Position = UDim2.new(0.5,0,0.5,0)

	TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
		Size = size,
		Position = pos
	}):Play()
end

local function newWindow(lines)
	local Frame = Instance.new("Frame")
	Frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
	Frame.BackgroundTransparency = 0.1
	Frame.Active = true
	Frame.Draggable = true
	Frame.Parent = ScreenGui
	Instance.new("UICorner", Frame)

	local Layout = Instance.new("UIListLayout", Frame)
	Layout.Padding = UDim.new(0,4)

	local Padding = Instance.new("UIPadding", Frame)
	Padding.PaddingLeft = UDim.new(0,8)
	Padding.PaddingTop = UDim.new(0,8)

	local Close = Instance.new("TextButton")
	Close.Text = "x"
	Close.Size = UDim2.new(1,0,0,25)
	Close.BackgroundTransparency = 1
	Close.TextColor3 = Color3.fromRGB(200,200,200)
	Close.Parent = Frame

	Close.MouseButton1Click:Connect(function()
		Frame:Destroy()
	end)

	local labels = {}

	for _,txt in ipairs(lines) do
		local lbl = Instance.new("TextLabel")
		lbl.Size = UDim2.new(1,0,0,20)
		lbl.Text = txt
		lbl.Font = Enum.Font.Code
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.TextColor3 = Color3.fromRGB(220,220,220)
		lbl.BackgroundTransparency = 1
		lbl.Parent = Frame
		table.insert(labels, lbl)
	end

	task.wait()
	local sizeY = (#lines * 20) + 50
	Frame.Size = UDim2.new(0,300,0,sizeY)

	smoothOpen(Frame, Frame.Size, UDim2.new(0.5,-150,0.5,-sizeY/2))

	return Frame, labels
end

local function getGameName(callback)
	task.spawn(function()
		local success, info = pcall(function()
			return MarketplaceService:GetProductInfo(game.PlaceId)
		end)

		if success and info then
			callback(info.Name)
		else
			callback("Unknown Game")
		end
	end)
end

local function createOption(text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1,0,0,25)
	btn.Text = text
	btn.Font = Enum.Font.Code
	btn.TextColor3 = Color3.fromRGB(120,200,255)
	btn.BackgroundTransparency = 1
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.Parent = Main

	btn.MouseEnter:Connect(function()
		btn.TextColor3 = Color3.fromRGB(255,255,255)
	end)

	btn.MouseLeave:Connect(function()
		btn.TextColor3 = Color3.fromRGB(120,200,255)
	end)

	btn.MouseButton1Click:Connect(callback)
end

createOption("[1] Get Usernames", function()
	local list = {}
	for _,p in pairs(Players:GetPlayers()) do
		table.insert(list, p.Name)
	end
	newWindow(list)
end)

createOption("[2] Info", function()
	newWindow({
		"SpyDump UI Tool",
		"Uso: datos locales",
		"Visual tipo hacking"
	})
end)

createOption("[3] Game Name", function()
	local win, labels = newWindow({"Fetching game name..."})

	getGameName(function(name)
		if labels[1] then
			labels[1].Text = name
		end
	end)
end)

createOption("[4] Exit Game", function()
	LocalPlayer:Kick("You Exit the Game.")
end)

createOption("[5] Date", function()
	local win, labels = newWindow({"Loading..."})

	task.spawn(function()
		while win.Parent do
			local t = os.date("*t")
			labels[1].Text = string.format(
				"%02d:%02d:%02d | %d/%02d/%02d",
				t.hour,t.min,t.sec,t.year,t.month,t.day
			)
			task.wait(1)
		end
	end)
end)

createOption("[6] NeoFetch", function()
	newWindow({
		"Roblox",
		"-------------",
		"SpyDump 2.1-0",
		"Game: Roblox",
		"Language: Lua",
		"Client: LocalScript",
		"-------------",
		"Fsociety Group",
		"T00dkiddd"
	})
end)

Toggle.MouseButton1Click:Connect(function()
	Main.Visible = not Main.Visible
end)
