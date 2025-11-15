module copium.physics.three.particular;
/// Particular physics engine

// Data management:
// Vectors:
// Define a 3d vector of your current type by doing Type[3]
// X is [0], Y is [1], and Z is [2]
import copium.rendering.window : deltaTime;
import copium.math.spatial.distance;
import copium.math.spatial.speed;

public struct Dynamo
{
    // Trying to go for XPBD type shii... wish me luck lmao
}

public struct DScene
{
    // TODO: Make a plan for voxel terrain and fluid simulation (which would include pressurization)

}

/// This is for making solid objects like metal sheets or blocks.
struct SolidBody
{
    NodeGroup[] ngroups;
    struct NodeGroup
    {
        Node[] nodes;
    }

    struct Node
    {
        // TODO: find out how to define an array of constraints
        // We could do per node, which would be difficult to coordinate.
        // I'd like a general system where you can go solveConstraint(node1, node2), and if there is no link, it would return a velocity change of 0.
        Meter[3] position;
        MetersPerSecond[3] velocity;
        void addConstraint(Node otherNode)
        {

        }

        Vector3D getConstraintVelocity(Constraint* constraint)
        {
            return Vector3D();
        }
    }

    /// Joins two different nodes. This is my attempt at FEA.
    struct Constraint
    {
        Node* node1;
        Node* node2;
        MaterialProperties properties;

        this(Node* node1, Node* node2, MaterialProperties properties)
        {
            this.node1 = node1;
            this.node2 = node2;
            this.properties = properties;
        }

        MetersPerSecond[3][2] solveVelocities()
        {
            double currentLength = distance(node1.position, node2.position);

            MetersPerSecond[3][2] finalRet = [
                impulse1,
                impulse2
            ];
            return finalRet;
        }
        // Had to resist the urge to name this function "ISSBROKIE?" lmao
        bool isBroken()
        {
            // TODO: Too tired.
            return false;
        }
    }

    /// Properties for solid materials under tension and compression
    struct MaterialProperties
    {
        // If the force difference is greater than elastic, allow but apply a force pulling them back towards each other.
        // If the force difference is greater than plastic, set length to the updated distance. (and apply pulling force?? need more research)
        // If the force difference is greater than rigid, sever connection.
        // The applied forces will try to stabilize at length.

        // Mechanical:
        double tensileStrength; /// How much stress a constraint can endure before breaking.
        double yieldStrength; /// How much stress a constraint can endure before having plastic deformation.
        double youngMod; /// Young's modulus (how hard it resists pulling in the elastic range).

        // Temperature: (in celcius)
        // Freezing and melting point are separate for certain substances, so why would I limit this?
        double freezingPoint; /// Temperature at which the material freezes.
        double meltingPoint; /// Temperature at which the material melts.

        double length; /// Determines what distance the solver tries to pull to.
        double startLength; /// Tracks what the initial length was to determine stress profile
    }
}

struct LiquidBody
{
    // Outline: simulates at increasing resolution the closer it is to a solid body.
    auto minimumResolution = Centimeter(1 / 10);
    auto maximumResolution = Meter(50);
}
