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
    
    @State private var snappingLines: (horizontal: CGFloat?, vertical: CGFloat?) = (nil, nil)
    
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
            
            if let hSnap = snappingLines.horizontal {
                Rectangle()
                    .fill(Color.yellow)
                    .frame(width: AppConstants.canvasWidth, height: 2) // **Full-width horizontal line**
                    .position(x: 0.5 * AppConstants.canvasWidth, y: max(2, min(hSnap, AppConstants.canvasHeight-2)))
                    .allowsHitTesting(false)
            }
            
            if let vSnap = snappingLines.vertical {
                Rectangle()
                    .fill(Color.yellow)
                    .frame(width: 2, height: AppConstants.canvasHeight) // **Full-height vertical line**
                    .position(x: max(2, min(vSnap, AppConstants.canvasWidth-2)), y: 0.5 * AppConstants.canvasHeight)
                    .allowsHitTesting(false)
            }
        }
        .gesture (
            DragGesture()
                .onChanged { value in
                    image.position = value.location
                    viewModel.selectedImageID = image.id
                    snappingLines = viewModel.updateSnapping(imageID: image.id, currentPosition: image.position)
                }
                .onEnded { _ in
                    viewModel.applySnapping(imageID: image.id, snappingTarget: snappingLines)
                    viewModel.updateImagePosition(imageID: image.id, newPosition: image.position)
                }
        )
        .onTapGesture {
            viewModel.selectedImageID = image.id
        }
    }
}
