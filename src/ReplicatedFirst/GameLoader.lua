-- Game Loader Script
-- Loads game assets and initializes the game client-side

local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ContentProvider = game:GetService("ContentProvider")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer

-- Preload assets
local function preloadAssets()
    -- Preload common sounds
    local sounds = {
        "rbxassetid://131961290" -- Punch sound
    }
    
    -- Preload images
    local images = {
        "rbxassetid://123456789" -- UI placeholder
    }
    
    -- Preload meshes
    local meshes = {
        "rbxassetid://987654321" -- Airplane mesh placeholder
    }
    
    -- Load all assets
    ContentProvider:PreloadAsync(sounds)
    ContentProvider:PreloadAsync(images)
    ContentProvider:PreloadAsync(meshes)
end

-- Initialize game client
local function initializeGame()
    print("Loading Airplane Combat Game...")
    
    -- Remove default Roblox UI
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
    
    -- Enable specific UI elements
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
    
    -- Load game UI
    local gameUI = script.Parent.Parent.StarterGui.GameUI
    if gameUI then
        require(gameUI)
    end
    
    -- Load player controller
    local playerController = script.Parent.Parent.StarterPlayer.StarterPlayerScripts.PlayerController
    if playerController then
        require(playerController)
    end
    
    print("Game client initialized!")
end

-- Wait for player to be ready
player.CharacterAdded:Wait()
initializeGame()

-- Preload assets in background
spawn(preloadAssets)

print("Game loader completed!")
