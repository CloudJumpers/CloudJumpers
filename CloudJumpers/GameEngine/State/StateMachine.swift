//
//  StateMachine.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/19/22.
//

import Combine
import Foundation

class StateMachine {
    private let endSubject = PassthroughSubject<TimeTrialGameEndState, Never>()
    var endPublisher: AnyPublisher<TimeTrialGameEndState, Never> {
        endSubject.eraseToAnyPublisher()
    }

    func transition(to state: GameState) {
        switch state {
        case .playing:
            return
        case .timeTrialEnd(let time):
            endSubject.send(TimeTrialGameEndState(playerEndTime: time))
        }
    }
}
