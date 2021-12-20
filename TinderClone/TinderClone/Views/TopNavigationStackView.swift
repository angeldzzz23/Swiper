//
//  TopNavigationStackView.swift
//  TinderClone
//
//  Created by Angel Zambrano on 12/20/21.
//

import UIKit

class TopNavigationStackView: UIStackView {
    
    let settingsButton = UIButton(type: .system)
    let messagesButton = UIButton(type: .system)
    let fireImageView = UIImageView(image: UIImage(named: "app_icon"))
    
    
    // TODO:
    // Shrink fireImageview without having to use hack
    override init(frame:CGRect) {
        super.init(frame: frame)
        
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        fireImageView.contentMode = .scaleAspectFit
        
        settingsButton.setImage(UIImage(named: "top_left_profile")?.withRenderingMode(.alwaysOriginal), for: .normal)
        messagesButton.setImage(UIImage(named: "top_right_messages")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        // try to fix this
        [settingsButton, UIView(), fireImageView, UIView(), messagesButton].forEach { v in
            addArrangedSubview(v)
        }
        
        // Read the documentation for this
        distribution = .equalCentering
        
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        
        
        
  
        
        
    }
    
    required init(coder: NSCoder) {
        fatalError("fatal error")
    }
   


}
