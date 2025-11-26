module main;

import std.stdio;
import window = copium.windowing.window;
import blank = copium.rendering.blank;

void main(){
    string[1] args;
    args[0] = "buh";
    window.Window window1 = window.Window("red", 50, 50, 500, 500, args);
    blank.Renderer renderer1 = blank.Renderer(window1.getWindowContext(), 255, 0, 0);

    window.Window window2 = window.Window("blue", 50, 50, 500, 500, args);
    blank.Renderer renderer2 = blank.Renderer(window2.getWindowContext(), 0, 0, 255);

    while (!((window1.closed)&&(window2.closed)))
    {
        window.pollEvents();
        if (window1.shouldClose()) {
            window1.close();
        }
        if (window2.shouldClose()) {
            window2.close();
        }
        renderer1.render();
        renderer2.render();
    }
}