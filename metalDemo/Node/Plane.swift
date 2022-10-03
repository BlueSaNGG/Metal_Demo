//
//  Plane.swift
//  metalDemo
//
//  Created by sang BLUE on 10/2/22.
//

import MetalKit
class Plane: Primitive {

    override func buildVertices() {
        vertices = [
            Vertex(position: simd_float3(-1, 1, 0), color: simd_float4(1, 0, 0, 1), texture: simd_float2(0, 1)),
            Vertex(position: simd_float3(-1, -1, 0), color: simd_float4(0, 1, 0, 1), texture: simd_float2(0, 0)),
            Vertex(position: simd_float3(1, -1, 0), color: simd_float4(0, 0, 1, 1), texture: simd_float2(1, 0)),
            Vertex(position: simd_float3(1, 1, 0), color: simd_float4(1, 0, 1, 1), texture: simd_float2(1, 1)),
        ]
        
        indices = [
            0, 1, 2,
            0, 2, 3
        ]
    }
}
