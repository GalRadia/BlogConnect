//
//  Post.swift
//  BlogConnect
//
//  Created by Student17 on 05/08/2024.
//

import Foundation

// Define the enum for categories
enum Category: String {
    case Cooking
    case News
    case Leisure
    case Adventure
    // Add other categories as needed
}

// Define the Post class
class Post {
    var description: String
    var categorie: Category
    var id :UUID

    init(description: String, categorie: Category) {
        self.id = UUID()
        self.description = description
        self.categorie = categorie
    }
    // Convert User object to dictionary
       func toDictionary() -> [String: Any] {
           return [
               "description": description,
               "categories": categorie.rawValue,
               "id": id.uuidString
           ]
       }


}
