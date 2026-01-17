-- Game Assets Configuration (Updated for Roblox Upload)
-- Contains all game assets like sounds, particles, and visual effects
-- REPLACE THE [ASSET_ID] placeholders with your actual Roblox asset IDs

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create assets folder
local assets = Instance.new("Folder")
assets.Name = "GameAssets"
assets.Parent = ReplicatedStorage

-- Sound assets
local sounds = Instance.new("Folder")
sounds.Name = "Sounds"
sounds.Parent = assets

-- Combat sounds
local punchSound = Instance.new("Sound")
punchSound.Name = "Punch"
punchSound.SoundId = "rbxassetid://[PUNCH_SOUND_ID]" -- REPLACE WITH ACTUAL ID
punchSound.Volume = 0.5
punchSound.Parent = sounds

local kickSound = Instance.new("Sound")
kickSound.Name = "Kick"
kickSound.SoundId = "rbxassetid://[KICK_SOUND_ID]" -- REPLACE WITH ACTUAL ID
kickSound.Volume = 0.6
kickSound.Parent = sounds

local captureSound = Instance.new("Sound")
captureSound.Name = "Capture"
captureSound.SoundId = "rbxassetid://[CAPTURE_SOUND_ID]" -- REPLACE WITH ACTUAL ID
captureSound.Volume = 0.4
captureSound.Parent = sounds

local damageSound = Instance.new("Sound")
damageSound.Name = "Damage"
damageSound.SoundId = "rbxassetid://[DAMAGE_SOUND_ID]" -- REPLACE WITH ACTUAL ID
damageSound.Volume = 0.5
damageSound.Parent = sounds

local deathSound = Instance.new("Sound")
deathSound.Name = "Death"
deathSound.SoundId = "rbxassetid://[DEATH_SOUND_ID]" -- REPLACE WITH ACTUAL ID
deathSound.Volume = 0.7
deathSound.Parent = sounds

-- Ambient sounds
local airplaneAmbient = Instance.new("Sound")
airplaneAmbient.Name = "AirplaneAmbient"
airplaneAmbient.SoundId = "rbxassetid://[AIRPLANE_AMBIENT_ID]" -- REPLACE WITH ACTUAL ID
airplaneAmbient.Volume = 0.3
airplaneAmbient.Looped = true
airplaneAmbient.Parent = sounds

local emergencyAlarm = Instance.new("Sound")
emergencyAlarm.Name = "EmergencyAlarm"
emergencyAlarm.SoundId = "rbxassetid://[EMERGENCY_ALARM_ID]" -- REPLACE WITH ACTUAL ID
emergencyAlarm.Volume = 0.8
emergencyAlarm.Looped = true
emergencyAlarm.Parent = sounds

-- UI sounds
local buttonClick = Instance.new("Sound")
buttonClick.Name = "ButtonClick"
buttonClick.SoundId = "rbxassetid://[BUTTON_CLICK_ID]" -- REPLACE WITH ACTUAL ID
buttonClick.Volume = 0.3
buttonClick.Parent = sounds

local victorySound = Instance.new("Sound")
victorySound.Name = "Victory"
victorySound.SoundId = "rbxassetid://[VICTORY_SOUND_ID]" -- REPLACE WITH ACTUAL ID
victorySound.Volume = 0.6
victorySound.Parent = sounds

local defeatSound = Instance.new("Sound")
defeatSound.Name = "Defeat"
defeatSound.SoundId = "rbxassetid://[DEFEAT_SOUND_ID]" -- REPLACE WITH ACTUAL ID
defeatSound.Volume = 0.6
defeatSound.Parent = sounds

-- Particle effects
local particles = Instance.new("Folder")
particles.Name = "Particles"
particles.Parent = assets

-- Impact particles
local punchImpact = Instance.new("ParticleEmitter")
punchImpact.Name = "PunchImpact"
punchImpact.Texture = "rbxassetid://[PUNCH_IMPACT_TEXTURE_ID]" -- REPLACE WITH ACTUAL ID
punchImpact.Color = ColorSequence.new(Color3.new(1, 1, 0))
punchImpact.Transparency = NumberSequence.new(0, 1)
punchImpact.Size = NumberSequence.new(0.5, 2)
punchImpact.Lifetime = NumberRange.new(0.5, 1)
punchImpact.Rate = 10
punchImpact.Speed = NumberRange.new(5, 10)
punchImpact.Acceleration = Vector3.new(0, -10, 0)
punchImpact.Parent = particles

local kickImpact = Instance.new("ParticleEmitter")
kickImpact.Name = "KickImpact"
kickImpact.Texture = "rbxassetid://[KICK_IMPACT_TEXTURE_ID]" -- REPLACE WITH ACTUAL ID
kickImpact.Color = ColorSequence.new(Color3.new(1, 0.5, 0))
kickImpact.Transparency = NumberSequence.new(0, 1)
kickImpact.Size = NumberSequence.new(1, 3)
kickImpact.Lifetime = NumberRange.new(0.8, 1.5)
kickImpact.Rate = 15
kickImpact.Speed = NumberRange.new(8, 15)
kickImpact.Acceleration = Vector3.new(0, -15, 0)
kickImpact.Parent = particles

