module main;

import std.stdio;
import std.file : write, exists, remove;
import std.path : buildPath;
import copium.rendering.single;
import copium.windowing.window;

void main(){
    const string vertexShaderPath = "/home/halu/Documents/runtime/tests/shaders/shadercase/testing/bin/triangle.vert.spv";
    const string fragmentShaderPath = "/home/halu/Documents/runtime/tests/shaders/shadercase/testing/bin/triangle.frag.spv";
    string[1] args;
    args[0] = "buh";
    Window window1 = Window("triangle", 50, 50, 500, 500, args);
    writeln("making renderer");
    Renderer renderer1 = Renderer(window1.getWindowContext());
    writeln("setting fragment");
    renderer1.setFragment(fragmentShaderPath);
    renderer1.setVertex(vertexShaderPath);
    renderer1.createPipeline();

    while (!(window1.closed))
    {
        pollEvents();
        if (window1.shouldClose()) {
            window1.close();
        }
        renderer1.render();
    }
}
