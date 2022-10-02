//
//  Texturable.swift
//  metalDemo
//
//  Created by sang BLUE on 10/2/22.
//

import MetalKit

protocol Texturable {
    var texture: MTLTexture? { get set }
}

extension Texturable {
    func setTexture(device: MTLDevice, imageName: String) -> MTLTexture? {
        let textureLoader = MTKTextureLoader(device: device)
        var texture: MTLTexture? = nil
        
        if let textureUrl = Bundle.main.url(forResource: imageName, withExtension: nil) {
            do {
                texture = try textureLoader.newTexture(URL: textureUrl, options: [:])
            } catch {
                print("texture not created")
            }
        }
        return texture
    }
}
