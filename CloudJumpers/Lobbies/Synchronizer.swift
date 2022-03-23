//
//  Synchronizer.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 23/3/22.
//

import Foundation

/// Synchronizer provides a mechanism for devices with
/// different receive times to start a game approximately
/// at the same time, ignoring clock drift between two devices.
struct Synchronizer {
    private var callbackAtMillis: Int
    private var timer: Timer?
    private var callback: (() -> Void)?

    init(serverTimeMillis: Int) {
        self.callbackAtMillis = serverTimeMillis + LobbyConstants.gameStartDelayMillis
    }

    mutating func setNewCallback( newCallback: @escaping () -> Void) {
        let localTime = LobbyUtils.getUnixTimestampMillis()

        guard localTime < callbackAtMillis else {
            newCallback()
            return
        }

        let delta = Double(callbackAtMillis - localTime) / 1_000
        let newTimer = Timer.scheduledTimer(
            withTimeInterval: TimeInterval(delta),
            repeats: false
        ) { _ in newCallback() }

        timer = newTimer
        callback = newCallback
    }

    mutating func updateSynchronizer(serverTimeMillis: Int) {
        guard let prevCallback = callback else {
            return
        }

        timer?.invalidate()
        callbackAtMillis = serverTimeMillis + LobbyConstants.gameStartDelayMillis
        setNewCallback(newCallback: prevCallback)
    }
}
