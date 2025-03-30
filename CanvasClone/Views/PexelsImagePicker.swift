//
//  PexelsImagePicker.swift
//  CanvasClone
//
//  Created by Pedro Henrique on 30/03/25.
//

import SwiftUI

struct PexelsImagePicker: View {
    
    @State private var fetchErrorMessage: String?
    
    var body: some View {
        NavigationView {
            VStack {
                if let message = fetchErrorMessage {
                    Text(message).foregroundColor(.gray)
                }
            }
            .navigationTitle("Pick an Image")
            .task {
                await fetchPexelsImages()
            }
        }
    }
    
    private func fetchPexelsImages() async {
        let apiKey = ""
        let urlString = ""
        
        guard let url = URL(string: urlString) else {
            fetchErrorMessage = "Invalid URL request"
            return
        }
    }
}

#Preview {
    PexelsImagePicker()
}
