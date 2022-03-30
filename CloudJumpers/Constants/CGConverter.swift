//
//  CGConverter.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/29/22.
//

import CoreGraphics

class CGConverter {
    static let sharedConverter = CGConverter()
    var screenSize: CGSize

    private init() {
        screenSize = .zero
    }

    func setScreenSize(size: CGSize) {
        screenSize = size
    }

    func getSceneSize(for size: CGSize) -> CGSize {
        size.applying(.init(scaleX: screenSize.width, y: screenSize.width))
    }

    func getSceneVector(for vector: CGVector) -> CGVector {
        vector.applying(.init(scaleX: screenSize.width, y: screenSize.width))
    }

    func getScenePosition(for position: CGPoint) -> CGPoint {
        position.applying(.init(scaleX: screenSize.width, y: screenSize.width))
    }

}
