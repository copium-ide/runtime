module main;

import std.stdio;
import std.file : write, exists, remove;
import std.path : buildPath;
import copium.rendering.single;
import copium.windowing.window;
import copium.math.interval;
import copium.utils.array;
import std.datetime;

void main()
{
    const string vertexShaderPath = "/home/halu/Documents/runtime/tests/shaders/shadercase/testing/bin/triangle.vert.spv";
    const string fragmentShaderPath = "/home/halu/Documents/runtime/tests/shaders/shadercase/testing/bin/triangle.frag.spv";

    Array!windowFlag args;
    args.append(WINDOW_RESIZABLE);

    Window window1 = Window("triangle", 50, 50, 500, 500, &args);

    writeln("making renderer");
    Renderer renderer1 = Renderer(window1.getWindowContext(), VSYNC_DISABLED);

    writeln("setting fragment");
    renderer1.setFragment(fragmentShaderPath);
    renderer1.setVertex(vertexShaderPath);
    renderer1.createPipeline();

    writeln("creating interval");
    FPS limiter = FPS(60);
    

    while (!(window1.closed))
    {
        

        pollEvents();
        if (window1.shouldClose())
        {
            window1.close();
            break;
        }
        else
        {
            if (limiter.shouldFire())
            {
                renderer1.render();
            }

        }

    }
}
