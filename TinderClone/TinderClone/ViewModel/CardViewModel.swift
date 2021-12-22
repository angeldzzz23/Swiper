//
//  CardViewMode.swift
//  TinderClone
//
//  Created by Angel Zambrano on 12/21/21.
//

import Foundation
import UIKit


// creates a contract that will exists
protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

// deals with the UI for the application
// represents the the state of view
class CardViewModel {
    // define properties that the view will display/render out
    let imageNames: [String]
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
    
    fileprivate var imageIndex = 0 {
        didSet {
            let imageName = imageNames[imageIndex]
            let image = UIImage(named: imageName)
            imageIndexObserver?(imageIndex,image)
        }
    }
    
    // reactive programming
    var imageIndexObserver: ((Int,UIImage?) -> ())?
    
     func advanceToNextPhoto() {
         imageIndex  = min(imageIndex + 1, imageNames.count - 1)
    }
    
     func goToPrevPhoto() {
        imageIndex = max(0,imageIndex - 1)
    }
    
    init(imageNames: [String], attributedString: NSAttributedString, textAlignment: NSTextAlignment) {
        self.imageNames = imageNames
        self.attributedString = attributedString
        self.textAlignment = textAlignment
    }
    
    
}

