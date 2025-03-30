//
//  PexelsImagePicker.swift
//  CanvasClone
//
//  Created by Pedro Henrique on 30/03/25.
//

import SwiftUI

struct PexelsImagePicker: View {
    
    @State private var images: [UIImage] = []
    @State private var fetchErrorMessage: String?
    @State private var isLoading = true
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading images...").padding()
                } else if images.isEmpty {
                    Text("No images found").foregroundColor(.gray)
                } else if let message = fetchErrorMessage {
                    Text(message).foregroundColor(.gray)
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                            ForEach(images, id: \.self) { image in
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .onTapGesture {
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
                await fetchPexelsImages()
            }
        }
    }
    
    private func fetchPexelsImages() async {
        guard let apiKey = SecretsManager().loadAPIKey() else {
            fetchErrorMessage = "Failed to load Pexels' API Key"
            isLoading = false
            return
        }
        
        let urlString = "https://api.pexels.com/v1/curated?per_page=80"
        
        guard let url = URL(string: urlString) else {
            fetchErrorMessage = "Invalid URL request"
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let photos = json["photos"] as? [[String: Any]] {
                
                let urls = photos.compactMap {
                    $0["src"] as? [String: String]
                }.compactMap {
                    $0["medium"]
                }
                
                let uiImages = await withTaskGroup(of: UIImage?.self) { group in
                    for url in urls {
                        group.addTask {
                            return await loadImage(from: url)
                        }
                    }
                    
                    var results: [UIImage] = []
                    for await image in group {
                        if let img = image {
                            results.append(img)
                        }
                    }
                    return results
                }
                
                await MainActor.run {
                    images = uiImages
                    isLoading = false
                }
                
            } else {
                await MainActor.run {
                    fetchErrorMessage = "Invalid JSON format"
                    isLoading = false
                }
            }
        } catch {
            await MainActor.run {
                fetchErrorMessage = "Error fetching Pexels' images: \(error)"
                isLoading = false
            }
        }
    }
    
    private func loadImage(from urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } catch {
            return nil
        }
    }
}

#Preview {
    PexelsImagePicker()
}
