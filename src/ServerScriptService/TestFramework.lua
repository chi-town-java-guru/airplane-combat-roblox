-- Comprehensive Testing Framework
-- Automated testing for game systems and functionality

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- Test framework
local TestFramework = {}
TestFramework.tests = {}
TestFramework.results = {
    passed = 0,
    failed = 0,
    total = 0
}

function TestFramework:assert(condition, message)
    if condition then
        self.results.passed = self.results.passed + 1
        print("✅ PASS: " .. message)
        return true
    else
        self.results.failed = self.results.failed + 1
        print("❌ FAIL: " .. message)
        return false
    end
end

function TestFramework:assertEqual(actual, expected, message)
    return self:assert(actual == expected, message .. " (Expected: " .. tostring(expected) .. ", Got: " .. tostring(actual) .. ")")
end

function TestFramework:assertNotNil(value, message)
    return self:assert(value ~= nil, message .. " (Value should not be nil)")
end

function TestFramework:registerTest(name, testFunction)
    table.insert(self.tests, {
        name = name,
        test = testFunction
    })
end

function TestFramework:runTests()
    print("🧪 Running Test Suite...")
    print("=" .. string.rep("=", 50))
    
    self.results = { passed = 0, failed = 0, total = 0 }
    
    for _, test in ipairs(self.tests) do
        print("\n📋 Running: " .. test.name)
        self.results.total = self.results.total + 1
        
        local success, error = pcall(test.test)
        if not success then
            self.results.failed = self.results.failed + 1
            print("❌ ERROR: " .. test.name .. " - " .. tostring(error))
        end
    end
    
    print("\n" .. string.rep("=", 50))
    print("📊 Test Results:")
    print("Total: " .. self.results.total)
    print("Passed: " .. self.results.passed)
    print("Failed: " .. self.results.failed)
    print("Success Rate: " .. string.format("%.1f%%", (self.results.passed / self.results.total) * 100))
    
    return self.results.failed == 0
end

-- Game System Tests
local GameTests = {}

function GameTests:testRemoteEvents()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    
    -- Test remote events exist
    TestFramework:assertNotNil(ReplicatedStorage:FindFirstChild("RemoteEvents"), "RemoteEvents folder should exist")
    
    local remoteEvents = ReplicatedStorage.RemoteEvents
    TestFramework:assertNotNil(remoteEvents:FindFirstChild("CombatEvent"), "CombatEvent should exist")
    TestFramework:assertNotNil(remoteEvents:FindFirstChild("GameStateEvent"), "GameStateEvent should exist")
    
    -- Test remote functions exist
    TestFramework:assertNotNil(ReplicatedStorage:FindFirstChild("RemoteFunctions"), "RemoteFunctions folder should exist")
    
    local remoteFunctions = ReplicatedStorage.RemoteFunctions
    TestFramework:assertNotNil(remoteFunctions:FindFirstChild("GetGameData"), "GetGameData should exist")
    TestFramework:assertNotNil(remoteFunctions:FindFirstChild("GetPlayerStats"), "GetPlayerStats should exist")
end

function GameTests:testGameBalance()
    -- Test game balance configuration
    TestFramework:assertNotNil(_G.GameBalance, "GameBalance should be loaded")
    
    local balance = _G.GameBalance
    TestFramework:assertNotNil(balance.COMBAT, "COMBAL configuration should exist")
    TestFramework:assertNotNil(balance.PROGRESSION, "PROGRESSION configuration should exist")
    TestFramework:assertNotNil(balance.ECONOMY, "ECONOMY configuration should exist")
    
    -- Test balance values
    TestFramework:assert(balance.COMBAT.PUNCH_DAMAGE > 0, "Punch damage should be positive")
    TestFramework:assert(balance.COMBAT.KICK_DAMAGE > balance.COMBAT.PUNCH_DAMAGE, "Kick damage should be higher than punch")
    TestFramework:assert(balance.PROGRESSION.WIN_XP > 0, "Win XP should be positive")
end

function GameTests:testSecurity()
    -- Test security system
    TestFramework:assertNotNil(_G.Security, "Security system should be loaded")
    
    local security = _G.Security
    TestFramework:assertNotNil(security.validatePlayer, "validatePlayer function should exist")
    TestFramework:assertNotNil(security.validateDamage, "validateDamage function should exist")
    TestFramework:assertNotNil(security.validatePosition, "validatePosition function should exist")
end

function GameTests:testDataStore()
    -- Test DataStore system
    TestFramework:assertNotNil(_G.PlayerDataManager, "PlayerDataManager should be loaded")
    
    -- Test DataStore service availability
    local success, result = pcall(function()
        return game:GetService("DataStoreService")
    end)
    TestFramework:assert(success, "DataStoreService should be available")
end

