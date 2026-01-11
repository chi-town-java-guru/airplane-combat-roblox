-- Analytics and Performance Monitoring System
-- Tracks game performance, player behavior, and server health

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local StatsService = game:GetService("Stats")
local Workspace = game:GetService("Workspace")

-- Analytics configuration
local AnalyticsConfig = {
    ENABLED = true,
    BATCH_SIZE = 50,
    SEND_INTERVAL = 60, -- seconds
    WEBHOOK_URL = "", -- Configure for your analytics service
    
    -- Performance thresholds
    WARNING_FPS = 30,
    CRITICAL_FPS = 20,
    WARNING_PING = 200,
    CRITICAL_PING = 500,
    WARNING_MEMORY = 1000, -- MB
    CRITICAL_MEMORY = 1500 -- MB
}

-- Data collection
local AnalyticsData = {
    server = {
        startTime = tick(),
        totalPlayers = 0,
        peakPlayers = 0,
        roundsPlayed = 0,
        crashes = 0,
        errors = 0
    },
    
    performance = {
        fpsHistory = {},
        pingHistory = {},
        memoryHistory = {},
        serverLag = 0
    },
    
    playerStats = {},
    events = {},
    errors = {}
}

-- Performance Monitor
local PerformanceMonitor = {}

function PerformanceMonitor:startMonitoring()
    local frameCount = 0
    local lastFpsUpdate = tick()
    local currentFps = 60
    
    -- FPS monitoring
    RunService.Heartbeat:Connect(function(deltaTime)
        frameCount = frameCount + 1
        
        if tick() - lastFpsUpdate >= 1 then
            currentFps = frameCount
            frameCount = 0
            lastFpsUpdate = tick()
            
            -- Store FPS data
            table.insert(AnalyticsData.performance.fpsHistory, {
                time = tick(),
                fps = currentFps
            })
            
            -- Keep only last 60 seconds of data
            if #AnalyticsData.performance.fpsHistory > 60 then
                table.remove(AnalyticsData.performance.fpsHistory, 1)
            end
            
            -- Check for performance issues
            if currentFps < AnalyticsConfig.CRITICAL_FPS then
                Analytics:logEvent("performance_critical", {
                    type = "low_fps",
                    value = currentFps
                })
            elseif currentFps < AnalyticsConfig.WARNING_FPS then
                Analytics:logEvent("performance_warning", {
                    type = "low_fps",
                    value = currentFps
                })
            end
        end
    end)
    
    -- Memory monitoring
    spawn(function()
        while true do
            wait(5) -- Check every 5 seconds
            
            local memoryUsage = StatsService:GetTotalMemoryUsageMb()
            
            table.insert(AnalyticsData.performance.memoryHistory, {
                time = tick(),
                memory = memoryUsage
            })
            
            -- Keep only last hour of data
            if #AnalyticsData.performance.memoryHistory > 720 then
                table.remove(AnalyticsData.performance.memoryHistory, 1)
            end
            
            -- Check for memory issues
            if memoryUsage > AnalyticsConfig.CRITICAL_MEMORY then
                Analytics:logEvent("performance_critical", {
                    type = "high_memory",
                    value = memoryUsage
                })
            elseif memoryUsage > AnalyticsConfig.WARNING_MEMORY then
                Analytics:logEvent("performance_warning", {
                    type = "high_memory",
                    value = memoryUsage
                })
            end
        end
    end)
    
    print("Performance monitoring started")
end

-- Player Analytics
local PlayerAnalytics = {}

