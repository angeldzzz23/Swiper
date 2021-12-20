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
        
        let grayView = UIView()
        grayView.backgroundColor = .gray
        
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
        let yellowView = UIView()
        yellowView.backgroundColor = .yellow
        yellowView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        
        
        
        let stackView  = UIStackView(arrangedSubviews: [topStackView, blueView,yellowView])
//        stackView.distribution = .fillEqually
        stackView.axis = .vertical // makes it spand in the vertical axis
        
        
        
        view.addSubview(stackView)
        stackView.frame = .init(x: 0, y: 0, width: 300, height: 300)
        
        stackView.fillSuperview()
        

        
        
    }


}

