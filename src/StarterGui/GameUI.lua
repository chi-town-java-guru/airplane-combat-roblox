-- Game UI Script
-- Creates the user interface for the airplane combat game

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create main screen GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GameUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = true

-- Create health bar
local healthFrame = Instance.new("Frame")
healthFrame.Name = "HealthFrame"
healthFrame.Size = UDim2.new(0, 200, 0, 20)
healthFrame.Position = UDim2.new(0, 10, 0, 10)
healthFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
healthFrame.BorderSizePixel = 2
healthFrame.BorderColor3 = Color3.new(1, 1, 1)
healthFrame.Parent = screenGui

local healthBar = Instance.new("Frame")
healthBar.Name = "HealthBar"
healthBar.Size = UDim2.new(1, 0, 1, 0)
healthBar.Position = UDim2.new(0, 0, 0, 0)
healthBar.BackgroundColor3 = Color3.new(0, 1, 0)
healthBar.BorderSizePixel = 0
healthBar.Parent = healthFrame

local healthText = Instance.new("TextLabel")
healthText.Name = "HealthText"
healthText.Size = UDim2.new(1, 0, 1, 0)
healthText.Position = UDim2.new(0, 0, 0, 0)
healthText.BackgroundTransparency = 1
healthText.Text = "100/100"
healthText.TextColor3 = Color3.new(1, 1, 1)
healthText.TextScaled = true
healthText.Font = Enum.Font.SourceSansBold
healthText.Parent = healthFrame

-- Create controls help
local controlsFrame = Instance.new("Frame")
controlsFrame.Name = "ControlsFrame"
controlsFrame.Size = UDim2.new(0, 250, 0, 150)
controlsFrame.Position = UDim2.new(1, -260, 0, 10)
controlsFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
controlsFrame.BorderSizePixel = 2
controlsFrame.BorderColor3 = Color3.new(1, 1, 1)
controlsFrame.Parent = screenGui

local controlsTitle = Instance.new("TextLabel")
controlsTitle.Name = "ControlsTitle"
controlsTitle.Size = UDim2.new(1, 0, 0, 30)
controlsTitle.Position = UDim2.new(0, 0, 0, 0)
controlsTitle.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
controlsTitle.BorderSizePixel = 0
controlsTitle.Text = "COMBAT CONTROLS"
controlsTitle.TextColor3 = Color3.new(1, 1, 1)
controlsTitle.TextScaled = true
controlsTitle.Font = Enum.Font.SourceSansBold
controlsTitle.Parent = controlsFrame

local controlsText = Instance.new("TextLabel")
controlsText.Name = "ControlsText"
controlsText.Size = UDim2.new(1, -10, 1, -40)
controlsText.Position = UDim2.new(0, 5, 0, 35)
controlsText.BackgroundTransparency = 1
controlsText.Text = "F - Punch (10 damage)\nG - Kick (15 damage)\nH - Capture (3 seconds)\n\nKick enemies near emergency exit to kick them out!"
controlsText.TextColor3 = Color3.new(1, 1, 1)
controlsText.TextScaled = true
controlsText.Font = Enum.Font.SourceSans
controlsText.TextXAlignment = Enum.TextXAlignment.Left
controlsText.TextYAlignment = Enum.TextYAlignment.Top
controlsText.Parent = controlsFrame

-- Create objective display
local objectiveFrame = Instance.new("Frame")
objectiveFrame.Name = "ObjectiveFrame"
objectiveFrame.Size = UDim2.new(0, 300, 0, 80)
objectiveFrame.Position = UDim2.new(0.5, -150, 0, 10)
objectiveFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
objectiveFrame.BorderSizePixel = 2
objectiveFrame.BorderColor3 = Color3.new(1, 0.5, 0)
objectiveFrame.Parent = screenGui

local objectiveTitle = Instance.new("TextLabel")
objectiveTitle.Name = "ObjectiveTitle"
objectiveTitle.Size = UDim2.new(1, 0, 0, 25)
objectiveTitle.Position = UDim2.new(0, 0, 0, 0)
objectiveTitle.BackgroundColor3 = Color3.new(0.2, 0.1, 0)
objectiveTitle.BorderSizePixel = 0
objectiveTitle.Text = "OBJECTIVE"
objectiveTitle.TextColor3 = Color3.new(1, 0.8, 0)
objectiveTitle.TextScaled = true
objectiveTitle.Font = Enum.Font.SourceSansBold
objectiveTitle.Parent = objectiveFrame

local objectiveText = Instance.new("TextLabel")
objectiveText.Name = "ObjectiveText"
objectiveText.Size = UDim2.new(1, -10, 1, -30)
objectiveText.Position = UDim2.new(0, 5, 0, 25)
objectiveText.BackgroundTransparency = 1
objectiveText.Text = "Neutralize all threats inside the airplane!\n• Kill enemies with combat\n• Kick them out the emergency exit\n• Capture and restrain them"
objectiveText.TextColor3 = Color3.new(1, 1, 1)
objectiveText.TextScaled = true
objectiveText.Font = Enum.Font.SourceSans
objectiveText.TextXAlignment = Enum.TextXAlignment.Center
objectiveText.TextYAlignment = Enum.TextYAlignment.Top
objectiveText.Parent = objectiveFrame

