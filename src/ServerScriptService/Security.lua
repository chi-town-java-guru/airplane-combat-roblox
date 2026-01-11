-- Anti-Exploit Security System
-- Prevents common exploits and validates player actions

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- Security settings
local MAX_WALK_SPEED = 50
local MAX_JUMP_POWER = 100
local MAX_HEALTH = 1000
local TELEPORT_THRESHOLD = 50
local DAMAGE_COOLDOWN = 0.5

-- Player validation data
local playerData = {}
local lastDamageTime = {}

-- Security functions
local Security = {}

function Security:validatePlayer(player)
    if not player or not player.Character then return false end
    
    local character = player.Character
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return false end
    
    -- Check for valid stats
    if humanoid.WalkSpeed > MAX_WALK_SPEED then
        humanoid.WalkSpeed = 16
        self:logExploit(player, "Invalid WalkSpeed")
        return false
    end
    
    if humanoid.JumpPower > MAX_JUMP_POWER then
        humanoid.JumpPower = 50
        self:logExploit(player, "Invalid JumpPower")
        return false
    end
    
    if humanoid.MaxHealth > MAX_HEALTH then
        humanoid.MaxHealth = 100
        humanoid.Health = math.min(humanoid.Health, 100)
        self:logExploit(player, "Invalid MaxHealth")
        return false
    end
    
    return true
end

function Security:validateDamage(player, target, damage)
    if not self:validatePlayer(player) then return false end
    if not target or not target.Character then return false end
    
    local currentTime = tick()
    local lastDamage = lastDamageTime[player.UserId] or 0
    
    -- Check damage cooldown
    if currentTime - lastDamage < DAMAGE_COOLDOWN then
        self:logExploit(player, "Damage spam detected")
        return false
    end
    
    -- Validate damage amount
    if damage > 100 or damage < 0 then
        self:logExploit(player, "Invalid damage amount: " .. damage)
        return false
    end
    
    -- Check distance between players
    local playerPos = player.Character.PrimaryPart.Position
    local targetPos = target.Character.PrimaryPart.Position
    local distance = (playerPos - targetPos).Magnitude
    
    if distance > 20 then
        self:logExploit(player, "Long range damage: " .. distance)
        return false
    end
    
    lastDamageTime[player.UserId] = currentTime
    return true
end

function Security:validatePosition(player)
    if not player or not player.Character then return false end
    
    local character = player.Character
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end
    
    local currentPos = rootPart.Position
    local lastPos = playerData[player.UserId] and playerData[player.UserId].lastPos or currentPos
    
    -- Check for teleportation
    local distance = (currentPos - lastPos).Magnitude
    if distance > TELEPORT_THRESHOLD then
        self:logExploit(player, "Teleportation detected: " .. distance)
        rootPart.Position = lastPos
        return false
    end
    
    playerData[player.UserId] = {
        lastPos = currentPos,
        lastCheck = tick()
    }
    
    return true
end

function Security:logExploit(player, reason)
    warn("EXPLOIT DETECTED - Player: " .. player.Name .. " - Reason: " .. reason)
    
    -- Log to server analytics
    if game:GetService("HttpService") then
        -- Could send to external logging service
    end
    
    -- Kick for severe exploits
    if string.find(reason, "Teleportation") or string.find(reason, "Invalid") then
        player:Kick("Exploit detected: " .. reason)
    end
end

-- Initialize security monitoring
local function initializeSecurity()
    -- Monitor player movements
    RunService.Heartbeat:Connect(function()
        for _, player in ipairs(Players:GetPlayers()) do
            Security:validatePosition(player)
        end
    end)
    
    -- Monitor player stats
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            local humanoid = character:WaitForChild("Humanoid")
            
            -- Monitor stat changes
            humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                Security:validatePlayer(player)
            end)
            
            humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
                Security:validatePlayer(player)
            end)
            
            humanoid:GetPropertyChangedSignal("MaxHealth"):Connect(function()
                Security:validatePlayer(player)
            end)
        end)
    end)
    
    print("Anti-exploit security system initialized")
end

initializeSecurity()

-- Export security functions
_G.Security = Security
