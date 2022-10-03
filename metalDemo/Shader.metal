//
//  Shader.metal
//  metalDemo
//
//  Created by sang BLUE on 10/2/22.
//

#include <metal_stdlib>
using namespace metal;

struct ModelConstants {
    float4x4 modelViewMatrix;
};

struct VertexIn {
    float4 position [[attribute(0)]];   // a convinent cause we need to return a float4 for the rasterizer
    float4 color [[attribute(1)]];
    float2 textureCoordinates [[attribute(2)]];
};

struct VertexOut {
    float4 position [[position]]; // this tells the rasterizer which of these data items contains the vertex position value
    float4 color;
    float2 textureCoordinates;
};

// a vertex function, return float 4 for the position of the vertex
vertex VertexOut vertex_shader(const VertexIn vertexIn [[stage_in]],
                               constant ModelConstants &modelConstants [[buffer(1)]]){
    // we could change the position of the vertex
    VertexOut vertexOut;
    // multiply vertices by the scale matrix
    vertexOut.position = modelConstants.modelViewMatrix  * vertexIn.position;
    
    vertexOut.color = vertexIn.color;
    vertexOut.textureCoordinates = vertexIn.textureCoordinates;
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

// for texture1
fragment half4 textured_fragment(VertexOut vertexIn [[stage_in]],
                                 sampler sampler2d [[sampler(0)]],
                                 texture2d<float> texture [[texture(0)]] // this is the texture in fragment buffer 0
                                 ) {
    //extract the color from the current fragments texture coordinates
    float4 color = texture.sample(sampler2d, vertexIn.textureCoordinates);
    if (color.a == 0.0) discard_fragment();
    return half4(color.r, color.g, color.b, 1);
}


// for texture 1 and texture 2
fragment half4 textured_mask_fragment(VertexOut vertexIn [[ stage_in ]],
                                      texture2d<float> texture [[ texture(0)]],
                                      texture2d<float> maskTexture [[ texture(1) ]],
                                      sampler sampler2d [[sampler(0)]]) {
    
    float4 color = texture.sample(sampler2d, vertexIn.textureCoordinates);
    float4 maskColor = maskTexture.sample(sampler2d, vertexIn.textureCoordinates);
    float maskOpacity = maskColor.a;
    if (maskOpacity < 0.5) discard_fragment();
    return half4(color.r, color.g, color.b, 1);
}
