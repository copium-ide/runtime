module copium.math.spatial.distance;

import std.traits : isFloatingPoint, ReturnType;
import std.format : format;

/// Universal distance struct
struct Distance(string name, double factor)
{
    double value;

    this(double v)
    {
        this.value = v;
    }

    string toString() const
    {
        return format("%.2f%s", this.value, name);
    }

    // Method to convert the local value into the common base unit value (Meters)
    double toMeters() const
    {
        return this.value * factor;
    }

    // Method to convert a meter value back into (this) local unit
    static auto fromMeters(double meters)
    {
        return typeof(this)(meters / factor);
    }

    // Overload binary operators for Distance types. Converts both operands to meters, performs the operation, and returns the result converted back to the left-hand side's type (this).
    auto opBinary(string op, T2)(T2 rhs)
        if (is(T2 == Distance!U2, U2...)) // Constraint on the RHS type
    {
        static if (op == "+" || op == "-" || op == "*" || op == "/")
        {
            double rhsMeters = rhs.toMeters();
            double lhsMeters = this.toMeters();
            double resultInMeters;

            // Use a mixin to inject the actual operator at compile time
            mixin(`resultInMeters = lhsMeters ` ~ op ~ ` rhsMeters;`);

            // Convert the resulting meter value back into the same type of (this)
            return this.fromMeters(resultInMeters);
        }
        else
        {
            static assert(false, "Unsupported operator: " ~ op);
        }
    }
}

// Instantiate specific distance types:
alias Meter = Distance!("m", 1.0); /// Meters
alias Kilometer = Distance!("km", 1000.0); /// Kilometers
alias Mile = Distance!("mi", 1609.34); /// Miles
alias Centimeter = Distance!("cm", 0.01); /// Centimeters
