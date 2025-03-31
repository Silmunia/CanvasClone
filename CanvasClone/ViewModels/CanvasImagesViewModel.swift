//
//  CanvasImagesViewModel.swift
//  CanvasClone
//
//  Created by Pedro Henrique on 30/03/25.
//

import SwiftUI

class CanvasImagesViewModel: ObservableObject {
    @Published var canvasImages: [CanvasImage] = []
    @Published var selectedImageID: UUID?
    
    func updateSelectedImage(newId: UUID?) {
        selectedImageID = newId
    }
    
    func addNewImage(image: UIImage) {
        
        let newImage = CanvasImage(
            id: UUID(),
            uiImage: image,
            position: CGPoint(
                x: 0.25 * AppConstants.canvasWidth,
                y: 0.25 * AppConstants.canvasHeight
            )
        )
        
        canvasImages.append(newImage)
    }
    
    func updateImagePosition(imageID: UUID, newPosition: CGPoint) {
        if let index = canvasImages.firstIndex(where: { $0.id == imageID }) {
            var updatedImage = canvasImages[index]
            
            updatedImage.position = applyBoundsToPosition(position: newPosition)
            
            canvasImages[index] = updatedImage
        }
    }
    
    private func applyBoundsToPosition(position: CGPoint) -> CGPoint {
        let x = min(max(position.x, 0), AppConstants.canvasWidth)
        let y = min(max(position.y, 0), AppConstants.canvasHeight)
        
        return CGPoint(x: x, y: y)
    }
    
}