function PlayerAnalytics:trackPlayerJoin(player)
    AnalyticsData.server.totalPlayers = AnalyticsData.server.totalPlayers + 1
    AnalyticsData.server.peakPlayers = math.max(AnalyticsData.server.peakPlayers, #Players:GetPlayers())
    
    AnalyticsData.playerStats[player.UserId] = {
        joinTime = tick(),
        playTime = 0,
        roundsPlayed = 0,
        eliminations = 0,
        captures = 0,
        deaths = 0,
        ping = 0,
        fps = 60
    }
    
    Analytics:logEvent("player_join", {
        userId = player.UserId,
        playerName = player.Name,
        totalPlayers = #Players:GetPlayers()
    })
end

function PlayerAnalytics:trackPlayerLeave(player)
    local playerData = AnalyticsData.playerStats[player.UserId]
    if playerData then
        playerData.playTime = tick() - playerData.joinTime
        
        Analytics:logEvent("player_leave", {
            userId = player.UserId,
            playerName = player.Name,
            playTime = playerData.playTime,
            roundsPlayed = playerData.roundsPlayed,
            eliminations = playerData.eliminations,
            captures = playerData.captures,
            deaths = playerData.deaths
        })
        
        AnalyticsData.playerStats[player.UserId] = nil
    end
end

function PlayerAnalytics:trackCombatEvent(player, eventType, data)
    local playerData = AnalyticsData.playerStats[player.UserId]
    if not playerData then return end
    
    if eventType == "elimination" then
        playerData.eliminations = playerData.eliminations + 1
    elseif eventType == "capture" then
        playerData.captures = playerData.captures + 1
    elseif eventType == "death" then
        playerData.deaths = playerData.deaths + 1
    end
    
    Analytics:logEvent("combat_event", {
        userId = player.UserId,
        eventType = eventType,
        data = data
    })
end

-- Main Analytics System
local Analytics = {}

function Analytics:logEvent(eventName, data)
    if not AnalyticsConfig.ENABLED then return end
    
    local event = {
        timestamp = tick(),
        eventName = eventName,
        data = data or {}
    }
    
    table.insert(AnalyticsData.events, event)
    
    -- Keep events manageable
    if #AnalyticsData.events > AnalyticsConfig.BATCH_SIZE * 2 then
        for i = 1, AnalyticsConfig.BATCH_SIZE do
            table.remove(AnalyticsData.events, 1)
        end
    end
end

function Analytics:logError(errorType, errorMessage, stackTrace)
    local error = {
        timestamp = tick(),
        errorType = errorType,
        message = errorMessage,
        stackTrace = stackTrace
    }
    
    table.insert(AnalyticsData.errors, error)
    AnalyticsData.server.errors = AnalyticsData.server.errors + 1
    
    -- Keep only last 100 errors
    if #AnalyticsData.errors > 100 then
        table.remove(AnalyticsData.errors, 1)
    end
    
    warn("Analytics Error: " .. errorType .. " - " .. errorMessage)
end

function Analytics:sendData()
    if not AnalyticsConfig.WEBHOOK_URL or AnalyticsConfig.WEBHOOK_URL == "" then
        return -- No webhook configured
    end
    
    local payload = {
        serverId = game.JobId,
        timestamp = tick(),
        data = AnalyticsData
    }
    
    local success, response = pcall(function()
        return HttpService:PostAsync(
            AnalyticsConfig.WEBHOOK_URL,
            HttpService:JSONEncode(payload),
            Enum.HttpContentType.ApplicationJson,
            false
        )
    end)
    
    if success then
        print("Analytics data sent successfully")
        -- Clear sent data
        AnalyticsData.events = {}
    else
        warn("Failed to send analytics data: " .. tostring(response))
    end
end

function Analytics:getPerformanceReport()
    local report = {
        currentFps = 0,
        averageFps = 0,
        currentMemory = 0,
        averageMemory = 0,
        serverUptime = tick() - AnalyticsData.server.startTime,
        totalPlayers = AnalyticsData.server.totalPlayers,
        peakPlayers = AnalyticsData.server.peakPlayers
    }
    
    -- Calculate averages
    if #AnalyticsData.performance.fpsHistory > 0 then
        local totalFps = 0
        for _, entry in ipairs(AnalyticsData.performance.fpsHistory) do
            totalFps = totalFps + entry.fps
        end
        report.averageFps = totalFps / #AnalyticsData.performance.fpsHistory
        report.currentFps = AnalyticsData.performance.fpsHistory[#AnalyticsData.performance.fpsHistory].fps
    end
    
    if #AnalyticsData.performance.memoryHistory > 0 then
        local totalMemory = 0
        for _, entry in ipairs(AnalyticsData.performance.memoryHistory) do
            totalMemory = totalMemory + entry.memory
        end
        report.averageMemory = totalMemory / #AnalyticsData.performance.memoryHistory
        report.currentMemory = AnalyticsData.performance.memoryHistory[#AnalyticsData.performance.memoryHistory].memory
    end
    
    return report
end

-- Initialize analytics system
local function initializeAnalytics()
    -- Start performance monitoring
    PerformanceMonitor:startMonitoring()
    
    -- Track player events
    Players.PlayerAdded:Connect(PlayerAnalytics.trackPlayerJoin)
    Players.PlayerRemoving:Connect(PlayerAnalytics.trackPlayerLeave)
    
    -- Periodic data sending
    spawn(function()
        while true do
            wait(AnalyticsConfig.SEND_INTERVAL)
            Analytics:sendData()
        end
    end)
    
    -- Global error handler
    spawn(function()
        local success, errorMessage = pcall(function()
            -- This would catch unhandled errors
        end)
        if not success then
            Analytics:logError("unhandled_error", errorMessage, debug.traceback())
        end
    end)
    
    print("Analytics system initialized")
end

-- Export systems
_G.Analytics = Analytics
_G.PerformanceMonitor = PerformanceMonitor
_G.PlayerAnalytics = PlayerAnalytics

-- Initialize
initializeAnalytics()
