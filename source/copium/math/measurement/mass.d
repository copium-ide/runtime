module copium.math.measurement.mass;

import std.traits : isFloatingPoint, ReturnType;
import std.format : format;

/// Universal Mass struct
struct Mass(string name, double factor, T)
{
    T value;

    @nogc this(T v)
    {
        this.value = v;
    }

    // Method to convert the local value into the common base unit value
    @nogc auto toBaseUnit() const
    {
        return this.value * factor;
    }

    // Method to convert a meter value back into (this) local unit
    @nogc static auto fromBaseUnit(double value)
    {
        return typeof(this)(value / factor);
    }

    // Overload binary operators for Distance types. Converts both operands to the base unit, performs the operation, and returns the result converted back to the left-hand side's type (this).
    @nogc auto opBinary(string op, T2)(T2 rhs)
        if (is(T2 == Distance!U2, U2...)) // Constraint on the RHS type
    {
        static if (op == "+" || op == "-" || op == "*" || op == "/")
        {
            double rhsBaseUnit = rhs.toBaseUnit();
            double lhsBaseUnit = this.toBaseUnit();
            double resultInBaseUnit;

            // Use a mixin to inject the actual operator at compile time
            mixin(`resultInBaseUnit = lhsBaseUnit ` ~ op ~ ` rhsBaseUnit;`);

            // Convert the resulting newton value back into the same type of (this)
            return this.fromBaseUnit(resultInBaseUnit);
        }
        else
        {
            static assert(false, "Unsupported operator: " ~ op);
        }
    }
    @nogc auto opEquals(RHS)(ref const RHS rhs) const if (is(RHS == Distance!U2, U2...))
    {
        return this.toBaseUnit() == rhs.toBaseUnit();
    }

    @nogc auto opCmp(RHS)(ref const RHS rhs) const 
        if (is(RHS == Distance!U2, U2...))
    {
        double lhsBaseUnit = this.toBaseUnit();
        double rhsBaseUnit = rhs.toBaseUnit();

        if (lhsBaseUnit < rhsBaseUnit) {
            return -1;
        } else if (lhsBaseUnit > rhsBaseUnit) {
            return 1;
        } else {
            return 0;
        }
    }
}
