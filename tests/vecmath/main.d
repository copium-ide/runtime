module tests.vecmath.main;

import std.stdio;
import std.math : approxEqual;
import copium.math.vec3d;

// Helper function to check if two vectors are approximately equal
bool areVectorsEqual(Vector3D v1, Vector3D v2, double tolerance = 1e-9) {
    return approxEqual(v1.x, v2.x, tolerance) &&
           approxEqual(v1.y, v2.y, tolerance) &&
           approxEqual(v1.z, v2.z, tolerance);
}

void main()
{
    // --- Initialization Tests ---
    writeln("--- Initialization Tests ---");
    auto v1 = Vector3D(1.0, 2.0, 3.0);
    auto v_default = Vector3D(); // Should be (0, 0, 0) due to Dlang's default struct initialization
    
    assert(v1.x == 1.0 && v1.y == 2.0 && v1.z == 3.0);
    assert(areVectorsEqual(v_default, Vector3D(0, 0, 0)));
    writeln("Initialization tests passed.");

    // --- Unary Operator Tests ---
    writeln("\n--- Unary Operator Tests ---");
    auto v_neg = -v1;
    assert(areVectorsEqual(v_neg, Vector3D(-1.0, -2.0, -3.0)));
    writeln("-v1 = ", v_neg);

    // --- Binary Operator Tests (Vector-Vector) ---
    writeln("\n--- Binary Operator Tests (Vector-Vector) ---");
    auto v2 = Vector3D(4.0, 5.0, 6.0);

    auto v_add = v1 + v2;
    assert(areVectorsEqual(v_add, Vector3D(5.0, 7.0, 9.0)));
    writeln(v1, " + ", v2, " = ", v_add);

    auto v_sub = v2 - v1;
    assert(areVectorsEqual(v_sub, Vector3D(3.0, 3.0, 3.0)));
    writeln(v2, " - ", v1, " = ", v_sub);

    auto v_mul = v1 * v2;
    assert(areVectorsEqual(v_mul, Vector3D(4.0, 10.0, 18.0)));
    writeln(v1, " * ", v2, " (component-wise) = ", v_mul);
    
    // --- Binary Operator Tests (Vector-Scalar) ---
    writeln("\n--- Binary Operator Tests (Vector-Scalar) ---");
    double scalar = 2.0;
    auto v_scale = v1 * scalar;
    assert(areVectorsEqual(v_scale, Vector3D(2.0, 4.0, 6.0)));
    writeln(v1, " * ", scalar, " = ", v_scale);

    auto v_div = v1 / scalar;
    assert(areVectorsEqual(v_div, Vector3D(0.5, 1.0, 1.5)));
    writeln(v1, " / ", scalar, " = ", v_div);

    // --- Binary Operator Tests (Scalar-Vector) ---
    writeln("\n--- Binary Operator Tests (Scalar-Vector) ---");
    auto v_scale_left = scalar * v1; // Tests opBinaryRight
    assert(areVectorsEqual(v_scale_left, Vector3D(2.0, 4.0, 6.0)));
    writeln(scalar, " * ", v1, " = ", v_scale_left);


    // --- Compound Assignment Tests ---
    writeln("\n--- Compound Assignment Tests ---");
    auto v3 = Vector3D(1.0, 1.0, 1.0);
    v3 += Vector3D(2.0, 2.0, 2.0);
    assert(areVectorsEqual(v3, Vector3D(3.0, 3.0, 3.0)));
    writeln("v3 after += vector: ", v3);
    
    v3 *= 2.0;
    assert(areVectorsEqual(v3, Vector3D(6.0, 6.0, 6.0)));
    writeln("v3 after *= scalar: ", v3);

    // --- Vector Math Methods Tests ---
    writeln("\n--- Vector Math Methods Tests ---");
    auto v4 = Vector3D(3.0, 0.0, 4.0); // A 3-4-5 triangle vector
    
    assert(v4.lengthSquared == 25.0);
    writeln(v4, " length squared = ", v4.lengthSquared);

    assert(v4.length == 5.0);
    writeln(v4, " length = ", v4.length);

    auto unit_v4 = v4.normalized();
    auto expected_unit = Vector3D(0.6, 0.0, 0.8);
    assert(areVectorsEqual(unit_v4, expected_unit));
    assert(approxEqual(unit_v4.length, 1.0));
    writeln(v4, " normalized = ", unit_v4);

    double dot_prod = v1.dot(v2);
    assert(dot_prod == 4.0 + 10.0 + 18.0);
    writeln("Dot product of ", v1, " and ", v2, " = ", dot_prod);

    auto cross_prod = v1.cross(Vector3D(1.0, 0.0, 0.0));
    auto expected_cross = Vector3D(0.0, 3.0, -2.0);
    assert(areVectorsEqual(cross_prod, expected_cross));
    writeln("Cross product of ", v1, " and (1,0,0) = ", cross_prod);
}
