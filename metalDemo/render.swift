//
//  render.swift
//  metalDemo
//
//  Created by sang BLUE on 10/2/22.
//

import MetalKit

class Renderer: NSObject {
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    var scene: Scene?
    
    // setup the pipline state and metal vertex buffer
    var pipelineState: MTLRenderPipelineState?
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?
    
    //setup the constants
    struct Constants {
        var animateBy: Float = 0.0
    }
    var constants = Constants()
    var time: Float = 0     // set up the time for moving
    
    
    init(device: MTLDevice) {
        self.device = device
        commandQueue = device.makeCommandQueue()!
        super.init()
    }

}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    
    // called every frame
    func draw(in view: MTKView) {
        // unwrap the gloabl variales
        guard let drawable = view.currentDrawable,
              let descriptor = view.currentRenderPassDescriptor
        else {return }
        
        // create command buffer to hold all our commands -> hold the command encoder
        let commandBuffer = commandQueue.makeCommandBuffer()
        // create command encoder stored inside the command buffer
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)
        // set up the pipelines state -> created by pipeline descriptor
        
        
        // pass the time to render function of the scene
        let deltaTime = 1/Float(view.preferredFramesPerSecond)
        // recursively called render from game scene to child scene
        scene?.render(commandEncoder: commandEncoder!, deltaTime: deltaTime)
        
        
        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        // all draw happen after commit
        commandBuffer?.commit()
    }
}
