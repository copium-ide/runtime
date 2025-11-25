module copium.math.measurement.time;

import std.traits : isFloatingPoint, ReturnType;
import std.format : format;

/// Universal Time struct
struct Time(string name, double factor)
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

    // Method to convert the local value into the common base unit value
    double toBaseUnit() const
    {
        return this.value * factor;
    }

    // Method to convert a meter value back into (this) local unit
    static auto fromBaseUnit(double value)
    {
        return typeof(this)(value / factor);
    }

    // Overload binary operators for Distance types. Converts both operands to the base unit, performs the operation, and returns the result converted back to the left-hand side's type (this).
    auto opBinary(string op, T2)(T2 rhs)
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
}

// Instantiate specific unit types:
alias MicroSecond = Time!("ms", 0.000001); /// Microseconds
alias MilliSecond = Time!("ms", 0.001); /// Milliseconds
alias Second = Time!("s", 1.0); /// Seconds
alias Minute = Time!("m", 60.0); /// Minutes
alias Hour = Time!("h", 3_600.0); /// Hours
alias Days = Time!("d", 86_400.0); /// Days

