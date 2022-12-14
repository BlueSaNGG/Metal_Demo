//
//  Node.swift
//  metalDemo
//
//  Created by sang BLUE on 10/2/22.
//

import MetalKit
class Node {
    var name = "Untitled"
    var children: [Node] = []
    var position = simd_float3(repeating: 0)
    var rotation = simd_float3(repeating: 0)
    var scale = simd_float3(repeating: 1)
    var modelMatrix: matrix_float4x4 {
      var matrix = matrix_float4x4(translationX: position.x,
                                   y: position.y, z: position.z)
      matrix = matrix.rotatedBy(rotationAngle: rotation.x,
                                x: 1, y: 0, z: 0)
      matrix = matrix.rotatedBy(rotationAngle: rotation.y,
                                x: 0, y: 1, z: 0)
      matrix = matrix.rotatedBy(rotationAngle: rotation.z,
                                x: 0, y: 0, z: 1)
      matrix = matrix.scaledBy(x: scale.x, y: scale.y, z: scale.z)
      return matrix
    }
    
    func add(childNode: Node) {
      children.append(childNode)
    }
    
    func render(commandEncoder: MTLRenderCommandEncoder, parentModelViewMatrix: matrix_float4x4) {
        let modelViewMatrix = matrix_multiply(parentModelViewMatrix, modelMatrix)
        for child in children  {
            child.render(commandEncoder: commandEncoder, parentModelViewMatrix: modelViewMatrix)
        }
        // call do render if the node conforms the renderable
        if let renderable = self as? Renderable {
          commandEncoder.pushDebugGroup(name)
          renderable.doRender(commandEncoder: commandEncoder, modelViewMatrix: modelViewMatrix)
          commandEncoder.popDebugGroup()
        }
    }
}



