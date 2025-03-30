//
//  SecretsController.swift
//  CanvasClone
//
//  Created by Pedro Henrique on 30/03/25.
//

import Foundation

struct SecretsManager {
    func loadAPIKey() -> String? {
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let dictionary = NSDictionary(contentsOfFile: path) {
            if let apiKey = dictionary["PEXELS_KEY"] as? String {
                return apiKey
            }
        }
        return nil
    }
}
