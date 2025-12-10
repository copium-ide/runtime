module main;

import std.stdio;
import std.file : write, exists, remove;
import std.path : buildPath;
// Remove 'import core.exception : scopeGuard;'
import copium.rendering.compile;
import bindbc.glslang : glslang_stage_t, GLSLANG_STAGE_VERTEX;

void main() {
    testGLSLCompilation();
    writeln("All tests passed!");
}

void testGLSLCompilation() {
    const shaderPath = "/home/halu/Documents/runtime/tests/shaders/shadercase/testing/bin/triangle.vert.spv";

    try {

        // Use the 'scope(exit)' language statement.
        // It does not require an import and takes a block of code to run on exit.
        scope(exit) {
            if (exists(shaderPath)) {
                remove(shaderPath);
                writeln("Cleaned up test shader file.");
            }
        }
        
        // 2. Instantiate the GLSL compiler
        GLSL compiler;

        // 3. Compile the shader (Vertex stage)
        auto spirvCode = compiler.compile(shaderPath, GLSLANG_STAGE_VERTEX);

        // 4. Assertions
        assert(spirvCode.length > 0, "Compilation should produce valid SPIR-V code");

        writeln("Test Passed: Successfully compiled SPIR-V of size ", spirvCode.length, " words.");

    } catch (Exception e) {
        stderr.writeln("Test Failed with exception: ", e.msg);
        assert(false, "Test failed due to exception during file operations or compilation");
    }
}
