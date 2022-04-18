//
//  UIColor+RGBA.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 18/4/22.
//

import UIKit

typealias RGBA = (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)

extension UIColor {
    convenience init(from rgba: RGBA) {
        let r = rgba.r / 255.0
        let g = rgba.g / 255.0
        let b = rgba.b / 255.0
        self.init(red: r, green: g, blue: b, alpha: rgba.a)
    }
}
