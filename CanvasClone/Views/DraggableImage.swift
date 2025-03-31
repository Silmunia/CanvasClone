//
//  DraggableImage.swift
//  CanvasClone
//
//  Created by Pedro Henrique on 30/03/25.
//

import SwiftUI

struct DraggableImage: View {
    
    @Binding var image: CanvasImage
    @Binding var selectedImageID: UUID?
    
    var body: some View {
        ZStack {
            Image(uiImage: image.uiImage)
                .resizable()
                .scaledToFit()
                .frame(
                    width: 100,
                    height: 100
                )
                .position(image.position)
            
            if selectedImageID == image.id {
                Rectangle()
                    .fill(Color.blue.opacity(0.3))
                    .frame(
                        width: 104,
                        height: 104
                    )
                    .position(image.position)
                    .allowsHitTesting(false)
            }
        }
        .gesture (
            DragGesture()
                .onChanged { value in
                    image.position = value.location
                    selectedImageID = image.id
                }
        )
        .onTapGesture {
            selectedImageID = image.id
        }
    }
}
