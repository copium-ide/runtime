cd shadercase/testing
glslc -fshader-stage=frag triangle.frag.glsl -o bin/triangle.frag.spv
glslc -fshader-stage=vert triangle.vert.glsl -o bin/triangle.vert.spv