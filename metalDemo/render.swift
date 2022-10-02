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
    
    // create vertices
    var vertices: [Float] = [
       -1,  1,  0,  // V0
       -1, -1,  0,  // V1
       1, -1, 0, // V2
       1, 1, 0, //V3
    ]
    
    // create indices to refer the vertices
    var indices: [UInt16] = [
        0, 1, 2,
        2, 3, 0
    ]
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
        
        buildPipelineState()
    }

    
    private func buildPipelineState() {
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "vertex_shader")
        let fragmentFunction = library?.makeFunction(name: "fragment_shader")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor:
            pipelineDescriptor)
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        // unwrap the gloabl variales
        guard let drawable = view.currentDrawable,
              let pipelineState = pipelineState,
              let descriptor = view.currentRenderPassDescriptor
        else {return }
        
        // create command buffer to hold all our commands -> hold the command encoder
        let commandBuffer = commandQueue.makeCommandBuffer()
        // create command encoder stored inside the command buffer
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)

        // send the command buffer to GPU
        commandEncoder?.setRenderPipelineState(pipelineState)
        
        let deltaTime = 1/Float(view.preferredFramesPerSecond)
        scene?.render(commandEncoder: commandEncoder!, deltaTime: deltaTime)
        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        // all draw happen after commit
        commandBuffer?.commit()
    }
}
