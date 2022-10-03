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
    var camera = Camera()   // a scene has one camera
    var sceneConstants = SceneConstants()
    
    init(device: MTLDevice, size: CGSize) {
        self.device = device
        self.size = size
        super.init()
        // set the aspect and position z of the camera
        camera.aspect = Float(size.width / size.height)
        camera.position.z = -6
        add(childNode: camera)
    }
    
    // called every frame
    func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        update(deltaTime: deltaTime)
        sceneConstants.projectionMatrix = camera.projectionMatrix
        //send the projection matrix to the vertex function
        commandEncoder.setVertexBytes(&sceneConstants,
                                      length: MemoryLayout<SceneConstants>.stride,
                                      index: 2)
        // the position of camera
        for child in children  {
            child.render(commandEncoder: commandEncoder, parentModelViewMatrix: camera.viewMatrix)
        }
    }
    
    // called every frame
    func update(deltaTime: Float) {
        
    }
    
}
