//
//  EventDelegate.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/20/22.
//

import Foundation

protocol EventDelegate: AnyObject {
    func event(add event: Event)
}
