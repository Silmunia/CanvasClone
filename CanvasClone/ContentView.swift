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
    
    var body: some View {
        VStack {
            CanvasView()
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
                        .foregroundColor(.blue)
                        .frame(width: 60, height: 60)
                        .background(Circle().fill(Color.white).shadow(radius: 5))
                }
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
