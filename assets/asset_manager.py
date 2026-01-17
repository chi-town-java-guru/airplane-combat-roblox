#!/usr/bin/env python3
"""
Asset Management Script for Airplane Combat Roblox Game
This script helps organize and manage game assets.
"""

import os
import json
from pathlib import Path

class AssetManager:
    def __init__(self, project_root):
        self.project_root = Path(project_root)
        self.assets_dir = self.project_root / "assets"
        self.audio_dir = self.assets_dir / "audio"
        self.images_dir = self.assets_dir / "images"
        self.game_assets_file = self.project_root / "src" / "ReplicatedStorage" / "GameAssets.lua"
        
    def check_assets(self):
        """Check which assets are missing"""
        required_audio = [
            "punch.mp3", "kick.mp3", "capture.mp3", "damage.mp3", "death.mp3",
            "airplane_ambient.mp3", "emergency_alarm.mp3", "button_click.mp3",
            "victory.mp3", "defeat.mp3"
        ]
        
        required_images = [
            "punch_impact.png", "kick_impact.png", "blood_particles.png",
            "capture_particles.png", "explosion_particles.png"
        ]
        
        missing_audio = []
        missing_images = []
        
        for audio_file in required_audio:
            if not (self.audio_dir / audio_file).exists():
                missing_audio.append(audio_file)
                
        for image_file in required_images:
            if not (self.images_dir / image_file).exists():
                missing_images.append(image_file)
                
        return missing_audio, missing_images
    
    def generate_asset_report(self):
        """Generate a report of current asset status"""
        missing_audio, missing_images = self.check_assets()
        
        print("=== Asset Status Report ===")
        print(f"Audio directory: {self.audio_dir}")
        print(f"Images directory: {self.images_dir}")
        print()
        
        if missing_audio:
            print(f"Missing Audio Files ({len(missing_audio)}):")
            for audio in missing_audio:
                print(f"  - {audio}")
        else:
            print("✓ All audio files present")
            
        print()
        
        if missing_images:
            print(f"Missing Image Files ({len(missing_images)}):")
            for image in missing_images:
                print(f"  - {image}")
        else:
            print("✓ All image files present")
            
        return len(missing_audio) == 0 and len(missing_images) == 0
    
    def create_asset_mapping(self):
        """Create a mapping of asset names to file paths"""
        asset_mapping = {
            "sounds": {
                "Punch": "rbxasset://audio/punch.mp3",
                "Kick": "rbxasset://audio/kick.mp3",
                "Capture": "rbxasset://audio/capture.mp3",
                "Damage": "rbxasset://audio/damage.mp3",
                "Death": "rbxasset://audio/death.mp3",
                "AirplaneAmbient": "rbxasset://audio/airplane_ambient.mp3",
                "EmergencyAlarm": "rbxasset://audio/emergency_alarm.mp3",
                "ButtonClick": "rbxasset://audio/button_click.mp3",
                "Victory": "rbxasset://audio/victory.mp3",
                "Defeat": "rbxasset://audio/defeat.mp3"
            },
            "particles": {
                "PunchImpact": "rbxasset://images/punch_impact.png",
                "KickImpact": "rbxasset://images/kick_impact.png",
                "Blood": "rbxasset://images/blood_particles.png",
                "Capture": "rbxasset://images/capture_particles.png",
                "Explosion": "rbxasset://images/explosion_particles.png"
            }
        }
        
        return asset_mapping
    
    def save_asset_config(self):
        """Save asset configuration to JSON file"""
        mapping = self.create_asset_mapping()
        config_file = self.assets_dir / "asset_config.json"
        
        with open(config_file, 'w') as f:
            json.dump(mapping, f, indent=2)
            
        print(f"Asset configuration saved to: {config_file}")

def main():
    # Get project root (assuming script is run from assets directory)
    project_root = Path(__file__).parent.parent
    
    manager = AssetManager(project_root)
    
    print("Airplane Combat - Asset Manager")
    print("=" * 40)
    
    # Generate asset report
    all_present = manager.generate_asset_report()
    
    # Save asset configuration
    manager.save_asset_config()
    
    if all_present:
        print("\n✓ All assets are ready!")
    else:
        print("\n⚠ Some assets are missing. Please download them using the guide.")
        print("See: ASSET_DOWNLOAD_GUIDE.md")

if __name__ == "__main__":
    main()
