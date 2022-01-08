//
//  MatchView.swift
//  TinderClone
//
//  Created by Angel Zambrano on 1/7/22.
//

import UIKit
import Firebase

class MatchView: UIView {
    
    var currentUser: User! {
        didSet {
           
            
        }
    }
    
    
    var cardUID: String! {
        
        didSet {
            // either fetch current user or pass in our current user if we have it 
            
            // fetch the cardUID information
            let query =  Firestore.firestore().collection("users")
            
             query.document(cardUID).getDocument { snapshot, err in
                if let err = err {
                    print("Failed to fetch card user:", err)
                    return
                }
                
                // getting the data as a dictionary
                guard let dictionary = snapshot?.data() else {return}
                let user = User(dictionary: dictionary)
                 
                guard let url = URL(string: user.imageUrl1 ?? "") else {return}
                self.cardUserImageView.sd_setImage(with: url)
                 
                 guard let currentUserImageUrl = URL(string: self.currentUser.imageUrl1 ?? "") else {return }
                 
                 // gets rid of the flashing
                 self.currentUserImageView.sd_setImage(with: currentUserImageUrl) { _, _, _, _ in
                     self.setUpAnimations()
                 }
                
                 // set up the description label text here
                 
                 
                
                
                
            }
            
            
        }
    }
    
    
    
    fileprivate let isAMatchImageView: UIImageView = {
       let iv = UIImageView(image: UIImage(named: "itsamatch"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    /// the label that contains the description of the user
    fileprivate let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "You and X have liked\neach other"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    /// the imageview of the user
    fileprivate let currentUserImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "jane2"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    fileprivate let cardUserImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "kelly2"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.alpha = 0
        return imageView
    }()
    
    
    
    fileprivate let sendMessageButton: UIButton = {
        let button = SendMessageButton(type: .system)
        button.setTitle("SEND MESSAGE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    
    
    fileprivate let keepSwipingButton: UIButton = {
        let button = KeepSwipingButton(type: .system)
        button.setTitle("SEND MESSAGE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBlurView()
        setUpLayout()
        
    }
    
    fileprivate func setUpAnimations() {
        
        views.forEach({$0.alpha = 1})
        // starting positions
        let angle = 30 * CGFloat.pi/180 // -30 in radians
        
        currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle).concatenating(  CGAffineTransform(translationX: 200, y: 0))
      
        cardUserImageView.transform = CGAffineTransform(rotationAngle: angle).concatenating( CGAffineTransform(translationX: -200, y: 0))

        // buttons start off completely off screen
        sendMessageButton.transform = CGAffineTransform(translationX: -500, y: 0)
        keepSwipingButton.transform = CGAffineTransform(translationX: 500, y: 0)
        
        // keyframe animations for segmented animations
        UIView.animateKeyframes(withDuration: 1.2, delay: 0, options: .calculationModeCubic) {
        
            // animation 1 - transaltion back to original position
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.45) {
                self.currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
                self.cardUserImageView.transform = CGAffineTransform(rotationAngle: angle)
            }
            
            // animation 2 - rotation
            //
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4) {
                self.currentUserImageView.transform = .identity
                self.cardUserImageView.transform = .identity
            }
            
            
        } completion: { _ in
            
        }
        
        // added the animation for the buttons
        UIView.animate(withDuration: 0.75, delay: 0.65 * 1.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseOut) {
            self.sendMessageButton.transform = .identity
            self.keepSwipingButton.transform = .identity
        } completion: { _ in
            
        }

    

    }
    
    
    
    lazy var views = [isAMatchImageView,descriptionLabel, currentUserImageView, cardUserImageView, sendMessageButton, keepSwipingButton]
    
    
    /// sets up the contraints of each view
    /// the following constraints are added:
    /// isAMatchImageView,
    /// descriptionLabel - the description,
    /// currentUserImageView,
    /// cardUserImageView - the user you have made the match with,
    fileprivate func setUpLayout() {
        views.forEach { v in
            addSubview(v)
            v.alpha = 0
        }
  
        
        let imageWith: CGFloat = 140 // the width of the image
        
        // constraints for the itsAMatchImageView
        isAMatchImageView.anchor(top: nil, leading: nil, bottom: descriptionLabel.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 16, right: 0), size: .init(width: 300, height: 80))
        isAMatchImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        // costraints for the description label
        descriptionLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: currentUserImageView.topAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 32, right: 0), size: .init(width: 0, height: 50))
        
        // constraints the trailing anchor to the centerx anchor
        currentUserImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: centerXAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16), size: .init(width: imageWith, height: imageWith))
        currentUserImageView.layer.cornerRadius = imageWith/2
        currentUserImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        // constraints leading anchor to the middle
        // adds some padding
        cardUserImageView.anchor(top: nil, leading: centerXAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0), size: .init(width: imageWith, height: imageWith))
        cardUserImageView.layer.cornerRadius = imageWith/2
        // centers it to the middle
        cardUserImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
     // constraints for the sendMessageButton
        sendMessageButton.anchor(top: currentUserImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 32, left: 48, bottom: 0, right: 48), size: .init(width: 0, height: 60))
        
        keepSwipingButton.anchor(top: sendMessageButton.bottomAnchor, leading: sendMessageButton.leadingAnchor, bottom: nil, trailing: sendMessageButton.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 60))
        
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
            self.alpha = 0
        } completion: { _ in
            // we remove the view from the superview
            self.removeFromSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
