-- Game Balance and Progression System
-- Manages game balance, leveling, rewards, and economy

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Game balance configuration
local GameBalance = {
    -- Combat balance
    COMBAT = {
        PUNCH_DAMAGE = 10,
        KICK_DAMAGE = 15,
        CAPTURE_DURATION = 3,
        RESPAWN_TIME = 5,
        COMBAT_COOLDOWN = 0.5,
        
        -- Enemy balance
        ENEMY_HEALTH = 100,
        ENEMY_DAMAGE = 15,
        ENEMY_SPEED = 12,
        ENEMY_AGRO_RANGE = 20,
        ENEMY_ATTACK_RANGE = 8,
        ENEMY_ATTACK_COOLDOWN = 2,
        
        -- Difficulty scaling
        DIFFICULTY_MULTIPLIER = 1.0,
        ENEMY_SPAWN_RATE = 30, -- seconds
        MAX_ENEMIES = 8
    },
    
    -- Progression system
    PROGRESSION = {
        -- Experience requirements (cumulative)
        LEVEL_XP = {
            0,   -- Level 1
            100, -- Level 2
            250, -- Level 3
            500, -- Level 4
            1000,-- Level 5
            1750,-- Level 6
            2800,-- Level 7
            4200,-- Level 8
            6000,-- Level 9
            8500 -- Level 10
        },
        
        -- Rewards
        WIN_XP = 50,
        LOSE_XP = 10,
        ELIMINATION_XP = 5,
        CAPTURE_XP = 8,
        SURVIVAL_BONUS_XP = 2, -- per minute
        
        -- Coin rewards
        WIN_COINS = 25,
        LOSE_COINS = 5,
        ELIMINATION_COINS = 3,
        CAPTURE_COINS = 5,
        SURVIVAL_BONUS_COINS = 1 -- per minute
    },
    
    -- Economy
    ECONOMY = {
        -- Starting values
        STARTING_COINS = 100,
        DAILY_BONUS_COINS = 50,
        
        -- Shop items (if implemented)
        COSMETIC_COST_RANGE = {50, 500},
        POWERUP_COST_RANGE = {25, 200},
        
        -- Game pass costs (Robux)
        VIP_PASS_COST = 400,
        PREMIUM_PASS_COST = 1200,
        ELITE_PASS_COST = 2500
    },
    
    -- Round configuration
    ROUND = {
        DURATION = 300, -- 5 minutes
        MIN_PLAYERS = 1,
        MAX_PLAYERS = 8,
        PRE_ROUND_TIME = 15,
        POST_ROUND_TIME = 10,
        
        -- Win conditions
        SURVIVAL_WIN = true,
        ELIMINATION_WIN = true,
        TIME_LIMIT_WIN = true
    },
    
    -- Performance settings
    PERFORMANCE = {
        MAX_PARTICLES = 100,
        MAX_SOUNDS = 20,
        LOD_DISTANCE = 100,
        UPDATE_FREQUENCY = 0.1 -- seconds
    }
}

-- Progression calculator
local ProgressionCalculator = {}

function ProgressionCalculator:getLevelForXP(xp)
    local levels = GameBalance.PROGRESSION.LEVEL_XP
    for level = #levels, 1, -1 do
        if xp >= levels[level] then
            return level
        end
    end
    return 1
end

function ProgressionCalculator:getXPForLevel(level)
    return GameBalance.PROGRESSION.LEVEL_XP[level] or 0
end

function ProgressionCalculator:getXPToNextLevel(currentXP)
    local currentLevel = self:getLevelForXP(currentXP)
    local nextLevelXP = self:getXPForLevel(currentLevel + 1)
    
    if nextLevelXP == 0 then
        return 0 -- Max level
    end
    
    return nextLevelXP - currentXP
end

function ProgressionCalculator:calculateRoundRewards(stats)
    local rewards = {
        xp = 0,
        coins = 0
    }
    
    -- Base rewards
    if stats.won then
        rewards.xp = rewards.xp + GameBalance.PROGRESSION.WIN_XP
        rewards.coins = rewards.coins + GameBalance.PROGRESSION.WIN_COINS
    else
        rewards.xp = rewards.xp + GameBalance.PROGRESSION.LOSE_XP
        rewards.coins = rewards.coins + GameBalance.PROGRESSION.LOSE_COINS
    end
    
    -- Combat rewards
    rewards.xp = rewards.xp + (stats.eliminations * GameBalance.PROGRESSION.ELIMINATION_XP)
    rewards.coins = rewards.coins + (stats.eliminations * GameBalance.PROGRESSION.ELIMINATION_COINS)
    
    rewards.xp = rewards.xp + (stats.captures * GameBalance.PROGRESSION.CAPTURE_XP)
    rewards.coins = rewards.coins + (stats.captures * GameBalance.PROGRESSION.CAPTURE_COINS)
    
    -- Survival bonus
    if stats.survivalTime then
        local survivalMinutes = math.floor(stats.survivalTime / 60)
        rewards.xp = rewards.xp + (survivalMinutes * GameBalance.PROGRESSION.SURVIVAL_BONUS_XP)
        rewards.coins = rewards.coins + (survivalMinutes * GameBalance.PROGRESSION.SURVIVAL_BONUS_COINS)
    end
    
    -- Performance multiplier (based on score)
    local performanceMultiplier = 1.0
    if stats.score > 100 then
        performanceMultiplier = 1.5
    elseif stats.score > 50 then
        performanceMultiplier = 1.2
    end
    
    rewards.xp = math.floor(rewards.xp * performanceMultiplier)
    rewards.coins = math.floor(rewards.coins * performanceMultiplier)
    
    return rewards
end

function ProgressionCalculator:applyDifficultyScaling(difficulty)
    local multiplier = 1.0 + (difficulty - 1) * 0.2
    
    GameBalance.COMBAT.ENEMY_HEALTH = math.floor(100 * multiplier)
    GameBalance.COMBAT.ENEMY_DAMAGE = math.floor(15 * multiplier)
    GameBalance.COMBAT.ENEMY_SPEED = 12 * multiplier
    GameBalance.COMBAT.DIFFICULTY_MULTIPLIER = multiplier
end

-- Achievement system
local AchievementSystem = {}

function AchievementSystem:checkAchievements(player, stats)
    local achievements = {}
    
    -- First Blood
    if stats.eliminations >= 1 then
        table.insert(achievements, "first_blood")
    end
    
    -- Survivor
    if stats.survivalTime and stats.survivalTime >= 240 then -- 4 minutes
        table.insert(achievements, "survivor")
    end
    
    -- Master Fighter
    if stats.eliminations >= 10 then
        table.insert(achievements, "master_fighter")
    end
    
    -- Speed Demon
    if stats.won and stats.roundTime and stats.roundTime <= 120 then -- 2 minutes
        table.insert(achievements, "speed_demon")
    end
    
    -- Untouchable
    if stats.won and stats.damageTaken == 0 then
        table.insert(achievements, "untouchable")
    end
    
    -- Capture Pro
    if stats.captures >= 5 then
        table.insert(achievements, "capture_pro")
    end
    
    return achievements
end

-- Export systems
_G.GameBalance = GameBalance
_G.ProgressionCalculator = ProgressionCalculator
_G.AchievementSystem = AchievementSystem

-- Make balance available to clients
local balanceRemote = ReplicatedStorage:WaitForChild("RemoteFunctions"):WaitForChild("GetGameData")
balanceRemote.OnServerInvoke = function(player)
    return GameBalance
end

print("Game balance and progression system initialized")
