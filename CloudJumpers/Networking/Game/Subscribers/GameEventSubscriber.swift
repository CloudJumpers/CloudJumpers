//
//  GameEventSubscriber.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 24/3/22.
//

import Foundation

protocol GameEventSubscriber: AnyObject {
    var eventManager: EventManager? { get set }
}
