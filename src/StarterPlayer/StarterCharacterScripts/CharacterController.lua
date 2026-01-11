-- Character Controller Script
-- Handles character-specific functionality like damage, health, and animations

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Character stats
local MAX_HEALTH = 100
local currentHealth = MAX_HEALTH

-- Get remote events
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local combatEvent = remoteEvents:WaitForChild("CombatEvent")
local uiEvent = remoteEvents:WaitForChild("UIEvent")

-- Create health display
local function createHealthDisplay()
    local healthGui = Instance.new("BillboardGui")
    healthGui.Name = "HealthDisplay"
    healthGui.Size = UDim2.new(0, 100, 0, 20)
    healthGui.StudsOffset = Vector3.new(0, 3, 0)
    healthGui.Parent = character:WaitForChild("Head")
    
    local healthBar = Instance.new("Frame")
    healthBar.Name = "HealthBar"
    healthBar.Size = UDim2.new(1, 0, 1, 0)
    healthBar.BackgroundColor3 = Color3.new(0, 1, 0)
    healthBar.Parent = healthGui
    
    local healthBorder = Instance.new("UIStroke")
    healthBorder.Thickness = 2
    healthBorder.Color = Color3.new(0, 0, 0)
    healthBorder.Parent = healthBar
    
    return healthBar
end

-- Update health display
local healthBar = createHealthDisplay()

local function updateHealthDisplay()
    local healthPercentage = currentHealth / MAX_HEALTH
    healthBar.Size = UDim2.new(healthPercentage, 0, 1, 0)
    
    -- Change color based on health
    if healthPercentage > 0.6 then
        healthBar.BackgroundColor3 = Color3.new(0, 1, 0) -- Green
    elseif healthPercentage > 0.3 then
        healthBar.BackgroundColor3 = Color3.new(1, 1, 0) -- Yellow
    else
        healthBar.BackgroundColor3 = Color3.new(1, 0, 0) -- Red
    end
end

-- Handle damage
local function takeDamage(damage)
    currentHealth = math.max(0, currentHealth - damage)
    updateHealthDisplay()
    
    -- Flash effect
    humanoid.Health = currentHealth
    
    if currentHealth <= 0 then
        -- Character died
        combatEvent:FireServer("PlayerDied")
    end
    
    -- Update UI
    uiEvent:FireServer("UpdateHealth", currentHealth)
end

-- Handle healing
local function heal(amount)
    currentHealth = math.min(MAX_HEALTH, currentHealth + amount)
    updateHealthDisplay()
    humanoid.Health = currentHealth
    uiEvent:FireServer("UpdateHealth", currentHealth)
end

-- Combat animations
local function playCombatAnimation(animationType)
    local animator = humanoid:WaitForChild("Animator")
    
    if animationType == "punch" then
        -- Create punch animation
        local punchAnim = Instance.new("Animation")
        punchAnim.AnimationId = "rbxassetid://2514354904" -- Example punch animation
        local punchTrack = animator:LoadAnimation(punchAnim)
        punchTrack:Play()
        punchTrack.Ended:Connect(function()
            punchTrack:Stop()
        end)
        
    elseif animationType == "kick" then
        -- Create kick animation
        local kickAnim = Instance.new("Animation")
        kickAnim.AnimationId = "rbxassetid://2514356985" -- Example kick animation
        local kickTrack = animator:LoadAnimation(kickAnim)
        kickTrack:Play()
        kickTrack.Ended:Connect(function()
            kickTrack:Stop()
        end)
        
    elseif animationType == "capture" then
        -- Create capture animation
        local captureAnim = Instance.new("Animation")
        captureAnim.AnimationId = "rbxassetid://2514358236" -- Example capture animation
        local captureTrack = animator:LoadAnimation(captureAnim)
        captureTrack:Play()
        captureTrack.Ended:Connect(function()
            captureTrack:Stop()
        end)
    end
end

-- Connect to damage events
combatEvent.OnClientEvent:Connect(function(action, data)
    if action == "TakeDamage" then
        takeDamage(data.damage)
    elseif action == "Heal" then
        heal(data.amount)
    elseif action == "PlayAnimation" then
        playCombatAnimation(data.animationType)
    end
end)

-- Handle character death
humanoid.Died:Connect(function()
    -- Remove health display
    if healthBar and healthBar.Parent then
        healthBar.Parent:Destroy()
    end
    
    -- Notify server
    combatEvent:FireServer("PlayerDied")
end)

-- Handle respawn
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    currentHealth = MAX_HEALTH
    
    -- Recreate health display
    healthBar = createHealthDisplay()
    updateHealthDisplay()
end)

-- Initialize
updateHealthDisplay()
print("Character controller initialized for", player.Name)
