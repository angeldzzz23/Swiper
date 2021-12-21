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
    

    
    let cardViewModels = [
        User(name: "Angel", age: 22, proffession: "Coffee Drinker", imageName: "lady5c").toCardViewModel(),
        User(name: "Jane", age: 18, proffession: "Teacher", imageName: "lady4c").toCardViewModel()
    ]
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupDummyCards()
        
    }
    
    fileprivate func setupDummyCards()  {
        
        cardViewModels.forEach { cardVM in
            let cardView = CardView(frame: .zero) // this is just a rect with 0, 0, doesnt matter since we are using autolayout
            cardView.imageView.image = UIImage(named: cardVM.imageName)
            cardView.InformationLabel.attributedText = cardVM.attributedString
            cardView.InformationLabel.textAlignment = cardVM.textAlignment
            cardDeckView.addSubview(cardView)
            cardView.fillSuperview()
            
        }
        
        
        
        
    
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

