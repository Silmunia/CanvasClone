//
//  DraggableImagesViewModel.swift
//  CanvasClone
//
//  Created by Pedro Henrique on 30/03/25.
//

import SwiftUI

class DraggableImagesViewModel: ObservableObject {
    @Published var selectedImageID: UUID?
    
    func updateSelectedImage(newId: UUID?) {
        selectedImageID = newId
    }
}
