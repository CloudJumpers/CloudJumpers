//
//  InputManager.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/11/22.
//

import Combine
import SpriteKit

class InputManager {
    private let inputSubject = PassthroughSubject<Input, Never>()
    var inputPublisher: AnyPublisher<Input, Never> {
        inputSubject.eraseToAnyPublisher()
    }

    func parseInput(input: Input) {
        inputSubject.send(input)
    }
}
