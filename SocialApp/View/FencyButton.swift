//
//  FencyButton.swift
//  SocialApp
//
//  Created by A K M Saleh Sultan on 3/23/18.
//  Copyright © 2018 A K M Saleh Sultan. All rights reserved.
//

import UIKit

class FencyButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: CGFloat(SHADOW_GRAY), green: CGFloat(SHADOW_GRAY), blue: CGFloat(SHADOW_GRAY), alpha: CGFloat(SHADOW_GRAY)).cgColor
        
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        layer.cornerRadius = 2.0
        
    }
    
}
