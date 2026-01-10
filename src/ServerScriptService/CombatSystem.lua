-- Combat System Server Script
-- Handles combat logic, damage, and game state

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")

-- Combat settings
local PUNCH_DAMAGE = 10
local KICK_DAMAGE = 15
local KICK_OUT_FORCE = 100
local CAPTURE_DURATION = 3

-- Game state
local gameActive = true
local capturedPlayers = {}
local eliminatedPlayers = {}

-- Get combat remote event
local combatEvent = ReplicatedStorage:WaitForChild("CombatEvent")

-- Function to apply damage to player
local function applyDamage(player, damage)
    local character = player.Character
    if not character or not character:FindFirstChild("Humanoid") then return end
    
    local humanoid = character.Humanoid
    humanoid:TakeDamage(damage)
    
    -- Check if player is eliminated
    if humanoid.Health <= 0 then
        eliminatedPlayers[player.UserId] = true
        checkWinCondition()
    end
end

-- Function to kick player out of plane
local function kickOutPlane(player)
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local humanoidRootPart = character.HumanoidRootPart
    
    -- Apply force to kick out
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.new(0, -50, -KICK_OUT_FORCE)
    bodyVelocity.Parent = humanoidRootPart
    
    -- Remove velocity after 2 seconds
    Debris:AddItem(bodyVelocity, 2)
    
    -- Mark as eliminated
    eliminatedPlayers[player.UserId] = true
    checkWinCondition()
    
    -- Visual effect
    local kickEffect = Instance.new("Explosion")
    kickEffect.Position = humanoidRootPart.Position
    kickEffect.BlastRadius = 5
    kickEffect.BlastPressure = 0
    kickEffect.Parent = Workspace
    
    print(player.Name .. " was kicked out of the plane!")
end

-- Function to capture player
local function capturePlayer(capturer, target)
    local targetCharacter = target.Character
    if not targetCharacter or not targetCharacter:FindFirstChild("Humanoid") then return end
    
    local humanoid = targetCharacter.Humanoid
    
    -- Restrict movement
    humanoid.WalkSpeed = 0
    humanoid.JumpPower = 0
    humanoid.AutoRotate = false
    
    -- Create capture constraint
    local constraint = Instance.new("BodyPosition")
    constraint.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    constraint.Position = capturer.Character.HumanoidRootPart.Position + capturer.Character.HumanoidRootPart.CFrame.LookVector * 3
    constraint.Parent = targetCharacter.HumanoidRootPart
    
    capturedPlayers[target.UserId] = {
        capturer = capturer,
        constraint = constraint,
        originalWalkSpeed = humanoid.WalkSpeed,
        originalJumpPower = humanoid.JumpPower
    }
    
    print(target.Name .. " was captured by " .. capturer.Name)
end

-- Function to release captured player
local function releaseCapture(target)
    local captureData = capturedPlayers[target.UserId]
    if not captureData then return end
    
    local targetCharacter = target.Character
    if not targetCharacter or not targetCharacter:FindFirstChild("Humanoid") then return end
    
    local humanoid = targetCharacter.Humanoid
    
    -- Restore movement
    humanoid.WalkSpeed = captureData.originalWalkSpeed
    humanoid.JumpPower = captureData.originalJumpPower
    humanoid.AutoRotate = true
    
    -- Remove constraint
    if captureData.constraint then
        captureData.constraint:Destroy()
    end
    
    capturedPlayers[target.UserId] = nil
    print(target.Name .. " was released from capture")
end

-- Function to check win condition
local function checkWinCondition()
    local activePlayers = {}
    local totalPlayers = 0
    
    for _, player in ipairs(Players:GetPlayers()) do
        if not eliminatedPlayers[player.UserId] then
            table.insert(activePlayers, player)
            totalPlayers = totalPlayers + 1
        end
    end
    
    -- Check if only good players remain (simplified win condition)
    if totalPlayers > 0 and #activePlayers <= 2 then
        gameActive = false
        for _, player in ipairs(activePlayers) do
            -- Announce winner
            local message = Instance.new("Message")
            message.Text = player.Name .. " wins! All threats neutralized!"
            message.Parent = Workspace
            Debris:AddItem(message, 5)
        end
    end
end

-- Handle combat events
combatEvent.OnServerEvent:Connect(function(player, action, target)
    if not gameActive then return end
    
    if action == "punch" then
        if target and target:FindFirstChild("Humanoid") then
            local targetPlayer = Players:GetPlayerFromCharacter(target)
            if targetPlayer then
                applyDamage(targetPlayer, PUNCH_DAMAGE)
                
                -- Visual effect
                local hitEffect = Instance.new("Part")
                hitEffect.Size = Vector3.new(1, 1, 1)
                hitEffect.Position = target.HumanoidRootPart.Position
                hitEffect.BrickColor = BrickColor.new("Bright red")
                hitEffect.Material = Enum.Material.Neon
                hitEffect.Anchored = true
                hitEffect.CanCollide = false
                hitEffect.Parent = Workspace
                Debris:AddItem(hitEffect, 0.2)
            end
        end
        
    elseif action == "kick" then
        if target and target:FindFirstChild("Humanoid") then
            local targetPlayer = Players:GetPlayerFromCharacter(target)
            if targetPlayer then
                applyDamage(targetPlayer, KICK_DAMAGE)
                
                -- Visual effect
                local hitEffect = Instance.new("Part")
                hitEffect.Size = Vector3.new(2, 2, 2)
                hitEffect.Position = target.HumanoidRootPart.Position
                hitEffect.BrickColor = BrickColor.new("Bright orange")
                hitEffect.Material = Enum.Material.Neon
                hitEffect.Anchored = true
                hitEffect.CanCollide = false
                hitEffect.Parent = Workspace
                Debris:AddItem(hitEffect, 0.3)
            end
        end
        
    elseif action == "kickOut" then
        if target and target:FindFirstChild("Humanoid") then
            local targetPlayer = Players:GetPlayerFromCharacter(target)
            if targetPlayer then
                kickOutPlane(targetPlayer)
            end
        end
        
    elseif action == "capture" then
        if target and target:FindFirstChild("Humanoid") then
            local targetPlayer = Players:GetPlayerFromCharacter(target)
            if targetPlayer then
                capturePlayer(player, targetPlayer)
            end
        end
        
    elseif action == "releaseCapture" then
        if target and target:FindFirstChild("Humanoid") then
            local targetPlayer = Players:GetPlayerFromCharacter(target)
            if targetPlayer then
                releaseCapture(targetPlayer)
            end
        end
    end
end)

-- Handle player joining
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        -- Give player starting loadout
        local tool = Instance.new("Tool")
        tool.Name = "Combat Tool"
        tool.Parent = player.Backpack
        
        -- Add tool grip
        local handle = Instance.new("Part")
        handle.Name = "Handle"
        handle.Size = Vector3.new(1, 1, 1)
        handle.BrickColor = BrickColor.new("Dark grey")
        handle.Material = Enum.Material.Metal
        handle.Parent = tool
    end)
end)

-- Handle player leaving
Players.PlayerRemoving:Connect(function(player)
    eliminatedPlayers[player.UserId] = true
    if capturedPlayers[player.UserId] then
        releaseCapture(player)
    end
    checkWinCondition()
end)

print("Combat system initialized!")
