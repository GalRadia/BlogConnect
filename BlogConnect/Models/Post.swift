//
//  Post.swift
//  BlogConnect
//
//  Created by Student17 on 05/08/2024.
//

import Foundation

// Define the enum for categories
enum Category: String {
    case cooking
    case news
    case leisure
    case adventure
    // Add other categories as needed
}

// Define the Post class
class Post {
    var description: String
    var rate: Double
    var categories: [Category]

    init(description: String, rate: Double, categories: [Category] = []) {
        self.description = description
        self.rate = rate
        self.categories = categories
    }

    func addCategory(_ category: Category) {
        if !categories.contains(category) {
            categories.append(category)
        }
    }

    func removeCategory(_ category: Category) {
        if let index = categories.firstIndex(of: category) {
            categories.remove(at: index)
        }
    }

}
