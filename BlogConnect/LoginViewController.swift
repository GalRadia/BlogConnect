//
//  LoginViewController.swift
//  BlogConnect
//
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController{
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func loginClicked(_ sender:Any){
        let email = emailTextField.text!
        let password = passwordTextField.text!
        if email.isEmpty || password.isEmpty{
            print("Enter email/password !!")
            showAlertWithOk(title: "Login Error", message: "Please enter valid email/password",okAction:nil)
        }
        else{
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard let strongSelf = self else { return }
                if error == nil{
                    print("Logged in successfully")
                    SceneDelegate.showHome()
                }
                else{
                    strongSelf.showAlertWithOk(title: "Login Error", message: error!.localizedDescription, okAction: nil)
                }
            }

            
        }
    }
}
extension UIViewController{
    func showAlertWithOk(title: String, message: String, okAction:((UIAlertAction)-> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: okAction))
        self.present(alert,animated: true)
    }
    func showAlertWithOkAndCancel(title: String, message: String, okAction:((UIAlertAction)-> Void)?,
                                  cancelAction:((UIAlertAction)->Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: okAction))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: cancelAction))
        self.present(alert,animated:true)
    }
}
