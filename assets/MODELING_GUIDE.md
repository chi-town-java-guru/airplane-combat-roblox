# Blender Modeling Guide - Roblox Airplane Game

## Prerequisites
- Blender 3.0+ installed
- Roblox Studio installed
- Basic understanding of 3D modeling

## Model 1: Airplane Interior

### Setup
1. Open Blender
2. Delete default cube
3. Set units to Metric (File > Scene Properties > Units > Metric)
4. Set scale: 1 Blender Unit = 1 Roblox Stud

### Airplane Fuselage
1. Add > Mesh > Cube
2. Scale to: X=25, Y=4, Z=4 (50x8x8 studs)
3. Add subdivision surface modifier
4. Add solidify modifier (thickness 0.2)
5. Apply materials

### Interior Floor
1. Add > Mesh > Plane
2. Scale to: X=24, Y=3 (48x6 studs)
3. Position at Y=-2
4. Add material: Metal/Carpet texture

### Ceiling
1. Duplicate floor (Shift+D)
2. Move to Y=2
3. Add material: Light metal

### Walls
1. Left wall: Add Cube, scale X=24, Y=4, Z=0.5, position Z=-3
2. Right wall: Duplicate, position Z=3
3. Front wall: Add Cube, scale X=0.5, Y=4, Z=3, position X=24
4. Back wall: Duplicate, position X=-24

### Emergency Exit
1. Add Cube, scale X=1, Y=2, Z=1
2. Position X=-24, Y=0, Z=0
3. Set material to Red/Emergency color

### Seats
1. Create seat prototype:
   - Base: Cube, scale X=1, Y=0.5, Z=1
   - Backrest: Cube, scale X=1, Y=0.1, Z=1, position Y=0.5
2. Duplicate and arrange in rows (8 rows, 2 seats per row)
3. Position: X from -20 to 15, Z at -1.5 and 1.5

### Windows
1. Add Cube, scale X=0.5, Y=2, Z=0.25
2. Position along walls every 5 units
3. Set material to Glass/Transparent

## Model 2: Character Rigs

### Player Character
1. Import reference humanoid (use Roblox R15 rig as reference)
2. Scale to standard Roblox character size
3. Add basic clothing/body parts
4. Ensure proper joint naming conventions

### Enemy Character
1. Duplicate player rig
2. Modify appearance (different colors, clothing)
3. Add enemy-specific features (red tint, different accessories)

## Model 3: Combat Tools

### Fist Model
1. Add Sphere, scale to 0.3
2. Add subdivision surface for smoothness
3. Position as hand attachment point

### Foot Model
1. Add Cube, scale X=0.4, Y=0.15, Z=0.6
2. Add edge loops for shape definition
3. Position as foot attachment point

### Capture Device
1. Add Cylinder, scale X=0.15, Y=2, Z=0.15
2. Add emission material (glowing effect)
3. Add small spheres at ends for energy effect

## Model 4: Environment Props

### Luggage
1. Add Cube, scale X=1, Y=0.6, Z=0.4
2. Add handle (small cylinder on top)
3. Add details with edge loops

### Oxygen Masks
1. Add Sphere, scale 0.2
2. Add tube (curved cylinder)
3. Position above seats

### Food Trays
1. Add Cube, scale X=0.8, Y=0.05, Z=0.6
2. Add compartment dividers

## Export Instructions

### For Roblox Studio
1. Select all objects for export
2. File > Export > FBX (.fbx)
3. Settings:
   - Scale: Apply Transform
   - Forward: -Z Forward
   - Up: Y Up
   - Apply Modifiers: Checked
   - Include: Mesh, Materials
4. Save as .fbx file

### Import to Roblox
1. Open Roblox Studio
2. Toolbox > Models > Import
3. Select .fbx file
4. Adjust scale if needed (usually 0.01)
5. Save as .rbxm model

## Material Guidelines

### Roblox Materials
- Metal: Use "Metal" material type
- Plastic: Use "Plastic" material type  
- Glass: Use "Glass" with transparency
- Fabric: Use "Fabric" for seats
- Neon: Use "Neon" for glowing parts

### Colors
- Airplane: Light stone grey, medium stone grey
- Emergency: Bright red
- Seats: Dark blue fabric
- Windows: Light blue glass
- UI elements: White/black contrast

## Naming Conventions
- Use descriptive names: "AirplaneFuselage", "Seat_01", "EmergencyExit"
- Group related parts: "Seat_01_Base", "Seat_01_Backrest"
- Avoid special characters and spaces

## Performance Tips
- Keep polygon count reasonable (under 1000 per part)
- Use subdivision surfaces sparingly
- Combine small details into texture maps
- Remove unnecessary internal geometry

## Testing
1. Export test model frequently
2. Import to Roblox Studio
3. Check scale and positioning
4. Test collision groups
5. Verify material appearance

Save your work frequently and create backups!
