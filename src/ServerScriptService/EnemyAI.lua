-- Enemy AI Script
-- Controls the behavior of bad people (enemies) in the airplane

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local PathfindingService = game:GetService("PathfindingService")

-- AI settings
local AGGRO_RANGE = 20
local ATTACK_RANGE = 8
local PATROL_SPEED = 8
local CHASE_SPEED = 16
local ATTACK_COOLDOWN = 2

-- Enemy behaviors
local enemies = {}
local pathfinder = PathfindingService:CreatePath({
    AgentRadius = 2,
    AgentHeight = 5,
    AgentCanJump = false
})

-- Create enemy characters
local function createEnemy(position)
    local enemy = Instance.new("Model")
    enemy.Name = "Enemy"
    enemy.Parent = Workspace
    
    -- Create enemy body
    local humanoid = Instance.new("Humanoid")
    humanoid.Health = 100
    humanoid.MaxHealth = 100
    humanoid.WalkSpeed = PATROL_SPEED
    humanoid.Parent = enemy
    
    -- Create enemy parts
    local rootPart = Instance.new("Part")
    rootPart.Name = "HumanoidRootPart"
    rootPart.Size = Vector3.new(2, 2, 1)
    rootPart.Position = position
    rootPart.Anchored = false
    rootPart.Parent = enemy
    
    local torso = Instance.new("Part")
    torso.Name = "Torso"
    torso.Size = Vector3.new(2, 2, 1)
    torso.Position = position + Vector3.new(0, 0, 0)
    torso.BrickColor = BrickColor.new("Bright red")
    torso.Material = Enum.Material.Plastic
    torso.Parent = enemy
    
    local head = Instance.new("Part")
    head.Name = "Head"
    head.Size = Vector3.new(2, 1, 1)
    head.Position = position + Vector3.new(0, 1.5, 0)
    head.BrickColor = BrickColor.new("Bright orange")
    head.Material = Enum.Material.Plastic
    head.Parent = enemy
    
    -- Weld parts together
    local weld = Instance.new("Weld")
    weld.Part0 = rootPart
    weld.Part1 = torso
    weld.C0 = CFrame.new(0, 0, 0)
    weld.Parent = rootPart
    
    local headWeld = Instance.new("Weld")
    headWeld.Part0 = torso
    headWeld.Part1 = head
    headWeld.C0 = CFrame.new(0, 1.5, 0)
    headWeld.Parent = torso
    
    -- Add enemy behavior data
    local enemyData = {
        model = enemy,
        humanoid = humanoid,
        target = nil,
        state = "patrol", -- patrol, chase, attack
        lastAttack = 0,
        patrolPoints = {},
        currentPatrolIndex = 1,
        position = position
    }
    
    -- Generate patrol points inside airplane
    local airplane = Workspace:FindFirstChild("Airplane")
    if airplane then
        for i = 1, 4 do
            local patrolPoint = Vector3.new(
                math.random(-20, 20),
                6.5,
                math.random(-2, 2)
            )
            table.insert(enemyData.patrolPoints, patrolPoint)
        end
    end
    
    table.insert(enemies, enemyData)
    return enemyData
end

-- Find nearest player to enemy
local function findNearestPlayer(enemyPosition)
    local nearestPlayer = nil
    local nearestDistance = AGGRO_RANGE
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (enemyPosition - player.Character.HumanoidRootPart.Position).Magnitude
            if distance < nearestDistance then
                nearestDistance = distance
                nearestPlayer = player
            end
        end
    end
    
    return nearestPlayer, nearestDistance
end

-- Move enemy towards target
local function moveTowardsTarget(enemyData, targetPosition)
    local humanoid = enemyData.humanoid
    local rootPart = enemyData.model.HumanoidRootPart
    
    -- Calculate direction
    local direction = (targetPosition - rootPart.Position).Unit
    local distance = (targetPosition - rootPart.Position).Magnitude
    
    -- Move towards target
    if distance > 2 then
        humanoid:Move(direction)
    else
        humanoid:Move(Vector3.new(0, 0, 0))
    end
end

