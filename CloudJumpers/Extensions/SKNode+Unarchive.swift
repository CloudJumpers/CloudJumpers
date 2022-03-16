//
//  SKNode+Unarchive.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 15/3/22.
//

import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file: String) -> SKNode? {
        if let path = Bundle.main.path(forResource: file, ofType: "sks") {
            // swiftlint:disable:next force_try
            let sceneData = try! NSData(contentsOfFile: path, options: .mappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWith: sceneData as Data)

            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
              // swiftlint:disable:next force_cast
            let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}
