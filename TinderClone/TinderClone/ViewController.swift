//
//  ViewController.swift
//  TinderClone
//
//  Created by Angel Zambrano on 12/20/21.
//

import UIKit

class ViewController: UIViewController {
    
    // instance properties
    let topStackView = TopNavigationStackView()
    let cardDeckView = UIView()
    let buttonStackView = HomeBottomControlsStackView()

    
   
    override func viewDidLoad() {
        super.viewDidLoad()        
        setupLayout()
        setupDummyCards()
        
    }
    
    fileprivate func setupDummyCards()  {
        let cardView = CardView(frame: .zero)
        cardDeckView.addSubview(cardView)
        cardView.fillSuperview()
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
    }


}

