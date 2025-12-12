module copium.math.interval;

import std.datetime;

/// Takes a double for fps.
struct FPS
{
    long interval;
    Duration deltaTime;
    Duration accumulator;
    MonoTime previousTime;

    @nogc this(double fps)
    {
        previousTime = MonoTime.currTime();
        accumulator = Duration.zero;
        interval = cast(long) (1000.0 / fps);
        deltaTime = dur!"msecs"(interval);
    }

    @nogc bool shouldFire()
    {
        auto currentTime = MonoTime.currTime();
        auto frameTime = currentTime - previousTime;
        this.previousTime = currentTime;


        this.accumulator += frameTime;

        if (this.accumulator >= deltaTime)
        {
            this.accumulator = dur!"msecs"(0);
            return true;
        }

        return false;
    }

}
