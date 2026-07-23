-- 1. Initialize core game engines
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- State variables
local currentTarget = nil
local enabled = false
local currentHitbox = nil

-- Chair Flight Variables
local currentFlightChair = nil
local flightEnabled = false

-- 2. Load the Mobile UI Framework (Rayfield Library)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
	Name = "=Telekinesis=",
	LoadingTitle = "Preparing Mobile Layout...",
	LoadingSubtitle = "by GregTheWizz",
	ConfigurationSaving = { Enabled = false }
})

local Tab = Window:CreateTab("Main Modifiers", 4483362458)
local ChairUI = Window:CreateTab("Seat", 4483362458)

-- ==================== [ TELEKINESIS CODE ] ====================
-- Base tracking checks
function getPart()
	local target = Mouse.Target
	local character = LocalPlayer.Character
	if target and target:IsA("BasePart") and not target.Anchored then
		if character and not target:IsDescendantOf(character) then
			return target.AssemblyRootPart or target
		end
	end
	return nil
end

function setOwner(part)
	local character = LocalPlayer.Character
	local hrp = character and character:FindFirstChild("HumanoidRootPart")

	if part and hrp and not currentHitbox then
		currentHitbox = Instance.new("Part", workspace)
		currentHitbox.Size = Vector3.new(3, 3, 3)
		currentHitbox.Transparency = 1
		currentHitbox.CanCollide = false
		currentHitbox.Anchored = false
		currentHitbox.CFrame = part.CFrame
		currentHitbox.Massless = true

		currentHitbox.CFrame = part.CFrame
	end
end


function toggleScript(state)
	enabled = state
	
	if not enabled then
		-- Clean up the physics forces when toggled off
		if currentTarget then
			local force = currentTarget:FindFirstChildOfClass("BodyPosition")
			if force then force:Destroy() end
		end

		if currentHitbox then 
			currentHitbox:Destroy() 
			currentHitbox = nil 
		end

		currentTarget = nil
	end
end

Tab:CreateToggle({
	Name = "Activate Telekinesis",
	CurrentValue = false,
	Flag = "TelekinesisToggle",
	Callback = function(Value)
		toggleScript(Value)
	end,
})

-- ==================== [ SEAT FLIGHT CODE ] ====================

function toggleChairFlight(state)
	flightEnabled = state
	local character = LocalPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local hrp = character and character:FindFirstChild("HumanoidRootPart")

	if flightEnabled then
		if hrp and humanoid then
			-- Create a legitimate, unanchored VehicleSeat container
			currentFlightChair = Instance.new("VehicleSeat")
			currentFlightChair.Size = Vector3.new(3, 1, 3)
			currentFlightChair.Transparency = 0 -- Keep visible so you can see your seat!
			currentFlightChair.BrickColor = BrickColor.new("Bright red")
			currentFlightChair.CanCollide = true
			currentFlightChair.Anchored = false
			currentFlightChair.Massless = true
			currentFlightChair.CFrame = hrp.CFrame * CFrame.new(0, -1.5, 0) -- Place under your feet
			currentFlightChair.Parent = workspace

			-- Force your avatar onto the seat smoothly
			currentFlightChair:Sit(humanoid)

			-- Add Hover Position Physics Engine
			local flightForce = Instance.new("BodyPosition", currentFlightChair)
			flightForce.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			flightForce.P = 20000
			flightForce.D = 1500
			flightForce.Position = hrp.Position

			-- Add Orientation Balance Stabilizer (Stops the chair from flipping upsidedown)
			local gyroForce = Instance.new("BodyGyro", currentFlightChair)
			gyroForce.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
			gyroForce.P = 25000
			gyroForce.D = 500
			gyroForce.CFrame = hrp.CFrame
		end
	else
		-- Clean up flight components safely when toggled off
		if currentFlightChair then
			currentFlightChair:Destroy()
			currentFlightChair = nil
		end
		if humanoid then
			humanoid.Jump = true -- Make character hop off safely
		end
	end
end

ChairUI:CreateToggle({
	Name = "Spawn Seat",
	CurrentValue = false,
	Flag = "ChairFlightToggle",
	Callback = function(Value)
		toggleChairFlight(Value)
	end,
})

-- ==================== [ MAIN EXECUTION ENGINE PIPELINE ] ====================

RunService.Heartbeat:Connect(function()
	local character = LocalPlayer.Character
	local hrp = character and character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end 

	-- Part 1: Telekinesis Tracking Systems
	if enabled and not currentTarget then
		currentTarget = getPart()
		if currentTarget then
			setOwner(currentTarget)
			local force = Instance.new("BodyPosition", currentTarget)
			force.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			force.P = 40000
			force.D = 2500
			force.Position = Mouse.Hit.Position
		end
	end

	if enabled and currentTarget then
		local force = currentTarget:FindFirstChildOfClass("BodyPosition")
		if force then
			if Mouse.Target == nil then
				-- Sky Lock Border Protection
			else
				force.Position = Mouse.Hit.Position
			end
			if currentHitbox then
				currentHitbox.CFrame = currentTarget.CFrame
			end
		end
	end

	-- Part 2: Dynamic Chair Flight Handling Tracker
	if flightEnabled and currentFlightChair then
		local flightForce = currentFlightChair:FindFirstChildOfClass("BodyPosition")
		local gyroForce = currentFlightChair:FindFirstChildOfClass("BodyGyro")

		if flightForce and gyroForce then
			if Mouse.Target == nil then
				-- Do Nothing
			else
				-- Follow your finger tap or drag point cleanly through 3D space
				flightForce.Position = Mouse.Hit.Position + Vector3.new(0, 3, 0) -- Hover slightly off the hit floor

				-- Smoothly turn the chair to face the direction you are steering
				local camera = workspace.CurrentCamera
				gyroForce.CFrame = CFrame.new(currentFlightChair.Position, Vector3.new(Mouse.Hit.Position.X, currentFlightChair.Position.Y, Mouse.Hit.Position.Z))
			end
		end
	end
end)
