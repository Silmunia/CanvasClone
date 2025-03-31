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
    
    private let snapThreshold: CGFloat = 15
    
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
    
    func updateSnapping(currentPosition: CGPoint) -> (horizontal: CGFloat?, vertical: CGFloat?) {
        
        var newSnappingLines: (horizontal: CGFloat?, vertical: CGFloat?) = (nil, nil)
        
        let imageBorders = calculateImageBorders(imagePosition: currentPosition)
        
        if imageBorders.left < snapThreshold {
            newSnappingLines.vertical = 0
        }
        if abs(imageBorders.right - AppConstants.canvasWidth) < snapThreshold {
            newSnappingLines.vertical = AppConstants.canvasWidth
        }
        if imageBorders.top < snapThreshold {
            newSnappingLines.horizontal = 0
        }
        if abs(imageBorders.bottom - AppConstants.canvasHeight) < snapThreshold {
            newSnappingLines.horizontal = AppConstants.canvasHeight
        }
        if isNearCanvasCenter(imagePosition: currentPosition) {
            newSnappingLines.vertical = 0.5 * AppConstants.canvasWidth
            newSnappingLines.horizontal = 0.5 * AppConstants.canvasHeight
        }
        
        return newSnappingLines
    }
    
    private func calculateImageBorders(imagePosition: CGPoint) -> (top: CGFloat, right: CGFloat, bottom: CGFloat, left: CGFloat) {
        let imageLeft = imagePosition.x - (0.5 * AppConstants.basicImageSize)
        let imageRight = imagePosition.x + (0.5 * AppConstants.basicImageSize)
        let imageTop = imagePosition.y - (0.5 * AppConstants.basicImageSize)
        let imageBottom = imagePosition.y + (0.5 * AppConstants.basicImageSize)
        
        return (top: imageTop, right: imageRight, bottom: imageBottom, left: imageLeft)
    }
    
    private func isNearCanvasCenter(imagePosition: CGPoint) -> Bool {
        return abs(imagePosition.x - AppConstants.canvasWidth * 0.5) < snapThreshold
        && abs(imagePosition.y - AppConstants.canvasHeight * 0.5) < snapThreshold
    }
    
    func applySnapping(imageID: UUID, snappingTarget: (horizontal: CGFloat?, vertical: CGFloat?)) {
        
        guard let index = canvasImages.firstIndex(where: { $0.id == imageID }) else {
            return
        }
        
        var updatedImage = canvasImages[index]
        
        if let snapX = snappingTarget.vertical {
            updatedImage.position.x = snapX
        }
        
        if let snapY = snappingTarget.horizontal {
            updatedImage.position.y = snapY
        }
        
        canvasImages[index] = updatedImage
    }
    
}
