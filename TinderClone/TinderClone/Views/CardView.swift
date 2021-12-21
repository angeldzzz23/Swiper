//
//  CardView.swift
//  TinderClone
//
//  Created by Angel Zambrano on 12/20/21.
//

import UIKit

class CardView: UIView {
    
    fileprivate let imageView = UIImageView(image: UIImage(named: "lady5c"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // adding corner radius
        layer.cornerRadius = 10
        clipsToBounds = true
        
        
        addSubview(imageView)
        imageView.fillSuperview()  // adds contraint to the superview
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
