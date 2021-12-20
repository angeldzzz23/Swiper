//
//  ViewController.swift
//  TinderClone
//
//  Created by Angel Zambrano on 12/20/21.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
     

        // this map function, iterates through all of the colors and returns  and array
        let subviews = [UIColor.gray, UIColor.darkGray, UIColor.black].map { color -> UIView in
            let v = UIView()
            v.backgroundColor = color
            return v
        }
        
        
        let topStackView = UIStackView(arrangedSubviews: subviews)

        topStackView.distribution = .fillEqually
        topStackView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let blueView = UIView()
        blueView.backgroundColor = .blue
    
        
        let buttonStackView = HomeBottomControlsStackView()
        
        
        
        let overallStackView  = UIStackView(arrangedSubviews: [topStackView, blueView,buttonStackView])
        overallStackView.axis = .vertical // makes it spand in the vertical axis
        
        
        
        view.addSubview(overallStackView)

        
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        

        
        
    }


}

