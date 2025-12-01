module main;

import std.stdio;
import copium.math.measurement.distance;

alias Meter = Distance!("m", 1, float);
alias Kilometer = Distance!("km", 1_000, float);
alias Centimeter = Distance!("cm", 0.01, float);

void main() {
    auto d1 = Kilometer(10.0);
    auto d2 = Meter(500.0);
    auto d3 = Centimeter(250.0);

    // Adding km and m results in km (LHS type)
    auto sum1 = d1 + d2; 
    writeln(sum1, " from ",d1," + ",d2); // 10.50 km

    // Subtracting m from cm results in cm (LHS type)
    auto diff1 = d3 - d2;
    writeln(diff1); // -49750.00 cm

    // Adding m and km results in m (LHS type)
    auto sum2 = d2 + d1;
    writeln(sum2); // 10500.00 m

    auto result = Meter(500.0) + Kilometer(10.0);
    writeln(result);

    if (d1 > d2)
    {
        writeln("d1 is bigger");
    } else {
        writeln("d2 is bigger");
    }
    if (d1 == d2)
    {
        writeln("equal");
    } else {
        writeln("inequal");
    }
}