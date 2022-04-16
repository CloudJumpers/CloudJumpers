//
//  Images.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 15/3/22.
//

import UIKit

enum Images: String {
    case innerStick
    case outerStick
    case jumpingSprite

    var name: String {
        rawValue
    }

    var image: UIImage? {
        UIImage(named: rawValue)
    }
}
