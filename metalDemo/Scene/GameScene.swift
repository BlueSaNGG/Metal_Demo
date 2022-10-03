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
//        quad = Plane(device: device, imageName: "apple.jpeg")
        quad = Plane(device: device, imageName: "apple.jpeg")
        super.init(device: device, size: size)
        add(childNode: quad)
        let quad2 = Plane(device: device, imageName: "apple.jpeg")
        quad2.scale = simd_float3(repeating: 0.5)
        quad2.position.y = 1.5
        quad.add(childNode: quad2)
    }
    
    override func update(deltaTime: Float) {
        quad.rotation.y += deltaTime
    }
}
