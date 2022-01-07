//
//  SendMessageButton.swift
//  TinderClone
//
//  Created by Angel Zambrano on 1/7/22.
//

import UIKit

// here we are going to draw the gradient
class SendMessageButton: UIButton {

    // draw method allows us to draw additional thing inside of our views
    // the
    override func draw(_ rect: CGRect) {
        super.draw(rect) // doesnt really do anything
        
        let gradientLayer = CAGradientLayer()
        let leftColor  =  #colorLiteral(red: 0.8882574439, green: 0.1114654019, blue: 0.4571794271, alpha: 1)
        let rightColor = #colorLiteral(red: 0.9826737046, green: 0.3377019167, blue: 0.3818222284, alpha: 1)
        gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
        // unsure
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        // mmm?
        self.layer.insertSublayer(gradientLayer, at: 0)
        // getting rounded corners
        layer.cornerRadius = rect.height / 2
        clipsToBounds = true
        
        gradientLayer.frame = rect
    }
}
