//
//  Types.swift
//  metalDemo
//
//  Created by sang BLUE on 10/2/22.
//
import simd

struct Vertex {
    var position: simd_float3
    var color: simd_float4
    var texture: simd_float2
}

struct ModelConstants {
    // send to the GPU to transform all the vertices of the model into camera space
    var modelViewMatrix = matrix_identity_float4x4
}
