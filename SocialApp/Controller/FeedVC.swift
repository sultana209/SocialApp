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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

  
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "postCell") as! PostCell
    }

    @IBAction func SignOutTapped(_ sender: Any) {
      let keychainResult =  KeychainWrapper.standard.removeObject(forKey: Key_UId)
        print("Salma: Id removed from Keychain \(keychainResult)")
        
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    

}
