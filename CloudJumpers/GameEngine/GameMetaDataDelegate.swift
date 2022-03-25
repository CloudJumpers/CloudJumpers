//
//  GameMetaDataDelegate.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/24/22.
//

import Foundation

protocol GameMetaDataDelegate: AnyObject {
    func metaData(changePlayerLocation player: EntityID, location: EntityID?)
}
