module copium.math.vec3d;

import std.math : sqrt, fabs;

public struct Vector3D
{
    double x;
    double y;
    double z;

    // call as new Vector3d(x,y,z)
    this(double x, double y, double z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    // operator overloading for binary operations (e.g., v1 + v2, v1 - v2, v1 * v2, v1 / v2)
    public Vector3D opBinary(string op)(Vector3D rhs) const {
        static if (op == "+" || op == "-" || op == "*" || op == "/") {
            return mixin("Vector3D(x " ~ op ~ " rhs.x, y " ~ op ~ " rhs.y, z " ~ op ~ " rhs.z)");
        } else {
            static assert(0, "Operator " ~ op ~ " not implemented for Vector3D");
        }
    }

    // Operator overloading for scalar multiplication/division (e.g., v * 2.0, v / 2.0)
    public Vector3D opBinary(string op)(double scalar) const {
        static if (op == "*" || op == "/") {
            return mixin("Vector3D(x " ~ op ~ " scalar, y " ~ op ~ " scalar, z " ~ op ~ " scalar)");
        } else {
            static assert(0, "Operator " ~ op ~ " not implemented for Vector3D with scalar");
        }
    }

    // Operator overloading for unary operations (e.g., -v)
    public Vector3D opUnary(string op)() const {
        static if (op == "-") {
            return Vector3D(-x, -y, -z);
        }
        else static if (op == "+") {
            return this;
        } else {
            static assert(0, "Unary operator " ~ op ~ " not implemented for Vector3D");
        }
    }

    // Compound assignment operators (e.g., v1 += v2)
    public Vector3D opOpAssign(string op)(Vector3D rhs) {
        static if (op == "+" || op == "-" || op == "*" || op == "/") {
            mixin("x " ~ op ~ "= rhs.x;");
            mixin("y " ~ op ~ "= rhs.y;");
            mixin("z " ~ op ~ "= rhs.z;");
            return this;
        } else {
            static assert(0, "Compound operator " ~ op ~ "= not implemented for Vector3D");
        }
    }

    // Compound assignment operators with a scalar (e.g., v += 2.0)
    public Vector3D opOpAssign(string op)(double scalar) {
        static if (op == "+" || op == "-" || op == "*" || op == "/") {
            mixin("x " ~ op ~ "= scalar;");
            mixin("y " ~ op ~ "= scalar;");
            mixin("z " ~ op ~ "= scalar;");
            return this;
        } else {
            static assert(0, "Compound operator " ~ op ~ "= not implemented for Vector3D with scalar");
        }
    }


    // methods

    // Magnitude (length) of the vector
    @property public double length() const {
        return sqrt(x*x + y*y + z*z);
    }

    // Magnitude squared (useful for comparisons without expensive sqrt)
    @property public double lengthSquared() const {
        return x*x + y*y + z*z;
    }

    // Normalizes the vector to a unit vector (length of 1)
    public Vector3D normalized() const {
        double len = length();
        // Handle the zero vector case to avoid division by zero
        if (fabs(len) < 1e-9) {
            return Vector3D(0, 0, 0);
        }
        return Vector3D(x / len, y / len, z / len);
    }

    // Dot product with another vector
    public double dot(Vector3D rhs) const {
        return x*rhs.x + y*rhs.y + z*rhs.z;
    }

    // Cross product with another vector (only in 3D)
    public Vector3D cross(Vector3D rhs) const {
        return Vector3D(
            y * rhs.z - z * rhs.y,
            z * rhs.x - x * rhs.z,
            x * rhs.y - y * rhs.x
        );
    }

}
