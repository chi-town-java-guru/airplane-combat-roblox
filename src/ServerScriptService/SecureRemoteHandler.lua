-- Secure Remote Event Handler
-- Validates all remote event communications

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Get security module
local Security = require(script.Parent.Security)

-- Rate limiting
local rateLimits = {}
local RATE_LIMIT = 10 -- requests per second
local RATE_WINDOW = 1 -- seconds

local function checkRateLimit(player)
    local userId = player.UserId
    local currentTime = tick()
    
    if not rateLimits[userId] then
        rateLimits[userId] = {}
    end
    
    -- Clean old requests
    local requests = rateLimits[userId]
    for i = #requests, 1, -1 do
        if currentTime - requests[i] > RATE_WINDOW then
            table.remove(requests, i)
        end
    end
    
    -- Check if over limit
    if #requests >= RATE_LIMIT then
        Security:logExploit(player, "Remote event rate limit exceeded")
        return false
    end
    
    table.insert(requests, currentTime)
    return true
end

-- Secure combat event handler
local combatEvent = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("CombatEvent")
combatEvent.OnServerEvent:Connect(function(player, action, data)
    if not checkRateLimit(player) then return end
    
    if action == "Punch" then
        if not Security:validateDamage(player, data.target, 10) then return end
        -- Process punch
        
    elseif action == "Kick" then
        if not Security:validateDamage(player, data.target, 15) then return end
        -- Process kick
        
    elseif action == "Capture" then
        if not Security:validatePlayer(player) then return end
        -- Process capture
        
    else
        Security:logExploit(player, "Invalid combat action: " .. tostring(action))
    end
end)

-- Secure game state event handler
local gameStateEvent = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("GameStateEvent")
gameStateEvent.OnServerEvent:Connect(function(player, action, data)
    if not checkRateLimit(player) then return end
    
    -- Only allow certain actions from players
    local allowedActions = {"Ready", "Spectate", "Leave"}
    
    if not table.find(allowedActions, action) then
        Security:logExploit(player, "Invalid game state action: " .. tostring(action))
        return
    end
    
    -- Process valid actions
end)

print("Secure remote event handlers initialized")
