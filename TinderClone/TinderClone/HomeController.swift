//
//  ViewController.swift
//  TinderClone
//
//  Created by Angel Zambrano on 12/20/21.
//

import UIKit

class HomeController: UIViewController {
    
    // instance properties
    let topStackView = TopNavigationStackView()
    let cardDeckView = UIView()
    let buttonStackView = HomeBottomControlsStackView()

    let users = [
    User(name: "Angel", age: 22, proffession: "Coffee Drinker", imageName: "lady5c"),
    User(name: "Jane", age: 18, proffession: "Teacher", imageName: "lady4c")

    
    ]
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupDummyCards()
        
    }
    
    fileprivate func setupDummyCards()  {
        
        users.forEach { user in
            let cardView = CardView(frame: .zero)
        
            cardView.InformationLabel.text = "\(user.name) \(user.age)\n\(user.proffession)"
            cardView.imageView.image = UIImage(named: user.imageName)
            
            // addiding attributed text
            let attributedText = NSMutableAttributedString(string: user.name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
            
            attributedText.append(NSAttributedString(string: "  \(user.age)", attributes: [.font : UIFont.systemFont(ofSize: 24, weight: .regular)]))
            
            attributedText.append(NSAttributedString(string: "\n\(user.proffession)", attributes: [.font : UIFont.systemFont(ofSize: 20, weight: .regular)]))

            
            cardView.InformationLabel.attributedText = attributedText
            
            cardDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
        
        
//        (0..<10).forEach { (_) in
//            let cardView = CardView(frame: .zero)
//            cardDeckView.addSubview(cardView)
//            cardView.fillSuperview()
//        }
        
        
    
    }
    
    // MARK: setting up the layout
    fileprivate func setupLayout() {
        
        let overallStackView  = UIStackView(arrangedSubviews: [topStackView, cardDeckView,buttonStackView])
        
        overallStackView.axis = .vertical // makes it spand in the vertical axis
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        // adding margins to the left and right side of the stack view
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        // changing the z index for cardDeckView
        overallStackView.bringSubviewToFront(cardDeckView)
    }


}

