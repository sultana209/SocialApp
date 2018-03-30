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
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

  
        tableView.delegate = self
        tableView.dataSource = self
        
        DataServices.ds.REF_POSTS.observe(DataEventType.value) { (snapshot) in
           // print(snapshot.value)
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
     
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let post = posts[indexPath.row]
//        print("Salma: \(post.caption)")
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "postCell" ) as? PostCell {
            cell.configureCell(post: post)
            return cell
        } else {
            return PostCell()
        }
   
    }

    @IBAction func SignOutTapped(_ sender: Any) {
      let keychainResult =  KeychainWrapper.standard.removeObject(forKey: Key_UId)
        print("Salma: Id removed from Keychain \(keychainResult)")
        
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    

}
