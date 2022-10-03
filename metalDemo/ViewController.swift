//
//  ViewController.swift
//  metalDemo
//
//  Created by sang BLUE on 10/2/22.
//

import UIKit
import MetalKit

enum Colors {
    static let wenderlichGreen = MTLClearColor(red: 0.0, green: 0.4, blue: 0.21, alpha: 1.0)
}

class ViewController: UIViewController {
        
    var metalView: MTKView {
        return view as! MTKView
    }
    // There should be 1 device and 1 command queue per application
    // representation of the GPU
    var renderer: Renderer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        metalView.device = MTLCreateSystemDefaultDevice()
        guard let device = metalView.device else {
          fatalError("Device not created. Run on a physical device")
        }
        metalView.depthStencilPixelFormat = .depth32Float
        metalView.clearColor =  Colors.wenderlichGreen
        renderer = Renderer(device: device)
        metalView.delegate = renderer
        renderer?.scene = GameScene(device: device, size: view.bounds.size)
        
    }


}
