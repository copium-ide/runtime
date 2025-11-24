module copium.rendering.window;

import bindbc.sdl;
import std.stdio;
import std.string;
import std.conv;
import core.stdc.config;

public enum float fps = 60;
public enum float deltaTime = 1/fps;

static this() {
    if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_EVENTS) < 0) {
        writeln("Failed to initialize SDL: ", SDL_GetError());
        return;
    }

    writeln("SDL initialized successfully.");

    // Your SDL application logic goes here

    
}

void createWindow(string title, int w, int h){
    // Create a window
    writeln("Creating window.");
    auto window = SDL_CreateWindow(
        toStringz(title),
        w, // Width
        h, // Height
        SDL_WINDOW_RESIZABLE // Flags
    );
    writeln("Creating renderer.");
    auto renderer = SDL_CreateRenderer(window, null);
    if (renderer is null) {
        writeln("Failed to create renderer: ", SDL_GetError());
        SDL_DestroyWindow(window);
        SDL_Quit();
        return;
    }

    bool running = true;
    SDL_Event event;
    writeln("Running loop.");
    while (running) {
        while (SDL_PollEvent(&event)) {
            if (event.type == SDL_EVENT_QUIT) {
                running = false;
            }
        }
        // Set drawing color to blue
        SDL_SetRenderDrawColor(renderer, 0, 0, 255, 255);

        // Clear the screen
        SDL_RenderClear(renderer);

        // Present the renderer
        SDL_RenderPresent(renderer);
    }

}

void quit(){
    writeln("Quitting...");
    SDL_Quit(); // Clean up SDL
}