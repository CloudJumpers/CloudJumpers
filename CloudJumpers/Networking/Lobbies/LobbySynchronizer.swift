//
//  LobbySynchronizer.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 23/3/22.
//

import Foundation

/// LobbySynchronizer provides a mechanism for devices with
/// different receive times to start a game approximately
/// at the same time, ignoring relatively minor differences,
/// e.g. clock drift or any scheduling differences between two devices.
struct LobbySynchronizer {
    private var callback: (() -> Void)?
    private var callbackAtMillis: Int
    private var timer: Foundation.Timer?

    init(_ serverTimestampMillis: Int) {
        self.callbackAtMillis = serverTimestampMillis + LobbyConstants.gameStartDelayMillis
    }

    /// updateCallback allows specifying the callback function at a later point in time.
    /// This is because serverTimestamp and the callback function may not be available
    /// simultaneously, in order to facilitate instantiation.
    mutating func updateCallback(_ newCallback: @escaping () -> Void) {
        // Invalidate any previously set callback
        timer?.invalidate()

        let localTime = LobbyUtils.getUnixTimestampMillis()
        guard localTime < callbackAtMillis else {
            newCallback()
            return
        }

        let deltaInSeconds = Double(callbackAtMillis - localTime) / 1_000
        let newTimer = Foundation.Timer.scheduledTimer(
            withTimeInterval: TimeInterval(deltaInSeconds),
            repeats: false
        ) { _ in newCallback() }

        timer = newTimer
        callback = newCallback
    }

    /// updateServerRegisteredTime exists to facilitate adjustment of callback time,
    /// if needed. This is because some providers like Firebase provide two updates:
    /// An early estimate of what the server update time would be, followed by a second,
    /// actual timestamp.
    mutating func updateServerRegisteredTime(_ serverTimestampMillis: Int) {
        callbackAtMillis = serverTimestampMillis + LobbyConstants.gameStartDelayMillis

        guard let prevCallback = callback else {
            return
        }

        // Invalidate previously set callback
        timer?.invalidate()
        updateCallback(prevCallback)
    }
}
