//
//  User.swift
//  TinderClone
//
//  Created by Angel Zambrano on 12/20/21.
//

import UIKit
import Foundation

struct User: ProducesCardViewModel {
    // defining properties for our model layer
    var name: String?
    var age: Int?
    var proffession: String?
    var uid: String?
//    let imageNames: [String]
    var imageUrl1: String?
    var imageUrl2: String?
    var imageUrl3: String?
    
    init(dictionary: [String: Any]) {
        // initialize our user data
//         = name
        self.age = dictionary["age"] as? Int
        self.proffession = dictionary["proffession"] as? String
        
      
        self.name = dictionary["fullname"] as? String ?? ""
        self.imageUrl1 = dictionary["imageUrl1"] as? String
        self.imageUrl2 = dictionary["imageUrl2"] as? String
        self.imageUrl3 = dictionary["imageUrl3"] as? String
        self.uid = dictionary["uid"] as? String ?? ""
        
    }
    
    
    func toCardViewModel() -> CardViewModel {
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
    
        
        let ageString = age  != nil  ? "\(age!)" : "N\\A"
        
        attributedText.append(NSAttributedString(string: "  \(ageString)", attributes: [.font : UIFont.systemFont(ofSize: 24, weight: .regular)]))
        
        let proffessionString = proffession != nil ? proffession! : "not available"
        
        attributedText.append(NSAttributedString(string: "\n\(proffessionString)", attributes: [.font : UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        
        // here we are making sure that we only put the images that the user has enterted
        var imageUrls = [String]()
        if let url = imageUrl1 {imageUrls.append(url)}
        if let url = imageUrl2 {imageUrls.append(url)}
        if let url = imageUrl3 {imageUrls.append(url)}
        
        
        return CardViewModel(imageNames: imageUrls, attributedString: attributedText, textAlignment: .left)
    }
    
}
