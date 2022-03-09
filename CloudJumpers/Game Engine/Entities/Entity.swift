//
//  Entity.swift
//  Cloud Jumpers
//
//  Created by Trong Tan on 3/8/22.
//

import Foundation

protocol Entity: Hashable {
    var id: UUID { get set }
}
