-- Game Configuration
-- Central configuration file for all game settings and balance values

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Game balance settings
local GAME_CONFIG = {
    -- Round settings
    ROUND_DURATION = 300, -- 5 minutes in seconds
    MIN_PLAYERS = 1,
    MAX_PLAYERS = 8,
    RESPAWN_TIME = 5,
    PRE_ROUND_TIME = 10,
    
    -- Player stats
    PLAYER_HEALTH = 100,
    PLAYER_SPEED = 16,
    PLAYER_JUMP_POWER = 50,
    
    -- Combat settings
    PUNCH_DAMAGE = 10,
    PUNCH_RANGE = 8,
    PUNCH_COOLDOWN = 0.8,
    
    KICK_DAMAGE = 15,
    KICK_RANGE = 10,
    KICK_COOLDOWN = 1.2,
    
    CAPTURE_DURATION = 3,
    CAPTURE_RANGE = 6,
    CAPTURE_COOLDOWN = 2,
    
    -- Enemy settings
    ENEMY_HEALTH = 100,
    ENEMY_DAMAGE = 15,
    ENEMY_SPEED = 12,
    ENEMY_JUMP_POWER = 40,
    
    ENEMY_AGGRO_RANGE = 20,
    ENEMY_ATTACK_RANGE = 8,
    ENEMY_PATROL_SPEED = 8,
    ENEMY_CHASE_SPEED = 16,
    ENEMY_ATTACK_COOLDOWN = 2,
    
    -- Enemy spawn settings
    MAX_ENEMIES = 6,
    ENEMY_SPAWN_DELAY = 2,
    ENEMY_RESPAWN_TIME = 10,
    
    -- Airplane settings
    AIRPLANE_SIZE = Vector3.new(40, 15, 80),
    SEAT_COUNT = 24,
    EMERGENCY_EXIT_POSITION = Vector3.new(0, 0, 35),
    
    -- UI settings
    UI_FADE_TIME = 0.5,
    HEALTH_BAR_HEIGHT = 3,
    NAME_DISPLAY_DISTANCE = 50,
    
    -- Sound settings
    MASTER_VOLUME = 0.8,
    SFX_VOLUME = 0.7,
    MUSIC_VOLUME = 0.5,
    AMBIENT_VOLUME = 0.3,
    
    -- Visual settings
    PARTICLE_QUALITY = "High", -- Low, Medium, High
    SHADOW_QUALITY = "Medium",
    VIEW_DISTANCE = 100,
    
    -- Game modes
    GAME_MODES = {
        "Elimination", -- Eliminate all enemies
        "Survival", -- Survive until the plane lands
        "Capture", -- Capture all enemies
        "Escape" -- Escape through emergency exit
    },
    
    DEFAULT_GAME_MODE = "Elimination",
    
    -- Difficulty settings
    DIFFICULTIES = {
        Easy = {
            enemyHealthMultiplier = 0.7,
            enemyDamageMultiplier = 0.8,
            enemySpeedMultiplier = 0.9,
            maxEnemies = 4
        },
        Normal = {
            enemyHealthMultiplier = 1.0,
            enemyDamageMultiplier = 1.0,
            enemySpeedMultiplier = 1.0,
            maxEnemies = 6
        },
        Hard = {
            enemyHealthMultiplier = 1.5,
            enemyDamageMultiplier = 1.3,
            enemySpeedMultiplier = 1.2,
            maxEnemies = 8
        },
        Extreme = {
            enemyHealthMultiplier = 2.0,
            enemyDamageMultiplier = 1.5,
            enemySpeedMultiplier = 1.4,
            maxEnemies = 10
        }
    },
    
    DEFAULT_DIFFICULTY = "Normal",
    
    -- Achievement settings
    ACHIEVEMENTS = {
        FirstBlood = {
            Name = "First Blood",
            Description = "Get your first elimination",
            Icon = "rbxassetid://123456789"
        },
        Survivor = {
            Name = "Survivor",
            Description = "Complete a round without dying",
            Icon = "rbxassetid://123456790"
        },
        MasterFighter = {
            Name = "Master Fighter",
            Description = "Eliminate 10 enemies in one round",
            Icon = "rbxassetid://123456791"
        },
        SpeedDemon = {
            Name = "Speed Demon",
            Description = "Complete a round in under 2 minutes",
            Icon = "rbxassetid://123456792"
        },
        Untouchable = {
            Name = "Untouchable",
            Description = "Win a round without taking damage",
            Icon = "rbxassetid://123456793"
        },
        TeamPlayer = {
            Name = "Team Player",
            Description = "Revive 3 teammates in one round",
            Icon = "rbxassetid://123456794"
        },
        EscapeArtist = {
            Name = "Escape Artist",
            Description = "Kick 3 enemies out of the plane",
            Icon = "rbxassetid://123456795"
        },
        CapturePro = {
            Name = "Capture Pro",
            Description = "Capture 5 enemies in one round",
            Icon = "rbxassetid://123456796"
        }
    },
    
    -- Leaderboard settings
    LEADERBOARD_TYPES = {
        "Wins",
        "Eliminations",
        "Captures",
        "SurvivalTime",
        "KDRatio"
    },
    
    -- Shop/Upgrade settings (for future monetization)
    SHOP_ITEMS = {
        {
            Name = "Health Boost",
            Description = "Start with +25 health",
            Price = 100,
            Type = "Upgrade",
            Effect = {health = 25}
        },
        {
            Name = "Speed Boost",
            Description = "Increase movement speed by 10%",
            Price = 150,
            Type = "Upgrade",
            Effect = {speed = 1.1}
        },
        {
            Name = "Damage Boost",
            Description = "Increase damage by 15%",
            Price = 200,
            Type = "Upgrade",
            Effect = {damage = 1.15}
        },
        {
            Name = "Cool Skin",
            Description = "Custom character skin",
            Price = 500,
            Type = "Cosmetic",
            Effect = {skin = "cool"}
        }
    },
    
    -- VIP settings
    VIP_BENEFITS = {
        extraHealth = 25,
        speedBoost = 1.1,
        damageBoost = 1.1,
        exclusiveSkins = true,
        priorityQueue = true,
        doubleXP = true
    },
    
    -- Anti-cheat settings
    ANTI_CHEAT = {
        maxSpeed = 30,
        maxDamagePerSecond = 100,
        flyDetection = true,
        teleportDetection = true,
        damageValidation = true
    },
    
    -- Analytics settings
    ANALYTICS = {
        trackPlayerStats = true,
        trackGameMetrics = true,
        trackPerformance = true,
        anonymizeData = false
    }
}

