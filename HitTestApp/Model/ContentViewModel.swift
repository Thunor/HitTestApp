//
//  ContentViewModel.swift
//  HitTestApp
//
//  Created by Eric Freitas on 3/8/22.
//

import Foundation
import SceneKit


extension ContentView {
    @MainActor class ContentViewModel: ObservableObject {
        @Published var scnScene = SCNScene()
        @Published var sceneView: ScenekitView!
        @Published var cameraNode = SCNNode()
        @Published var cameraOrbit: SCNNode!
        @Published var statusText = "..."
        @Published var targetNode: SCNNode!
    }
}
