import bpy
import bmesh
import math

# Clear existing objects
bpy.ops.object.select_all(action='SELECT')
bpy.ops.object.delete()

# Set units to Metric
bpy.context.scene.unit_settings.system = 'METRIC'
bpy.context.scene.unit_settings.scale_length = 1.0

# Create airplane interior
def create_airplane_interior():
    # Fuselage
    bpy.ops.mesh.primitive_cube_add()
    fuselage = bpy.context.active_object
    fuselage.name = "Fuselage"
    fuselage.scale = (25, 4, 4)  # 50x8x8 studs
    fuselage.location = (0, 0, 0)
    
    # Add subdivision surface
    bpy.ops.object.modifier_add(type='SUBSURF')
    bpy.ops.object.modifier_add(type='SOLIDIFY')
    fuselage.modifiers["Solidify"].thickness = 0.2
    
    # Floor
    bpy.ops.mesh.primitive_plane_add()
    floor = bpy.context.active_object
    floor.name = "Floor"
    floor.scale = (24, 3, 1)
    floor.location = (0, -2, 0)
    
    # Ceiling
    bpy.ops.mesh.primitive_plane_add()
    ceiling = bpy.context.active_object
    ceiling.name = "Ceiling"
    ceiling.scale = (24, 3, 1)
    ceiling.location = (0, 2, 0)
    
    # Left Wall
    bpy.ops.mesh.primitive_cube_add()
    left_wall = bpy.context.active_object
    left_wall.name = "LeftWall"
    left_wall.scale = (24, 4, 0.5)
    left_wall.location = (0, 0, -3)
    
    # Right Wall
    bpy.ops.mesh.primitive_cube_add()
    right_wall = bpy.context.active_object
    right_wall.name = "RightWall"
    right_wall.scale = (24, 4, 0.5)
    right_wall.location = (0, 0, 3)
    
    # Front Wall
    bpy.ops.mesh.primitive_cube_add()
    front_wall = bpy.context.active_object
    front_wall.name = "FrontWall"
    front_wall.scale = (0.5, 4, 3)
    front_wall.location = (24, 0, 0)
    
    # Back Wall
    bpy.ops.mesh.primitive_cube_add()
    back_wall = bpy.context.active_object
    back_wall.name = "BackWall"
    back_wall.scale = (0.5, 4, 3)
    back_wall.location = (-24, 0, 0)
    
    # Emergency Exit
    bpy.ops.mesh.primitive_cube_add()
    emergency_exit = bpy.context.active_object
    emergency_exit.name = "EmergencyExit"
    emergency_exit.scale = (1, 2, 1)
    emergency_exit.location = (-24, 0, 0)
    
    return fuselage, floor, ceiling, left_wall, right_wall, front_wall, back_wall, emergency_exit

def create_seats():
    seats = []
    for row in range(8):
        for seat_pos in [-1.5, 1.5]:
            # Seat base
            bpy.ops.mesh.primitive_cube_add()
            seat_base = bpy.context.active_object
            seat_base.name = f"Seat_{row+1}_{seat_pos == -1.5 and 'A' or 'B'}_Base"
            seat_base.scale = (1, 0.5, 1)
            seat_base.location = (-20 + row * 5, -1.5, seat_pos)
            
            # Seat backrest
            bpy.ops.mesh.primitive_cube_add()
            seat_back = bpy.context.active_object
            seat_back.name = f"Seat_{row+1}_{seat_pos == -1.5 and 'A' or 'B'}_Back"
            seat_back.scale = (1, 0.1, 1)
            seat_back.location = (-20 + row * 5, -1.0, seat_pos)
            
            seats.extend([seat_base, seat_back])
    
    return seats

def create_windows():
    windows = []
    for i in range(8):
        for side in [-3.5, 3.5]:
            bpy.ops.mesh.primitive_cube_add()
            window = bpy.context.active_object
            window.name = f"Window_{i+1}_{side == -3.5 and 'L' or 'R'}"
            window.scale = (0.5, 2, 0.25)
            window.location = (-20 + i * 5, 1, side)
            windows.append(window)
    
    return windows

