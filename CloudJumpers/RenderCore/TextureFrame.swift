//
//  TextureFrame.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 7/4/22.
//

typealias TextureName = String
typealias TextureSetName = String

struct TextureFrame {
    let name: TextureName
    let setName: TextureSetName

    init(from setName: TextureSetName, _ name: TextureName) {
        self.name = name
        self.setName = setName
    }

    var asFrames: [TextureFrame] {
        [self]
    }
}
