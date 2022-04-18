//
//  HUD.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 7/4/22.
//

enum HUDs: TextureName {
    case hud0
    case hud1
    case hud2
    case hud3
    case hud4
    case hud5
    case hud6
    case hud7
    case hud8
    case hud9
    case hud10

    static func forProgress(_ progress: Int) -> HUDs {
        guard let textureName = self.init(rawValue: "hud\(progress)") else {
            fatalError("HUD texture was not found for progress \(progress)")
        }

        return textureName
    }
}

// MARK: - TextureFrameable
extension HUDs: TextureFrameable {
    var setName: TextureSetName { "HUD" }
    var frameName: TextureName { rawValue }
}
