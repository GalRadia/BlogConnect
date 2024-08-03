//
//  HomeViewController.swift
//  BlogConnect
//
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func logoutClicked(_sender:Any){
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            SceneDelegate.showLogin()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
}
