-- Enhanced UI/UX System
-- Modern, responsive user interface with animations and polish

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- UI Configuration
local UIConfig = {
    COLORS = {
        PRIMARY = Color3.new(0.2, 0.4, 0.8),
        SECONDARY = Color3.new(0.8, 0.2, 0.2),
        SUCCESS = Color3.new(0.2, 0.8, 0.2),
        WARNING = Color3.new(0.8, 0.6, 0.2),
        BACKGROUND = Color3.new(0.1, 0.1, 0.15),
        TEXT = Color3.new(1, 1, 1),
        TEXT_MUTED = Color3.new(0.7, 0.7, 0.7)
    },
    
    FONTS = {
        HEADING = Enum.Font.GothamBold,
        BODY = Enum.Font.Gotham,
        UI = Enum.Font.SourceSans
    },
    
    ANIMATIONS = {
        FADE_IN = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        FADE_OUT = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        SLIDE_IN = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        BOUNCE = TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
        PULSE = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
    }
}

-- Enhanced UI Manager
local UIManager = {}

function UIManager:createScreenGui(name, zIndex)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = name
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    if zIndex then
        screenGui.DisplayOrder = zIndex
    end
    
    return screenGui
end

function UIManager:createFrame(parent, name, size, position, color)
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.Size = size
    frame.Position = position
    frame.BackgroundColor3 = color or UIConfig.COLORS.BACKGROUND
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    return frame
end

function UIManager:createLabel(parent, name, text, size, position, font, textColor)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Text = text or ""
    label.Size = size or UDim2.new(1, 0, 1, 0)
    label.Position = position or UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = font or UIConfig.FONTS.BODY
    label.TextColor3 = textColor or UIConfig.COLORS.TEXT
    label.TextScaled = true
    label.Parent = parent
    
    return label
end

function UIManager:createButton(parent, name, text, size, position, callback)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Text = text or ""
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = UIConfig.COLORS.PRIMARY
    button.BorderSizePixel = 0
    button.Font = UIConfig.FONTS.UI
    button.TextColor3 = UIConfig.COLORS.TEXT
    button.TextScaled = true
    button.Parent = parent
    
    -- Hover effects
    button.MouseEnter:Connect(function()
        local hoverTween = TweenService:Create(button, UIConfig.ANIMATIONS.FADE_IN, {
            BackgroundColor3 = UIConfig.COLORS.SUCCESS
        })
        hoverTween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local normalTween = TweenService:Create(button, UIConfig.ANIMATIONS.FADE_OUT, {
            BackgroundColor3 = UIConfig.COLORS.PRIMARY
        })
        normalTween:Play()
    end)
    
    -- Click effects
    button.MouseButton1Click:Connect(function()
        local clickTween = TweenService:Create(button, UIConfig.ANIMATIONS.BOUNCE, {
            Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset - 5, 
                           button.Size.Y.Scale, button.Size.Y.Offset - 5)
        })
        clickTween:Play()
        clickTween.Completed:Connect(function()
            local restoreTween = TweenService:Create(button, UIConfig.ANIMATIONS.FADE_IN, {
                Size = size
            })
            restoreTween:Play()
        end)
        
        if callback then
            callback()
        end
    end)
    
    return button
end

function UIManager:showNotification(title, message, type, duration)
    type = type or "info"
    duration = duration or 3
    
    local notificationGui = self:createScreenGui("Notification", 1000)
    
    -- Determine color based on type
    local color = UIConfig.COLORS.PRIMARY
    if type == "success" then
        color = UIConfig.COLORS.SUCCESS
    elseif type == "warning" then
        color = UIConfig.COLORS.WARNING
    elseif type == "error" then
        color = UIConfig.COLORS.SECONDARY
    end
    
    -- Create notification frame
    local frame = self:createFrame(notificationGui, "NotificationFrame", 
        UDim2.new(0, 300, 0, 100), 
        UDim2.new(1, -320, 0, 20),
        color)
    
    frame.AnchorPoint = Vector2.new(1, 0)
    frame.BackgroundTransparency = 1
    
    -- Animate in
    local slideIn = TweenService:Create(frame, UIConfig.ANIMATIONS.SLIDE_IN, {
        Position = UDim2.new(1, -20, 0, 20),
        BackgroundTransparency = 0
    })
    slideIn:Play()
    
    -- Add content
    local titleLabel = self:createLabel(frame, "Title", title, 
        UDim2.new(1, -20, 0, 30), 
        UDim2.new(0, 10, 0, 10),
        UIConfig.FONTS.HEADING)
    
    local messageLabel = self:createLabel(frame, "Message", message,
        UDim2.new(1, -20, 0, 60),
        UDim2.new(0, 10, 0, 40),
        UIConfig.FONTS.BODY,
        UIConfig.COLORS.TEXT_MUTED)
    
    messageLabel.TextWrapped = true
    
    -- Auto remove
    spawn(function()
        wait(duration)
        local fadeOut = TweenService:Create(frame, UIConfig.ANIMATIONS.FADE_OUT, {
            Position = UDim2.new(1, 320, 0, 20),
            BackgroundTransparency = 1
        })
        fadeOut:Play()
        fadeOut.Completed:Connect(function()
            notificationGui:Destroy()
        end)
    end)
