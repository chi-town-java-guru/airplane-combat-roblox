-- Monetization System
-- Handles game passes, developer products, and virtual economy

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Game Pass configuration
local GAME_PASSES = {
    VIP = {
        ID = 0, -- Set your actual game pass ID
        NAME = "VIP Pass",
        PRICE = 400,
        BENEFITS = {
            "2x XP rewards",
            "2x coin rewards", 
            "Exclusive VIP chat tag",
            "Special cosmetic items",
            "Priority server access"
        }
    },
    
    PREMIUM = {
        ID = 0, -- Set your actual game pass ID
        NAME = "Premium Pass",
        PRICE = 1200,
        BENEFITS = {
            "3x XP rewards",
            "3x coin rewards",
            "Premium chat tag",
            "Exclusive premium cosmetics",
            "Daily bonus coins",
            "Skip wait times"
        }
    },
    
    ELITE = {
        ID = 0, -- Set your actual game pass ID
        NAME = "Elite Pass",
        PRICE = 2500,
        BENEFITS = {
            "5x XP rewards",
            "5x coin rewards",
            "Elite chat tag",
            "All exclusive cosmetics",
            "Daily bonus coins (2x)",
            "Skip wait times",
            "Private server access",
            "Special abilities"
        }
    }
}

-- Developer products configuration
local DEVELOPER_PRODUCTS = {
    COINS_SMALL = {
        ID = 0, -- Set your actual product ID
        NAME = "Coin Pack - Small",
        PRICE = 100, -- Robux
        COINS = 1000
    },
    
    COINS_MEDIUM = {
        ID = 0, -- Set your actual product ID
        NAME = "Coin Pack - Medium",
        PRICE = 500,
        COINS = 6000 -- Bonus
    },
    
    COINS_LARGE = {
        ID = 0, -- Set your actual product ID
        NAME = "Coin Pack - Large",
        PRICE = 1000,
        COINS = 15000 -- Bonus
    },
    
    COINS_MEGA = {
        ID = 0, -- Set your actual product ID
        NAME = "Coin Pack - Mega",
        PRICE = 5000,
        COINS = 100000 -- Mega bonus
    },
    
    XP_BOOST = {
        ID = 0, -- Set your actual product ID
        NAME = "XP Boost (1 Hour)",
        PRICE = 200,
        DURATION = 3600, -- 1 hour in seconds
        MULTIPLIER = 2
    },
    
    COIN_BOOST = {
        ID = 0, -- Set your actual product ID
        NAME = "Coin Boost (1 Hour)",
        PRICE = 200,
        DURATION = 3600,
        MULTIPLIER = 2
    }
}

-- Monetization Manager
local MonetizationManager = {}

function MonetizationManager:checkGamePassOwnership(player, passType)
    local gamePass = GAME_PASSES[passType]
    if not gamePass or gamePass.ID == 0 then return false end
    
    return MarketplaceService:UserOwnsGamePassAsync(player.UserId, gamePass.ID)
end

function MonetizationManager:promptGamePassPurchase(player, passType)
    local gamePass = GAME_PASSES[passType]
    if not gamePass or gamePass.ID == 0 then return end
    
    MarketplaceService:PromptGamePassPurchase(player, gamePass.ID)
end

function MonetizationManager:promptDeveloperProductPurchase(player, productType)
    local product = DEVELOPER_PRODUCTS[productType]
    if not product or product.ID == 0 then return end
    
    MarketplaceService:PromptProductPurchase(player, product.ID)
end

function MonetizationManager:grantGamePassBenefits(player, passType)
    local playerData = _G.PlayerDataManager and _G.PlayerDataManager[player.UserId]
    if not playerData then return end
    
    local gamePass = GAME_PASSES[passType]
    if not gamePass then return end
    
    -- Apply multipliers
    if passType == "VIP" then
        playerData.data.xpMultiplier = 2
        playerData.data.coinMultiplier = 2
        playerData.data.isVIP = true
    elseif passType == "PREMIUM" then
        playerData.data.xpMultiplier = 3
        playerData.data.coinMultiplier = 3
        playerData.data.isPremium = true
    elseif passType == "ELITE" then
        playerData.data.xpMultiplier = 5
        playerData.data.coinMultiplier = 5
        playerData.data.isElite = true
    end
    
    -- Notify player
    if _G.UIManager then
        _G.UIManager:showNotification(
            "Game Pass Activated!",
            "You now have " .. gamePass.NAME .. " benefits!",
            "success",
            5
        )
    end
end

function MonetizationManager:grantDeveloperProduct(player, productType)
    local playerData = _G.PlayerDataManager and _G.PlayerDataManager[player.UserId]
    if not playerData then return end
    
    local product = DEVELOPER_PRODUCTS[productType]
    if not product then return end
    
    if productType == "COINS_SMALL" or productType == "COINS_MEDIUM" or 
       productType == "COINS_LARGE" or productType == "COINS_MEGA" then
        -- Grant coins
        playerData.data.Coins = (playerData.data.Coins or 0) + product.COINS
        
        if _G.UIManager then
            _G.UIManager:showNotification(
                "Purchase Complete!",
                "You received " .. product.COINS .. " coins!",
                "success",
                5
            )
        end
        
    elseif productType == "XP_BOOST" then
        -- Grant XP boost
        playerData.data.xpBoostEndTime = tick() + product.DURATION
        playerData.data.xpBoostMultiplier = product.MULTIPLIER
        
        if _G.UIManager then
            _G.UIManager:showNotification(
                "XP Boost Activated!",
                "2x XP for 1 hour!",
                "success",
                5
            )
        end
        
    elseif productType == "COIN_BOOST" then
        -- Grant coin boost
        playerData.data.coinBoostEndTime = tick() + product.DURATION
        playerData.data.coinBoostMultiplier = product.MULTIPLIER
        
        if _G.UIManager then
            _G.UIManager:showNotification(
                "Coin Boost Activated!",
                "2x coins for 1 hour!",
                "success",
                5
            )
        end
    end
