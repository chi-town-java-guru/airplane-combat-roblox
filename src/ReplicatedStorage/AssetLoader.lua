-- Asset Loader Script
-- Loads and manages all game assets from the asset folders

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

-- Asset paths
local ASSET_PATHS = {
    data = "assets/data/",
    audio = "assets/audio/",
    images = "assets/images/",
    models = "assets/models/",
    animations = "assets/animations/"
}

-- Load JSON data files
local function loadDataFile(fileName)
    local success, result = pcall(function()
        local content = game:GetService("HttpService"):GetAsync("file://" .. ASSET_PATHS.data .. fileName)
        return HttpService:JSONDecode(content)
    end)
    
    if success then
        return result
    else
        warn("Failed to load data file: " .. fileName .. " - " .. tostring(result))
        return {}
    end
end

-- Load localization data
local localizationData = loadDataFile("localization.json")
_G.Localization = localizationData

-- Load game balance data
local balanceData = loadDataFile("game_balance.json")
_G.GameBalance = balanceData

-- Load map configuration
local mapData = loadDataFile("map_config.json")
_G.MapConfig = mapData

-- Load player settings
local settingsData = loadDataFile("player_settings.json")
_G.PlayerSettings = settingsData

-- Asset management functions
local AssetManager = {}

function AssetManager:getLocalizedString(key, language)
    language = language or "en"
    local keys = {}
    for k in string.gmatch(key, "[^%.]+") do
        table.insert(keys, k)
    end
    
    local value = self.localization[language]
    for _, k in ipairs(keys) do
        if value and value[k] then
            value = value[k]
        else
            return key -- Return key if not found
        end
    end
    
    return value or key
end

function AssetManager:getBalanceSetting(setting)
    return self.balance[setting]
end

function AssetManager:getMapConfig(setting)
    return self.mapConfig[setting]
end

function AssetManager:getPlayerSetting(setting)
    return self.playerSettings[setting]
end

-- Initialize asset manager
AssetManager.localization = localizationData or {}
AssetManager.balance = balanceData or {}
AssetManager.mapConfig = mapData or {}
AssetManager.playerSettings = settingsData or {}

-- Export asset manager
_G.AssetManager = AssetManager

print("Asset loader initialized!")
print("Loaded localization data: " .. tostring(localizationData ~= nil))
print("Loaded balance data: " .. tostring(balanceData ~= nil))
print("Loaded map config: " .. tostring(mapData ~= nil))
print("Loaded player settings: " .. tostring(settingsData ~= nil))
