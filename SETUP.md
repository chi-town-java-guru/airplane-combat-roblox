# Roblox Airplane Combat Game - Setup Instructions

## Overview
This is a complete Roblox game where players fight bad people inside an airplane. Players can punch, kick, capture enemies, or kick them out of the plane through the emergency exit.

## Game Features
- **Airplane Environment**: Fully modeled airplane interior with seats, walls, and emergency exit
- **Combat System**: Punch (F key), Kick (G key), Capture (H key)
- **Enemy AI**: Intelligent enemies that patrol, chase, and attack players
- **Win Conditions**: Eliminate all enemies or survive until the plane lands
- **UI System**: Health bars, controls help, and game status displays

## Installation

### Prerequisites
- Roblox Studio (latest version)
- Roblox account with game creation permissions

### Step 1: Create New Roblox Game
1. Open Roblox Studio
2. Click "Create New Game"
3. Choose "Baseplate" template
4. Name your game "Airplane Combat Game"
5. Save the game

### Step 2: Import Game Files
1. Copy all files from the `src/` directory to your Roblox game's corresponding folders:
   - `src/ServerScriptService/` → `ServerScriptService/`
   - `src/StarterPlayer/StarterPlayerScripts/` → `StarterPlayer/StarterPlayerScripts/`
   - `src/StarterPlayer/StarterCharacterScripts/` → `StarterPlayer/StarterCharacterScripts/`
   - `src/StarterGui/` → `StarterGui/`
   - `src/Workspace/` → `Workspace/`
   - `src/ReplicatedFirst/` → `ReplicatedFirst/`
   - `src/ReplicatedStorage/` → `ReplicatedStorage/`
   - `src/Lighting/` → `Lighting/`

### Step 3: Configure Game Settings
1. In Roblox Studio, go to Game Settings
2. Set "Max Players" to 8
3. Enable "Team Create" if working with others
4. Set "Genre" to "Fighting"

### Step 4: Test the Game
1. Press "Play" in Roblox Studio
2. The airplane should spawn automatically
3. Use the controls to test combat:
   - **F** - Punch enemies (10 damage)
   - **G** - Kick enemies (15 damage)
   - **H** - Capture enemies (3 second restraint)

## Game Mechanics

### Combat System
- **Punch**: Quick attack with low damage, short cooldown
- **Kick**: Slower attack with higher damage, can kick enemies out near emergency exit
- **Capture**: Restrains enemy movement for 3 seconds

### Enemy AI
- Enemies patrol inside the airplane
- They chase players when detected (20 unit range)
- Attack players when in range (8 units)
- Have 100 health and deal 15 damage per attack

### Win Conditions
- Eliminate all enemy threats
- Kick enemies out through emergency exit
- Capture and restrain enemies
- Survive until the round ends (5 minutes)

## File Structure

```
Roblox Game/
├── ServerScriptService/
│   ├── AirplaneModel.lua          # Creates the airplane
│   ├── CombatSystem.lua           # Handles combat logic
│   ├── EnemyAI.lua                # Enemy behavior system
│   └── GameManager.lua            # Game state management
├── StarterPlayer/
│   ├── StarterPlayerScripts/
│   │   └── PlayerController.lua   # Player controls and movement
│   └── StarterCharacterScripts/
├── StarterGui/
│   └── GameUI.lua                 # User interface
├── ReplicatedFirst/
│   └── GameLoader.lua             # Client initialization
├── ReplicatedStorage/
│   └── RemoteEvents/             # Communication events
├── Workspace/
│   └── AirplaneModel.lua          # Airplane creation
└── Lighting/
```

## Customization

### Difficulty Settings
Edit these values in the scripts:
- `EnemyAI.lua`: Change `AGGRO_RANGE`, `ATTACK_RANGE`, `PATROL_SPEED`
- `CombatSystem.lua`: Modify damage values `PUNCH_DAMAGE`, `KICK_DAMAGE`
- `GameManager.lua`: Adjust `ROUND_DURATION`, `MIN_PLAYERS`

### Airplane Design
Modify `AirplaneModel.lua` to:
- Change airplane size and layout
- Add more seats or obstacles
- Modify emergency exit position

### Combat Balance
Adjust in `PlayerController.lua`:
- `PUNCH_RANGE`, `KICK_RANGE`, `CAPTURE_RANGE`
- Combat cooldowns and damage values

## Troubleshooting

### Common Issues
1. **Airplane doesn't spawn**: Check `AirplaneModel.lua` is in Workspace
2. **Combat not working**: Ensure `CombatSystem.lua` is in ServerScriptService
3. **UI not showing**: Verify `GameUI.lua` is in StarterGui
4. **Enemies not moving**: Check `EnemyAI.lua` is properly loaded

### Debug Tips
- Use `print()` statements to verify script execution
- Check Roblox Studio Output window for errors
- Test with multiple players using Team Create

## Publishing

1. Click "Publish to Roblox" in Roblox Studio
2. Fill in game description and tags
3. Set game to "Public" or "Friends Only"
4. Share the game link with others

## Support

For issues or questions:
1. Check the Roblox Developer Forum
2. Review script error messages
3. Test individual components separately

Enjoy your Airplane Combat Game!
