//
//  GameScene.swift
//  metalDemo
//
//  Created by sang BLUE on 10/2/22.
//

import MetalKit
class GameScene: Scene {
    var quad: Plane
    var cube: Cube
    
    override init(device: MTLDevice, size: CGSize) {
//        quad = Plane(device: device)
//        quad = Plane(device: device, imageName: "apple.jpeg")
        cube = Cube(device: device)
        quad = Plane(device: device, imageName: "apple.jpeg")
        super.init(device: device, size: size)
        add(childNode: cube)
        add(childNode: quad)
        
        quad.position.z = -3
        quad.scale = simd_float3(repeating: 3)
        cube.scale = simd_float3(repeating: 0.5)
        
        
    }
    
    override func update(deltaTime: Float) {
        cube.rotation.y += deltaTime
    }
}
