import std.datetime.stopwatch : StopWatch, AutoStart;
import std.stdio : writefln;
import core.time : Duration;

struct ParticleStruct {
    float[3] pos;
    float[3] vel;
    float mass;
}

class ParticleClass {
    float[3] pos;
    float[3] vel;
    float mass;
    
    this() {
        pos = [0, 0, 0];
        vel = [1, 1, 1];
        mass = 1.0f;
    }
}

void main() {
    enum size_t N = 1_000_000;
    enum int iterations = 100;
    
    // ========================================
    // STRUCT BENCHMARK
    // ========================================
    writefln("Allocating %s structs...", N);
    auto allocTimer = StopWatch(AutoStart.yes);
    
    ParticleStruct[] structParticles;
    structParticles.length = N;
    foreach (ref p; structParticles) {
        p.pos = [0, 0, 0];
        p.vel = [1, 1, 1];
        p.mass = 1.0f;
    }
    
    allocTimer.stop();
    writefln("Struct allocation: %s ms", allocTimer.peek.total!"msecs");
    
    writefln("\nRunning %s iterations on structs...", iterations);
    auto structTimer = StopWatch(AutoStart.yes);
    
    foreach (iter; 0..iterations) {
        foreach (ref p; structParticles) {
            p.pos[0] += p.vel[0] * 0.016f;
            p.pos[1] += p.vel[1] * 0.016f;
            p.pos[2] += p.vel[2] * 0.016f;
        }
    }
    
    structTimer.stop();
    Duration structDuration = structTimer.peek;
    writefln("Struct total: %s ms", structDuration.total!"msecs");
    writefln("Struct per iteration: %.3f ms", structDuration.total!"usecs" / cast(float)iterations / 1000.0);
    
    // ========================================
    // CLASS BENCHMARK
    // ========================================
    writefln("\n\nAllocating %s classes...", N);
    allocTimer.reset();
    allocTimer.start();
    
    ParticleClass[] classParticles;
    classParticles.length = N;
    foreach (ref p; classParticles) {
        p = new ParticleClass();
    }
    
    allocTimer.stop();
    writefln("Class allocation: %s ms", allocTimer.peek.total!"msecs");
    
    writefln("\nRunning %s iterations on classes...", iterations);
    auto classTimer = StopWatch(AutoStart.yes);
    
    foreach (iter; 0..iterations) {
        foreach (p; classParticles) {
            p.pos[0] += p.vel[0] * 0.016f;
            p.pos[1] += p.vel[1] * 0.016f;
            p.pos[2] += p.vel[2] * 0.016f;
        }
    }
    
    classTimer.stop();
    Duration classDuration = classTimer.peek;
    writefln("Class total: %s ms", classDuration.total!"msecs");
    writefln("Class per iteration: %.3f ms", classDuration.total!"usecs" / cast(float)iterations / 1000.0);
    
    // ========================================
    // COMPARISON
    // ========================================
    writefln("\n========================================");
    writefln("RESULTS:");
    writefln("========================================");
    writefln("Struct: %.3f ms per iteration", structDuration.total!"usecs" / cast(float)iterations / 1000.0);
    writefln("Class:  %.3f ms per iteration", classDuration.total!"usecs" / cast(float)iterations / 1000.0);
    writefln("Speedup: %.2fx faster with structs", 
             cast(float)classDuration.total!"usecs" / cast(float)structDuration.total!"usecs");
}