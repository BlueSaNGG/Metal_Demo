//
//  GameScene.swift
//  metalDemo
//
//  Created by sang BLUE on 10/2/22.
//

import MetalKit
class GameScene: Scene {
    var quad: Plane
    
    override init(device: MTLDevice, size: CGSize) {
//        quad = Plane(device: device)
        quad = Plane(device: device, imageName: "apple.jpeg")
        super.init(device: device, size: size)
        add(childNode: quad)
    }
}
