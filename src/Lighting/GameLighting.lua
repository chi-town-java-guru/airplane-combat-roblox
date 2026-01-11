-- Game Lighting Configuration
-- Sets up atmospheric lighting for the airplane interior

local Lighting = game:GetService("Lighting")

-- Set basic lighting properties
Lighting.Ambient = Color3.new(0.3, 0.3, 0.3)
Lighting.Brightness = 1.2
Lighting.ColorShift_Top = Color3.new(0.8, 0.8, 1)
Lighting.ColorShift_Bottom = Color3.new(0.9, 0.9, 1)
Lighting.FogColor = Color3.new(0.7, 0.7, 0.8)
Lighting.FogEnd = 100
Lighting.FogStart = 50

-- Configure sun/moon
Lighting.ClockTime = 14 -- 2 PM (daylight)
Lighting.GeographicLatitude = 30
Lighting.TimeOfDay = "14:00:00"

-- Create airplane interior lights
local function createInteriorLights()
    -- Main overhead lighting
    local overheadLight = Instance.new("PointLight")
    overheadLight.Name = "OverheadLight"
    overheadLight.Brightness = 1.5
    overheadLight.Color = Color3.new(1, 0.95, 0.8)
    overheadLight.Range = 30
    overheadLight.Shadows = true
    overheadLight.Parent = Lighting
    
    -- Emergency exit lighting
    local emergencyLight = Instance.new("PointLight")
    emergencyLight.Name = "EmergencyLight"
    emergencyLight.Brightness = 0.8
    emergencyLight.Color = Color3.new(1, 0.2, 0.2)
    emergencyLight.Range = 15
    emergencyLight.Enabled = false
    emergencyLight.Parent = Lighting
    
    -- Window ambient light
    local windowLight = Instance.new("PointLight")
    windowLight.Name = "WindowLight"
    windowLight.Brightness = 0.6
    windowLight.Color = Color3.new(0.8, 0.9, 1)
    windowLight.Range = 25
    windowLight.Parent = Lighting
    
    return {
        overhead = overheadLight,
        emergency = emergencyLight,
        window = windowLight
    }
end

-- Create atmospheric effects
local function createAtmosphere()
    local atmosphere = Instance.new("Atmosphere")
    atmosphere.Name = "GameAtmosphere"
    atmosphere.Density = 0.3
    atmosphere.Offset = 0.25
    atmosphere.Color = Color3.new(0.8, 0.8, 1)
    atmosphere.Decay = Color3.new(0.5, 0.5, 0.6)
    atmosphere.Glare = 0.1
    atmosphere.Haze = 0.5
    atmosphere.Parent = Lighting
    
    return atmosphere
end

-- Create skybox
local function createSkybox()
    local sky = Instance.new("Sky")
    sky.Name = "GameSky"
    sky.SkyboxBk = "rbxassetid://150680329"
    sky.SkyboxDn = "rbxassetid://150680329"
    sky.SkyboxFt = "rbxassetid://150680329"
    sky.SkyboxLf = "rbxassetid://150680329"
    sky.SkyboxRt = "rbxassetid://150680329"
    sky.SkyboxUp = "rbxassetid://150680329"
    sky.CelestialBodiesShown = true
    sky.SunAngularSize = 15
    sky.MoonAngularSize = 10
    sky.StarCount = 100
    sky.Parent = Lighting
    
    return sky
end

-- Create post-processing effects
local function createPostProcessing()
    local colorCorrection = Instance.new("ColorCorrectionEffect")
    colorCorrection.Name = "ColorCorrection"
    colorCorrection.Brightness = 0.1
    colorCorrection.Contrast = 0.1
    colorCorrection.Saturation = 0.1
    colorCorrection.TintColor = Color3.new(1, 1, 1)
    colorCorrection.Parent = Lighting
    
    local bloom = Instance.new("BloomEffect")
    bloom.Name = "Bloom"
    bloom.Intensity = 0.2
    bloom.Size = 24
    bloom.Threshold = 2
    bloom.Parent = Lighting
    
    local blur = Instance.new("BlurEffect")
    blur.Name = "MotionBlur"
    blur.Size = 0.5
    blur.Enabled = false
    blur.Parent = Lighting
    
    return {
        colorCorrection = colorCorrection,
        bloom = bloom,
        blur = blur
    }
end

-- Dynamic lighting system
local function setupDynamicLighting()
    local lights = createInteriorLights()
    local atmosphere = createAtmosphere()
    local sky = createSkybox()
    local postProcessing = createPostProcessing()
    
    -- Emergency lighting system
    local emergencyEnabled = false
    
    local function toggleEmergencyLights(enabled)
        emergencyEnabled = enabled
        lights.emergency.Enabled = enabled
        
        if enabled then
            -- Red emergency lighting
            Lighting.ColorShift_Top = Color3.new(1, 0.2, 0.2)
            Lighting.ColorShift_Bottom = Color3.new(1, 0.3, 0.3)
            lights.overhead.Color = Color3.new(1, 0.5, 0.5)
            postProcessing.colorCorrection.TintColor = Color3.new(1, 0.8, 0.8)
        else
            -- Normal lighting
            Lighting.ColorShift_Top = Color3.new(0.8, 0.8, 1)
            Lighting.ColorShift_Bottom = Color3.new(0.9, 0.9, 1)
            lights.overhead.Color = Color3.new(1, 0.95, 0.8)
            postProcessing.colorCorrection.TintColor = Color3.new(1, 1, 1)
        end
    end
    
    -- Day/night cycle (optional, for longer flights)
    local timeOfDay = 14
    local function updateTime()
        timeOfDay = (timeOfDay + 0.1) % 24
        Lighting.ClockTime = timeOfDay
        
        -- Adjust lighting based on time
        if timeOfDay >= 6 and timeOfDay <= 18 then
            -- Daytime
            lights.window.Brightness = 0.6
            Lighting.Brightness = 1.2
        else
            -- Nighttime
            lights.window.Brightness = 0.2
            Lighting.Brightness = 0.8
        end
    end
    
    -- Return lighting control functions
    return {
        toggleEmergency = toggleEmergencyLights,
        updateTime = updateTime,
        lights = lights
    }
end

-- Initialize lighting system
local lightingSystem = setupDynamicLighting()

-- Expose functions to other scripts
_G.GameLighting = lightingSystem

print("Game lighting system initialized!")
