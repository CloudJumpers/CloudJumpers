//
//  Sounds.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 29/3/22.
//

import AVFAudio

enum Sounds: String {
    case walking = "walking.wav"
    case jumpFoot = "jump-foot.wav"
    case jumpCape = "jump-cape.wav"
    case endLose = "end-lose.wav"
    case endWin = "end-win.wav"
    case respawned = "respawned.wav"
    case background = "ui-bgm.wav"
    case pause = "ui-pause.wav"

    var player: AVAudioPlayer? {
        try? AVAudioPlayer(contentsOf: url)
    }

    private var url: URL {
        let path = Bundle.main.path(forResource: rawValue, ofType: nil)
        return URL(fileURLWithPath: path ?? rawValue)
    }
}
