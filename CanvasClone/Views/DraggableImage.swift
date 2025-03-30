//
//  DraggableImage.swift
//  CanvasClone
//
//  Created by Pedro Henrique on 30/03/25.
//

import SwiftUI

struct DraggableImage: View {
    
    var image: CanvasImage
    
    var body: some View {
        Image(uiImage: image.uiImage)
            .resizable()
            .scaledToFit()
            .frame(
                width: 100,
                height: 100
            )
            .position(image.position)
    }
}
