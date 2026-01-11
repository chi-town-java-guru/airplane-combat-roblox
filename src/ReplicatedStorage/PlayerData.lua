-- Player Data Management
-- Handles player stats, progression, and persistent data

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Player data structure
local PlayerData = {
    -- Basic stats
    Level = 1,
    Experience = 0,
    Coins = 0,
    Wins = 0,
    Losses = 0,
    
    -- Combat stats
    TotalEliminations = 0,
    TotalCaptures = 0,
    TotalDamage = 0,
    TotalHealing = 0,
    
    -- Performance stats
    BestSurvivalTime = 0,
    BestRoundScore = 0,
    BestEliminationStreak = 0,
    BestCaptureStreak = 0,
    
    -- Session stats (reset each session)
    SessionEliminations = 0,
    SessionCaptures = 0,
    SessionDamage = 0,
    SessionHealing = 0,
    SessionWins = 0,
    SessionLosses = 0,
    
    -- Achievements
    UnlockedAchievements = {},
    
    -- Settings
    SoundVolume = 1.0,
    MusicVolume = 0.8,
    GraphicsQuality = "Medium",
    Controls = {
        Punch = "F",
        Kick = "G",
        Capture = "H",
        Sprint = "LeftShift"
    },
    
    -- Cosmetics
    EquippedSkin = "Default",
    OwnedSkins = {"Default"},
    EquippedEffects = {},
    OwnedEffects = {},
    
    -- VIP status
    IsVIP = false,
    VIPExpiration = nil,
    
    -- Last played
    LastPlayed = os.time(),
    TotalPlayTime = 0
}

-- Experience requirements for levels
local LEVEL_REQUIREMENTS = {
    0,   -- Level 1
    100, -- Level 2
    250, -- Level 3
    500, -- Level 4
    1000, -- Level 5
    2000, -- Level 6
    3500, -- Level 7
    5500, -- Level 8
    8000, -- Level 9
    12000, -- Level 10
    17000, -- Level 11
    25000, -- Level 12
    35000, -- Level 13
    50000, -- Level 14
    70000, -- Level 15
    100000 -- Level 16
}

-- Player data manager
local PlayerDataManager = {}
PlayerDataManager.__index = PlayerDataManager

function PlayerDataManager.new(player)
    local self = setmetatable({}, PlayerDataManager)
    self.player = player
    self.data = self:loadPlayerData()
    self.dataStore = self:getDataStore()
    return self
end

function PlayerDataManager:getDataStore()
    local DataStoreService = game:GetService("DataStoreService")
    return DataStoreService:GetDataStore("PlayerDataV1")
end

function PlayerDataManager:loadPlayerData()
    -- In a real implementation, this would load from DataStore
    -- For now, return default data
    local defaultData = {}
    for key, value in pairs(PlayerData) do
        if type(value) == "table" then
            defaultData[key] = {}
            for k, v in pairs(value) do
                defaultData[key][k] = v
            end
        else
            defaultData[key] = value
        end
    end
    return defaultData
end

function PlayerDataManager:savePlayerData()
    -- In a real implementation, this would save to DataStore
    local success, errorMessage = pcall(function()
        self.dataStore:SetAsync(self.player.UserId, self.data)
    end)
    
    if not success then
        warn("Failed to save player data for " .. self.player.Name .. ": " .. tostring(errorMessage))
    end
    
    return success
end

function PlayerDataManager:addExperience(amount)
    self.data.Experience = self.data.Experience + amount
    
    -- Check for level up
    local currentLevel = self.data.Level
    while currentLevel < #LEVEL_REQUIREMENTS and self.data.Experience >= LEVEL_REQUIREMENTS[currentLevel + 1] do
        currentLevel = currentLevel + 1
        self:levelUp(currentLevel)
    end
    
    self.data.Level = currentLevel
end

function PlayerDataManager:levelUp(newLevel)
    -- Award level up rewards
    local coinsReward = newLevel * 50
    self.data.Coins = self.data.Coins + coinsReward
    
    -- Notify player
    local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
    local uiEvent = remoteEvents:WaitForChild("UIEvent")
    uiEvent:FireClient(self.player, "LevelUp", {
        level = newLevel,
        coins = coinsReward
    })
    
    print(self.player.Name .. " reached level " .. newLevel)
end

function PlayerDataManager:addCoins(amount)
    self.data.Coins = self.data.Coins + amount
end

function PlayerDataManager:removeCoins(amount)
    if self.data.Coins >= amount then
        self.data.Coins = self.data.Coins - amount
        return true
    end
    return false
end

function PlayerDataManager:recordWin()
    self.data.Wins = self.data.Wins + 1
    self.data.SessionWins = self.data.SessionWins + 1
    self:addExperience(100)
    self:addCoins(50)
