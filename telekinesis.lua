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
local FlightTab = Window:CreateTab("Seat", 4483362458)

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

-- ==================== [ MATRIX HOVER FLY ENGINE ] ====================

function toggleMatrixFly(state)
    flightEnabled = state
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    
    if flightEnabled then
        if hrp and humanoid then
            -- Create Hover Physics DIRECTLY inside your character core [INDEX]
            flightForce = Instance.new("BodyPosition", hrp)
            flightForce.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            flightForce.P = 15000
            flightForce.D = 1000
            flightForce.Position = hrp.Position
            
            -- Keep player straight and stable while flying
            flightGyro = Instance.new("BodyGyro", hrp)
            flightGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            flightGyro.P = 20000
            flightGyro.D = 500
            flightGyro.CFrame = hrp.CFrame
        end
    else
        -- Clean up body forces from your character completely
        if flightForce then flightForce:Destroy() flightForce = nil end
        if flightGyro then flightGyro:Destroy() flightGyro = nil end
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) -- Reset animation [INDEX]
        end
    end
end

FlightTab:CreateToggle({
   Name = "Activate Matrix Fly",
   CurrentValue = false,
   Flag = "MatrixFlyToggle",
   Callback = function(Value)
       toggleMatrixFly(Value)
   end,
})

-- ==================== [ MAIN EXECUTION LOOP ] ====================

RunService.Heartbeat:Connect(function()
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid then return end 

    -- Part 1: Telekinesis Tracking Engine
	if telekinesisEnabled and not currentTarget then
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
	
	if telekinesisEnabled and currentTarget then
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

    -- Part 2: Matrix Flight Control System
    if flightEnabled and flightForce and flightGyro then
        -- TRICK THE ENGINE: Forcefully lock your local character animation state into Seated [INDEX, INDEX]
        -- This forces your character to stay in a sitting position while flying around!
        humanoid:ChangeState(Enum.HumanoidStateType.Seated) 
        
        local camera = workspace.CurrentCamera
        
        if Mouse.Target == nil then
            --don't fly
          flightGyroro.CFrame = CFrame.new(hrp.Position, hrp.Position camerara.CFrame.LookVector)
        else
            -- Follow your dragging finger acrosthehe landscaplayoutucleanlyly
            flightForce.Position = Mouse.Hit.Position - camera.CFrame.LookVector --Floatat 4 studs above the floor
            
            -- Turn your body to look directly awhereryouoarerdraggingng
            flightGyro.CFrame = CFrame.new(hrp.Position, Vector3.new(Mouse.Hit.Position.X, hrp.Position.Y, Mouse.Hit.Position.Z))
        end
    end
end)
