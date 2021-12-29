//
//  ContentView.swift
//  HitTestApp
//
//  Created by Eric Freitas on 12/28/21.
//

import SwiftUI
import SceneKit

struct ContentView: View {
    
    @State private var scnScene = SCNScene()
    @State private var sceneView: ScenekitView!
    @State private var cameraNode = SCNNode()
    @State private var cameraOrbit: SCNNode!
    @State private var statusText = "..."
    @State private var targetNode: SCNNode!
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                sceneView
                    .allowsHitTesting(true)
                    .simultaneousGesture(
                        // DragGesture that is used to rotate the camera:
                        DragGesture()
                            .onChanged { drag in
                                let velocity = CGSize(
                                    width: drag.predictedEndLocation.x - drag.location.x,
                                    height: drag.predictedEndLocation.y - drag.location.y
                                )
                                let scrollWidthRatio = CGFloat(velocity.width) / 10000 * -1
                                let scrollHeightRatio = CGFloat(velocity.height) / 10000
                                cameraOrbit.eulerAngles.y += CGFloat(2 * CGFloat.pi) * scrollWidthRatio
                                cameraOrbit.eulerAngles.x += CGFloat(CGFloat.pi) * scrollHeightRatio
                            }
                    )
                    .simultaneousGesture(
                        // DragGesture that is used to get the tap location.  DragGesture is used because there is no
                        // location value provided with the TapGesture().  The location is used to perform hit testing
                        // on the sceneView (ScenekitView), our only NSViewRepresentable portion of code.
                        // The first node hit, the one closest to the camera, is returned and the name is stored in the
                        // State var statusText, which is used in the double tap gesture to focus.
                        DragGesture(minimumDistance: 0.0, coordinateSpace: .local)
                            .onEnded({ value in
                                var startLocation = value.startLocation
                                // pass the startLocation into the hitTest() method
                                startLocation.y = geometry.size.height - startLocation.y
                                let hits = sceneView.view.hitTest(startLocation, options: [:])
                                
                                if hits.count > 0 {
                                    statusText = hits.first?.node.name ?? ".."
                                    debugPrint("ball: \(hits.first?.node.name ?? "..")")
                                } else {
                                    statusText = ".."
                                }
                            })
                    )
                    .simultaneousGesture(
                        // The double tap gesture will both focus the view on the selected object, and change the pivot point so that
                        // rotations with the mouse or touchpad rotate the view around that object.  The statusText is also updated.
                        // The name of the node, located by the 0 minimum distance DragGesture above, is used to locate the node here
                        // the cameraOrbit node is set as a child of that node, with a look(at:) constraint to center on the selected ball.
                        TapGesture(count: 2)
                            .onEnded({ action in
                                if let targetNode = self.scnScene.rootNode.childNode(withName: statusText, recursively: true) {
                                    let targetPosition = targetNode.position
                                    cameraOrbit.removeFromParentNode()
                                    targetNode.addChildNode(cameraOrbit)
                                    cameraNode.look(at: targetPosition)
                                    self.targetNode = targetNode
                                    statusText = targetNode.name ?? ".."
                                }
                            })
                    )
            }
            
            VStack {
                Text("Selected Sphere: \(statusText)")
                    .padding()
                    .foregroundColor(.white)
                Spacer()
            }
        }
        
        .onAppear {
            sceneView = ScenekitView(scene: scnScene)
            
            // Setup the camera - The double tapping will not work with the default SCNView.allowsCameraControl option
            cameraNode = setupCameraNode(scene: scnScene)
            cameraOrbit = setupCameraOrbit(cameraNode: cameraNode, scene: scnScene)
            
            scnScene.background.contents = NSColor.black
            
            
            // do other scene setup.. add objects, cameras, lights, etc...
            addSpheres(scene: scnScene)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
