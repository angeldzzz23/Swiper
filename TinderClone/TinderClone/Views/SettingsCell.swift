//
//  SettingsCell.swift
//  TinderClone
//
//  Created by Angel Zambrano on 12/24/21.
//

import UIKit

class SettingsCell: UITableViewCell {


    class SettingsTextfield: UITextField {
        
        // to shift the place holder to the right
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 24, dy: 0)
        }
        
        // to shift the text to the right
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 24, dy: 0)
        }
        
        override var intrinsicContentSize: CGSize {
            return .init(width: 0, height: 44)
        }
    }
    
    
    // our text texfield
    let textfield: UITextField = {
       let tf = SettingsTextfield()
        tf.placeholder = "Enter Name"
        return tf
        
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        addSubview(textfield)
        
        // For some reason, I wasnt able to edit on a cell but this solved the problem
        // https://www.py4u.net/discuss/1900205
        contentView.addSubview(textfield)
        
//        textfield.allowsEditingTextAttributes = true
//        textfield.isEnabled = true
        
//        econtentView.isUserInteractionEnabled = true
            
        
        textfield.fillSuperview()
        
        contentView.isUserInteractionEnabled = true
    }

        
    // default initialzier
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
