//
//  ContentView.swift
//  HitTestApp
//
//  Created by Eric Freitas on 12/28/21.
//

import SwiftUI
import SceneKit

struct ContentView: View {
    
    @StateObject private var viewModel: ContentViewModel
    
    init() {
        self._viewModel = StateObject(wrappedValue: ContentViewModel())
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                viewModel.sceneView
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
                                viewModel.cameraOrbit.eulerAngles.y += CGFloat(2 * CGFloat.pi) * scrollWidthRatio
                                viewModel.cameraOrbit.eulerAngles.x += CGFloat(CGFloat.pi) * scrollHeightRatio
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
                                let hits = viewModel.sceneView.view.hitTest(startLocation, options: [:])
                                
                                if hits.count > 0 {
                                    viewModel.statusText = hits.first?.node.name ?? ".."
                                    debugPrint("ball: \(hits.first?.node.name ?? "..")")
                                } else {
                                    viewModel.statusText = ".."
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
                                if let targetNode = self.viewModel.scnScene.rootNode.childNode(withName: viewModel.statusText, recursively: true) {
                                    let targetPosition = targetNode.position
                                    
                                    // smoothly transistion to new position
                                    SCNTransaction.begin()
                                    SCNTransaction.animationDuration = 1.5
                                    viewModel.cameraOrbit.position = targetPosition
                                    viewModel.cameraNode.look(at: targetPosition)
                                    SCNTransaction.commit()
                                    
                                    self.viewModel.targetNode = targetNode
                                    viewModel.statusText = targetNode.name ?? ".."
                                }
                            })
                    )
            }
            
            VStack {
                Text("Selected Sphere: \(viewModel.statusText)")
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    .foregroundColor(Color(.sRGB, red: 0.8, green: 0.8, blue: 0.8, opacity: 0.5) )
                    .background(RoundedRectangle(cornerRadius: 16, style: .circular)
                                    .fill(Color.textBackground))
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 0))
                
                Spacer()
                
                HStack {
                    InstructionsView()
                    Spacer()
                }
                .padding()
            }
        }
        
        .onAppear {
            viewModel.sceneView = ScenekitView(scene: viewModel.scnScene)
            
            // Setup the camera - The double tapping will not work with the default SCNView.allowsCameraControl option
            viewModel.cameraNode = setupCameraNode(scene: viewModel.scnScene)
            viewModel.cameraOrbit = setupCameraOrbit(cameraNode: viewModel.cameraNode, scene: viewModel.scnScene)
            
            // your basic black background
            viewModel.scnScene.background.contents = NSColor.black
            
            
            // do other scene setup.. add objects, cameras, lights, etc...
            addSpheres(scene: viewModel.scnScene)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