-- Attack player
local function attackPlayer(enemyData, player)
    local currentTime = tick()
    if currentTime - enemyData.lastAttack < ATTACK_COOLDOWN then return end
    
    local character = player.Character
    if not character or not character:FindFirstChild("Humanoid") then return end
    
    local humanoid = character.Humanoid
    humanoid:TakeDamage(15)
    
    enemyData.lastAttack = currentTime
    
    -- Visual effect
    local attackEffect = Instance.new("Part")
    attackEffect.Size = Vector3.new(3, 3, 3)
    attackEffect.Position = character.HumanoidRootPart.Position
    attackEffect.BrickColor = BrickColor.new("Bright red")
    attackEffect.Material = Enum.Material.Neon
    attackEffect.Anchored = true
    attackEffect.CanCollide = false
    attackEffect.Parent = Workspace
    game:GetService("Debris"):AddItem(attackEffect, 0.5)
    
    print("Enemy attacked " .. player.Name)
end

-- Update enemy AI
local function updateEnemy(enemyData)
    local enemyPosition = enemyData.model.HumanoidRootPart.Position
    local nearestPlayer, distance = findNearestPlayer(enemyPosition)
    
    -- State machine
    if enemyData.state == "patrol" then
        enemyData.humanoid.WalkSpeed = PATROL_SPEED
        
        if nearestPlayer then
            enemyData.state = "chase"
            enemyData.target = nearestPlayer
        else
            -- Patrol behavior
            if #enemyData.patrolPoints > 0 then
                local currentPatrolPoint = enemyData.patrolPoints[enemyData.currentPatrolIndex]
                moveTowardsTarget(enemyData, currentPatrolPoint)
                
                -- Check if reached patrol point
                if (enemyPosition - currentPatrolPoint).Magnitude < 3 then
                    enemyData.currentPatrolIndex = (enemyData.currentPatrolIndex % #enemyData.patrolPoints) + 1
                end
            end
        end
        
    elseif enemyData.state == "chase" then
        enemyData.humanoid.WalkSpeed = CHASE_SPEED
        
        if not nearestPlayer or distance > AGGRO_RANGE * 1.5 then
            enemyData.state = "patrol"
            enemyData.target = nil
        else
            enemyData.target = nearestPlayer
            moveTowardsTarget(enemyData, nearestPlayer.Character.HumanoidRootPart.Position)
            
            -- Check if in attack range
            if distance < ATTACK_RANGE then
                enemyData.state = "attack"
            end
        end
        
    elseif enemyData.state == "attack" then
        enemyData.humanoid.WalkSpeed = PATROL_SPEED
        
        if not nearestPlayer or distance > ATTACK_RANGE * 1.5 then
            enemyData.state = "chase"
        else
            -- Attack the player
            attackPlayer(enemyData, nearestPlayer)
            
            -- Face the player
            local lookAt = CFrame.new(enemyPosition, nearestPlayer.Character.HumanoidRootPart.Position)
            enemyData.model.HumanoidRootPart.CFrame = lookAt
        end
    end
end

-- Initialize enemies
local function initializeEnemies()
    local airplane = Workspace:FindFirstChild("Airplane")
    if not airplane then return end
    
    -- Create 4 enemies at different positions
    local spawnPositions = {
        Vector3.new(15, 6.5, 1.5),
        Vector3.new(-15, 6.5, -1.5),
        Vector3.new(0, 6.5, 1.5),
        Vector3.new(10, 6.5, -1.5)
    }
    
    for _, position in ipairs(spawnPositions) do
        createEnemy(position)
    end
    
    print("Created " .. #enemies .. " enemies")
end

-- Main AI update loop with performance optimization
local lastUpdateTime = 0
local UPDATE_INTERVAL = 0.1 -- Update every 100ms instead of every frame

RunService.Heartbeat:Connect(function(deltaTime)
    local currentTime = tick()
    
    -- Throttle updates for performance
    if currentTime - lastUpdateTime < UPDATE_INTERVAL then
        return
    end
    lastUpdateTime = currentTime
    
    -- Update enemies with error handling
    for i = #enemies, 1, -1 do
        local enemyData = enemies[i]
        if enemyData and enemyData.model and enemyData.model.Parent and enemyData.humanoid and enemyData.humanoid.Health > 0 then
            local success, errorMsg = pcall(function()
                updateEnemy(enemyData)
            end)
            
            if not success then
                warn("Error updating enemy AI: " .. tostring(errorMsg))
                -- Remove problematic enemy
                if enemyData.model then
                    enemyData.model:Destroy()
                end
                table.remove(enemies, i)
            end
        else
            -- Clean up dead/destroyed enemies
            table.remove(enemies, i)
        end
    end
end)

-- Initialize when game starts
initializeEnemies()

print("Enemy AI system initialized!")
