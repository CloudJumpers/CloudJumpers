//
//  InputManager.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/11/22.
//

import Foundation
import Combine

class InputManager {
    private let inputSubject = PassthroughSubject<Input, Never>()
    var inputPublisher: AnyPublisher<Input, Never> {
        inputSubject.eraseToAnyPublisher()
    }
    
    func parseInput() {
        // Process input here
    }

}

