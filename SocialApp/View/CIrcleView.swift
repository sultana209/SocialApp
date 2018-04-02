//
//  CIrcleView.swift
//  SocialApp
//
//  Created by A K M Saleh Sultan on 3/28/18.
//  Copyright © 2018 A K M Saleh Sultan. All rights reserved.
//

import UIKit

class CIrcleView: UIImageView {
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        layer.shadowColor = UIColor(red: CGFloat(SHADOW_GRAY), green: CGFloat(SHADOW_GRAY), blue: CGFloat(SHADOW_GRAY), alpha: CGFloat(SHADOW_GRAY)).cgColor
//
//        layer.shadowOpacity = 0.8
//        layer.shadowRadius = 5.0
//        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
//
//
//    }
//
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//
//        layer.cornerRadius = self.frame.width / 2
//        clipsToBounds = true
//
//    }
    
    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }
}
