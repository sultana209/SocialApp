//
//  PostCell.swift
//  SocialApp
//
//  Created by A K M Saleh Sultan on 3/28/18.
//  Copyright © 2018 A K M Saleh Sultan. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(post: Post) {
        self.post = post
        self.caption.text  = post.caption
        self.likesLbl.text = "\(post.likes)"
  
    }
  
}
