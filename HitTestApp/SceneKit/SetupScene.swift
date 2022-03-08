//
//  SetupScene.swift
//  HitTestApp
//
//  Created by Eric Freitas on 12/28/21.
//

import Foundation
import SceneKit

// This function will setup the camera.  In this there are two nodes.  The camera node, and
// a camera orbit node.  Attaching the cameraNode to the cameraOrbit node allows the camera to
// be rotated around whichever node the cameraOrbit node is attached to as a child.  The drag
// gesture is used to calculate the eulerAngles which determine the position that the camera node
// takes around it's parent node.
func setupCameraNode(scene: SCNScene) -> SCNNode {
    // Create the camera node.  Set a look(at:) constraint to the first ball at a distance of 40 units.
    let cameraNode = SCNNode()
    cameraNode.camera = SCNCamera()
    cameraNode.camera?.automaticallyAdjustsZRange = true
    cameraNode.look(at: scene.rootNode.childNode(withName: "Sphere0", recursively: true)?.position ?? SCNVector3(x: 0, y: 0, z: 0))
    cameraNode.position = SCNVector3(x: 0, y: 0, z: 40)
    
    return cameraNode
}

func setupCameraOrbit(cameraNode: SCNNode, scene: SCNScene) -> SCNNode {
    // Create the cameraOrbit node.  Set the x eulerAngle to a slight tilt, simply personal preference.
    // add the cameraNode as a child, and the cameraOrbit node as a child of the root node, which in this
    // case corresponds to Ball0, coincidentally.
    let cameraOrbit = SCNNode()
    cameraOrbit.eulerAngles.x = -0.26179
    cameraOrbit.addChildNode(cameraNode)
    
    // Add the cameraOrbit node as a child node of the rootNode.
    scene.rootNode.addChildNode(cameraOrbit)
    
    return cameraOrbit
}

func addSpheres(scene: SCNScene) {
    
    let pointCount = 2
    // Add a parent node for the balls.  Having them as children of this node adds some
    // flexibility to our use of cameras in later development.  For instance setting the camera to
    // this parent node will allow moving it and all it's children to another location in the scene.
    let parentNode = SCNNode()
    
    // Create up to the pointCount number of balls..
    for pointIdx in 0 ..< pointCount {
        
        // Create the balls with SCNSphere geometry, then generate a random color for any ballls
        // created after the first two, which are currently hardcoded to yellow and red for demonstration
        // purposes.
        let sphereGeometry = SCNSphere(radius: 1)
        let sphere = SCNNode(geometry: sphereGeometry)
        var ballColor: NSColor!
        
        // Generate the positions of the balls and assign the color.  Again, the first two balls
        // are created with fixed positions and colors.
        var position: SCNVector3 = SCNVector3()
        if pointIdx == 0 {
            position = SCNVector3(0.0, 0.0, 0.0)
            ballColor = NSColor.yellow
        } else if pointIdx == 1 {
            position = SCNVector3(15, 0, 0)
            ballColor = NSColor.red
        }
        sphere.position = position
        
        // add diffuse and emission colors for the balls.
        sphere.geometry?.firstMaterial?.diffuse.contents = ballColor
        sphere.geometry?.firstMaterial?.emission.contents = ballColor
        sphere.name = "Sphere\(pointIdx)"
        
        // add the ball as a child node of the parent node
        parentNode.addChildNode(sphere)
    }
    // add the parent node as a child of the rootNode
    scene.rootNode.addChildNode(parentNode)
    
    // Set the position of the parent node to the same position as it's first child node.  (Not really necessary in this demo)
    parentNode.position = parentNode.childNodes.first?.position ?? parentNode.position
}