end

function UIManager:createLoadingScreen()
    local loadingGui = self:createScreenGui("LoadingScreen", 999)
    
    -- Background
    local background = self:createFrame(loadingGui, "Background", 
        UDim2.new(1, 0, 1, 0), 
        UDim2.new(0, 0, 0, 0),
        Color3.new(0, 0, 0))
    
    -- Loading container
    local container = self:createFrame(background, "Container",
        UDim2.new(0, 300, 0, 150),
        UDim2.new(0.5, -150, 0.5, -75))
    container.BackgroundTransparency = 0.5
    
    -- Title
    local title = self:createLabel(container, "Title", "AIRPLANE COMBAT",
        UDim2.new(1, 0, 0, 50),
        UDim2.new(0, 0, 0, 10),
        UIConfig.FONTS.HEADING)
    
    -- Loading bar
    local loadingBar = self:createFrame(container, "LoadingBar",
        UDim2.new(0, 250, 0, 10),
        UDim2.new(0.5, -125, 0, 80))
    loadingBar.BackgroundColor3 = UIConfig.COLORS.BACKGROUND
    
    local loadingFill = self:createFrame(loadingBar, "Fill",
        UDim2.new(0, 0, 1, 0),
        UDim2.new(0, 0, 0, 0),
        UIConfig.COLORS.PRIMARY)
    
    -- Status text
    local statusText = self:createLabel(container, "Status", "Loading...",
        UDim2.new(1, 0, 0, 30),
        UDim2.new(0, 0, 0, 110),
        UIConfig.FONTS.BODY,
        UIConfig.COLORS.TEXT_MUTED)
    
    -- Animate loading bar
    local loadingTween = TweenService:Create(loadingFill, UIConfig.ANIMATIONS.PULSE, {
        Size = UDim2.new(1, 0, 1, 0)
    })
    loadingTween:Play()
    
    return {
        gui = loadingGui,
        statusText = statusText,
        hide = function()
            local fadeOut = TweenService:Create(background, UIConfig.ANIMATIONS.FADE_OUT, {
                BackgroundTransparency = 1
            })
            fadeOut:Play()
            fadeOut.Completed:Connect(function()
                loadingGui:Destroy()
            end)
        end
    }
end

function UIManager:createSettingsMenu()
    local settingsGui = self:createScreenGui("SettingsMenu", 998)
    
    -- Background overlay
    local overlay = self:createFrame(settingsGui, "Overlay",
        UDim2.new(1, 0, 1, 0),
        UDim2.new(0, 0, 0, 0),
        Color3.new(0, 0, 0))
    overlay.BackgroundTransparency = 0.5
    
    -- Settings panel
    local panel = self:createFrame(overlay, "Panel",
        UDim2.new(0, 400, 0, 500),
        UDim2.new(0.5, -200, 0.5, -250))
    panel.BackgroundTransparency = 0.2
    
    -- Title
    local title = self:createLabel(panel, "Title", "SETTINGS",
        UDim2.new(1, 0, 0, 50),
        UDim2.new(0, 0, 0, 20),
        UIConfig.FONTS.HEADING)
    
    -- Settings sections would go here
    -- Volume, graphics, controls, etc.
    
    -- Close button
    local closeButton = self:createButton(panel, "CloseButton", "✕",
        UDim2.new(0, 40, 0, 40),
        UDim2.new(1, -50, 0, 10),
        function()
            settingsGui:Destroy()
        end)
    
    return settingsGui
end

-- Initialize UI system
local function initializeUI()
    -- Create loading screen
    local loadingScreen = UIManager:createLoadingScreen()
    
    -- Simulate loading
    spawn(function()
        wait(2)
        loadingScreen.statusText.Text = "Loading assets..."
        wait(1)
        loadingScreen.statusText.Text = "Connecting to server..."
        wait(1)
        loadingScreen.statusText.Text = "Ready!"
        wait(0.5)
        loadingScreen:hide()
        
        -- Show welcome notification
        UIManager:showNotification("Welcome!", "Press F to punch, G to kick, H to capture", "info", 5)
    end)
end

-- Export UI manager
_G.UIManager = UIManager

-- Initialize when player joins
if player.Character then
    initializeUI()
else
    player.CharacterAdded:Wait()
    initializeUI()
end

print("Enhanced UI/UX system initialized")
