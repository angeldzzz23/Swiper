//
//  AgeRangeCell.swift
//  TinderClone
//
//  Created by Angel Zambrano on 12/28/21.
//

import UIKit

class AgeRangeCell: UITableViewCell {
    /// represents the slider that contains the minimum number
    let minSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 100
        return slider
    }()
    /// represents the slider that contains the maximum nymber
    let maxSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 100
        return slider
    }()
    
    let maxLabel: UILabel = {
        let label = AgeRangeLabel()
        label.text = "Max 88"
        return label
    }()
    
    
    let minLabel: UILabel = {
        let label = AgeRangeLabel()
        label.text = "Min 88"
        return label
    }()
    
    class AgeRangeLabel: UILabel {
        override var intrinsicContentSize: CGSize {
            return .init(width: 80, height: 0)
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        // draw a vertical stack view of sliders
        let overallStackview = UIStackView(arrangedSubviews:
          [ UIStackView(arrangedSubviews:[minLabel,minSlider]),UIStackView(arrangedSubviews:[maxLabel,maxSlider]) ])
        
        
        // instead of using 
        
        overallStackview.axis = .vertical
        overallStackview.spacing = 16
        
//        addSubview(overallStackview)
       
        contentView.isUserInteractionEnabled = true
        contentView.addSubview(overallStackview)
        
        // anchoding the stackview
        
        overallStackview.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        
     
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
