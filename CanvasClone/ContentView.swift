//
//  ContentView.swift
//  CanvasClone
//
//  Created by Pedro Henrique on 30/03/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = CanvasImagesViewModel()
    @State private var showImagePicker = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            CanvasView(imagesViewModel: viewModel)
        }
        .sheet(isPresented: $showImagePicker) {
            PexelsImagePicker { selectedImage in
                viewModel.addNewImage(image: selectedImage)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                Button(action: {
                    showImagePicker = true
                }) {
                    Text("+")
                        .font(.system(size: 40))
                        .foregroundColor(colorScheme == .dark ? .black : .blue)
                        .frame(width: 60, height: 60)
                        .background(Circle().fill(.white).shadow(radius: 5))
                }
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
