module copium.physics.three.dynamo;
/// Dynamo physics engine
import copium.math.vectors.three;
import copium.rendering.window : deltaTime;
import copium.math.spatial.distance;

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
        Vector3D position;
        Vector3D velocity;
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
        // TODO: do this
        // Damage will be subtracted from every stat when determining what type of deform.
        // If the force difference is greater than elastic, allow but apply a force pulling them back towards each other.
        // If the force difference is greater than plastic, set length to the updated distance. (and apply pulling force?? need more research)
        // If the force difference is greater than rigid, sever connection.
        // Damage = Damage + magnitude of force * some modifier
        // The applied forces will try to stabilize at length.

        // Mechanical:
        float tensileStrength; /// How much stress a constraint can endure before breaking.
        float yieldStrength; /// How much stress a constraint can endure before having plastic deformation.
        float youngMod; /// Young's modulus (how hard it resists pulling in the elastic range).

        // Temperature: (in celcius)
        // Freezing and melting point are separate for certain substances, so why would I limit this?
        float freezingPoint; /// Temperature at which the material freezes.
        float meltingPoint; /// Temperature at which the material melts.

        float length; /// Determines what distance the solver tries to pull to.
        float damage;
        Node* node1;
        Node* node2;

        Vector3D[2] solveVelocities()
        {
            double currentLength = distance(node1.position, node2.position);
            Vector3D[2] vectors = [
                Vector3D(),
                Vector3D()
            ];
            return vectors;
        }
        // Had to resist the urge to name this function "ISSBROKIE?" lmao
        bool isBroken()
        {
            // TODO: Too tired.
            return false;
        }
    }
}
struct LiquidBody
{
    // Outline: simulates at increasing resolution the closer it is to a solid body.
    double minimumResolution = metersInCentimeter/10;
    double maximumResolution = meter*50;
}
