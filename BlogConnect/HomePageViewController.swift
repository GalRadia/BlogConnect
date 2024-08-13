

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore
class HomePageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts: [Post] = []
     var filteredPosts: [Post] = [] // Array for storing filtered posts
     
     override func viewDidLoad() {
         super.viewDidLoad()
         
         tableView.delegate = self
         tableView.dataSource = self
         tableView.rowHeight = UITableView.automaticDimension
         tableView.estimatedRowHeight = 100 // Set an estimated row height
         
         fetchPosts()
     }
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return filteredPosts.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "PostCellIdentifier", for: indexPath) as! PostsTableViewCell
         let post = filteredPosts[indexPath.row]
         cell.configure(with: post)
         return cell
     }
     
    func fetchPosts() {
        guard let currentUser = Auth.auth().currentUser else {
            print("No current user is authenticated")
            return
        }

        let ref = Database.database().reference().child("posts")
        ref.observe(.value) { snapshot in
            self.posts = []
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let postDict = snapshot.value as? [String: Any] {
                    if let post = Post.fromDictionary(postDict) {
                        self.posts.append(post)
                    } else {
                        print("Failed to parse post: \(postDict)")
                    }
                }
            }
            
            // Sort posts by timestamp
            self.posts.sort(by: { $0.timestamp > $1.timestamp })
            
            self.filterPosts() // Filter posts after loading and sorting
        }
    }

     
     func filterPosts() {
         let selectedCategoryIndex = categorySegmentedControl.selectedSegmentIndex
         if let selectedCategoryTitle = categorySegmentedControl.titleForSegment(at: selectedCategoryIndex) {
             if selectedCategoryTitle == "All" {
                 // If "All" is selected, display all posts
                 filteredPosts = posts
             } else if let selectedCategory = Category(rawValue: selectedCategoryTitle) {
                 // Filter posts based on the selected category
                 filteredPosts = posts.filter { $0.category == selectedCategory }
             } else {
                 // If the selected category is not found or is invalid, set filteredPosts to an empty list
                 filteredPosts = []
                 print("Selected category not found or invalid")
             }
         } else {
             // If no category is selected, display all posts
             filteredPosts = posts
         }
         
         tableView.reloadData() // Refresh the table after filtering
     }
     
     @IBAction func categoryChanged(_ sender: UISegmentedControl) {
         filterPosts()
     }
 }
