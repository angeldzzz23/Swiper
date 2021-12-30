//
//  CardView.swift
//  TinderClone
//
//  Created by Angel Zambrano on 12/20/21.
//

import UIKit
import SDWebImage // it is useful for loadin g images

protocol CardViewDelegate {
    func didTapMoreInfo(cardViewmode: CardViewModel)
}

class CardView: UIView {

    var delegate: CardViewDelegate?
    
    
    var cardViewModel: CardViewModel! {
        didSet {
            
            let imageName = cardViewModel.imageUrls.first ?? ""
            if let url = URL(string: imageName) {
                imageView.sd_setImage(with: url)
            }
           
            InformationLabel.attributedText = cardViewModel.attributedString
            InformationLabel.textAlignment = cardViewModel.textAlignment
            
            // setting the barstackview to be the approapritate color
            (0..<cardViewModel.imageUrls.count).forEach { (_) in
                let barView = UIView()
                barView.backgroundColor = barDeselectedColor
                barsStackView.addArrangedSubview(barView)
            }
            barsStackView.arrangedSubviews.first?.backgroundColor = .white
            
            setupImageInndexObserver()
        }
    }
     
    fileprivate func setupImageInndexObserver() {
        cardViewModel.imageIndexObserver = {[weak self] (idx,imagURL) in
            print("changing photo from view model")
            
            // using a url for our image
            if let url = URL(string: imagURL ?? "")  {
                self?.imageView.sd_setImage(with: url)
            }
                
    
            self?.barsStackView.arrangedSubviews.forEach { v in
                v.backgroundColor = self?.barDeselectedColor
            }
            self?.barsStackView.arrangedSubviews[idx].backgroundColor = .white
            
        }
    }
    
    // MARK: encapsulation
    fileprivate let imageView = UIImageView(image: UIImage(named: "lady5c"))
    let gradientLayer = CAGradientLayer()
    fileprivate let InformationLabel = UILabel()

    fileprivate let treshhold: CGFloat = 100

   
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
        
        // adding pan gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        // adding tap gesture
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
    }
    
//    var imageIndex = 0
    fileprivate let barDeselectedColor = UIColor(white: 0, alpha: 0.1)
    
    /// handles the tap gesture
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        
        let tapLocation = gesture.location(in: nil) // the location of the gesture
        let shouldAdvc = tapLocation.x > frame.width / 2 ? true : false  // check if you can advance to nextphoto
        
        if shouldAdvc {
            cardViewModel.advanceToNextPhoto()
        } else {
            cardViewModel.goToPrevPhoto()
        }
        
        
    }
    
    
    // the button moreINfoButto
    fileprivate let moreInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "info_icon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleMoreInfo), for: .touchUpInside)
        return button
    }()
    
    
    /// this method is called when the button
    /// Presenting the user details pare
    @objc fileprivate func handleMoreInfo() {  // there is no presenrt here
        // delegation to present a Viewcontroller
        delegate?.didTapMoreInfo(cardViewmode: self.cardViewModel)
    }
    
    
    fileprivate func setUpLayout() {
        // adding corner radius
        layer.cornerRadius = 10
        clipsToBounds = true
        
        
        
        
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        imageView.fillSuperview()  // adds contraint to the superview
        
        setUpBarsStackView()
        
        // add a gradient layer
        setUpGradientLayer()
        
        addSubview(InformationLabel)
        
        InformationLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        
        
        InformationLabel.textColor = .white
        
        InformationLabel.numberOfLines = 0
        
        // adding the moreInfoButton
        
        addSubview(moreInfoButton)
        
        moreInfoButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 16, right: 16), size: .init(width: 44, height: 44))
    }
    
    /// the top stack view that contains the bars
    fileprivate let barsStackView = UIStackView()
    
    fileprivate func setUpBarsStackView() {
        addSubview(barsStackView)
        
        barsStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
        
        
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
        
    
        barsStackView.arrangedSubviews.first?.backgroundColor = .white
        
     
    }
    
 

    // sets up the gradiet
    fileprivate func setUpGradientLayer() {
        
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5,1.1] // What does this do?
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 300, height: 400)
        layer.addSublayer(gradientLayer)
        
    }
    
    // executes everytime the view starts to draw itself
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    
    }
 
   
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            superview?.subviews.forEach({ subview in
                subview.layer.removeAllAnimations()
            })
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded(gesture)
        default:
            () // leaving it empty 
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
