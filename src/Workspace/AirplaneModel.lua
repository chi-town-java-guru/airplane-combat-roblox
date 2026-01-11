-- Airplane Model Script
-- Creates the main airplane structure for the game

local Workspace = game:GetService("Workspace")

-- Create airplane model
local airplane = Instance.new("Model")
airplane.Name = "Airplane"
airplane.Parent = Workspace

-- Create airplane fuselage (main body)
local fuselage = Instance.new("Part")
fuselage.Name = "Fuselage"
fuselage.Size = Vector3.new(50, 8, 8)
fuselage.Position = Vector3.new(0, 10, 0)
fuselage.BrickColor = BrickColor.new("Light stone grey")
fuselage.Material = Enum.Material.Metal
fuselage.Anchored = true
fuselage.Parent = airplane

-- Create airplane floor
local floor = Instance.new("Part")
floor.Name = "Floor"
floor.Size = Vector3.new(48, 1, 6)
floor.Position = Vector3.new(0, 6, 0)
floor.BrickColor = BrickColor.new("Medium stone grey")
floor.Material = Enum.Material.Metal
floor.Anchored = true
floor.Parent = airplane

-- Create airplane ceiling
local ceiling = Instance.new("Part")
ceiling.Name = "Ceiling"
ceiling.Size = Vector3.new(48, 1, 6)
ceiling.Position = Vector3.new(0, 14, 0)
ceiling.BrickColor = BrickColor.new("Light stone grey")
ceiling.Material = Enum.Material.Metal
ceiling.Anchored = true
ceiling.Parent = airplane

-- Create airplane walls
local leftWall = Instance.new("Part")
leftWall.Name = "LeftWall"
leftWall.Size = Vector3.new(48, 8, 1)
leftWall.Position = Vector3.new(0, 10, -3)
leftWall.BrickColor = BrickColor.new("Light stone grey")
leftWall.Material = Enum.Material.Metal
leftWall.Anchored = true
leftWall.Parent = airplane

local rightWall = Instance.new("Part")
rightWall.Name = "RightWall"
rightWall.Size = Vector3.new(48, 8, 1)
rightWall.Position = Vector3.new(0, 10, 3)
rightWall.BrickColor = BrickColor.new("Light stone grey")
rightWall.Material = Enum.Material.Metal
rightWall.Anchored = true
rightWall.Parent = airplane

-- Create airplane front wall (with door)
local frontWall = Instance.new("Part")
frontWall.Name = "FrontWall"
frontWall.Size = Vector3.new(1, 8, 6)
frontWall.Position = Vector3.new(24, 10, 0)
frontWall.BrickColor = BrickColor.new("Light stone grey")
frontWall.Material = Enum.Material.Metal
frontWall.Anchored = true
frontWall.Parent = airplane

-- Create airplane back wall (with emergency exit)
local backWall = Instance.new("Part")
backWall.Name = "BackWall"
backWall.Size = Vector3.new(1, 8, 6)
backWall.Position = Vector3.new(-24, 10, 0)
backWall.BrickColor = BrickColor.new("Light stone grey")
backWall.Material = Enum.Material.Metal
backWall.Anchored = true
backWall.Parent = airplane

-- Create emergency exit door
local emergencyExit = Instance.new("Part")
emergencyExit.Name = "EmergencyExit"
emergencyExit.Size = Vector3.new(2, 4, 1)
emergencyExit.Position = Vector3.new(-24, 8, 0)
emergencyExit.BrickColor = BrickColor.new("Bright red")
emergencyExit.Material = Enum.Material.Metal
emergencyExit.Anchored = true
emergencyExit.CanCollide = false
emergencyExit.Parent = airplane

-- Create seats
local seats = {}
for i = 1, 8 do
    for j = 1, 2 do
        local seat = Instance.new("Seat")
        seat.Name = "Seat_" .. i .. "_" .. j
        seat.Size = Vector3.new(2, 1, 2)
        seat.Position = Vector3.new(-20 + (i-1) * 5, 6.5, j == 1 and -1.5 or 1.5)
        seat.BrickColor = BrickColor.new("Dark blue")
        seat.Material = Enum.Material.Fabric
        seat.Anchored = true
        seat.Parent = airplane
        table.insert(seats, seat)
    end
end

-- Create airplane windows
local windows = {}
for i = 1, 8 do
    for j = 1, 2 do
        local window = Instance.new("Part")
        window.Name = "Window_" .. i .. "_" .. j
        window.Size = Vector3.new(1, 2, 0.5)
        window.Position = Vector3.new(-20 + (i-1) * 5, 11, j == 1 and -3.5 or 3.5)
        window.BrickColor = BrickColor.new("Light blue")
        window.Material = Enum.Material.Glass
        window.Transparency = 0.3
        window.Anchored = true
        window.CanCollide = false
        window.Parent = airplane
        table.insert(windows, window)
    end
end

-- Add collision groups for proper physics
local PhysicsService = game:GetService("PhysicsService")
PhysicsService:CreateCollisionGroup("Airplane")
PhysicsService:CreateCollisionGroup("Players")
PhysicsService:CollisionGroupSetCollidable("Airplane", "Airplane", false)
PhysicsService:CollisionGroupSetCollidable("Players", "Airplane", true)

-- Set collision groups for airplane parts
for _, part in ipairs(airplane:GetDescendants()) do
    if part:IsA("BasePart") then
        PhysicsService:SetPartCollisionGroup(part, "Airplane")
    end
end

print("Airplane model created successfully!")
