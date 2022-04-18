//
//  TextureFrame.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 7/4/22.
//

public typealias TextureName = String
public typealias TextureSetName = String

public struct TextureFrame {
    let name: TextureName
    let setName: TextureSetName

    public init(from setName: TextureSetName, _ name: TextureName) {
        self.name = name
        self.setName = setName
    }

    public var asFrames: [TextureFrame] {
        [self]
    }
}
