//
//  SoundManager.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 29/3/22.
//

import AVFAudio

class SoundManager {
    static let instance = SoundManager()
    private var players: [Sounds: AVAudioPlayer]

    init() {
        players = [:]
    }

    func play(_ sound: Sounds, loopsBy loops: Int = 0) {
        if players[sound] == nil {
            players[sound] = sound.player
        }

        players[sound]?.numberOfLoops = loops
        players[sound]?.play()
    }

    func pause(_ sound: Sounds) {
        players[sound]?.pause()
    }

    func stop(_ sound: Sounds) {
        players[sound]?.stop()
    }

    func stopAll() {
        players.values.forEach { $0.stop() }
    }
}
