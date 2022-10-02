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
}
