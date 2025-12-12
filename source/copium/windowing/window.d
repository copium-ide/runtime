module copium.windowing.window;

import bindbc.sdl;
import std.stdio;
import std.string;
import std.conv;
import core.stdc.config;
import copium.utils.string : toCString;
import copium.utils.array;
import std.algorithm : reduce;

alias windowFlag = ulong;

public enum float fps = 60;
public enum float deltaTime = 1 / fps;
public bool running = false;

private SDL_Event event;


// Window functionality
const uint WINDOW_RESIZABLE =           SDL_WINDOW_RESIZABLE;
const uint WINDOW_MINIMIZED =           SDL_WINDOW_MINIMIZED;
const uint WINDOW_MAXIMIZED =           SDL_WINDOW_MAXIMIZED;
const uint WINDOW_NOT_FOCUSABLE =       SDL_WINDOW_NOT_FOCUSABLE;

// Window appearance
const uint WINDOW_FULLSCREEN =          SDL_WINDOW_FULLSCREEN;
const uint WINDOW_BORDERLESS =          SDL_WINDOW_BORDERLESS;
const uint WINDOW_TRANSPARENT =         SDL_WINDOW_TRANSPARENT;
const uint WINDOW_OCCLUDED =            SDL_WINDOW_OCCLUDED; /// Is the window covered by other windows? (minimize also triggers this)
const uint WINDOW_HIDDEN =              SDL_WINDOW_HIDDEN; /// Window is not shown at all. Can be toggled using Window.show() or Window.hide()
const uint WINDOW_ALWAYS_ON_TOP =       SDL_WINDOW_ALWAYS_ON_TOP; /// Window appears at the top of the screen regardless of its focus.
const uint WINDOW_UTILITY =             SDL_WINDOW_UTILITY; /// System tray

// Comfort
const uint WINDOW_HIGH_PIXEL_DENSITY =  SDL_WINDOW_HIGH_PIXEL_DENSITY;

// Input focus
const uint WINDOW_INPUT_FOCUS =         SDL_WINDOW_INPUT_FOCUS; /// Is the window focused?
const uint WINDOW_MOUSE_FOCUS =         SDL_WINDOW_MOUSE_FOCUS; /// Is the user hovering over the window?
const uint WINDOW_MOUSE_CAPTURE =       SDL_WINDOW_MOUSE_CAPTURE; /// Receives mouse input regardless of whether it is focused on the window.
const uint WINDOW_MOUSE_RELATIVE_MODE = SDL_WINDOW_MOUSE_RELATIVE_MODE; /// Useful for first-person shooters. Keeps the mouse in the middle.
const uint WINDOW_MOUSE_GRABBED =       SDL_WINDOW_MOUSE_GRABBED; /// Constrains the mouse to the window.
const uint WINDOW_KEYBOARD_GRABBED =    SDL_WINDOW_KEYBOARD_GRABBED; /// Constrains keyboard input to the window. **This will disable some system shortcuts.**

// Menus
const uint WINDOW_TOOLTIP =             SDL_WINDOW_TOOLTIP; ///This is for stuff like tooltips. **Use only within another window.**
const uint WINDOW_POPUP_MENU =          SDL_WINDOW_POPUP_MENU; /// This is for stuff like right click menus. **Use only within another window.**
const uint WINDOW_MODAL =               SDL_WINDOW_MODAL; /// Disables input to the main window until the modal closes.

// Rendering backend
const uint WINDOW_OPENGL =              SDL_WINDOW_OPENGL; /// Vulkan is recommended for performance. **Cannot be changed.**
const uint WINDOW_VULKAN =              SDL_WINDOW_VULKAN; /// Recommended rendering backend. **Cannot be changed.**
const uint WINDOW_METAL =               SDL_WINDOW_METAL; /// Use for apple devices. **Cannot be changed.**

// Misc
const uint WINDOW_EXTERNAL =            SDL_WINDOW_EXTERNAL; /// Window was not created with SDL or the standard Copium window library (basically sdl)


struct Window
{
    private SDL_Window* window;
    public bool closed = false;
    @nogc this(string title, int x, int y, int w, int h, Array!windowFlag* flags)
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
            flags.reduce!"|"()

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
