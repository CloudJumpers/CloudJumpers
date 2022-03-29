//
//  CGConverter.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/29/22.
//

import CoreGraphics

class CGConverter {
    static let sharedConverter = CGConverter()
    var sceneBound: CGRect
    
    private init() {
        sceneBound = CGRect.zero
    }
    
    func setSceneBound(bound: CGRect) {
        sceneBound = bound
    }
    
    func getSceneSize(for size: CGSize) -> CGSize {
        return size.applying(.init(scaleX: sceneBound.width, y: sceneBound.width))
    }
    
}
