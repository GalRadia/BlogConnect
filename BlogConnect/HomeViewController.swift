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
    @IBOutlet weak var descTextField: UITextView!
    @IBOutlet weak var categoriesTags: UISegmentedControl!
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.maximumDate = Date()
        descTextField.layer.borderWidth = 1
        descTextField.layer.borderColor = UIColor.systemGray5.cgColor
        descTextField.layer.cornerRadius = 6
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
        // Validate that title and description are not empty
        guard let title = titleTextField.text, !title.isEmpty,
              let description = descTextField.text, !description.isEmpty else {
            self.showAlertWithOk(title: "Validation Error", message: "Title and Description cannot be empty.", okAction: nil)
            return
        }

        // Retrieve the selected category from the segmented control
        guard let selectedCategoryTitle = categoriesTags.titleForSegment(at: categoriesTags.selectedSegmentIndex),
              let category = Category(rawValue: selectedCategoryTitle) else {
            print("Invalid category selected")
            return
        }

        // Safely unwrap the current user
        guard let currentUser = Auth.auth().currentUser else {
            print("No current user is authenticated")
            self.showAlertWithOk(title: "Error", message: "No user is logged in.", okAction: nil)
            return
        }

        // Show confirmation alert to the user
        let confirmationAlert = UIAlertController(title: "Confirm Submission",
                                                   message: "Are you sure you want to submit this post?",
                                                   preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Yes", style: .default) { _ in
            // Create the post object with the current timestamp
            let post = Post(title: title,
                            description: description,
                            category: category,
                            userName: currentUser.displayName ?? "Anonymous", // Use currentUser safely
                            timestamp: self.datePicker.date)

            // Save post ID to the user's reference
            let ref = Database.database().reference()
            let userReference = ref.child("users").child(currentUser.uid)
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
                        self.titleTextField.text = ""
                        self.descTextField.text = ""
                        self.categoriesTags.selectedSegmentIndex = 0
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        confirmationAlert.addAction(confirmAction)
        confirmationAlert.addAction(cancelAction)
        
        self.present(confirmationAlert, animated: true, completion: nil)
    }

  
    }

