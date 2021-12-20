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
    let blueView = UIView()
    let buttonStackView = HomeBottomControlsStackView()

    
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        blueView.backgroundColor = .blue
        setupLayout()
        
        
    }
    
    // MARK: setting up the layout
    fileprivate func setupLayout() {
        let overallStackView  = UIStackView(arrangedSubviews: [topStackView, blueView,buttonStackView])
        overallStackView.axis = .vertical // makes it spand in the vertical axis
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }


}