-- Blood particles
local bloodParticles = Instance.new("ParticleEmitter")
bloodParticles.Name = "Blood"
bloodParticles.Texture = "rbxassetid://[BLOOD_TEXTURE_ID]" -- REPLACE WITH ACTUAL ID
bloodParticles.Color = ColorSequence.new(Color3.new(0.8, 0, 0))
bloodParticles.Transparency = NumberSequence.new(0, 1)
bloodParticles.Size = NumberSequence.new(0.3, 1)
bloodParticles.Lifetime = NumberRange.new(1, 2)
bloodParticles.Rate = 20
bloodParticles.Speed = NumberRange.new(3, 8)
bloodParticles.Acceleration = Vector3.new(0, -5, 0)
bloodParticles.Parent = particles

-- Capture particles
local captureParticles = Instance.new("ParticleEmitter")
captureParticles.Name = "Capture"
captureParticles.Texture = "rbxassetid://[CAPTURE_TEXTURE_ID]" -- REPLACE WITH ACTUAL ID
captureParticles.Color = ColorSequence.new(Color3.new(0, 0.5, 1))
captureParticles.Transparency = NumberSequence.new(0, 1)
captureParticles.Size = NumberSequence.new(0.5, 2.5)
captureParticles.Lifetime = NumberRange.new(2, 3)
captureParticles.Rate = 5
captureParticles.Speed = NumberRange.new(2, 5)
captureParticles.Acceleration = Vector3.new(0, -2, 0)
captureParticles.Parent = particles

-- Explosion particles (for emergency exit)
local explosionParticles = Instance.new("ParticleEmitter")
explosionParticles.Name = "Explosion"
explosionParticles.Texture = "rbxassetid://[EXPLOSION_TEXTURE_ID]" -- REPLACE WITH ACTUAL ID
explosionParticles.Color = ColorSequence.new(Color3.new(1, 0.8, 0))
explosionParticles.Transparency = NumberSequence.new(0, 1)
explosionParticles.Size = NumberSequence.new(2, 8)
explosionParticles.Lifetime = NumberRange.new(1, 3)
explosionParticles.Rate = 50
explosionParticles.Speed = NumberRange.new(20, 40)
explosionParticles.Acceleration = Vector3.new(0, -20, 0)
explosionParticles.Parent = particles

-- Visual effects
local effects = Instance.new("Folder")
effects.Name = "Effects"
effects.Parent = assets

-- Screen shake effect
local screenShake = Instance.new("NumberValue")
screenShake.Name = "ScreenShake"
screenShake.Value = 0
screenShake.Parent = effects

-- Flash effect
local flashEffect = Instance.new("Color3Value")
flashEffect.Name = "FlashEffect"
flashEffect.Value = Color3.new(1, 1, 1)
flashEffect.Parent = effects

-- Slow motion effect
local slowMotion = Instance.new("NumberValue")
slowMotion.Name = "SlowMotion"
slowMotion.Value = 1
slowMotion.Parent = effects

-- Model assets
local models = Instance.new("Folder")
models.Name = "Models"
models.Parent = assets

-- Weapon models (unarmed combat)
local fistModel = Instance.new("Model")
fistModel.Name = "Fist"
fistModel.Parent = models

-- Create fist mesh
local fistMesh = Instance.new("Part")
fistMesh.Name = "FistMesh"
fistMesh.Size = Vector3.new(0.5, 0.5, 0.5)
fistMesh.Material = Enum.Material.Plastic
fistMesh.BrickColor = BrickColor.new("Light orange")
fistMesh.Parent = fistModel

-- Create foot mesh for kicks
local footModel = Instance.new("Model")
footModel.Name = "Foot"
footModel.Parent = models

local footMesh = Instance.new("Part")
footMesh.Name = "FootMesh"
footMesh.Size = Vector3.new(0.8, 0.3, 1.2)
footMesh.Material = Enum.Material.Plastic
footMesh.BrickColor = BrickColor.new("Black")
footMesh.Parent = footModel

-- Create capture device model
local captureDevice = Instance.new("Model")
captureDevice.Name = "CaptureDevice"
captureDevice.Parent = models

local captureMesh = Instance.new("Part")
captureMesh.Name = "CaptureMesh"
captureMesh.Size = Vector3.new(0.3, 0.3, 2)
captureMesh.Material = Enum.Material.Neon
captureMesh.BrickColor = BrickColor.new("Cyan")
captureMesh.Transparency = 0.5
captureMesh.Parent = captureDevice

-- Asset management functions
local function playSound(soundName, parent)
    local sound = sounds:FindFirstChild(soundName)
    if sound then
        local newSound = sound:Clone()
        newSound.Parent = parent or workspace
        newSound:Play()
        newSound.Ended:Connect(function()
            newSound:Destroy()
        end)
    end
end

local function createParticles(particleName, parent)
    local particle = particles:FindFirstChild(particleName)
    if particle then
        local newParticle = particle:Clone()
        newParticle.Parent = parent
        return newParticle
    end
    return nil
end

local function applyEffect(effectName, value)
    local effect = effects:FindFirstChild(effectName)
    if effect then
        effect.Value = value or 1
    end
end

-- Export asset management functions
_G.GameAssets = {
    playSound = playSound,
    createParticles = createParticles,
    applyEffect = applyEffect,
    sounds = sounds,
    particles = particles,
    effects = effects,
    models = models
}

print("Game assets loaded successfully!")
print("⚠️  Remember to replace [ASSET_ID] placeholders with actual Roblox asset IDs!")
