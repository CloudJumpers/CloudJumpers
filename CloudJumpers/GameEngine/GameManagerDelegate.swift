//
//  GameManagerDelegate.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 14/4/22.
//

protocol GameManagerDelegate: AnyObject {
    func manager(_ manager: GameManager, didEndGameWith metaData: GameMetaData)
}
