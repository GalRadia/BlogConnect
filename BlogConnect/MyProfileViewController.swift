//Tzachi

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
           
           // Show delete button in Profile Page
           cell.configure(with: post, showDeleteButton: true)
           
           cell.onDeleteButtonTapped = { [weak self] in
               self?.confirmDeletePost(at: indexPath)
           }
           
           return cell
       }
       
       // Function to confirm deletion of a post
       func confirmDeletePost(at indexPath: IndexPath) {
           let alert = UIAlertController(title: "Delete Post", message: "Are you sure you want to delete this post?", preferredStyle: .alert)
           
           let confirmAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
               self.deletePost(at: indexPath)
           }
           
           let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
           
           alert.addAction(confirmAction)
           alert.addAction(cancelAction)
           
           self.present(alert, animated: true, completion: nil)
       }
    
    
    func deletePost(at indexPath: IndexPath) {
        guard indexPath.row < posts.count else {
            print("Index out of range - no post found at this index.")
            return
        }
        
        let post = posts[indexPath.row]
        let postRef = Database.database().reference().child("posts").child(post.id.uuidString)
        
        guard let currentUser = Auth.auth().currentUser else {
            print("No current user is authenticated")
            return
        }
        
        let userPostRef = Database.database().reference().child("users").child(currentUser.uid).child("postID")

        // Remove the post from the 'posts' node
        postRef.removeValue { error, _ in
            if let error = error {
                print("Failed to delete post: \(error.localizedDescription)")
            } else {
                print("Post deleted successfully")
                
                // Now remove the post ID from the user's list of posts
                userPostRef.queryOrderedByValue().queryEqual(toValue: post.id.uuidString).observeSingleEvent(of: .childAdded, with: { snapshot in
                    snapshot.ref.removeValue { error, _ in
                        if let error = error {
                            print("Failed to remove post ID from user's post list: \(error.localizedDescription)")
                        } else {
                            print("Post ID removed from user's post list successfully")
                            
                            // Check if indexPath.row is still valid before removing the post
                            if indexPath.row < self.posts.count {
                                // Remove the post from the local data source
                                self.posts.remove(at: indexPath.row)
                                
                                // Reload the entire table view
                                self.tableView.reloadData()
                                
                                // Optionally refresh posts from Firebase
                                self.fetchUserPosts()
                            } else {
                                print("Index out of range - post has already been removed.")
                            }
                        }
                    }
                })
            }
        }
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
