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
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var titleTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func submitClicked(_ sender: Any) {
        
    }
    @IBAction func resetClicked(_ sender: Any) {
        // Clear the text fields and reset the segmented control
                titleTextField.text = ""
                descTextField.text = ""
                categoriesTags.selectedSegmentIndex = 0
    }
    func savePost(user:User){
        guard let currentUser = Auth.auth().currentUser else {
                print("No current user is authenticated")
                return
            }
   
        var ref:DatabaseReference!
        ref = Database.database().reference()
        let userReference = ref.child("users").child(currentUser.uid)
        let post = Post(description: descTextField.text ?? "", rate: Int(slider.value), categories: Category(rawValue: categoriesTags.titleForSegment(at: categoriesTags.selectedSegmentIndex)!)!)
        userReference.child("postID").setValue(post.id)
        ref.child("posts").child(post.id.uuidString).setValue(post)
    }
    
}
