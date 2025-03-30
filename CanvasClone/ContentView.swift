//
//  ContentView.swift
//  CanvasClone
//
//  Created by Pedro Henrique on 30/03/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ScrollView([.horizontal, .vertical], showsIndicators: true) {
                ZStack {
                    Color(.gray)
                        .opacity(0.2)
                        .frame(width: 400, height: 400)
                }
            }
            .frame(width: 400, height: 400)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
