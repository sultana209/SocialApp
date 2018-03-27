//
//  FeedVC.swift
//  SocialApp
//
//  Created by A K M Saleh Sultan on 3/27/18.
//  Copyright © 2018 A K M Saleh Sultan. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func SignOutTapped(_ sender: Any) {
      let keychainResult =  KeychainWrapper.standard.removeObject(forKey: Key_UId)
        print("Salma: Id removed from Keychain \(keychainResult)")
        
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    

}