def create_character_rig():
    # Simple humanoid rig
    bpy.ops.mesh.primitive_uv_sphere_add()
    head = bpy.context.active_object
    head.name = "Head"
    head.scale = (1, 1, 1)
    head.location = (0, 1.5, 0)
    
    bpy.ops.mesh.primitive_cube_add()
    torso = bpy.context.active_object
    torso.name = "Torso"
    torso.scale = (1, 1.5, 0.5)
    torso.location = (0, 0, 0)
    
    bpy.ops.mesh.primitive_cube_add()
    left_arm = bpy.context.active_object
    left_arm.name = "LeftArm"
    left_arm.scale = (0.3, 1.2, 0.3)
    left_arm.location = (-1.2, 0.3, 0)
    
    bpy.ops.mesh.primitive_cube_add()
    right_arm = bpy.context.active_object
    right_arm.name = "RightArm"
    right_arm.scale = (0.3, 1.2, 0.3)
    right_arm.location = (1.2, 0.3, 0)
    
    bpy.ops.mesh.primitive_cube_add()
    left_leg = bpy.context.active_object
    left_leg.name = "LeftLeg"
    left_leg.scale = (0.3, 1.5, 0.3)
    left_leg.location = (-0.5, -1.5, 0)
    
    bpy.ops.mesh.primitive_cube_add()
    right_leg = bpy.context.active_object
    right_leg.name = "RightLeg"
    right_leg.scale = (0.3, 1.5, 0.3)
    right_leg.location = (0.5, -1.5, 0)
    
    return head, torso, left_arm, right_arm, left_leg, right_leg

def create_combat_tools():
    tools = []
    
    # Fist
    bpy.ops.mesh.primitive_uv_sphere_add()
    fist = bpy.context.active_object
    fist.name = "Fist"
    fist.scale = (0.3, 0.3, 0.3)
    fist.location = (0, 0, 0)
    tools.append(fist)
    
    # Foot
    bpy.ops.mesh.primitive_cube_add()
    foot = bpy.context.active_object
    foot.name = "Foot"
    foot.scale = (0.4, 0.15, 0.6)
    foot.location = (0, 0, 0)
    tools.append(foot)
    
    # Capture Device
    bpy.ops.mesh.primitive_cylinder_add()
    capture = bpy.context.active_object
    capture.name = "CaptureDevice"
    capture.scale = (0.15, 2, 0.15)
    capture.location = (0, 0, 0)
    tools.append(capture)
    
    return tools

def create_environment_props():
    props = []
    
    # Luggage
    for i in range(3):
        bpy.ops.mesh.primitive_cube_add()
        luggage = bpy.context.active_object
        luggage.name = f"Luggage_{i+1}"
        luggage.scale = (1, 0.6, 0.4)
        luggage.location = (10 + i * 2, -1.5, 0)
        props.append(luggage)
    
    # Oxygen Masks
    for i in range(4):
        bpy.ops.mesh.primitive_uv_sphere_add()
        mask = bpy.context.active_object
        mask.name = f"OxygenMask_{i+1}"
        mask.scale = (0.2, 0.2, 0.2)
        mask.location = (-15 + i * 5, 1.5, 2)
        props.append(mask)
    
    return props

# Create all models
print("Creating airplane interior...")
airplane_parts = create_airplane_interior()

print("Creating seats...")
seats = create_seats()

print("Creating windows...")
windows = create_windows()

print("Creating character rig...")
character_parts = create_character_rig()

print("Creating combat tools...")
tools = create_combat_tools()

print("Creating environment props...")
props = create_environment_props()

print("All models created successfully!")
print(f"Total objects created: {len(bpy.data.objects)}")

# Select all objects for export
bpy.ops.object.select_all(action='SELECT')

print("Ready to export to FBX for Roblox import!")
