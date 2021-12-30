//
//  userDetailsController.swift
//  TinderClone
//
//  Created by Angel Zambrano on 12/29/21.
//

import UIKit
import SDWebImage

class UserDetailsController: UIViewController, UIScrollViewDelegate {
    
    /// I modified the attributed text
    //  TODO: create a different viewModelobject for userDetails
    var cardViewModel: CardViewModel! {
        didSet {
            infoLabel.attributedText = cardViewModel.attributedString
            
            guard let firstImageUrl = cardViewModel.imageUrls.first, let url = URL(string: firstImageUrl) else {return}
            imageView.sd_setImage(with: url)

            
        }
    }
    
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
//        sv.backgroundColor = .green
        sv.alwaysBounceVertical = true
        sv.contentInsetAdjustmentBehavior = .never // keeps underneath the safe area
        sv.delegate = self
        return sv
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "lady4c"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "User name 30\nDoctor\nSome bio text down belo"
        label.numberOfLines = 0
        return label
    }()
    
    
    let dimissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "dismiss_down_arrow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleTapDismiss), for: .touchUpInside)
        return button
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        // adding the scroll view
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        
        scrollView.addSubview(imageView)
        
        
        // frame
        // autolayout doesnt act correctly in the frame
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
    
        scrollView.addSubview(infoLabel)
        infoLabel.anchor(top: imageView.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(top: 16, left: 15, bottom: 0, right: 16))
        
        // adding the button
        scrollView.addSubview(dimissButton)
        dimissButton.anchor(top: imageView.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: -25, left: 0, bottom: 0, right: 24), size: .init(width: 50, height: 50))
        
    }
    
    
    // review this:
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let changeY = -scrollView.contentOffset.y
        var width = view.frame.width + changeY * 2
        
     
        width = max(view.frame.width, width) // what does this to?
        imageView.frame = CGRect(x: min(0, -changeY), y: min(0, -changeY), width: width  , height: width)
        
    
    }
    
    /// handles the tap dismiss method
    @objc func handleTapDismiss() {
        
        self.dismiss(animated: true)
    }
    
    
    
    
    

}
