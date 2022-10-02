//
//  Plane.swift
//  metalDemo
//
//  Created by sang BLUE on 10/2/22.
//

import MetalKit
class Plane: Node {
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?
    var vertices: [Vertex] = [
        Vertex(position: simd_float3(-1, 1, 0), color: simd_float4(1, 0, 0, 1), texture: simd_float2(0, 0)),
        Vertex(position: simd_float3(-1, -1, 0), color: simd_float4(0, 1, 0, 1), texture: simd_float2(0, 1)),
        Vertex(position: simd_float3(1, -1, 0), color: simd_float4(0, 0, 1, 1), texture: simd_float2(1, 1)),
        Vertex(position: simd_float3(1, 1, 0), color: simd_float4(1, 0, 1, 1), texture: simd_float2(1, 0)),
    ]
    
    var indices: [UInt16] = [
        0, 1, 2,
        0, 2, 3
    ]
    var time: Float = 0
    struct Constants {
        var animateBy: Float = 0
    }
    var constants = Constants()
    
    // renderable Protocol
    var pipelineState: MTLRenderPipelineState!
    var fragmentFunctionName: String = "fragment_shader"
    var vertexFunctionName: String = "vertex_shader"
    var vertexDescriptor: MTLVertexDescriptor {
        let vertexDescriptor = MTLVertexDescriptor()
        
        // position
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        //color
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = MemoryLayout<simd_float3>.stride
        vertexDescriptor.attributes[1].bufferIndex = 0
        //texture
        vertexDescriptor.attributes[2].format = .float2
        vertexDescriptor.attributes[2].offset = MemoryLayout<simd_float3>.stride + MemoryLayout<simd_float4>.stride
        vertexDescriptor.attributes[2].bufferIndex = 0
        
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        
        return vertexDescriptor
    }
    
    // Texturable protocol
    var texture: MTLTexture?
    
    init(device: MTLDevice) {
        super.init()
        buildBuffers(device: device)
        // build pipeline at the begining
        pipelineState = buildPipelineState(device: device)
    }
    
    // constructor overload
    init(device: MTLDevice, imageName: String) {
        super.init()
        buildBuffers(device: device)
//        self.texture = setTexture(device: device, imageName: imageName)
        // build pipeline at the begining
        // update the fragment function name in pipeline
        if let texture = setTexture(device: device, imageName: imageName) {
            self.texture = texture
            fragmentFunctionName = "textured_fragment"
        }
        
        // build after check the image
        pipelineState = buildPipelineState(device: device)
    }
    
    // build buffer in GPU for this scene
    private func buildBuffers(device: MTLDevice) {
        // create a metal buffer hold the vertices from the vertices array
        vertexBuffer = device.makeBuffer(bytes: vertices,
                                         length: vertices.count * MemoryLayout<Vertex>.stride,
                                         options: [])
        indexBuffer = device.makeBuffer(bytes: indices,
                                        length: indices.count * MemoryLayout<UInt16>.size,
                                        options: [])
    }
    
    // different node have unique render function
    // this is called in draw
    override func render(commandEncoder: MTLRenderCommandEncoder,
                         deltaTime: Float) {
        super.render(commandEncoder: commandEncoder,
                     deltaTime: deltaTime)
        guard let indexBuffer = indexBuffer else { return }
        
        //animation function
        time += deltaTime
        let animateBy = abs(sin(time)/2 + 0.5)
        constants.animateBy = animateBy
        
        
        
        commandEncoder.setRenderPipelineState(pipelineState)
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        //send the constant, set the buffer index to be 1 in this example
        commandEncoder.setVertexBytes(&constants,
                                      length: MemoryLayout<Constants>.stride,
                                      index: 1)
        // send texture
        commandEncoder.setFragmentTexture(texture, index: 0)
        //send the index, this functoin have to be after the constant one
        commandEncoder.drawIndexedPrimitives(type: .triangle,
                                             indexCount: indices.count,
                                             indexType: .uint16,
                                             indexBuffer: indexBuffer,
                                             indexBufferOffset: 0)
    }
}


extension Plane: Renderable {

}

extension Plane: Texturable {
        
}
