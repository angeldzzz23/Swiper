//
//  CardView.swift
//  TinderClone
//
//  Created by Angel Zambrano on 12/20/21.
//

import UIKit

class CardView: UIView {

    var cardViewModel: CardViewModel! {
        didSet {
            imageView.image = UIImage(named: cardViewModel.imageName)
            InformationLabel.attributedText = cardViewModel.attributedString
            InformationLabel.textAlignment = cardViewModel.textAlignment
        }
    }
    
    fileprivate let imageView = UIImageView(image: UIImage(named: "lady5c"))
    fileprivate let InformationLabel = UILabel()

    // configurations
    fileprivate let treshhold: CGFloat = 100

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // adding corner radius
        layer.cornerRadius = 10
        clipsToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        imageView.fillSuperview()  // adds contraint to the superview
        
        addSubview(InformationLabel)
        
        InformationLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        
        InformationLabel.text = "Tst name test name AGE"
        InformationLabel.textColor = .white
        InformationLabel.font = UIFont.systemFont(ofSize: 34, weight: .heavy)
        InformationLabel.numberOfLines = 0
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        
    }
    
 
   
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        
        
        switch gesture.state {
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded(gesture)

        default:
            ()
        }
        
    }
    
    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        
        // rotation
        // converting radians to degrees
        let degrees: CGFloat = translation.x / 20 // the division of 20 slows the effect down
        let angle = degrees * .pi / 180
        
        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        
        self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y) // setting the card to rotate and panning
        
//        self.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
    }
    
    
    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        
        
        let translation = gesture.translation(in: nil)
        let shouldDismissCard = translation.x > treshhold || translation.x < -treshhold
    
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut) {
            
            if shouldDismissCard {
                
                if (translation.x > self.treshhold) {
                    let offScreenTransform = self.transform.translatedBy(x: 1000, y: 0)
                    self.transform = offScreenTransform
                } else if (translation.x < -self.treshhold) {
                    let offScreenTransform = self.transform.translatedBy(x: -1000, y: 0)
                    self.transform = offScreenTransform
                }
                
                
                
            } else {
                self.transform = .identity
            }
            
           
        } completion: { (_) in
           
            self.transform = .identity // brings it back to the origin
            if shouldDismissCard {
                self.removeFromSuperview()
            }
            
         
//            self.frame = CGRect(x: 0, y: 0, width: self.superview!.frame.width, height: self.superview!.frame.height)

        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
