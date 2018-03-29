//
//  ViewController.swift
//  SocialApp
//
//  Created by A K M Saleh Sultan on 3/21/18.
//  Copyright © 2018 A K M Saleh Sultan. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper


class SignInVC: UIViewController {

    @IBOutlet weak var emailField: fencyTextField!
    @IBOutlet weak var pwdField: fencyTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
    }

    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: Key_UId) {
            print("Salma: ID found in KeyChain")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookbtnTapped(_ sender: Any) {
   
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if error != nil {
                print("Salma: Unable to authenticate with facebook - \(error)")
            } else if result?.isCancelled == true {
                print("Salma: user cancelled facebook authontication")
            } else {
                print("Salma: successefully authenticated with facebook")
                
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential: credential)
            }
        }
    }
        func firebaseAuth(credential: AuthCredential) {
            
            Auth.auth().signIn(with: credential) { (user, error) in
                if let error = error {
                     print("Salma: Unable to authontication with Firebase - \(error)")
                }else {
                    print("Salma: Successfully authonticated with Firebase")
                    if let user = user {
                        let userData = ["provider": credential.provider]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                }
            }
        }
            
//            Auth.auth().signIn(with: credential, completion: { (user, error) in
//                if error != nil {
//                    print("Salma: Unable to authontication with Firebase - \(error)")
//                } else {
//                    print("Salma: Successfully authonticated with Firebase")
//                }
//            })
//
//        }
    
    @IBAction func signInBtnTapped(_ sender: Any) {
  
        if let email = emailField.text, let pwd = pwdField.text {
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("Salma: Email user authenticated with Firebase.")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("Salma: Unable to authenticate with Firebase using email.")
                        } else {
                            print("Salma: Successfully authenticate with firebase")
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                        }
                    })
                }
            })
        }
    
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataServices.ds.createFirebaseDBUser(uid: id, userData: userData)
     let keychainresult =   KeychainWrapper.standard.set(id , forKey: Key_UId)
        print("Salma: Data saved to keychain \(keychainresult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    
    
}

