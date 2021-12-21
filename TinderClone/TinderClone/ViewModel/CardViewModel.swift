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
struct CardViewModel {
    // define properties that the view will display/render out
    let imageName: String
    let attributedString:NSAttributedString
    let textAlignment: NSTextAlignment
    
}

