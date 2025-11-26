module copium.rendering.blank;

import bindbc.sdl;
import std.stdio;
import std.string;
import std.conv;
import core.stdc.config;

public enum float fps = 60;
public enum float deltaTime = 1 / fps;
public bool running = false;

struct Renderer
{
    private SDL_Renderer* renderer;
    this(SDL_Window* window, ubyte r, ubyte g, ubyte b)
    {
        if (SDL_WasInit(0) == 0)
        {
            SDL_Init(0);
        }
        if (SDL_WasInit(SDL_INIT_VIDEO) == 0)
        {
            SDL_InitSubSystem(SDL_INIT_VIDEO);
        }
        this.renderer = SDL_CreateRenderer(window, null);
        SDL_SetRenderDrawColor(this.renderer, r, g, b, 255);
    }

    void render(){
    SDL_RenderClear(renderer);
    SDL_RenderPresent(renderer);
    }

    void editColor(ubyte r, ubyte b, ubyte g){
        SDL_SetRenderDrawColor(this.renderer, r, g, b, 255);
    }    

    auto getRenderContext()
    {
        return this.renderer;
    }
}