end

function MonetizationManager:calculateRewards(baseRewards, player)
    local playerData = _G.PlayerDataManager and _G.PlayerDataManager[player.UserId]
    if not playerData then return baseRewards end
    
    local rewards = {
        xp = baseRewards.xp or 0,
        coins = baseRewards.coins or 0
    }
    
    -- Apply game pass multipliers
    if playerData.data.isVIP then
        rewards.xp = rewards.xp * 2
        rewards.coins = rewards.coins * 2
    elseif playerData.data.isPremium then
        rewards.xp = rewards.xp * 3
        rewards.coins = rewards.coins * 3
    elseif playerData.data.isElite then
        rewards.xp = rewards.xp * 5
        rewards.coins = rewards.coins * 5
    end
    
    -- Apply temporary boosts
    local currentTime = tick()
    
    if playerData.data.xpBoostEndTime and currentTime < playerData.data.xpBoostEndTime then
        rewards.xp = rewards.xp * (playerData.data.xpBoostMultiplier or 1)
    end
    
    if playerData.data.coinBoostEndTime and currentTime < playerData.data.coinBoostEndTime then
        rewards.coins = rewards.coins * (playerData.data.coinBoostMultiplier or 1)
    end
    
    return rewards
end

-- Marketplace service handlers
MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, gamePassId, wasPurchased)
    if not wasPurchased then return end
    
    -- Find which game pass was purchased
    for passType, gamePass in pairs(GAME_PASSES) do
        if gamePass.ID == gamePassId then
            MonetizationManager:grantGamePassBenefits(player, passType)
            
            if _G.Analytics then
                _G.Analytics:logEvent("game_pass_purchased", {
                    userId = player.UserId,
                    passType = passType,
                    price = gamePass.PRICE
                })
            end
            break
        end
    end
end)

MarketplaceService.PromptProductPurchaseFinished:Connect(function(player, productId, wasPurchased)
    if not wasPurchased then return end
    
    -- Find which product was purchased
    for productType, product in pairs(DEVELOPER_PRODUCTS) do
        if product.ID == productId then
            MonetizationManager:grantDeveloperProduct(player, productType)
            
            if _G.Analytics then
                _G.Analytics:logEvent("developer_product_purchased", {
                    userId = player.UserId,
                    productType = productType,
                    price = product.PRICE
                })
            end
            break
        end
    end
end)

-- Shop UI functions
local function createShopUI(player)
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- Create shop GUI
    local shopGui = Instance.new("ScreenGui")
    shopGui.Name = "Shop"
    shopGui.Parent = playerGui
    
    -- Background
    local background = Instance.new("Frame")
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.new(0, 0, 0)
    background.BackgroundTransparency = 0.5
    background.Parent = shopGui
    
    -- Shop panel
    local panel = Instance.new("Frame")
    panel.Size = UDim2.new(0, 600, 0, 400)
    panel.Position = UDim2.new(0.5, -300, 0.5, -200)
    panel.BackgroundColor3 = Color3.new(0.1, 0.1, 0.15)
    panel.BorderSizePixel = 0
    panel.Parent = background
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.Text = "SHOP"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
    title.TextColor3 = Color3.new(1, 1, 1)
    title.BackgroundTransparency = 1
    title.Parent = panel
    
    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 40, 0, 40)
    closeButton.Position = UDim2.new(1, -50, 0, 10)
    closeButton.Text = "✕"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 20
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
    closeButton.BorderSizePixel = 0
    closeButton.Parent = panel
    
    closeButton.MouseButton1Click:Connect(function()
        shopGui:Destroy()
    end)
    
    -- Add game passes and products to shop
    -- (This would be expanded with actual UI elements)
    
    return shopGui
end

-- Export monetization manager
_G.MonetizationManager = MonetizationManager
_G.GAME_PASSES = GAME_PASSES
_G.DEVELOPER_PRODUCTS = DEVELOPER_PRODUCTS

-- Remote function for shop access
local shopRemote = ReplicatedStorage:WaitForChild("RemoteFunctions"):WaitForChild("GetShopData")
shopRemote.OnServerInvoke = function(player)
    return {
        gamePasses = GAME_PASSES,
        developerProducts = DEVELOPER_PRODUCTS,
        ownedPasses = {
            VIP = MonetizationManager:checkGamePassOwnership(player, "VIP"),
            PREMIUM = MonetizationManager:checkGamePassOwnership(player, "PREMIUM"),
            ELITE = MonetizationManager:checkGamePassOwnership(player, "ELITE")
        }
    }
end

print("Monetization system initialized")
