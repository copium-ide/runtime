deprecated("Use a shader please.")
module copium.math.spatial.depth_camera;
/// This is going to be replaced with a shader
import copium.math.spatial.vector_3;
import copium.math.spatial.vector_2;
import std.math.trigonometry;
import std.math.constants : PI;

/// Turns degrees into radians.
@nogc private double toRadians(double degrees){
    return degrees * (PI/180);
}

/// Represents a 3x3 rotation matrix
private struct Matrix3x3 {
    double[3][3] data;

    // Multiplies a Matrix3x3 by a Vector3D
    @nogc public Vector3D opBinary(string op)(Vector3D rhs) const {
        static if (op == "*") {
            return Vector3D(
                data[0][0] * rhs.x + data[0][1] * rhs.y + data[0][2] * rhs.z,
                data[1][0] * rhs.x + data[1][1] * rhs.y + data[1][2] * rhs.z,
                data[2][0] * rhs.x + data[2][1] * rhs.y + data[2][2] * rhs.z
            );
        } else {
            static assert(0, "Operator " ~ op ~ " not implemented for Matrix3x3 * Vector3D");
        }
    }
}

/// Creates a rotation matrix from Euler angles (pitch, yaw, roll) around X, Y, Z axes
@nogc private Matrix3x3 createRotationMatrix(Vector3D rotation) {
    // Convert degrees to radians if necessary, assuming input 'rotation' is in a specific unit.
    // If your input is already in radians, remove the toRadians calls.
    double pitch = toRadians(rotation.x); // Rotation around X-axis (pitch)
    double yaw   = toRadians(rotation.y); // Rotation around Y-axis (yaw)
    double roll  = toRadians(rotation.z); // Rotation around Z-axis (roll)

    double cosP = cos(pitch), sinP = sin(pitch);
    double cosY = cos(yaw),   sinY = sin(yaw);
    double cosR = cos(roll),  sinR = sin(roll);

    Matrix3x3 m;

    // Combined rotation matrix (Y * X * Z, assuming a typical flight simulator order, but this order is often environment specific)
    // The implementation below assumes a specific order, adjust as needed.
    // This is a standard YXZ rotation matrix construction:
    m.data[0][0] = cosY * cosR + sinY * sinP * sinR;
    m.data[0][1] = sinR * cosP;
    m.data[0][2] = sinY * cosR - cosY * sinP * sinR;
    m.data[1][0] = cosY * -sinR + sinY * sinP * cosR;
    m.data[1][1] = cosP * cosR;
    m.data[1][2] = sinY * -sinR - cosY * sinP * cosR;
    m.data[2][0] = -sinY * cosP;
    m.data[2][1] = sinP;
    m.data[2][2] = cosY * cosP;
    
    return m;
}


/// X is horizantal, Y is vertical, Z is depth. Position and rotation are relative to the camera. What you see is what you get.
@nogc Vector2D[] onePointProject(Vector3D[] world, Vector3D position, Vector3D rotation, Vector3D pointOfProjection){
    Vector2D[] result;

    Matrix3x3 camRotationMatrix = createRotationMatrix(rotation); // Matrix is based on the camera's rotation.
    
    // For a standard pinhole camera model, the point of projection defines the focal length.
    // The distance from the camera origin (0,0,0 after transformation) to the projection plane.
    double focalDistance = pointOfProjection.z; // Assuming pointOfProjection is (0, 0, focal_length)

    foreach (i, point3D; world) {
        // 2. Translate world point relative to camera position (View Transform)
        // Camera space origin is at (0,0,0) with forward typically along the -Z axis in computer graphics.
        Vector3D relativePoint = point3D - position;

        // 3. Rotate the relative point into camera space orientation (View Transform)
        // We multiply by the rotation matrix to align the world coordinates with the camera's axes.
        Vector3D cameraSpacePoint = camRotationMatrix * relativePoint;

        // 4. Project from 3D camera space to 2D screen space (Projection Transform)
        // Standard perspective projection formula:
        // x_screen = (x_cam * focal_distance) / z_cam
        // y_screen = (y_cam * focal_distance) / z_cam

        // Handle points behind the camera or at the projection plane to avoid division by zero
        if (cameraSpacePoint.z > 1e-6) { // Ensure point is in front of the camera (positive Z in this coordinate system definition)
            double scale = focalDistance / cameraSpacePoint.z;
            double screenX = cameraSpacePoint.x * scale;
            double screenY = cameraSpacePoint.y * scale;
            
            result[i] = Vector2D(screenX, screenY);
        } else {
            // Point is directly in line with or behind camera. Send it to narnia.
            result[i] = Vector2D(double.nan, double.nan); 
        }
    }

    return result;
}