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
    
    func updateImagePosition(imageID: UUID, newPosition: CGPoint, imageScale: CGFloat) {
        if let index = canvasImages.firstIndex(where: { $0.id == imageID }) {
            var updatedImage = canvasImages[index]
            
            updatedImage.position = applyBoundsToPosition(position: newPosition, imageScale: imageScale)
            
            canvasImages[index] = updatedImage
        }
    }
    
    private func applyBoundsToPosition(position: CGPoint, imageScale: CGFloat) -> CGPoint {
        let imageBorders = calculateImageBorders(imagePosition: position, imageScale: imageScale)
        var newX: CGFloat = position.x
        var newY: CGFloat = position.y
        
        if (imageBorders.left < 0 || imageBorders.right < 0) {
            newX = 0.5 * AppConstants.basicImageSize * imageScale
        }
        
        if (imageBorders.left > AppConstants.canvasWidth || imageBorders.right > AppConstants.canvasWidth) {
            newX = AppConstants.canvasWidth - (0.5 * AppConstants.basicImageSize * imageScale)
        }
        
        if (imageBorders.top < 0 || imageBorders.bottom < 0) {
            newY = 0.5 * AppConstants.basicImageSize * imageScale
        }
        
        if (imageBorders.top > AppConstants.canvasHeight || imageBorders.bottom > AppConstants.canvasHeight) {
            newY = AppConstants.canvasHeight - (0.5 * AppConstants.basicImageSize * imageScale)
        }
        
        return CGPoint(x: newX, y: newY)
    }
    
    func updateSnapping(imageID: UUID, currentPosition: CGPoint, imageScale: CGFloat) -> (horizontal: CGFloat?, vertical: CGFloat?) {
        
        var newSnappingLines: (horizontal: CGFloat?, vertical: CGFloat?) = (nil, nil)
        
        let imageBorders = calculateImageBorders(imagePosition: currentPosition, imageScale: imageScale)
        
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
        
        for other in canvasImages where other.id != imageID {
            let otherBorders = calculateImageBorders(imagePosition: other.position, imageScale: imageScale)
            
            if abs(currentPosition.y - other.position.y) < (0.5 * AppConstants.basicImageSize * imageScale) {
                if abs(imageBorders.left - otherBorders.right) < snapThreshold {
                    newSnappingLines.vertical = otherBorders.right
                } else if abs(imageBorders.right - otherBorders.left) < snapThreshold {
                    newSnappingLines.vertical = otherBorders.left
                }
            }
            if abs(currentPosition.x - other.position.x) < (0.5 * AppConstants.basicImageSize * imageScale) {
                if abs(imageBorders.top - otherBorders.bottom) < snapThreshold {
                    newSnappingLines.horizontal = otherBorders.bottom
                } else if abs(imageBorders.bottom - otherBorders.top) < snapThreshold {
                    newSnappingLines.horizontal = otherBorders.top
                }
            }
        }
        
        return newSnappingLines
    }
    
    private func calculateImageBorders(imagePosition: CGPoint, imageScale: CGFloat) -> (top: CGFloat, right: CGFloat, bottom: CGFloat, left: CGFloat) {
        let imageLeft = imagePosition.x - (0.5 * AppConstants.basicImageSize * imageScale)
        let imageRight = imagePosition.x + (0.5 * AppConstants.basicImageSize * imageScale)
        let imageTop = imagePosition.y - (0.5 * AppConstants.basicImageSize * imageScale)
        let imageBottom = imagePosition.y + (0.5 * AppConstants.basicImageSize * imageScale)
        
        return (top: imageTop, right: imageRight, bottom: imageBottom, left: imageLeft)
    }
    
    private func isNearCanvasCenter(imagePosition: CGPoint) -> Bool {
        return abs(imagePosition.x - AppConstants.canvasWidth * 0.5) < snapThreshold
        && abs(imagePosition.y - AppConstants.canvasHeight * 0.5) < snapThreshold
    }
    
    func applySnapping(imageID: UUID, snappingTarget: (horizontal: CGFloat?, vertical: CGFloat?), currentPosition: CGPoint, imageScale: CGFloat) {
                
        guard let index = canvasImages.firstIndex(where: { $0.id == imageID }) else {
            return
        }
        
        var updatedImage = canvasImages[index]
        
        if let snapX = snappingTarget.vertical {
            if isImageSnappingVerticallyToCanvas(imagePosition: currentPosition, imageScale: imageScale) {
                updatedImage.position.x = snapX
            } else if currentPosition.x >= snapX {
                updatedImage.position.x = snapX + (0.5 * AppConstants.basicImageSize * imageScale)
            } else {
                updatedImage.position.x = snapX - (0.5 * AppConstants.basicImageSize * imageScale)
            }
        }
        
        if let snapY = snappingTarget.horizontal {
            if isImageSnappingHorizontallyToCanvas(imagePosition: currentPosition, imageScale: imageScale) {
                updatedImage.position.y = snapY
            } else if currentPosition.y >= snapY {
                updatedImage.position.y = snapY + (0.5 * AppConstants.basicImageSize * imageScale)
            } else {
                updatedImage.position.y = snapY - (0.5 * AppConstants.basicImageSize * imageScale)
            }
        }
        
        canvasImages[index] = updatedImage
    }
    
    private func isImageSnappingVerticallyToCanvas(imagePosition: CGPoint, imageScale: CGFloat) -> Bool {
        
        let imageBorders = calculateImageBorders(imagePosition: imagePosition, imageScale: imageScale)
        
        return imageBorders.left < snapThreshold
            || abs(imageBorders.right - AppConstants.canvasWidth) < snapThreshold
        || isNearCanvasCenter(imagePosition: imagePosition)
    }
    
    private func isImageSnappingHorizontallyToCanvas(imagePosition: CGPoint, imageScale: CGFloat) -> Bool {
        
        let imageBorders = calculateImageBorders(imagePosition: imagePosition, imageScale: imageScale)
        
        return imageBorders.top < snapThreshold
            || abs(imageBorders.bottom - AppConstants.canvasHeight) < snapThreshold
        || isNearCanvasCenter(imagePosition: imagePosition)
    }
    
}