-- Create configuration object
local config = {}
config.__index = config

function config.new()
    local self = setmetatable({}, config)
    self.settings = GAME_CONFIG
    self.currentDifficulty = GAME_CONFIG.DEFAULT_DIFFICULTY
    self.currentGameMode = GAME_CONFIG.DEFAULT_GAME_MODE
    return self
end

function config:getSetting(category, setting)
    if self.settings[category] and self.settings[category][setting] then
        return self.settings[category][setting]
    elseif self.settings[setting] then
        return self.settings[setting]
    end
    return nil
end

function config:setDifficulty(difficulty)
    if self.settings.DIFFICULTIES[difficulty] then
        self.currentDifficulty = difficulty
        return true
    end
    return false
end

function config:getDifficultySettings()
    return self.settings.DIFFICULTIES[self.currentDifficulty]
end

function config:setGameMode(gameMode)
    if table.find(self.settings.GAME_MODES, gameMode) then
        self.currentGameMode = gameMode
        return true
    end
    return false
end

function config:getCurrentGameMode()
    return self.currentGameMode
end

function config:getEnemyStats()
    local difficultySettings = self:getDifficultySettings()
    return {
        health = self.settings.ENEMY_HEALTH * difficultySettings.enemyHealthMultiplier,
        damage = self.settings.ENEMY_DAMAGE * difficultySettings.enemyDamageMultiplier,
        speed = self.settings.ENEMY_SPEED * difficultySettings.enemySpeedMultiplier,
        maxCount = difficultySettings.maxEnemies
    }
end

function config:getPlayerStats()
    return {
        health = self.settings.PLAYER_HEALTH,
        speed = self.settings.PLAYER_SPEED,
        jumpPower = self.settings.PLAYER_JUMP_POWER
    }
end

function config:getCombatStats()
    return {
        punch = {
            damage = self.settings.PUNCH_DAMAGE,
            range = self.settings.PUNCH_RANGE,
            cooldown = self.settings.PUNCH_COOLDOWN
        },
        kick = {
            damage = self.settings.KICK_DAMAGE,
            range = self.settings.KICK_RANGE,
            cooldown = self.settings.KICK_COOLDOWN
        },
        capture = {
            duration = self.settings.CAPTURE_DURATION,
            range = self.settings.CAPTURE_RANGE,
            cooldown = self.settings.CAPTURE_COOLDOWN
        }
    }
end

-- Export configuration
_G.GameConfig = config.new()

print("Game configuration loaded successfully!")
return _G.GameConfig
