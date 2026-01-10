-- Player Controller Script
-- Handles player movement and interactions inside the airplane

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Movement settings
local WALK_SPEED = 16
local JUMP_POWER = 15
local INSIDE_PLANE_SPEED = 12

-- Combat settings
local PUNCH_RANGE = 5
local PUNCH_DAMAGE = 10
local KICK_RANGE = 6
local KICK_DAMAGE = 15
local CAPTURE_RANGE = 8

-- State variables
local isCapturing = false
local capturedEnemy = nil
local combatCooldown = 0

-- Initialize player settings
humanoid.WalkSpeed = INSIDE_PLANE_SPEED
humanoid.JumpPower = JUMP_POWER

-- Create remote events for combat
local combatEvent = Instance.new("RemoteEvent")
combatEvent.Name = "CombatEvent"
combatEvent.Parent = ReplicatedStorage

-- Function to find nearest enemy
local function findNearestEnemy(range)
    local nearestEnemy = nil
    local nearestDistance = range
    
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("Humanoid") then
            local distance = (character.HumanoidRootPart.Position - otherPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance < nearestDistance then
                nearestDistance = distance
                nearestEnemy = otherPlayer.Character
            end
        end
    end
    
    return nearestEnemy, nearestDistance
end

-- Punch function
local function punch()
    if combatCooldown > 0 then return end
    
    local enemy, distance = findNearestEnemy(PUNCH_RANGE)
    if enemy then
        combatEvent:FireServer("punch", enemy)
        combatCooldown = 0.5
        
        -- Visual feedback
        local punchEffect = Instance.new("Part")
        punchEffect.Size = Vector3.new(1, 1, 1)
        punchEffect.Position = character.HumanoidRootPart.Position + character.HumanoidRootPart.CFrame.LookVector * 2
        punchEffect.BrickColor = BrickColor.new("Bright yellow")
        punchEffect.Material = Enum.Material.Neon
        punchEffect.Anchored = true
        punchEffect.CanCollide = false
        punchEffect.Parent = workspace
        
        game:GetService("Debris"):AddItem(punchEffect, 0.2)
    end
end

-- Kick function
local function kick()
    if combatCooldown > 0 then return end
    
    local enemy, distance = findNearestEnemy(KICK_RANGE)
    if enemy then
        combatEvent:FireServer("kick", enemy)
        combatCooldown = 0.8
        
        -- Check if enemy is near emergency exit for kick out
        local emergencyExit = workspace:FindFirstChild("Airplane"):FindFirstChild("EmergencyExit")
        if emergencyExit then
            local exitDistance = (enemy.HumanoidRootPart.Position - emergencyExit.Position).Magnitude
            if exitDistance < 10 then
                combatEvent:FireServer("kickOut", enemy)
            end
        end
        
        -- Visual feedback
        local kickEffect = Instance.new("Part")
        kickEffect.Size = Vector3.new(2, 2, 2)
        kickEffect.Position = character.HumanoidRootPart.Position + character.HumanoidRootPart.CFrame.LookVector * 3
        kickEffect.BrickColor = BrickColor.new("Bright orange")
        kickEffect.Material = Enum.Material.Neon
        kickEffect.Anchored = true
        kickEffect.CanCollide = false
        kickEffect.Parent = workspace
        
        game:GetService("Debris"):AddItem(kickEffect, 0.3)
    end
end

-- Capture function
local function capture()
    if isCapturing or combatCooldown > 0 then return end
    
    local enemy, distance = findNearestEnemy(CAPTURE_RANGE)
    if enemy then
        isCapturing = true
        capturedEnemy = enemy
        combatEvent:FireServer("capture", enemy)
        combatCooldown = 1.0
        
        -- Visual feedback
        local captureEffect = Instance.new("Part")
        captureEffect.Size = Vector3.new(4, 4, 4)
        captureEffect.Position = enemy.HumanoidRootPart.Position
        captureEffect.BrickColor = BrickColor.new("Bright blue")
        captureEffect.Material = Enum.Material.Neon
        captureEffect.Transparency = 0.5
        captureEffect.Anchored = true
        captureEffect.CanCollide = false
        captureEffect.Parent = workspace
        
        game:GetService("Debris"):AddItem(captureEffect, 2.0)
        
        -- Release capture after 3 seconds
        wait(3)
        isCapturing = false
        capturedEnemy = nil
        combatEvent:FireServer("releaseCapture", enemy)
    end
end

-- Input handling
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        punch()
    elseif input.KeyCode == Enum.KeyCode.G then
        kick()
    elseif input.KeyCode == Enum.KeyCode.H then
        capture()
    end
end)

-- Update combat cooldown
RunService.Heartbeat:Connect(function(deltaTime)
    if combatCooldown > 0 then
        combatCooldown = combatCooldown - deltaTime
    end
end)

-- Handle character respawn
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = INSIDE_PLANE_SPEED
    humanoid.JumpPower = JUMP_POWER
end)

print("Player controller initialized!")
