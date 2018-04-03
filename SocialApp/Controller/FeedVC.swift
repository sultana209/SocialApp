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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addImage: CIrcleView!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

  
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
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
            
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
               
                cell.configureCell(post: post, img: img)
                return cell
            } else {
            cell.configureCell(post: post)
            return cell
            }
        } else {
            return PostCell()
        }
   
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImage.image = img
        } else {
            print("Salma: A valid image wasn't selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

    @IBAction func SignOutTapped(_ sender: Any) {
      let keychainResult =  KeychainWrapper.standard.removeObject(forKey: Key_UId)
        print("Salma: Id removed from Keychain \(keychainResult)")
        
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    

}
