//
//  TimerEntity.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 17/3/22.
//

 import Foundation

 class TimerEntity: Entity, Renderable {
    private var initialTime = Constants.timerInitial
    var renderingComponent: RenderingComponent

    init() {
        self.renderingComponent = RenderingComponent(type: .timer(time: initialTime),
                                                     position: Constants.timerPosition,
                                                     name: Constants.timerName,
                                                     size: Constants.timerSize)
        super.init(type: .timer)
    }

    func activate(renderingSystem: RenderingSystem) {
        renderingSystem.addComponent(entity: self,
                                     component: renderingComponent)
    }

 }
