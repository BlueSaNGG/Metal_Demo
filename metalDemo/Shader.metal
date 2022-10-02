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

// a vertex function, return float 4 for the position of the vertex
vertex float4 vertex_shader(const device packed_float3 *vertices [[buffer(0)]], // the vertcies array
                            constant Constants &constants [[buffer(1)]],
                            // this object is in constant space, not device space
                            // same the buffer number as in draw
                            uint vertexId [[vertex_id]] // the vertex id of the current vertex being processed on the GPU
                            ) {
    // we could change the position of the vertex
    float4 position = float4(vertices[vertexId], 1);
    position.x += constants.animateBy;
    return position;
    
    // output of this function is the input of next stage in the pipeline
    // GPU assembles the vertices into triangle primitives and the rasterizer then takes over, then split our triangle into fragments
    // the fragments function return the color of each fragment
}

fragment half4 fragment_shader() {
    
    // red, green, blue, alpha
    return half4(1, 1, 0, 1);
}
