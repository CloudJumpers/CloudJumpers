//
//  Images.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 15/3/22.
//

import UIKit

enum Images: String {
    case player
    case innerStick
    case outerStick

    var name: String {
        rawValue
    }

    var image: UIImage? {
        UIImage(named: rawValue)
    }
}
