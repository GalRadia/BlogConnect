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

    // Initializer to create a Post object
    init(id: UUID = UUID(), title: String, description: String, category: Category, userName: String) {
        self.id = id
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

    // Static method to create a Post object from a dictionary
    static func fromDictionary(_ dictionary: [String: Any]) -> Post? {
        guard let idString = dictionary["id"] as? String,
              let id = UUID(uuidString: idString),
              let title = dictionary["title"] as? String,
              let description = dictionary["description"] as? String,
              let categoryString = dictionary["category"] as? String,
              let category = Category(rawValue: categoryString),
              let userName = dictionary["userName"] as? String else {
            print("Error: Unable to parse Post from dictionary")
            return nil
        }
        
        return Post(id: id, title: title, description: description, category: category, userName: userName)
    }
}
