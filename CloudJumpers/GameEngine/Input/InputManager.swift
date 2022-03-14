//
//  InputManager.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/11/22.
//

import Foundation
import Combine
import CoreGraphics
import SpriteKit

class InputManager {
    private let inputSubject = PassthroughSubject<Input, Never>()
    var inputPublisher: AnyPublisher<Input, Never> {
        inputSubject.eraseToAnyPublisher()
    }

    func parseInput(input: Input) {
        // Process input here
        inputSubject.send(input)
    }

    func processTouchBegan(at location: CGPoint) {
        let input = Input(inputType: .touchBegan(at: location))
        inputSubject.send(input)
    }

    func processTouchMoved(at location: CGPoint) {
        let input = Input(inputType: .touchMoved(at: location))
        inputSubject.send(input)
    }

    func processTouchEnded(at location: CGPoint) {
        let input = Input(inputType: .touchEnded(at: location))
        inputSubject.send(input)
    }

}
