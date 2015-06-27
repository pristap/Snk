
//  Created by Sanjay Madan on June 19, 2015
//  Copyright (c) 2015 mowglii.com

import Cocoa

// SnkAudio manages sound effects and music.
// SharedAudio is a global instance of SnkAudio 
// to be used throughout the app.

let SharedAudio = SnkAudio()

final class SnkAudio: NSObject {
    
    // Map sound filenames to sounds.
    var sounds = [String: NSSound]()
    
    // User preferences to enable sounds and music. What we
    // will really do is mute or unmute the sound so that
    // it can be resumed if the value is changed midstream.
    var soundsEnabled = true
    var musicEnabled: Bool = true {
        didSet {
            guard let music = music else { return }
            music.volume = musicEnabled ? musicVolume : 0
        }
    }
    
    // Currently playing sound or music.
    var sound: NSSound? = nil
    var music: NSSound? = nil
    
    // Need to remember music volume in case we
    // disable and then re-enable music.
    var musicVolume: Float = 1
    
    override init() {
        super.init()
        
        // Bind our soundsEnabled and musicEnabled
        // properties to the corresponding defaults
        // which the user can change at any time.
        
        self.bind("soundsEnabled", toObject: NSUserDefaultsController.sharedUserDefaultsController(), withKeyPath: "values." + kEnableSoundsKey, options: nil)
        self.bind("musicEnabled", toObject: NSUserDefaultsController.sharedUserDefaultsController(), withKeyPath: "values." + kEnableMusicKey, options: nil)
    }
    
    func loadSounds() {
        
        // Populate the sounds dictionary with loaded 
        // sounds so we can play them instantly later.
        
        for filePath in [kSoundStartup, kSoundHover, kSoundStartGame, kSoundFoodExposion, kSoundAnimateTo3D, kSoundRotateBoard, kSoundSpinBoard, kSoundCrash, kSoundGameOver, kSoundOk] {
            sounds[filePath] = NSSound(named: filePath)!
        }
    }
    
    // Play or stop playing sounds and music...
    
    func playSound(filePath: String, volume: Float = 1) {
        sound = sounds[filePath]
        guard let sound = sound else { return }
        sound.volume = soundsEnabled ? volume : 0
        if sound.playing {
            sound.stop()
        }
        sound.play()
    }
    
    func playMusic(filePath: String, volume: Float = 1, loop: Bool = false) {
        stopMusic()
        music = NSSound(named: filePath)
        guard let music = music else { return }
        music.volume = musicEnabled ? volume : 0
        music.loops = loop
        music.play()
        musicVolume = volume
    }
    
    func stopMusic() {
        guard let music = music else { return }
        music.stop()
    }
    
    func stopEverything() {
        guard let sound = sound else { return }
        sound.stop()
        stopMusic()
    }
}