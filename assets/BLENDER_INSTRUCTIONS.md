# Blender Automation Script for Roblox Airplane Models

## Quick Start Guide

### Step 1: Run the Python Script
1. Open Blender
2. Go to Scripting workspace
3. Open the Python console
4. Run: `exec(open("/path/to/create_models.py").read())`

Or:
1. In Blender, go to File > Scripts > Run Script
2. Select `create_models.py`

### Step 2: Export to Roblox
After running the script:
1. Select all objects (A key)
2. File > Export > FBX (.fbx)
3. Use these settings:
   - Scale: Apply Transform
   - Forward: -Z Forward  
   - Up: Y Up
   - Apply Modifiers: ✓
   - Include: Mesh, Materials
4. Save as `airplane_interior.fbx`

### Step 3: Import to Roblox Studio
1. Open Roblox Studio
2. Toolbox > Models > Import
3. Select your FBX file
4. Scale adjustment: Usually 0.01
5. Save as `.rbxm` model

## What the Script Creates

### Airplane Interior (Main Model)
- **Fuselage**: Main airplane body (50x8x8 studs)
- **Floor/ceiling/walls**: Complete interior structure
- **Emergency exit**: Red colored exit door
- **16 seats**: 8 rows × 2 seats each
- **16 windows**: Along both sides of airplane

### Character Rig
- **Humanoid structure**: Head, torso, arms, legs
- **Proper scaling**: Standard Roblox character size
- **Naming conventions**: Compatible with Roblox rigging

### Combat Tools
- **Fist**: Sphere for punch attacks
- **Foot**: Rectangle for kick attacks  
- **Capture device**: Cylinder with glow effect

### Environment Props
- **Luggage**: 3 luggage pieces
- **Oxygen masks**: 4 mask positions above seats

## Manual Modeling Instructions

If you prefer to model manually:

### 1. Setup Scene
```
File > New > General
Delete default cube
Scene Properties > Units > Metric
```

### 2. Create Fuselage
```
Add > Mesh > Cube
Scale: X=25, Y=4, Z=4
Add Modifiers: Subdivision Surface, Solidify
```

### 3. Add Interior Parts
Follow the detailed steps in MODELING_GUIDE.md

### 4. Materials
```
New Material > Basic Data
Metallic: 1.0 (for metal parts)
Roughness: 0.2
```

## Export Settings for Roblox

### FBX Export Settings
- **Scale**: Apply Transform
- **Transform**: Forward -Z, Up Y
- **Geometry**: Apply Modifiers ✓
- **Include**: Mesh, Materials
- **Mesh**: Smoothing: Face

### Material Conversion
Roblox will convert Blender materials to:
- Metallic > Roblox Metal material
- High roughness > Roblox Plastic
- Transparent > Roblox Glass

## Performance Optimization

### Polygon Count Targets
- Airplane interior: < 5,000 polygons
- Character rig: < 2,000 polygons  
- Combat tools: < 500 polygons each
- Environment props: < 1,000 polygons total

### Optimization Tips
1. Use subdivision surfaces sparingly
2. Remove hidden interior faces
3. Combine small details into textures
4. Keep collision meshes simple

## Testing in Roblox

### Import Test
1. Import to Roblox Studio
2. Check scale (should match stud measurements)
3. Test collision groups
4. Verify materials appear correctly

### Integration Test
1. Replace existing AirplaneModel.lua parts
2. Test player movement
3. Verify enemy AI navigation
4. Check combat interactions

## Troubleshooting

### Common Issues
- **Scale too large/small**: Adjust FBX export scale
- **Materials not showing**: Check material names in Roblox
- **Collision issues**: Verify collision groups
- **Performance lag**: Reduce polygon count

### Solutions
1. Re-export with different scale settings
2. Apply materials in Roblox Studio manually
3. Use Roblox collision groups system
4. Simplify geometry in Blender

## Next Steps

After creating the base models:
1. **Add details**: Textures, lighting, accessories
2. **Create variants**: Different airplane configurations
3. **Add animations**: Export animation data
4. **Optimize**: Performance testing and refinement

Run the script now to generate your complete airplane interior model!
