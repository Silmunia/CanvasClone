//
//  PexelsImagePicker.swift
//  CanvasClone
//
//  Created by Pedro Henrique on 30/03/25.
//

import SwiftUI

struct PexelsImagePicker: View {
    
    @StateObject var viewModel = ImagePickerViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    let onSelect: (UIImage) -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading images...").padding()
                } else if viewModel.images.isEmpty {
                    Text("No images found").foregroundColor(.gray)
                } else if let message = viewModel.fetchErrorMessage {
                    Text(message).foregroundColor(.gray)
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                            ForEach(viewModel.images, id: \.self) { image in
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .onTapGesture {
                                        onSelect(image)
                                        dismiss()
                                    }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Pick an Image")
            .task {
                await viewModel.fetchImages()
            }
        }
    }
}
