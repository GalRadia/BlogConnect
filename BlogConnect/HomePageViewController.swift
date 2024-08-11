

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
          
          // Register the custom cell
          tableView.register(UINib(nibName: "PostsTableViewCell", bundle: nil), forCellReuseIdentifier: "PostsTableViewCell")
          
          fetchPosts()
      }
      
      // UITableViewDataSource method to return the number of rows in the table
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return filteredPosts.count
      }

      // UITableViewDataSource method to configure and return the cell for each row
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "PostsTableViewCell", for: indexPath) as! PostsTableViewCell
          let post = filteredPosts[indexPath.row]
          cell.configure(with: post)
          return cell
      }
      
      // Method to fetch posts from Firebase
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
                      let post = self.parsePost(dictionary: postDict)
                      self.posts.append(post)
                  }
              }
              
              self.filterPosts() // Filter posts after loading
          }
      }
      
      // Method to parse a dictionary into a Post object
      func parsePost(dictionary: [String: Any]) -> Post {
          let id = UUID(uuidString: dictionary["id"] as? String ?? "") ?? UUID()
          let title = dictionary["title"] as? String ?? ""
          let description = dictionary["description"] as? String ?? ""
          let category = Category(rawValue: dictionary["category"] as? String ?? "") ?? .News
          let userName = dictionary["userName"] as? String ?? ""
          
          return Post(title: title, description: description, category: category, userName: userName)
      }
      
      // Method to filter posts based on the selected category
      func filterPosts() {
          let selectedCategoryIndex = categorySegmentedControl.selectedSegmentIndex
          let selectedCategory = Category(rawValue: categorySegmentedControl.titleForSegment(at: selectedCategoryIndex) ?? "") ?? .News
          
          filteredPosts = posts.filter { $0.category == selectedCategory }
          
          tableView.reloadData() // Refresh the table after filtering
      }
      
      @IBAction func categoryChanged(_ sender: UISegmentedControl) {
          filterPosts()
      }
    
    
    @IBAction func goToProfile(_ sender: UIButton) {
            performSegue(withIdentifier: "goToProfileSegue", sender: self)
        }

        // Action to navigate to add a new post
        @IBAction func addNewPost(_ sender: UIButton) {
            performSegue(withIdentifier: "goToAddPostSegue", sender: self)
        }
}
