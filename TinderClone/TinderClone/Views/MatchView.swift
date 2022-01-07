//
//  MatchView.swift
//  TinderClone
//
//  Created by Angel Zambrano on 1/7/22.
//

import UIKit

class MatchView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBlurView()
        
    }
    
    // the visual effect view
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    
    /// creating the blur effect
    fileprivate func setupBlurView() {
       
        visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDimiss)))
        
        addSubview(visualEffectView)
        visualEffectView.fillSuperview()
        visualEffectView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.visualEffectView.alpha = 1
        } completion: { _ in
            
        }

        
    }
    
    /// deals with the tapping gesture
    @objc fileprivate func handleTapDimiss() {
 
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.visualEffectView.alpha = 0
        } completion: { _ in
            // we remove the view from the superview
            self.removeFromSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
