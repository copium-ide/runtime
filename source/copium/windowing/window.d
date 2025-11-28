module copium.windowing.window;

import bindbc.sdl;
import std.stdio;
import std.string;
import std.conv;
import core.stdc.config;
import copium.c.string : toCString;

public enum float fps = 60;
public enum float deltaTime = 1 / fps;
public bool running = false;

private SDL_Event event;

struct Window
{
    private SDL_Window* window;
    public bool closed = false;
    @nogc this(string title, int x, int y, int w, int h, string[] flags)
    {
        if (SDL_WasInit(0) == 0)
        {
            SDL_Init(0);
        }
        if (SDL_WasInit(SDL_INIT_VIDEO) == 0)
        {
            SDL_InitSubSystem(SDL_INIT_VIDEO);
        }
        this.window = SDL_CreateWindow(
            toCString(title),
            w,
            h,
            SDL_WINDOW_RESIZABLE

        );
        SDL_SetWindowPosition(this.window, x, y);
    }

    @nogc ~this()
    {
        this.close();
    }

    @nogc SDL_Window* getWindowContext()
    {
        return this.window;
    }

    @nogc bool shouldClose()
    {
        bool closeRequested = false;

        if (event.type == SDL_EVENT_WINDOW_CLOSE_REQUESTED)
        {
            if (event.window.windowID == SDL_GetWindowID(this.window))
            {
                closeRequested = true;
            }
        }
        return closeRequested;
    }

    @nogc void close()
    {
        if (!closed && this.window != null)
        {
            SDL_DestroyWindow(this.window);
            this.window = null;
            this.closed = true;
        }
    }
}

@nogc void pollEvents()
{
    SDL_PollEvent(&event);
}
