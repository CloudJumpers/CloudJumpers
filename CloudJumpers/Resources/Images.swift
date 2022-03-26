//
//  Images.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 15/3/22.
//

import UIKit

enum Images: String {
    case player
    case background
    case innerStick
    case outerStick
    case freeze
    case confuse

    var name: String {
        rawValue
    }

    var image: UIImage? {
        UIImage(named: rawValue)
    }
}
