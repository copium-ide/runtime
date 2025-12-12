module copium.rendering.single;
/// Generates a rendering context for a single shader.
import bindbc.sdl;
import std.file;
import std.stdio;

struct Renderer
{
    SDL_GPUDevice* gpu_device;
    SDL_Window* window;

    SDL_GPUShader* fragment;
    SDL_GPUShader* vertex;
    SDL_GPUGraphicsPipeline* pipeline;

    @nogc this(SDL_Window* window,)
    {
        if (SDL_WasInit(0) == 0)
        {
            SDL_Init(0);
        }
        if (SDL_WasInit(SDL_INIT_VIDEO) == 0)
        {
            SDL_InitSubSystem(SDL_INIT_VIDEO);
        }
        this.gpu_device = SDL_CreateGPUDevice(
            SDL_GPU_SHADERFORMAT_SPIRV,
            false,
            null

        );

        this.window = window;
        SDL_ClaimWindowForGPUDevice(this.gpu_device, this.window);

    }

    void setFragment(string path)
    {
        ubyte[] shaderData = cast(ubyte[]) read(path);
        
        size_t size = shaderData.length;

        const(ubyte)* codePointer = shaderData.ptr;
        SDL_GPUShaderCreateInfo gpuData;
        SDL_GPUShaderCreateInfo* gpuInfo = &gpuData;
        gpuInfo.code_size = size;
        gpuInfo.code = codePointer;
        gpuInfo.entrypoint = "main";
        gpuInfo.format = SDL_GPU_SHADERFORMAT_SPIRV;
        gpuInfo.stage = SDL_GPU_SHADERSTAGE_FRAGMENT;

        this.fragment = SDL_CreateGPUShader(this.gpu_device, gpuInfo);
    }
    void setVertex(string path)
    {
        ubyte[] shaderData = cast(ubyte[]) read(path);
        
        size_t size = shaderData.length;

        const(ubyte)* codePointer = shaderData.ptr;
        SDL_GPUShaderCreateInfo gpuData;
        SDL_GPUShaderCreateInfo* gpuInfo = &gpuData;
        gpuInfo.code_size = size;
        gpuInfo.code = codePointer;
        gpuInfo.entrypoint = "main";
        gpuInfo.format = SDL_GPU_SHADERFORMAT_SPIRV;
        gpuInfo.stage = SDL_GPU_SHADERSTAGE_VERTEX;

        this.vertex = SDL_CreateGPUShader(this.gpu_device, gpuInfo);
    }
    void createPipeline()
    {
        SDL_GPUGraphicsPipelineCreateInfo pipeline_info;
        
        // Shader stages
        pipeline_info.vertex_shader = this.vertex;
        pipeline_info.fragment_shader = this.fragment;
        
        // Primitive type (triangles)
        pipeline_info.primitive_type = SDL_GPU_PRIMITIVETYPE_TRIANGLELIST;
        
        // Target info (render to screen)
        SDL_GPUColorTargetDescription color_target;
        color_target.format = SDL_GetGPUSwapchainTextureFormat(this.gpu_device, this.window);
        color_target.blend_state.enable_blend = false;
        
        pipeline_info.target_info.num_color_targets = 1;
        pipeline_info.target_info.color_target_descriptions = &color_target;
        
        this.pipeline = SDL_CreateGPUGraphicsPipeline(this.gpu_device, &pipeline_info);
    }

    void render()
    {
        SDL_GPUCommandBuffer* cmd_buf = SDL_AcquireGPUCommandBuffer(this.gpu_device);
        if (cmd_buf)
        {
            SDL_GPUTexture* swapchain_tex = null;
            // Acquire the current texture from the window's swapchain
            SDL_WaitAndAcquireGPUSwapchainTexture(cmd_buf, this.window, &swapchain_tex, null, null);

            if (swapchain_tex)
            {
                SDL_GPUColorTargetInfo color_target;
                color_target.texture = swapchain_tex;
                color_target.clear_color.r = 0.1f;
                color_target.clear_color.g = 0.5f;
                color_target.clear_color.b = 0.1f;
                color_target.clear_color.a = 1.0f;
                color_target.load_op = SDL_GPU_LOADOP_CLEAR;
                color_target.store_op = SDL_GPU_STOREOP_STORE;
                color_target.cycle = false;

                SDL_GPURenderPass* render_pass = SDL_BeginGPURenderPass(cmd_buf, &color_target, 1, null);

                SDL_BindGPUGraphicsPipeline(render_pass, this.pipeline);
                SDL_DrawGPUPrimitives(render_pass, 3, 1, 0, 0);  // Just 3 vertices

                SDL_EndGPURenderPass(render_pass);
            }

            SDL_SubmitGPUCommandBuffer(cmd_buf);
        }
    }
    void vSync(bool state)
    {
        if (state == true)
        {
            if (SDL_WindowSupportsGPUPresentMode(this.gpu_device, this.window, SDL_GPU_PRESENTMODE_MAILBOX)){
                SDL_SetGPUSwapchainParameters(this.gpu_device, this.window, SDL_GPU_SWAPCHAINCOMPOSITION_SDR, SDL_GPU_PRESENTMODE_MAILBOX);
            }
            
        } else {
            
            if (SDL_WindowSupportsGPUPresentMode(this.gpu_device, this.window, SDL_GPU_PRESENTMODE_IMMEDIATE)){
                SDL_SetGPUSwapchainParameters(this.gpu_device, this.window, SDL_GPU_SWAPCHAINCOMPOSITION_SDR, SDL_GPU_PRESENTMODE_IMMEDIATE);
            }
            
        }
    }
}
