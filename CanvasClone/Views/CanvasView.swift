//
//  CanvasView.swift
//  CanvasClone
//
//  Created by Pedro Henrique on 30/03/25.
//

import SwiftUI

struct CanvasView: View {
    
    @State private var selectedImageID: UUID? = nil
    
    @StateObject var imagesViewModel: CanvasImagesViewModel
    
    private let lineCount = max(3, Int(AppConstants.canvasWidth / AppConstants.canvasLineSpacing))
    
    var body: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: true) {
            ZStack {
                Color(.gray)
                    .opacity(0.2)
                    .frame(width: AppConstants.canvasWidth, height: AppConstants.canvasHeight)
                    .onTapGesture {
                        selectedImageID = nil
                    }
                
                ForEach($imagesViewModel.canvasImages) { image in
                    DraggableImage(
                        image: image,
                        selectedImageID: $selectedImageID
                    )
                }
                
                ForEach(0..<lineCount, id: \.self) { line in
                    let xPosition = CGFloat(line) * (AppConstants.canvasWidth / CGFloat(lineCount))
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: 1, height: AppConstants.canvasHeight)
                        .position(x: xPosition, y: 0.5 * AppConstants.canvasHeight)
                }
            }
        }
        .frame(width: AppConstants.canvasFrameWidth, height: AppConstants.canvasFrameHeight)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding()
    }
}
