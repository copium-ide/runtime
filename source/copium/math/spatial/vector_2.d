module copium.math.spatial.vector_2;

import std.math : sqrt, fabs;

public struct Vector2D
{
    double x;
    double y;

    // call as Vector2D(x,y)
    @nogc this(double x, double y)
    {
        if (x == double.nan || y == double.nan)
        {
            this.x = 0;
            this.y = 0;
        }
        else
        {
            this.x = x;
            this.y = y;
        }
    }

    // operator overloading for binary operations (e.g., v1 + v2, v1 - v2, v1 * v2, v1 / v2)
    @nogc public Vector2D opBinary(string op)(Vector2D rhs) const
    {
        static if (op == "+" || op == "-" || op == "*" || op == "/")
        {
            return mixin("Vector2D(x " ~ op ~ " rhs.x, y " ~ op ~ " rhs.y)");
        }
        else
        {
            static assert(0, "Operator " ~ op ~ " not implemented for Vector2D");
        }
    }

    // Scalar operations (e.g., v * 2.0, v + 2.0)
    @nogc public Vector2D opBinary(string op)(double scalar) const
    {
        static if (op == "+" || op == "-" || op == "*" || op == "/")
        {
            return mixin("Vector2D(x " ~ op ~ " scalar, y " ~ op ~ " scalar)");
        }
        else
        {
            static assert(0, "Scalar operator " ~ op ~ " not implemented for Vector2D");
        }
    }

    // Helper function for left-hand-side scalar operations (e.g. 2.0 * v)
    @nogc public Vector2D opBinaryRight(string op)(double lhs) const
    {
        static if (op == "+" || op == "*")
        {
            // Addition and multiplication are commutative, reuse opBinary
            return this.opBinary!(op)(lhs);
        }
        else static if (op == "-")
        {
            return Vector2D(lhs - this.x, lhs - this.y);
        }
        else static if (op == "/")
        {
            return Vector2D(lhs / this.x, lhs / this.y);
        }
        else
        {
            static assert(0, "Scalar operator opBinaryRight " ~ op ~ " not implemented for Vector2D");
        }
    }

    // Operator overloading for unary operations (e.g., -v)
    @nogc public Vector2D opUnary(string op)() const
    {
        static if (op == "-")
        {
            return Vector2D(-x, -y);
        }
        else static if (op == "+")
        {
            return this;
        }
        else
        {
            static assert(0, "Unary operator " ~ op ~ " not implemented for Vector2D");
        }
    }

    // Compound assignment operators (e.g., v1 += v2)
    @nogc public Vector2D opOpAssign(string op)(Vector2D rhs)
    {
        static if (op == "+" || op == "-" || op == "*" || op == "/")
        {
            mixin("x " ~ op ~ "= rhs.x;");
            mixin("y " ~ op ~ "= rhs.y;");
            return this;
        }
        else
        {
            static assert(0, "Compound operator " ~ op ~ "= not implemented for Vector2D");
        }
    }

    // Compound assignment operators with a scalar (e.g., v += 2.0)
    @nogc public Vector2D opOpAssign(string op)(double scalar)
    {
        static if (op == "+" || op == "-" || op == "*" || op == "/")
        {
            mixin("x " ~ op ~ "= scalar;");
            mixin("y " ~ op ~ "= scalar;");
            return this;
        }
        else
        {
            static assert(0, "Compound operator " ~ op ~ "= not implemented for Vector2D with scalar");
        }
    }

    // methods

    // Magnitude (length) of the vector
    @nogc @property public double length() const
    {
        return sqrt(x * x + y * y);
    }

    // Magnitude squared (useful for comparisons without expensive sqrt)
    @nogc @property public double lengthSquared() const
    {
        return x * x + y * y;
    }

    // Normalizes the vector to a unit vector (length of 1)
    @nogc public Vector2D normalized() const
    {
        double len = length();
        // Handle the zero vector case to avoid division by zero
        if (fabs(len) < 1e-9)
        {
            return Vector2D(0, 0);
        }
        return Vector2D(x / len, y / len);
    }

    // Dot product with another vector
    @nogc public double dot(Vector2D rhs) const
    {
        return x * rhs.x + y * rhs.y;
    }

}
