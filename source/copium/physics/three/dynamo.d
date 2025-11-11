module copium.physics.three.dynamo;
/// Dynamo physics engine
import copium.math.spatial.three.vector3;
import copium.rendering.window : deltaTime;

public struct Dynamo
{
    // Trying to go for XPBD type shii... wish me luck lmao
    Dscene solve(Dscene scene, int iterations) {
        foreach(DScene.MaterialBody mbody; scene.mbodies) {
            foreach(Dscene.MaterialBody.NodeGroup ngroup; mbody.ngroups) {
                foreach(DScene.NodeGroup.Node node; ngroup) {
                    Vector3D raw = node.position + node.velocity*deltaTime;
                    Vector3D[] constraints;
                    foreach(DScene.MaterialBody.NodeGroup.Node.Constraint constraint; node.constraints) {

                    }
                }
            }
        }
    }
}
public struct DScene
{
    // TODO: Make a plan for voxel terrain and fluid simulation (which would include pressurization)

    MaterialBody[] mbodies;
    struct MaterialBody {
        NodeGroup[] ngroups;
        struct NodeGroup {
            struct Node {
                Vector3D position;
                Vector3D velocity;
                Constraint[] constraints;
                struct Constraint {
                    // TODO: do this
                    // Damage will be subtracted from every stat when determining what type of deform.
                    // If the force difference is greater than elastic, allow but apply a force pulling them back towards each other.
                    // If the force difference is greater than plastic, set length to the updated distance. (and apply pulling force?? need more research)
                    // If the force difference is greater than rigid, sever connection.
                    // Damage = Damage + magnitude of force * some modifier
                    // The applied forces will try to stabilize at length.
                    float rigid;
                    float plastic;
                    float elastic;
                    float stiffness; // Determines how hard the material pulls back
                    float length; // Determines what it pulls to
                    float damage;
                    // Had to resist the urge to name this function "ISSBROKIE?" lmao
                    bool isBroken() {
                        // TODO: Too tired.
                    }
                }
            }
            
        }
    }


}
