//
//  StarView.swift
//  HitTestApp
//
//  Created by Eric Freitas on 12/24/21.
//
//  This is necessary in order to get an SCNView that conforms
//  to the SCNSceneRenderer protocol, because the SwiftUI SceneView does not.
//  This is important because there is no way to do hit testing from within
//  SwiftUI otherwise.  

import SwiftUI
import SceneKit

struct ScenekitView: NSViewRepresentable {
    
    typealias NSViewType = SCNView
    var scene: SCNScene
    var view = SCNView()

    func makeNSView(context: Context) -> SCNView {
        view.scene = scene
        return view
    }
    
    func updateNSView(_ nsView: SCNView, context: Context) { }

    func makeCoordinator() -> Coordinator {
        Coordinator(view)
    }

    class Coordinator: NSObject {
        private let view: SCNView
        init(_ view: SCNView) {
            self.view = view
            super.init()
        }
    }
}
