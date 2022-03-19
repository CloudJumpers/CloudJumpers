//
//  TimerEntity.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 17/3/22.
//

 import SpriteKit

 class TimerEntity: SKEntity {

    init() {
        super.init(type: .timer)
        self.node = createSKNode()
    }
     override func createSKNode() -> SKNode? {
         let sprite = SKLabelNode()
         sprite.position = Constants.timerPosition
         sprite.fontSize = Constants.timerSize.width
         sprite.text = "\(Constants.timerInitial)"
         sprite.fontColor = .black
         sprite.zPosition = SpriteZPosition.timer.rawValue
         return sprite
     }
 }
