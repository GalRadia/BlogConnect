//
//  HomeViewController.swift
//  BlogConnect
//
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

class HomeViewController: UIViewController{
    @IBOutlet weak var descTextField: UITextField!
    @IBOutlet weak var categoriesTags: UISegmentedControl!
    @IBOutlet weak var titleTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func submitClicked(_ sender: Any) {
        savePost()
    }
    @IBAction func resetClicked(_ sender: Any) {
        // Clear the text fields and reset the segmented control
                titleTextField.text = ""
                descTextField.text = ""
                categoriesTags.selectedSegmentIndex = 0
    }
    func savePost() {
        guard let currentUser = Auth.auth().currentUser else {
            print("No current user is authenticated")
            return
        }

        let ref = Database.database().reference()
        let userReference = ref.child("users").child(currentUser.uid)
        
        // Create the post object
        guard let selectedCategoryTitle = categoriesTags.titleForSegment(at: categoriesTags.selectedSegmentIndex),
              let category = Category(rawValue: selectedCategoryTitle) else {
            print("Invalid category selected")
            return
        }
        
        let post = Post(description: descTextField.text ?? "", categorie: category)
        
        // Save post ID to the user's reference
        userReference.child("postID").childByAutoId().setValue(post.id.uuidString) { error, _ in
            if let error = error {
                print("Failed to save post ID to user reference: \(error.localizedDescription)")
                self.showAlertWithOk(title: "Error", message: "Failed to save post ID. Please try again.", okAction: nil)
                return
            }
            
            // Save post details to the posts node
            let postDict = post.toDictionary()
            ref.child("posts").child(post.id.uuidString).setValue(postDict) { error, _ in
                if let error = error {
                    print("Failed to save post: \(error.localizedDescription)")
                    self.showAlertWithOk(title: "Error", message: "Failed to save post. Please try again.", okAction: nil)
                    return
                }
                
                // Success handling
                print("Post saved successfully")
                self.showAlertWithOk(title: "Success", message: "Your post has been saved.", okAction: { _ in
                    // Clear the text fields and navigate back if needed
                    self.descTextField.text = ""
                    self.categoriesTags.selectedSegmentIndex = 0
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }

}