function GameTests:testUI()
    -- Test UI system
    TestFramework:assertNotNil(_G.UIManager, "UIManager should be loaded")
    
    local ui = _G.UIManager
    TestFramework:assertNotNil(ui.createScreenGui, "createScreenGui function should exist")
    TestFramework:assertNotNil(ui.createFrame, "createFrame function should exist")
    TestFramework:assertNotNil(ui.createLabel, "createLabel function should exist")
    TestFramework:assertNotNil(ui.createButton, "createButton function should exist")
end

function GameTests:testAnalytics()
    -- Test analytics system
    TestFramework:assertNotNil(_G.Analytics, "Analytics should be loaded")
    
    local analytics = _G.Analytics
    TestFramework:assertNotNil(analytics.logEvent, "logEvent function should exist")
    TestFramework:assertNotNil(analytics.logError, "logError function should exist")
    TestFramework:assertNotNil(analytics.sendData, "sendData function should exist")
end

function GameTests:testMonetization()
    -- Test monetization system
    TestFramework:assertNotNil(_G.MonetizationManager, "MonetizationManager should be loaded")
    
    local monetization = _G.MonetizationManager
    TestFramework:assertNotNil(monetization.checkGamePassOwnership, "checkGamePassOwnership function should exist")
    TestFramework:assertNotNil(monetization.calculateRewards, "calculateRewards function should exist")
    
    TestFramework:assertNotNil(_G.GAME_PASSES, "GAME_PASSES should be defined")
    TestFramework:assertNotNil(_G.DEVELOPER_PRODUCTS, "DEVELOPER_PRODUCTS should be defined")
end

-- Performance Tests
local PerformanceTests = {}

function PerformanceTests:testFrameRate()
    local startTime = tick()
    local frameCount = 0
    
    -- Sample FPS for 2 seconds
    local connection
    connection = RunService.Heartbeat:Connect(function()
        frameCount = frameCount + 1
        
        if tick() - startTime >= 2 then
            connection:Disconnect()
            
            local fps = frameCount / 2
            TestFramework:assert(fps >= 30, "Frame rate should be at least 30 FPS (Got: " .. string.format("%.1f", fps) .. ")")
        end
    end)
end

function PerformanceTests:testMemoryUsage()
    local StatsService = game:GetService("StatsService")
    local initialMemory = StatsService:GetTotalMemoryUsageMb()
    
    -- Wait a moment and check memory again
    wait(1)
    local currentMemory = StatsService:GetTotalMemoryUsageMb()
    
    local memoryIncrease = currentMemory - initialMemory
    TestFramework:assert(memoryIncrease < 100, "Memory increase should be less than 100MB (Got: " .. memoryIncrease .. "MB)")
end

-- Integration Tests
local IntegrationTests = {}

function IntegrationTests:testPlayerJoin()
    -- Create a mock player for testing
    local mockPlayer = Instance.new("Player")
    mockPlayer.Name = "TestPlayer"
    mockPlayer.UserId = 12345
    
    -- Test player data manager creation
    if _G.PlayerDataManager then
        local manager = _G.PlayerDataManager.new(mockPlayer)
        TestFramework:assertNotNil(manager, "PlayerDataManager should create instance")
        TestFramework:assertNotNil(manager.data, "Player data should be initialized")
    end
    
    mockPlayer:Destroy()
end

function IntegrationTests:testCombatSystem()
    -- Test combat system integration
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local combatEvent = ReplicatedStorage:FindFirstChild("RemoteEvents")
    
    if combatEvent then
        combatEvent = combatEvent:FindFirstChild("CombatEvent")
        TestFramework:assertNotNil(combatEvent, "CombatEvent should be accessible")
    end
end

-- Register all tests
TestFramework:registerTest("Remote Events Test", GameTests.testRemoteEvents)
TestFramework:registerTest("Game Balance Test", GameTests.testGameBalance)
TestFramework:registerTest("Security System Test", GameTests.testSecurity)
TestFramework:registerTest("DataStore Test", GameTests.testDataStore)
TestFramework:registerTest("UI System Test", GameTests.testUI)
TestFramework:registerTest("Analytics Test", GameTests.testAnalytics)
TestFramework:registerTest("Monetization Test", GameTests.testMonetization)
TestFramework:registerTest("Frame Rate Test", PerformanceTests.testFrameRate)
TestFramework:registerTest("Memory Usage Test", PerformanceTests.testMemoryUsage)
TestFramework:registerTest("Player Join Test", IntegrationTests.testPlayerJoin)
TestFramework:registerTest("Combat System Test", IntegrationTests.testCombatSystem)

-- Auto-run tests in studio
if game:GetService("RunService"):IsStudio() then
    spawn(function()
        wait(3) -- Wait for systems to initialize
        
        local allTestsPassed = TestFramework:runTests()
        
        if allTestsPassed then
            print("\n🎉 All tests passed! Game is ready for publishing.")
        else
            print("\n⚠️ Some tests failed. Review issues before publishing.")
        end
    end)
end

-- Export test framework
_G.TestFramework = TestFramework

print("Testing framework initialized")
