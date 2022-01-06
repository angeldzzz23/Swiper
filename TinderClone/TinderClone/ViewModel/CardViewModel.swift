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
    let uid: String
    let imageUrls: [String]
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
    
    
    fileprivate var imageIndex = 0 {
        didSet {
            let imageURL = imageUrls[imageIndex]
//            let image = UIImage(named: imageName)
            imageIndexObserver?(imageIndex,imageURL)
        }
    }
    
    // reactive programming
    var imageIndexObserver: ((Int,String?) -> ())?
    
     func advanceToNextPhoto() {
         imageIndex  = min(imageIndex + 1, imageUrls.count - 1)
    }
    
     func goToPrevPhoto() {
        imageIndex = max(0,imageIndex - 1)
    }
    
    init(uid: String,imageNames: [String], attributedString: NSAttributedString, textAlignment: NSTextAlignment) {
        self.uid = uid
        self.imageUrls = imageNames
        self.attributedString = attributedString
        self.textAlignment = textAlignment
    }
    
    
}

