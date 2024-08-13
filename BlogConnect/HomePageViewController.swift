

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
                        if let post = self.parsePost(dictionary: postDict) {
                            self.posts.append(post)
                        } else {
                            print("Failed to parse post: \(postDict)")
                        }
                    }
                }

                self.filterPosts() // Filter posts after loading
            }
        }

        func parsePost(dictionary: [String: Any]) -> Post? {
            guard let idString = dictionary["id"] as? String,
                  let id = UUID(uuidString: idString),
                  let title = dictionary["title"] as? String,
                  let description = dictionary["description"] as? String,
                  let categoryString = dictionary["category"] as? String,
                  let category = Category(rawValue: categoryString),
                  let userName = dictionary["userName"] as? String else {
                return nil
            }

            return Post(id: id, title: title, description: description, category: category, userName: userName)
        }

    func filterPosts() {
        let selectedCategoryIndex = categorySegmentedControl.selectedSegmentIndex
        if let selectedCategoryTitle = categorySegmentedControl.titleForSegment(at: selectedCategoryIndex),
           let selectedCategory = Category(rawValue: selectedCategoryTitle) {
            // סינון הפוסטים לפי הקטגוריה הנבחרת
            filteredPosts = posts.filter { $0.category == selectedCategory }
        } else {
            // אם הקטגוריה לא נמצאה, אפשר להציג את כל הפוסטים או להגדיר filteredPosts לריק
            filteredPosts = []
            print("Selected category not found or invalid")
        }

        tableView.reloadData() // רענן את הטבלה לאחר הסינון
    }

        @IBAction func categoryChanged(_ sender: UISegmentedControl) {
            filterPosts()
        }

        @IBAction func goToProfile(_ sender: UIButton) {
            performSegue(withIdentifier: "goToProfileSegue", sender: self)
        }

        @IBAction func addNewPost(_ sender: UIButton) {
            performSegue(withIdentifier: "goToAddPostSegue", sender: self)
        }
    }
