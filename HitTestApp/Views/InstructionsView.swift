//
//  Instructions.swift
//  HitTestApp
//
//  Created by Eric Freitas on 2/16/22.
//

import SwiftUI

struct InstructionsView: View {
    var body: some View {
        
        VStack(alignment: .leading, spacing: 5, content: {
            Text("Single Click selects a sphere.")
            Text("Double clicking on a sphere selects and centers.")
            Text("Clicking on the black background deselects a sphere.")
            Text("Click and hold left mouse button will rotate around the centered sphere.")
        })
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            .foregroundColor(Color(.sRGB, red: 0.8, green: 0.8, blue: 0.8, opacity: 0.5) )
            .background(RoundedRectangle(cornerRadius: 16, style: .circular)
                            .fill(Color.textBackground))
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 0))
        
    }
}

struct Instructions_Previews: PreviewProvider {
    static var previews: some View {
        InstructionsView()
    }
}

