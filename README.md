# HitTestApp
SwiftUI &amp; Scenekit hit testing example.

This example application is written for macOS, though with minor changes it should be able to be changed to an iOS app fairly quickly.

Many people have run into the issue that the SwiftUI SceneView doesn't appear to have any hit testing ability.  
After much searching and working on this problem, I have discovered how to get the hit testing working.  It involves using a small
NSViewRepresentable (or UIViewRepresentable if on iOS) to get an SCNView which does conform to the `SCNSceneRenderer` protocol.

The `ScenekitView` class in this repo creates an `SCNView` for use by SwiftUI, replacing `SceneView`.

There are a number of other things in the contentView that are used as well.  Such as using a 
`DragGesture(minimumDistance: 0.0, coordinateSpace: .local).onEnded()` in order to get the location of a tap, since a 
`TapGesture()` does not provide a location value, which is needed for feeding to the `hitTest()`.

An example of using the `DragGesture()` to rotate the view is given. 

I've also included a `TapGesture()` to double click on an object for centering the view on it.  The camera system uses a camera node
attached as the child of a camera orbit node in order to get the entire view to rotate around. the selected object.  

Finally, there is a SwiftUI overlay on top of the Scene.
