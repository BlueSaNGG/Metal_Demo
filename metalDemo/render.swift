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
        
        buildPipelineState()
    }

    
    // different scene may have different pipeline state
    private func buildPipelineState() {
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "vertex_shader")
        let fragmentFunction = library?.makeFunction(name: "fragment_shader")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        let vertexDescriptor = MTLVertexDescriptor()
        // vertex attribute
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        // color attribute
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = MemoryLayout<simd_float3>.stride
        vertexDescriptor.attributes[1].bufferIndex = 0
        
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        
        pipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        
        
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
    
    
    // called every frame
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
        // set up the pipelines state -> created by pipeline descriptor
        commandEncoder?.setRenderPipelineState(pipelineState)
        
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
