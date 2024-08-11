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
    var id: UUID
    var title: String
    var description: String
    var category: Category
    var userName: String

    init(title: String, description: String, category: Category, userName: String) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.category = category
        self.userName = userName
    }

    // Convert Post object to dictionary
    func toDictionary() -> [String: Any] {
        return [
            "id": id.uuidString,
            "title": title,
            "description": description,
            "category": category.rawValue,
            "userName": userName
        ]
    }
}
