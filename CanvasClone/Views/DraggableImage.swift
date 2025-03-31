//
//  DraggableImage.swift
//  CanvasClone
//
//  Created by Pedro Henrique on 30/03/25.
//

import SwiftUI

struct DraggableImage: View {
    
    @ObservedObject var viewModel: CanvasImagesViewModel
    
    @Binding var image: CanvasImage
    
    var body: some View {
        ZStack {
            Image(uiImage: image.uiImage)
                .resizable()
                .scaledToFit()
                .frame(
                    width: AppConstants.basicImageSize,
                    height: AppConstants.basicImageSize
                )
                .position(image.position)
            
            if viewModel.selectedImageID == image.id {
                Rectangle()
                    .fill(Color.blue.opacity(0.3))
                    .frame(
                        width: AppConstants.basicImageSize + 4,
                        height: AppConstants.basicImageSize + 4
                    )
                    .position(image.position)
                    .allowsHitTesting(false)
            }
        }
        .gesture (
            DragGesture()
                .onChanged { value in
                    image.position = value.location
                    viewModel.selectedImageID = image.id
                }
                .onEnded { _ in
                    viewModel.updateImagePosition(imageID: image.id, newPosition: image.position)
                }
        )
        .onTapGesture {
            viewModel.selectedImageID = image.id
        }
    }
}
