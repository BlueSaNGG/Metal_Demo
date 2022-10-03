//
//  Scene.swift
//  metalDemo
//
//  Created by sang BLUE on 10/2/22.
//

import MetalKit
class Scene: Node {
    var device: MTLDevice
    var size: CGSize
    
    init(device: MTLDevice, size: CGSize) {
      self.device = device
      self.size = size
      super.init()
    }
    
    // called every frame
    func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        update(deltaTime: deltaTime)
        // the position of camera
        let viewMatrix = matrix_float4x4(translationX: 0, y: 0, z: -4)
        for child in children  {
          child.render(commandEncoder: commandEncoder, parentModelViewMatrix: viewMatrix)
        }
    }
    
    // called every frame
    func update(deltaTime: Float) {
        
    }
    
}
