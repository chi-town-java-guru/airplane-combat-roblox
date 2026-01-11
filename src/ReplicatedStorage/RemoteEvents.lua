-- Remote Events for Client-Server Communication
-- This file creates all necessary remote events for the game

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create RemoteEvent folder
local remoteEvents = Instance.new("Folder")
remoteEvents.Name = "RemoteEvents"
remoteEvents.Parent = ReplicatedStorage

-- Combat events
local combatEvent = Instance.new("RemoteEvent")
combatEvent.Name = "CombatEvent"
combatEvent.Parent = remoteEvents

-- Game state events
local gameStateEvent = Instance.new("RemoteEvent")
gameStateEvent.Name = "GameStateEvent"
gameStateEvent.Parent = remoteEvents

-- Player interaction events
local playerInteractionEvent = Instance.new("RemoteEvent")
playerInteractionEvent.Name = "PlayerInteractionEvent"
playerInteractionEvent.Parent = remoteEvents

-- Enemy events
local enemyEvent = Instance.new("RemoteEvent")
enemyEvent.Name = "EnemyEvent"
enemyEvent.Parent = remoteEvents

-- UI events
local uiEvent = Instance.new("RemoteEvent")
uiEvent.Name = "UIEvent"
uiEvent.Parent = remoteEvents

-- Remote functions for data requests
local remoteFunctions = Instance.new("Folder")
remoteFunctions.Name = "RemoteFunctions"
remoteFunctions.Parent = ReplicatedStorage

local getGameData = Instance.new("RemoteFunction")
getGameData.Name = "GetGameData"
getGameData.Parent = remoteFunctions

local getPlayerStats = Instance.new("RemoteFunction")
getPlayerStats.Name = "GetPlayerStats"
getPlayerStats.Parent = remoteFunctions

print("Remote events and functions created successfully!")