-- Create combat cooldown indicator
local cooldownFrame = Instance.new("Frame")
cooldownFrame.Name = "CooldownFrame"
cooldownFrame.Size = UDim2.new(0, 150, 0, 30)
cooldownFrame.Position = UDim2.new(0.5, -75, 1, -40)
cooldownFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
cooldownFrame.BorderSizePixel = 2
cooldownFrame.BorderColor3 = Color3.new(1, 1, 1)
cooldownFrame.Visible = false
cooldownFrame.Parent = screenGui

local cooldownBar = Instance.new("Frame")
cooldownBar.Name = "CooldownBar"
cooldownBar.Size = UDim2.new(0, 0, 1, 0)
cooldownBar.Position = UDim2.new(0, 0, 0, 0)
cooldownBar.BackgroundColor3 = Color3.new(1, 0.5, 0)
cooldownBar.BorderSizePixel = 0
cooldownBar.Parent = cooldownFrame

local cooldownText = Instance.new("TextLabel")
cooldownText.Name = "CooldownText"
cooldownText.Size = UDim2.new(1, 0, 1, 0)
cooldownText.Position = UDim2.new(0, 0, 0, 0)
cooldownText.BackgroundTransparency = 1
cooldownText.Text = "COMBAT COOLDOWN"
cooldownText.TextColor3 = Color3.new(1, 1, 1)
cooldownText.TextScaled = true
cooldownText.Font = Enum.Font.SourceSansBold
cooldownText.Parent = cooldownFrame

-- Create game status display
local statusFrame = Instance.new("Frame")
statusFrame.Name = "StatusFrame"
statusFrame.Size = UDim2.new(0, 200, 0, 60)
statusFrame.Position = UDim2.new(0.5, -100, 0.5, -30)
statusFrame.BackgroundColor3 = Color3.new(0, 0, 0)
statusFrame.BorderSizePixel = 3
statusFrame.BorderColor3 = Color3.new(1, 0, 0)
statusFrame.Visible = false
statusFrame.Parent = screenGui

local statusText = Instance.new("TextLabel")
statusText.Name = "StatusText"
statusText.Size = UDim2.new(1, -10, 1, -10)
statusText.Position = UDim2.new(0, 5, 0, 5)
statusText.BackgroundTransparency = 1
statusText.Text = "GAME OVER"
statusText.TextColor3 = Color3.new(1, 1, 1)
statusText.TextScaled = true
statusText.Font = Enum.Font.SourceSansBold
statusText.Parent = statusFrame

-- Update health display
local function updateHealth()
    local character = player.Character
    if character and character:FindFirstChild("Humanoid") then
        local humanoid = character.Humanoid
        local health = math.max(0, humanoid.Health)
        local maxHealth = humanoid.MaxHealth
        
        healthText.Text = math.floor(health) .. "/" .. maxHealth
        
        -- Update health bar color based on health percentage
        local healthPercentage = health / maxHealth
        if healthPercentage > 0.6 then
            healthBar.BackgroundColor3 = Color3.new(0, 1, 0) -- Green
        elseif healthPercentage > 0.3 then
            healthBar.BackgroundColor3 = Color3.new(1, 1, 0) -- Yellow
        else
            healthBar.BackgroundColor3 = Color3.new(1, 0, 0) -- Red
        end
        
        healthBar.Size = UDim2.new(healthPercentage, 0, 1, 0)
    end
end

-- Show cooldown
local function showCooldown(duration)
    cooldownFrame.Visible = true
    cooldownBar.Size = UDim2.new(1, 0, 1, 0)
    
    local startTime = tick()
    local connection
    
    connection = game:GetService("RunService").Heartbeat:Connect(function()
        local elapsed = tick() - startTime
        local remaining = math.max(0, duration - elapsed)
        local progress = remaining / duration
        
        cooldownBar.Size = UDim2.new(progress, 0, 1, 0)
        
        if remaining <= 0 then
            cooldownFrame.Visible = false
            connection:Disconnect()
        end
    end)
end

-- Show game status
local function showGameStatus(message, color)
    statusText.Text = message
    statusFrame.BorderColor3 = color or Color3.new(1, 0, 0)
    statusFrame.Visible = true
    
    wait(3)
    statusFrame.Visible = false
end

-- Connect to character events
player.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.HealthChanged:Connect(updateHealth)
    updateHealth()
end)

-- Update health every frame
game:GetService("RunService").Heartbeat:Connect(updateHealth)

-- Expose functions to other scripts
_G.GameUI = {
    showCooldown = showCooldown,
    showGameStatus = showGameStatus
}

print("Game UI initialized!")
