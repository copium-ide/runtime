module copium.scratch_compat.renderer;

import bindbc.sdl;
import std.stdio;
import std.string;
import std.conv;
import core.stdc.config;
import copium.utils.array;

// This does not support the entire stage specification.
// Backdrops: not implemented.
struct Stage
{
    private SDL_Renderer* renderer;
    private Array!Sprite sprites;
    @nogc this(SDL_Window* window)
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
        SDL_SetRenderDrawColor(this.renderer, 0, 0, 0, 255);
    }

    @nogc void render()
    {
        SDL_RenderClear(this.renderer);
        for (int i = 0; i < sprites.length; i++)
        {
            sprites[i].render(this.renderer);
        }
        SDL_RenderPresent(this.renderer);
    }

    @nogc void addSprite(SDL_Texture image, float x, float y)
    {
        sprites.append(Sprite(image));
    }

    @nogc SDL_Renderer* getRenderContext()
    {
        return this.renderer;
    }
}

// This does not support the entire specification.
// Visual effect blocks: Not supported.
// Multiple costumes: Not supported.
// Layering: Not supported. Currently operates in order of sprite initialization.
struct Sprite
{
    private SDL_Texture image;
    private SDL_FRect viewbox;
    private SDL_FPoint center;

    private bool hidden = false;

    private float x = 0;
    private float y = 0;

    private float w;
    private float h;

    private double direction = 90;
    private string rotationMode = "normal";

    private int scale = 100;

    @nogc this(SDL_Texture image)
    {
        this.image = image;
    }

    @nogc void hide()
    {
        this.hidden = true;
    }
    @nogc void show()
    {
        this.hidden = false;
    }

    @nogc void rotate(double deg)
    {
        this.direction = deg;
    }

    @nogc void render(SDL_Renderer* renderer)
    {
        if (this.hidden == false)
        {
            auto vbox = this.calcViewbox();
            SDL_RenderTextureRotated(
                renderer,
                &this.image,
                vbox,
                vbox,
                this.direction,
                &this.center,
                SDL_FLIP_NONE
            );
        }
    }

    @nogc private SDL_FPoint* calcCenter()
    {
        SDL_GetTextureSize(&this.image, &this.w, &this.h);
        float centerX = this.x + (this.w / 2.0f);
        float centerY = this.y + (this.h / 2.0f);

        this.center.x = centerX;
        this.center.y = centerY;
        return &this.center;
    }

    @nogc private SDL_FRect* calcViewbox()
    {
        SDL_GetTextureSize(
            &this.image,
            &this.w,
            &this.h
        );
        this.viewbox = SDL_FRect(
            this.x,
            this.y,
            this.w,
            this.h
        );
        return &this.viewbox;
    }
}
/*
struct CostumeGroup
{
    Array!Costume costumes;
    @nogc void addCostume(auto data)
    {
        costumes.append(Costume(data));
    }
    @nogc void removeCostume(int index)
    {
        // costumes.remove(index);
    }
    @nogc SDL_Texture getCostumeImage(int index)
    {
        return costumes[index].render();
    }
}

struct Costume
{
    bool datatype;
    Array!byte data;
    @nogc this(Bitmap data)
    {
    }
    @nogc this(SVG data)
    {
    }
    @nogc SDL_Texture render()
    {

    }
}
*/