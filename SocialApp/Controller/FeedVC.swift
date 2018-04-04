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
    @IBOutlet weak var captionField: fencyTextField!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imageSelected = false
    
    
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
    
    @IBAction func postBtnTapped(_ sender: Any) {
   
        guard let caption = captionField.text, caption != "" else{
            print("Salma: caption mut be entered")
            return
        }
        
        guard let img = addImage.image, imageSelected == true else {
            print("Salma: An image must be selected")
            return
        }
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            let imgUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataServices.ds.REF_POST_IMAGES.child(imgUid).putData(imgData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print("JESS: Unable to upload image to Firebasee torage")
                } else {
                    print("JESS: Successfully uploaded image to Firebase storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        self.postTOFirebase(imgUrl: url)
                    }
                }
            }
        }
      /*
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
           let imgUid = NSUUID().uuidString
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            DataServices.ds.REF_POST_IMAGES.child(imgUid).putData(imgData, metadata: metaData, completion: { (metadat, error) in
            
//                <#code#>
//            })
//            DataServices.ds.REF_POST_IMAGES.child(imgUid).putData(imgData, metadata: metaData, completion: { (metadata , error) in
                if error != nil {
                    print("Salma: unable to upload image to firebase.")
                } else {
                    print("Salma: successfully upload image to firebase storage.")
                    print(metaData)
                   
                    let  downloadURL = metaData.downloadURL()
//                    if let url = downloadURL{
//                        self.postTOFirebase(imUrl: url)
//                    }
         self.postTOFirebase(imUrl: downimgUrlRL!)
                
                }
            })
        }
 */
    }
    
    func postTOFirebase(imgUrl: String) {
        
        let post: Dictionary<String, AnyObject> = [
            "caption" : captionField.text! as AnyObject,
            "imageUrl": imgUrl as AnyObject,
            "likes": 0 as AnyObject
        ]
        let firebasePost = DataServices.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        captionField.text = ""
        imageSelected = false
        addImage.image = UIImage(named: "add-image")
        tableView.reloadData()
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImage.image = img
            imageSelected = true
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
