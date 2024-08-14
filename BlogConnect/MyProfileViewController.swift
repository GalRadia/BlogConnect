import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

class MyProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var logoutButton: UIButton!
    var posts: [Post] = []

        override func viewDidLoad() {
            super.viewDidLoad()
            
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 100 // Set an estimated row height
        }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserPosts()
    }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return posts.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCellIdentifier", for: indexPath) as! PostsTableViewCell
            let post = posts[indexPath.row]
            cell.configure(with: post)
            return cell
        }
        
        // Method to fetch posts of the current user from Firebase
        func fetchUserPosts() {
            guard let currentUser = Auth.auth().currentUser else {
                print("No current user is authenticated")
                return
            }
            
            let ref = Database.database().reference().child("posts")
            ref.observe(.value) { snapshot in
                self.posts = []
                
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot,
                       let postDict = snapshot.value as? [String: Any],
                       let userName = postDict["userName"] as? String,
                       userName == currentUser.displayName {
                        if let post = Post.fromDictionary(postDict) {
                            self.posts.append(post)
                        } else {
                            print("Failed to parse post: \(postDict)")
                        }
                    }
                }
                
                // Sort posts by timestamp
                self.posts.sort(by: { $0.timestamp > $1.timestamp })
                
                self.tableView.reloadData()
            }
        }
        
        // Logout the current user and perform segue to LoginViewController
        @IBAction func logoutButtonTapped(_ sender: UIButton) {
            do {
                try Auth.auth().signOut()
                
                // Perform the segue to the LoginViewController
                SceneDelegate.showLogin()
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        }
    }
