//
//  CanvasImagesViewModel.swift
//  CanvasClone
//
//  Created by Pedro Henrique on 30/03/25.
//

import SwiftUI

class CanvasImagesViewModel: ObservableObject {
    @Published private var canvasImages: [CanvasImage] = []
    
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
    
}
