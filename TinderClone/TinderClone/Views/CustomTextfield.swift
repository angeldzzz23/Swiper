//
//  CustomTextfield.swift
//  TinderClone
//
//  Created by Angel Zambrano on 12/22/21.
//

import UIKit

// changes the intrinsic height of the text field
class CustomTextfield: UITextField {
    let padding: CGFloat
    let height: CGFloat
    
    init(padding: CGFloat, height: CGFloat) {
        self.padding = padding
        self.height = height
        super.init(frame: .zero)
        layer.cornerRadius = height / 2
        backgroundColor = .white
        
    }
    
    // adding padding to the textfield
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
