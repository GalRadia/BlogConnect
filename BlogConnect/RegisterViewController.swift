//
//  RegisterViewController.swift
//  BlogConnect
//
//

import UIKit
import FirebaseAuth
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
        
        if name.isEmpty||email.isEmpty||password.isEmpty{
            showAlertWithOk(title: "Register Error", message: "Please enter valid name/email/password", okAction: nil)
        }
        else{
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
              guard let strongSelf = self else { return }
              // ...
                if error == nil{
                    print("User created")
                    
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = name
                    changeRequest?.commitChanges(completion:{ error in
                        if let error = error{
                            strongSelf.showAlertWithOk(title: "Registeration error", message: error.localizedDescription, okAction: nil)

                        }else{
                            SceneDelegate.showHome()
                        }
                    })
                }
                else{
                    strongSelf.showAlertWithOk(title: "Registeration error", message: error!.localizedDescription, okAction: nil)
                    print(error?.localizedDescription)
                }
            }
        }
    }
    @IBAction func cancelClicked (_sender:Any){
        self.navigationController?.popViewController(animated: true)
    }
}
