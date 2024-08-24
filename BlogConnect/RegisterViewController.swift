//
//  RegisterViewController.swift
//  BlogConnect
//
// Gal

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore
class RegisterViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBAction func submitClicked(_sender:Any){
        let name = nameTextField.text!
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        if name.isEmpty || email.isEmpty || password.isEmpty {
                   showAlertWithOk(title: "Register Error", message: "Please enter valid name/email/password", okAction: nil)
               } else {
                   checkIfUsernameExists(username: name) { [weak self] exists in
                       guard let strongSelf = self else { return }
                       
                       if exists {
                           strongSelf.showAlertWithOk(title: "Register Error", message: "Username already exists. Please choose a different one.", okAction: nil)
                       } else {
                           strongSelf.createUser(name: name, email: email, password: password)
                       }
                   }
               }
           }
           
           // Function to create the user
           func createUser(name: String, email: String, password: String) {
               Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
                   guard let strongSelf = self else { return }
                   if error == nil {
                       print("User created")
                       
                       let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                       changeRequest?.displayName = name
                       changeRequest?.commitChanges(completion: { error in
                           if let error = error {
                               strongSelf.showAlertWithOk(title: "Registration error", message: error.localizedDescription, okAction: nil)
                           } else {
                               let currentUser = Auth.auth().currentUser
                               let user = User(uid: currentUser!.uid, username: currentUser!.displayName!)
                               strongSelf.saveUserToDatabase(user: user)
                               
                               SceneDelegate.showHome()
                           }
                       })
                   } else {
                       strongSelf.showAlertWithOk(title: "Registration error", message: error!.localizedDescription, okAction: nil)
                       print(error?.localizedDescription as Any)
                   }
               }
           }
           
           // Function to check if username already exists
           func checkIfUsernameExists(username: String, completion: @escaping (Bool) -> Void) {
               let ref = Database.database().reference().child("users")
               ref.queryOrdered(byChild: "username").queryEqual(toValue: username).observeSingleEvent(of: .value) { snapshot in
                   completion(snapshot.exists())
               }
           }
           
           // Save the User to the database
           func saveUserToDatabase(user: User) {
               var ref: DatabaseReference!
               ref = Database.database().reference()
               guard let currentUser = Auth.auth().currentUser else {
                   print("No current user is authenticated")
                   return
               }
               
               // Define the path where the user data will be stored
               let userReference = ref.child("users").child(currentUser.uid)
               
               // Convert the User object to a dictionary
               let userDict = user.toDictionary()
               
               // Save the user data to the database
               userReference.setValue(userDict) { error, _ in
                   if let error = error {
                       print("Error saving user data: \(error.localizedDescription)")
                   } else {
                       print("User data successfully saved!")
                   }
               }
           }
       }
