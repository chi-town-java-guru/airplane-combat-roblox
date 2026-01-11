-- Enhanced DataStore with Backup and Recovery
-- Robust data persistence with multiple fallbacks

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- DataStore configuration
local DATA_STORE_NAME = "AirplaneCombatGame"
local BACKUP_STORE_NAME = "AirplaneCombatGame_Backup"
local CACHE_STORE_NAME = "AirplaneCombatGame_Cache"

-- Create DataStore instances
local dataStore = DataStoreService:GetDataStore(DATA_STORE_NAME)
local backupStore = DataStoreService:GetDataStore(BACKUP_STORE_NAME)
local cacheStore = DataStoreService:GetDataStore(CACHE_STORE_NAME)

-- In-memory cache for session data
local sessionCache = {}

-- Enhanced PlayerDataManager
local PlayerDataManager = {}
PlayerDataManager.__index = PlayerDataManager

function PlayerDataManager.new(player)
    local self = setmetatable({}, PlayerDataManager)
    self.player = player
    self.data = {}
    self.lastSave = 0
    self.saveInterval = 60 -- Save every 60 seconds
    self.pendingSave = false
    
    return self
end

function PlayerDataManager:loadPlayerData()
    local userId = self.player.UserId
    local success, data = self:attemptLoadFromMultipleSources(userId)
    
    if success then
        self.data = data
        self:initializeDefaults()
        print("Successfully loaded data for " .. self.player.Name)
    else
        warn("Failed to load data for " .. self.player.Name .. ", using defaults")
        self:createDefaultData()
    end
    
    -- Start auto-save timer
    self:startAutoSave()
    
    return self.data
end

function PlayerDataManager:attemptLoadFromMultipleSources(userId)
    -- Try primary DataStore first
    local success, data = pcall(function()
        return dataStore:GetAsync(userId)
    end)
    
    if success and data then
        print("Loaded from primary DataStore for user " .. userId)
        return true, data
    end
    
    -- Try backup DataStore
    local success2, backupData = pcall(function()
        return backupStore:GetAsync(userId)
    end)
    
    if success2 and backupData then
        print("Loaded from backup DataStore for user " .. userId)
        -- Restore to primary
        spawn(function()
            self:saveToMultipleSources(userId, backupData)
        end)
        return true, backupData
    end
    
    -- Try cache DataStore
    local success3, cacheData = pcall(function()
        return cacheStore:GetAsync(userId)
    end)
    
    if success3 and cacheData then
        print("Loaded from cache DataStore for user " .. userId)
        -- Restore to primary and backup
        spawn(function()
            self:saveToMultipleSources(userId, cacheData)
        end)
        return true, cacheData
    end
    
    return false, nil
end

function PlayerDataManager:saveToMultipleSources(userId, data)
    local savePromises = {}
    
    -- Save to primary
    table.insert(savePromises, pcall(function()
        dataStore:SetAsync(userId, data)
    end))
    
    -- Save to backup
    table.insert(savePromises, pcall(function()
        backupStore:SetAsync(userId, data)
    end))
    
    -- Save to cache
    table.insert(savePromises, pcall(function()
        cacheStore:SetAsync(userId, data)
    end))
    
    -- Check results
    local successCount = 0
    for _, result in ipairs(savePromises) do
        if result then successCount = successCount + 1 end
    end
    
    return successCount >= 2 -- Success if at least 2 out of 3 work
end

function PlayerDataManager:savePlayerData(force)
    if not force and (tick() - self.lastSave < self.saveInterval) then
        self.pendingSave = true
        return
    end
    
    local userId = self.player.UserId
    local success = self:saveToMultipleSources(userId, self.data)
    
    if success then
        self.lastSave = tick()
        self.pendingSave = false
        print("Successfully saved data for " .. self.player.Name)
    else
        warn("Failed to save data for " .. self.player.Name)
        -- Schedule retry
        spawn(function()
            wait(5)
            self:savePlayerData(true)
        end)
    end
end

function PlayerDataManager:startAutoSave()
    spawn(function()
        while self.player and self.player.Parent do
            wait(self.saveInterval)
            if self.pendingSave then
                self:savePlayerData(true)
            end
        end
    end)
end

function PlayerDataManager:initializeDefaults()
    -- Ensure all required fields exist
    local defaults = {
        Level = 1,
        Experience = 0,
        Coins = 0,
        Wins = 0,
        Losses = 0,
        TotalEliminations = 0,
        TotalCaptures = 0,
        TotalDamage = 0,
        TotalHealing = 0,
        BestSurvivalTime = 0,
        BestRoundScore = 0,
        BestEliminationStreak = 0,
        BestCaptureStreak = 0,
        SessionEliminations = 0,
        SessionCaptures = 0,
        SessionDamage = 0,
        SessionHealing = 0,
        SessionWins = 0,
        SessionLosses = 0,
        UnlockedAchievements = {},
        SoundVolume = 1.0,
        MusicVolume = 0.8,
        GraphicsQuality = "Medium",
        Controls = {
            Punch = "F",
            Kick = "G",
            Capture = "H",
            Sprint = "LeftShift"
        }
    }
    
    for key, value in pairs(defaults) do
        if self.data[key] == nil then
            self.data[key] = value
        end
    end
end

function PlayerDataManager:createDefaultData()
    self.data = {
        Level = 1,
        Experience = 0,
        Coins = 100, -- Starting bonus
        Wins = 0,
        Losses = 0,
        TotalEliminations = 0,
        TotalCaptures = 0,
        TotalDamage = 0,
        TotalHealing = 0,
        BestSurvivalTime = 0,
        BestRoundScore = 0,
        BestEliminationStreak = 0,
        BestCaptureStreak = 0,
        SessionEliminations = 0,
        SessionCaptures = 0,
        SessionDamage = 0,
        SessionHealing = 0,
        SessionWins = 0,
        SessionLosses = 0,
        UnlockedAchievements = {},
        SoundVolume = 1.0,
        MusicVolume = 0.8,
        GraphicsQuality = "Medium",
        Controls = {
            Punch = "F",
            Kick = "G",
            Capture = "H",
            Sprint = "LeftShift"
        }
    }
end

function PlayerDataManager:updateData(updates)
    for key, value in pairs(updates) do
        if type(self.data[key]) == "table" and type(value) == "table" then
            for subKey, subValue in pairs(value) do
                self.data[key][subKey] = subValue
            end
        else
            self.data[key] = value
        end
    end
    self.pendingSave = true
end

function PlayerDataManager:cleanup()
    -- Save final data
    self:savePlayerData(true)
    
    -- Clear from cache
    sessionCache[self.player.UserId] = nil
end

-- Player management
local playerManagers = {}

Players.PlayerAdded:Connect(function(player)
    local manager = PlayerDataManager.new(player)
    manager:loadPlayerData()
    playerManagers[player.UserId] = manager
end)

Players.PlayerRemoving:Connect(function(player)
    local manager = playerManagers[player.UserId]
    if manager then
        manager:cleanup()
        playerManagers[player.UserId] = nil
    end
end)

-- Export
_G.PlayerDataManager = PlayerDataManager

print("Enhanced DataStore system initialized")
