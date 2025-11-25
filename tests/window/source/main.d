module main;

import std.stdio;
import window = copium.rendering.window;

void main(){
    window.createWindow("bingus", 500, 500);
    while (!window.shouldQuit){
        
    }
    window.quit();
}