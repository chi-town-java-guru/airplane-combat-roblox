-- Game Manager Script
-- Manages overall game state, rounds, and win conditions

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Debris = game:GetService("Debris")

-- Game settings
local ROUND_DURATION = 300 -- 5 minutes
local MIN_PLAYERS = 1
local MAX_PLAYERS = 8
local RESPAWN_TIME = 5

-- Game state
local gameState = "waiting" -- waiting, playing, ended
local roundStartTime = 0
local playersInGame = {}
local eliminatedPlayers = {}
local capturedEnemies = {}

-- Game events
local gameEvent = Instance.new("RemoteEvent")
gameEvent.Name = "GameEvent"
gameEvent.Parent = ReplicatedStorage

-- Initialize game
local function initializeGame()
    print("Initializing Airplane Combat Game...")
    
    -- Set up lighting for airplane interior
    Lighting.Ambient = Color3.new(0.3, 0.3, 0.3)
    Lighting.OutdoorAmbient = Color3.new(0.2, 0.2, 0.2)
    Lighting.Brightness = 1.2
    
    -- Create airplane if it doesn't exist
    if not Workspace:FindFirstChild("Airplane") then
        require(script.Parent.Parent.Workspace.AirplaneModel)
    end
    
    -- Start waiting for players
    gameState = "waiting"
    print("Game initialized, waiting for players...")
end

-- Start new round
local function startRound()
    if #playersInGame < MIN_PLAYERS then
        print("Not enough players to start round")
        return
    end
    
    gameState = "playing"
    roundStartTime = tick()
    eliminatedPlayers = {}
    capturedEnemies = {}
    
    -- Reset all players
    for _, player in ipairs(playersInGame) do
        if player.Character then
            -- Reset health
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.Health = humanoid.MaxHealth
            end
            
            -- Position player in airplane
            local spawnPosition = Vector3.new(math.random(-20, 20), 6.5, math.random(-2, 2))
            player.Character:MoveTo(spawnPosition)
            
            -- Give player tools
            local tool = Instance.new("Tool")
            tool.Name = "Combat Tool"
            tool.Parent = player.Backpack
            
            local handle = Instance.new("Part")
            handle.Name = "Handle"
            handle.Size = Vector3.new(1, 1, 1)
            handle.BrickColor = BrickColor.new("Dark grey")
            handle.Material = Enum.Material.Metal
            handle.Parent = tool
        end
    end
    
    -- Notify all players
    gameEvent:FireAllClients("roundStart", {
        duration = ROUND_DURATION,
        playerCount = #playersInGame
    })
    
    print("Round started with " .. #playersInGame .. " players")
    
    -- Start round timer
    spawn(function()
        wait(ROUND_DURATION)
        if gameState == "playing" then
            endRound("time")
        end
    end)
end

-- End current round
local function endRound(reason)
    if gameState ~= "playing" then return end
    
    gameState = "ended"
    
    local winner = nil
    local message = ""
    
    if reason == "time" then
        -- Check who survived
        local survivors = {}
        for _, player in ipairs(playersInGame) do
            if not eliminatedPlayers[player.UserId] then
                table.insert(survivors, player)
            end
        end
        
        if #survivors > 0 then
            winner = survivors[1]
            message = winner.Name .. " survived the longest!"
        else
            message = "No survivors! Round ended in a draw."
        end
        
    elseif reason == "elimination" then
        -- Find last player standing
        local survivors = {}
        for _, player in ipairs(playersInGame) do
            if not eliminatedPlayers[player.UserId] then
                table.insert(survivors, player)
            end
        end
        
        if #survivors == 1 then
            winner = survivors[1]
            message = winner.Name .. " eliminated all threats!"
        else
            message = "All threats neutralized!"
        end
    end
    
    -- Notify all players
    gameEvent:FireAllClients("roundEnd", {
        reason = reason,
        winner = winner and winner.Name or "None",
        message = message
    })
    
    -- Show victory message
    local messageObj = Instance.new("Message")
    messageObj.Text = message
    messageObj.Parent = Workspace
    Debris:AddItem(messageObj, 5)
    
    print("Round ended: " .. message)
    
    -- Start new round after delay
    spawn(function()
        wait(10)
        initializeGame()
    end)
end

-- Handle player elimination
local function eliminatePlayer(player, reason)
    if eliminatedPlayers[player.UserId] then return end
    
    eliminatedPlayers[player.UserId] = reason
    
    -- Check if round should end
    local activePlayers = 0
    for _, playerInGame in ipairs(playersInGame) do
        if not eliminatedPlayers[playerInGame.UserId] then
            activePlayers = activePlayers + 1
        end
    end
    
    if activePlayers <= 1 then
        endRound("elimination")
    end
end

-- Handle player joining
Players.PlayerAdded:Connect(function(player)
    table.insert(playersInGame, player)
    
    -- Notify player
    gameEvent:FireClient(player, "gameJoin", {
        gameState = gameState,
        playerCount = #playersInGame
    })
    
    -- Handle character spawning
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        
        -- Handle death
        humanoid.Died:Connect(function()
            if gameState == "playing" then
                eliminatePlayer(player, "death")
                
                -- Respawn after delay
                spawn(function()
                    wait(RESPAWN_TIME)
                    if gameState == "playing" then
                        player:LoadCharacter()
                    end
                end)
            end
        end)
    end)
    
    print(player.Name .. " joined the game")
end)

-- Handle player leaving
Players.PlayerRemoving:Connect(function(player)
    for i, playerInGame in ipairs(playersInGame) do
        if playerInGame == player then
            table.remove(playersInGame, i)
            break
        end
    end
    
    if gameState == "playing" then
        eliminatePlayer(player, "left")
    end
    
    print(player.Name .. " left the game")
end)

-- Handle game events from clients
gameEvent.OnServerEvent:Connect(function(player, action, data)
    if action == "startRound" then
        if gameState == "waiting" and #playersInGame >= MIN_PLAYERS then
            startRound()
        end
    elseif action == "enemyCaptured" then
        if data and data.enemy then
            capturedEnemies[data.enemy] = true
            checkWinCondition()
        end
    end
end)

-- Check win condition
local function checkWinCondition()
    if gameState ~= "playing" then return end
    
    -- Count active enemies
    local enemyAI = require(script.Parent.EnemyAI)
    local activeEnemies = 0
    
    -- This would need to be connected to the EnemyAI system
    -- For now, we'll assume the win condition is when all players are eliminated or time runs out
    
    local activePlayers = 0
    for _, player in ipairs(playersInGame) do
        if not eliminatedPlayers[player.UserId] then
            activePlayers = activePlayers + 1
        end
    end
    
    if activePlayers <= 1 then
        endRound("elimination")
    end
end

-- Auto-start round when enough players join
spawn(function()
    while true do
        wait(5)
        if gameState == "waiting" and #playersInGame >= MIN_PLAYERS then
            startRound()
        end
    end
end)

-- Initialize the game
initializeGame()

print("Game Manager initialized!")