end

function PlayerDataManager:recordLoss()
    self.data.Losses = self.data.Losses + 1
    self.data.SessionLosses = self.data.SessionLosses + 1
    self:addExperience(25)
    self:addCoins(10)
end

function PlayerDataManager:recordElimination()
    self.data.TotalEliminations = self.data.TotalEliminations + 1
    self.data.SessionEliminations = self.data.SessionEliminations + 1
    self:addExperience(20)
    self:addCoins(5)
end

function PlayerDataManager:recordCapture()
    self.data.TotalCaptures = self.data.TotalCaptures + 1
    self.data.SessionCaptures = self.data.SessionCaptures + 1
    self:addExperience(30)
    self:addCoins(10)
end

function PlayerDataManager:recordDamage(amount)
    self.data.TotalDamage = self.data.TotalDamage + amount
    self.data.SessionDamage = self.data.SessionDamage + amount
end

function PlayerDataManager:recordHealing(amount)
    self.data.TotalHealing = self.data.TotalHealing + amount
    self.data.SessionHealing = self.data.SessionHealing + amount
end

function PlayerDataManager:recordSurvivalTime(time)
    if time > self.data.BestSurvivalTime then
        self.data.BestSurvivalTime = time
    end
end

function PlayerDataManager:recordRoundScore(score)
    if score > self.data.BestRoundScore then
        self.data.BestRoundScore = score
    end
end

function PlayerDataManager:unlockAchievement(achievementId)
    if not table.find(self.data.UnlockedAchievements, achievementId) then
        table.insert(self.data.UnlockedAchievements, achievementId)
        
        -- Award achievement rewards
        local coinsReward = 100
        self:addCoins(coinsReward)
        
        -- Notify player
        local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
        local uiEvent = remoteEvents:WaitForChild("UIEvent")
        uiEvent:FireClient(self.player, "AchievementUnlocked", {
            id = achievementId,
            coins = coinsReward
        })
    end
end

function PlayerDataManager:purchaseSkin(skinName, cost)
    if not table.find(self.data.OwnedSkins, skinName) and self:removeCoins(cost) then
        table.insert(self.data.OwnedSkins, skinName)
        return true
    end
    return false
end

function PlayerDataManager:equipSkin(skinName)
    if table.find(self.data.OwnedSkins, skinName) then
        self.data.EquippedSkin = skinName
        return true
    end
    return false
end

function PlayerDataManager:updatePlayTime()
    local currentTime = os.time()
    local sessionTime = currentTime - self.data.LastPlayed
    self.data.TotalPlayTime = self.data.TotalPlayTime + sessionTime
    self.data.LastPlayed = currentTime
end

function PlayerDataManager:getStats()
    return {
        Level = self.data.Level,
        Experience = self.data.Experience,
        Coins = self.data.Coins,
        Wins = self.data.Wins,
        Losses = self.data.Losses,
        TotalEliminations = self.data.TotalEliminations,
        TotalCaptures = self.data.TotalCaptures,
        BestSurvivalTime = self.data.BestSurvivalTime,
        BestRoundScore = self.data.BestRoundScore,
        KDRatio = self.data.TotalEliminations / math.max(1, self.data.Losses),
        WinRate = self.data.Wins / math.max(1, self.data.Wins + self.data.Losses) * 100,
        SessionStats = {
            Eliminations = self.data.SessionEliminations,
            Captures = self.data.SessionCaptures,
            Wins = self.data.SessionWins,
            Losses = self.data.SessionLosses
        }
    }
end

function PlayerDataManager:resetSessionStats()
    self.data.SessionEliminations = 0
    self.data.SessionCaptures = 0
    self.data.SessionDamage = 0
    self.data.SessionHealing = 0
    self.data.SessionWins = 0
    self.data.SessionLosses = 0
end

-- Auto-save functionality
function PlayerDataManager:startAutoSave()
    spawn(function()
        while true do
            wait(60) -- Save every minute
            self:savePlayerData()
            self:updatePlayTime()
        end
    end)
end

-- Player left cleanup
function PlayerDataManager:cleanup()
    self:savePlayerData()
    self:updatePlayTime()
end

-- Export for global access
_G.PlayerDataManager = PlayerDataManager

-- Initialize for all players
Players.PlayerAdded:Connect(function(player)
    local dataManager = PlayerDataManager.new(player)
    dataManager:startAutoSave()
    
    -- Store data manager in player
    player:SetAttribute("DataManager", dataManager)
end)

Players.PlayerRemoving:Connect(function(player)
    local dataManager = player:GetAttribute("DataManager")
    if dataManager then
        dataManager:cleanup()
    end
end)

print("Player data management system initialized!")
