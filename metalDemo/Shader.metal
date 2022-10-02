//
//  Shader.metal
//  metalDemo
//
//  Created by sang BLUE on 10/2/22.
//

#include <metal_stdlib>
using namespace metal;

struct Constants {
    float animateBy;
};

struct VertexIn {
    float4 position [[attribute(0)]];   // a convinent cause we need to return a float4 for the rasterizer
    float4 color [[attribute(1)]];
};

struct VertexOut {
    float4 position [[position]]; // this tells the rasterizer which of these data items contains the vertex position value
    float4 color;
};

// a vertex function, return float 4 for the position of the vertex
vertex VertexOut vertex_shader(const VertexIn vertexIn [[stage_in]]) {
    // we could change the position of the vertex
    VertexOut vertexOut;
    vertexOut.position = vertexIn.position;
    vertexOut.color = vertexIn.color;
    return vertexOut;
    
    // output of this function is the input of next stage in the pipeline
    // GPU assembles the vertices into triangle primitives and the rasterizer then takes over, then split our triangle into fragments
    // the fragments function return the color of each fragment
}



// every pixel will interpolated for the color
fragment half4 fragment_shader(VertexOut vertexIn [[stage_in]]) {
    // the data rasterizer has generated per fragment rather than one constant value for all fragments
    return half4(vertexIn.color);
    
    // red, green, blue, alpha
}
