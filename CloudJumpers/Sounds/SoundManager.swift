//
//  SoundManager.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 29/3/22.
//

import AVFAudio

class SoundManager {
    private static let enabled = false
    static let instance = SoundManager()
    private var players: [Sounds: AVAudioPlayer]

    private init() {
        players = [:]
    }

    func play(_ sound: Sounds, loopsBy loops: Int = 0) {
        guard Self.enabled else {
            return
        }

        if players[sound] == nil {
            players[sound] = sound.player
        }

        players[sound]?.numberOfLoops = loops
        players[sound]?.play()
    }

    func pause(_ sound: Sounds) {
        guard Self.enabled else {
            return
        }

        players[sound]?.pause()
    }

    func stop(_ sound: Sounds) {
        guard Self.enabled else {
            return
        }

        players[sound]?.stop()
    }

    func stopAll() {
        guard Self.enabled else {
            return
        }

        players.values.forEach { $0.stop() }
    }
}
