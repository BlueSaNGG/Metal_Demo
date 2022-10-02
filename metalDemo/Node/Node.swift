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
    
    func add(childNode: Node) {
      children.append(childNode)
    }
    
    func render(commandEncoder: MTLRenderCommandEncoder,
                deltaTime: Float) {
        for child in children  {
            child.render(commandEncoder: commandEncoder,deltaTime: deltaTime)
        }
    }
}



