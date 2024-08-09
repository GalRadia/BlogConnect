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
    var rate: Int
    var categories: Category
    var id :UUID

    init(description: String, rate: Int, categories: Category) {
        self.id = UUID()
        self.description = description
        self.rate = rate
        self.categories = categories
    }


}
