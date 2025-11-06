module copium.math.vec3d;

public struct Vector3D
{
    double x;
    double y;
    double z;
    Vector3D opUnary(string s)(Vector3D factor)
    {
        Vector3D vector;
        switch (s) {
            case "+":
                vector.x = vector.x + factor.x;
                vector.y = vector.y + factor.y;
                vector.z = vector.z + factor.z;
            case "-":
                vector.x = vector.x - factor.x;
                vector.y = vector.y - factor.y;
                vector.z = vector.z - factor.z;
            case "*":
                vector.x = vector.x * factor.x;
                vector.y = vector.y * factor.y;
                vector.z = vector.z * factor.z;
            case "/":
                vector.x = vector.x / factor.x;
                vector.y = vector.y / factor.y;
                vector.z = vector.z / factor.z;
            case "*~":
                // this is for rotating a vector where vector is a location and factor is a rotation value from 0 to 1
                // TODO: actually implement it.
                vector.x = vector.x + factor.x;
                vector.y = vector.y + factor.y;
                vector.z = vector.z + factor.z;
        }
        
        return vector;
    }
}