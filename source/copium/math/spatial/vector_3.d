module copium.math.spatial.vector_3;

import std.math : sqrt, fabs;
import std.stdio : writeln; // Added for the example usage

public struct Vector3D {
    double x;
    double y;
    double z;

    // call as Vector3d(x,y,z)
    @nogc this(double x, double y, double z) {
        if (x == double.nan || y == double.nan || z == double.nan) {
            this.x = 0;
            this.y = 0;
            this.z = 0;
        } else {
            this.x = x;
            this.y = y;
            this.z = z;
        }
    }

    // operator overloading for binary operations (e.g., v1 + v2, v1 - v2, v1 * v2, v1 / v2)
    @nogc public Vector3D opBinary(string op)(Vector3D rhs) const {
        static if (op == "+" || op == "-" || op == "*" || op == "/") {
            return mixin("Vector3D(x " ~ op ~ " rhs.x, y " ~ op ~ " rhs.y, z " ~ op ~ " rhs.z)");
        } else {
            static assert(0, "Operator " ~ op ~ " not implemented for Vector3D");
        }
    }

    // Operator overloading for unary operations (e.g., "-v)"
    @nogc public Vector3D opUnary(string op)() const {
        static if (op == "-") {
            return Vector3D(-x, -y, -z); // Fixed syntax errors here
        } else static if (op == "+") {
            return this;
        } else {
            static assert(0, "Unary operator " ~ op ~ " not implemented for Vector3D");
        }
    }

    // Compound assignment operators (e.g., v1 += v2)
    @nogc public Vector3D opOpAssign(string op)(Vector3D rhs) {
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
    @nogc public Vector3D opOpAssign(string op)(double scalar) {
        static if (op == "+" || op == "-" || op == "*" || op == "/") {
            mixin("x " ~ op ~ "= scalar;");
            mixin("y " ~ op ~ "= scalar;");
            mixin("z " ~ op ~ "= scalar;");
            return this;
        } else {
            static assert(0, "Compound operator " ~ op ~ "= not implemented for Vector3D with scalar");
        }
    }

    // Scalar operations (e.g., v * 2.0, 2.0 * v)
    @nogc public Vector3D opBinary(string op)(double scalar) const {
        static if (op == "+" || op == "-" || op == "*" || op == "/") {
            return mixin("Vector3D(x " ~ op ~ " scalar, y " ~ op ~ " scalar, z " ~ op ~ " scalar)");
        } else {
            static assert(0, "Scalar operator " ~ op ~ " not implemented for Vector3D");
        }
    }

    // Helper function for left-hand-side scalar operations (e.g. 2.0 * v)
    // The `opBinaryRight` template allows the compiler to handle cases where the scalar is on the left.
    // This is defined as a non-static member function taking the right-hand side type as argument
    @nogc public Vector3D opBinaryRight(string op)(double lhs) const {
        static if (op == "+" || op == "*") {
            // Addition and multiplication are commutative, reuse opBinary
            return this.opBinary!(op)(lhs);
        } else static if (op == "-") {
            return Vector3D(lhs - this.x, lhs - this.y, lhs - this.z);
        } else static if (op == "/") {
            return Vector3D(lhs / this.x, lhs / this.y, lhs / this.z);
        } else {
            static assert(0, "Scalar operator opBinaryRight " ~ op ~ " not implemented for Vector3D");
        }
    }

    // methods
    // Magnitude (length) of the vector
    @nogc @property public double length() const {
        return sqrt(x * x + y * y + z * z);
    }

    // Magnitude squared (useful for comparisons without expensive sqrt)
    @nogc @property public double lengthSquared() const {
        return x * x + y * y + z * z;
    }

    // Normalizes the vector to a unit vector (length of 1)
    @nogc public Vector3D normalize() const {
        double len = length();
        // Handle the zero vector case to avoid division by zero
        if (fabs(len) < 1e-9) {
            return Vector3D(0, 0, 0);
        }
        return Vector3D(x / len, y / len, z / len);
    }
}

/// Distance between vectors
@nogc public double distance(Vector3D lhs, Vector3D rhs) {
    double dx = lhs.x - rhs.x;
    double dy = lhs.y - rhs.y;
    double dz = lhs.z - rhs.z;
    return sqrt(dx*dx + dy*dy + dz*dz);
}

/// Dot product with another vector
@nogc public double dot(Vector3D lhs, Vector3D rhs) {
    return lhs.x * rhs.x + lhs.y * rhs.y + lhs.z * rhs.z;
}

/// Cross product with another vector (only in 3D)
@nogc public Vector3D cross(Vector3D lhs, Vector3D rhs) {
    return Vector3D(
        lhs.y * rhs.z - lhs.z * rhs.y,
        lhs.z * rhs.x - lhs.x * rhs.z,
        lhs.x * rhs.y - lhs.y * rhs.x
    );
}