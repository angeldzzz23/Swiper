//
//  HomeBottomControlsStackView.swift
//  TinderClone
//
//  Created by Angel Zambrano on 12/20/21.
//

import UIKit

class HomeBottomControlsStackView: UIStackView {
    
    // creating buttons
    static func createButton(image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    let refreshButton = createButton(image: UIImage(named: "refresh_circle")!)
    let dislikeButton = createButton(image: UIImage(named: "dismiss_circle")!)
    let superLikeButton = createButton(image: UIImage(named: "super_like_circle")!)
    let likeButton = createButton(image: UIImage(named: "like_circle")!)
    let specialButton = createButton(image: UIImage(named: "boost_circle")!)
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        
        // sets the distributiion
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        
        [refreshButton, dislikeButton, superLikeButton, likeButton,specialButton].forEach { button in
            self.addArrangedSubview(button)
        }
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
