//
//  Primitive.swift
//  metalDemo
//
//  Created by sang BLUE on 10/3/22.
//


import MetalKit
class Primitive: Node {
    var maskTexture: MTLTexture?
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?
    var vertices: [Vertex] = []
    
    var indices: [UInt16] = []
    var time: Float = 0
    
    var modelConstants = ModelConstants()
    
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
        buildVertices()
        buildBuffers(device: device)
        // build pipeline at the begining
        pipelineState = buildPipelineState(device: device)
    }
    
    // constructor overload
    init(device: MTLDevice, imageName: String) {
        super.init()
        buildVertices()
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
    
    // constructor overload
    init(device: MTLDevice, imageName: String, maskImageName: String) {
        super.init()
        buildVertices()
        buildBuffers(device: device)
        if let texture = setTexture(device: device, imageName: imageName) {
            self.texture = texture
            fragmentFunctionName = "textured_fragment"
        }
        if let maskTexture = setTexture(device: device, imageName: maskImageName) {
            self.maskTexture = maskTexture
            fragmentFunctionName = "textured_mask_fragment"
        }
        pipelineState = buildPipelineState(device: device)
    }
    
    
    // for subclass to override
    func buildVertices() {}
    
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
    
    
}


extension Primitive: Renderable {
    // unique render function
    // called in render if the object is renderable
    func doRender(commandEncoder: MTLRenderCommandEncoder, modelViewMatrix: matrix_float4x4) {
        guard let indexBuffer = indexBuffer else { return }
        // only do model view matrix assign for this object
        modelConstants.modelViewMatrix = modelViewMatrix
        
        commandEncoder.setRenderPipelineState(pipelineState)
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        //send the constant, set the buffer index to be 1 in this example
        commandEncoder.setVertexBytes(&modelConstants,
                                      length: MemoryLayout<ModelConstants>.stride,
                                      index: 1)
        // send texture
        commandEncoder.setFragmentTexture(texture, index: 0)
        commandEncoder.setFragmentTexture(maskTexture, index: 1)
        commandEncoder.setCullMode(.front)
        
        //send the index, this functoin have to be after the constant one
        commandEncoder.drawIndexedPrimitives(type: .triangle,
                                             indexCount: indices.count,
                                             indexType: .uint16,
                                             indexBuffer: indexBuffer,
                                             indexBufferOffset: 0)
    }
    

}

extension Primitive: Texturable {
        
}
 
