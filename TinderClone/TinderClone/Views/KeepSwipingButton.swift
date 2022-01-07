//
//  KeepSwipingButton.swift
//  TinderClone
//
//  Created by Angel Zambrano on 1/7/22.
//

import UIKit

class KeepSwipingButton: UIButton {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let gradientLayer = CAGradientLayer()
        let leftColor  =  #colorLiteral(red: 0.8882574439, green: 0.1114654019, blue: 0.4571794271, alpha: 1)
        let rightColor = #colorLiteral(red: 0.9826737046, green: 0.3377019167, blue: 0.3818222284, alpha: 1)
        gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
        // unsure
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        // apply a mask using a small rectable inside the gradeint somehow
        let cornerRadius = rect.height / 2
        let maskLayer = CAShapeLayer()
        
        let maskPath = CGMutablePath()
        
        maskPath.addPath(UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath)
        
        // punch out the middle
        
        // adding second math
        maskPath.addPath(UIBezierPath(roundedRect: rect.insetBy(dx: 2, dy: 2), cornerRadius: cornerRadius).cgPath)
        
        maskLayer.path = maskPath
        maskLayer.fillRule = .evenOdd
        
        gradientLayer.mask = maskLayer
        
        // mmm?
        self.layer.insertSublayer(gradientLayer, at: 0)
        // getting rounded corners
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        
        gradientLayer.frame = rect
    }

}
