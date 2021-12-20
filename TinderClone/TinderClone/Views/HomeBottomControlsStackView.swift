//
//  HomeBottomControlsStackView.swift
//  TinderClone
//
//  Created by Angel Zambrano on 12/20/21.
//

import UIKit

class HomeBottomControlsStackView: UIStackView {
    override init(frame:CGRect) {
        super.init(frame: frame)
        
        // sets the distributiion
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        
        
        let subviews = [UIImage(named: "refresh_circle"), UIImage(named: "dismiss_circle"),UIImage(named: "super_like_circle"),UIImage(named: "like_circle"),UIImage(named: "boost_circle")].map { img ->UIView in
            let button = UIButton(type: .system)
            button.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
            return button
        }
        
        
        // sets the bottom subviews
        subviews.forEach { v in
            addArrangedSubview(v)
        }
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
