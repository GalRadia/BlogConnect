//
//  LoginViewController.swift
//  BlogConnect
//
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import FirebaseDatabase

class LoginViewController: UIViewController{
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure Google Sign-In
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: FirebaseApp.app()?.options.clientID ?? "")

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
    @IBAction func SignUpClicked(_ sender: Any) {
       
    }
    
    @IBAction func GoogleSignInClicked(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
                
                let config = GIDConfiguration(clientID: clientID)
                GIDSignIn.sharedInstance.configuration = config
                
                GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
                    guard error == nil else {
                        print("Error signing in: \(error!.localizedDescription)")
                        return
                    }
                    
                    guard let user = result?.user,
                          let idToken = user.idToken?.tokenString else {
                        print("Google authentication failed.")
                        return
                    }
                    
                    let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                                   accessToken: user.accessToken.tokenString)
                    
                    Auth.auth().signIn(with: credential) { authResult, error in
                        if let error = error {
                            self.showAlertWithOk(title: "Login Error", message: error.localizedDescription, okAction: nil)
                            return
                        }
                        
                        guard let currentUser = Auth.auth().currentUser else { return }
                        let ref = Database.database().reference()
                        let userReference = ref.child("users").child(currentUser.uid)
                        
                        // Check if the user already exists
                        userReference.observeSingleEvent(of: .value) { snapshot in
                            if snapshot.exists() {
                                // User already exists, navigate to home
                                SceneDelegate.showHome()
                            } else {
                                // User does not exist, save user data
                                let user = User(uid: currentUser.uid, username: (currentUser.displayName ?? currentUser.email?.components(separatedBy: "@").first)!)
                                let userDict = user.toDictionary()
                                userReference.setValue(userDict) { error, _ in
                                    if let error = error {
                                        self.showAlertWithOk(title: "Database Error", message: error.localizedDescription, okAction: nil)
                                    } else {
                                        // Username saved successfully, proceed to home
                                        SceneDelegate.showHome()
                                    }
                                }
                            }
                        }
                    }
                }
           
    }
    
    @IBAction func PhoneSignInClicked(_ sender: Any) {
        showPhoneNumberInputDialog()
    }
    func showPhoneNumberInputDialog() {
            let alert = UIAlertController(title: "Enter Phone Number", message: "Please enter your phone number", preferredStyle: .alert)
            
            alert.addTextField { textField in
                textField.placeholder = "Phone Number"
                textField.keyboardType = .phonePad
            }
            
            let verifyAction = UIAlertAction(title: "Verify", style: .default) { _ in
                if let phoneNumber = alert.textFields?.first?.text, !phoneNumber.isEmpty {
                    self.startPhoneNumberVerification(phoneNumber)
                } else {
                    self.showAlertWithOk(title: "Error", message: "Phone number cannot be empty", okAction: nil)
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(verifyAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true)
        }
    func startPhoneNumberVerification(_ phoneNumber: String) {
           PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
               if let error = error {
                   self.showAlertWithOk(title: "Verification Error", message: error.localizedDescription, okAction: nil)
                   return
               }
               
               // Store verification ID to use later
               UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
               
               // Prompt user to enter the SMS code
               self.showVerificationCodeAlert()
           }
       }
    
     
    func showVerificationCodeAlert() {
        let alert = UIAlertController(title: "Enter Verification Code", message: "Please enter the code sent to your phone", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Verification Code"
            textField.keyboardType = .numberPad
        }
        
        let verifyAction = UIAlertAction(title: "Verify", style: .default) { _ in
            if let verificationCode = alert.textFields?.first?.text, !verificationCode.isEmpty {
                self.verifyCode(verificationCode)
            } else {
                self.showAlertWithOk(title: "Error", message: "Verification code cannot be empty", okAction: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(verifyAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    func verifyCode(_ verificationCode: String) {
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
            self.showAlertWithOk(title: "Error", message: "Verification ID not found", okAction: nil)
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                self.showAlertWithOk(title: "Sign In Error", message: error.localizedDescription, okAction: nil)
                return
            }
            if authResult?.user.displayName?.isEmpty==false{
                SceneDelegate.showHome()
            }
       
            self.showUsernameInputDialog { username in
                        guard let currentUser = Auth.auth().currentUser else { return }
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = username
                changeRequest?.commitChanges()
                        // Create user data
                        let user = User(uid: currentUser.uid, username: username)
                        let userDict = user.toDictionary()
                        
                        // Save user data to Firebase Realtime Database
                        let ref = Database.database().reference()
                        let userReference = ref.child("users").child(currentUser.uid)
                        userReference.setValue(userDict) { error, _ in
                            if let error = error {
                                self.showAlertWithOk(title: "Database Error", message: error.localizedDescription, okAction: nil)
                            } else {
                                // User data saved successfully, proceed to home
                                SceneDelegate.showHome()
                            }
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
    func showUsernameInputDialog(onSave: @escaping (String) -> Void) {
            let alert = UIAlertController(title: "Enter Username", message: "Please enter your username", preferredStyle: .alert)
            
            alert.addTextField { textField in
                textField.placeholder = "Username"
            }
            
            let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
                if let username = alert.textFields?.first?.text, !username.isEmpty,!username.trimmingCharacters(in: .whitespaces).isEmpty {
                    onSave(username)
                } else {
                    self.showAlertWithOk(title: "Error", message: "Username cannot be empty", okAction: nil)
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
}
