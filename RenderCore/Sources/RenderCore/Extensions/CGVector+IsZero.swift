//
//  File.swift
//  
//
//  Created by Phillmont Muktar on 18/4/22.
//

import CoreGraphics

extension CGVector {
    var isZero: Bool {
        dx.isZero && dy.isZero
    }
}
