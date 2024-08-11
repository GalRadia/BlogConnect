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
          
          tableView.register(UINib(nibName: "PostsTableViewCell", bundle: nil), forCellReuseIdentifier: "PostsTableViewCell")
          
          fetchUserPosts()
      }
      
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return posts.count
      }

      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "PostsTableViewCell", for: indexPath) as! PostsTableViewCell
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
                      let post = self.parsePost(dictionary: postDict)
                      self.posts.append(post)
                  }
              }
              
              self.tableView.reloadData()
          }
      }
      
      func parsePost(dictionary: [String: Any]) -> Post {
          let id = UUID(uuidString: dictionary["id"] as? String ?? "") ?? UUID()
          let title = dictionary["title"] as? String ?? ""
          let description = dictionary["description"] as? String ?? ""
          let category = Category(rawValue: dictionary["category"] as? String ?? "") ?? .News
          let userName = dictionary["userName"] as? String ?? ""
          
          return Post(title: title, description: description, category: category, userName: userName)
      }
      
    // Logout the current user and perform segue to LoginViewController
        @IBAction func logoutButtonTapped(_ sender: UIButton) {
            do {
                try Auth.auth().signOut()
                
                // Perform the segue to the LoginViewController
                performSegue(withIdentifier: "logoutSegue", sender: self)
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        }
        
        // Prepare for the segue (optional, if you need to pass data)
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "logout" {
                // Prepare anything you need for the LoginViewController
                if let loginVC = segue.destination as? LoginViewController {
                    // Pass any required data to the loginVC here
                }
            }
        }
    }
