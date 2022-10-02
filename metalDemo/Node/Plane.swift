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
    var vertices: [Float] = [
        -1,  1, 0,
         -1, -1, 0,
         1, -1, 0,
         1, 1, 0]
    var indices: [UInt16] = [
        0, 1, 2,
        0, 2, 3 ]
    var time: Float = 0
    struct Constants {
        var animateBy: Float = 0
    }
    var constants = Constants()
    
    private func buildBuffers(device: MTLDevice) {
        // create a metal buffer hold the vertices from the vertices array
        vertexBuffer = device.makeBuffer(bytes: vertices,
                                         length: vertices.count * MemoryLayout<Float>.size,
                                         options: [])
        indexBuffer = device.makeBuffer(bytes: indices,
                                        length: indices.count * MemoryLayout<UInt16>.size,
                                        options: [])
    }
    
    override func render(commandEncoder: MTLRenderCommandEncoder,
                         deltaTime: Float) {
        super.render(commandEncoder: commandEncoder,
                     deltaTime: deltaTime)
        guard let indexBuffer = indexBuffer else { return }
        //animation function
        time += deltaTime
        let animateBy = abs(sin(time)/2 + 0.5)
        constants.animateBy = animateBy
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        //send the constant, set the buffer index to be 1 in this example
        commandEncoder.setVertexBytes(&constants,
                                      length: MemoryLayout<Constants>.stride,
                                      index: 1)
        
        //send the index, this functoin have to be after the constant one
        commandEncoder.drawIndexedPrimitives(type: .triangle,
                                             indexCount: indices.count,
                                             indexType: .uint16,
                                             indexBuffer: indexBuffer,
                                             indexBufferOffset: 0)
    }
    
    init(device: MTLDevice) {
        super.init()
        buildBuffers(device: device)
    }
}
