//
//  userDetailsController.swift
//  TinderClone
//
//  Created by Angel Zambrano on 12/29/21.
//

import UIKit
import SDWebImage

//  TODO: create a different viewModelobject for userDetails
class UserDetailsController: UIViewController, UIScrollViewDelegate {
    
    /// I modified the attributed text
    //  TODO: create a different viewModelobject for userDetails
    var cardViewModel: CardViewModel! {
        didSet {
            infoLabel.attributedText = cardViewModel.attributedString
            


            
        }
    }
    
    let swipingPhotosController = SwippingPhotosController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
//        sv.backgroundColor = .green
        sv.alwaysBounceVertical = true
        sv.contentInsetAdjustmentBehavior = .never // keeps underneath the safe area
        sv.delegate = self
        return sv
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
    
    
    lazy var dislikeButton = self.createButton(image: UIImage(named: "dismiss_circle")!, selector: #selector(handleDislike))
    lazy var superLikeButton = self.createButton(image: UIImage(named: "super_like_circle")!, selector: #selector(handleDislike))
    lazy var likeButton = self.createButton(image: UIImage(named: "like_circle")!, selector: #selector(handleDislike))

    

    
    
    
    /// deals with the dislike button
    @objc fileprivate func handleDislike() {
        print("Disliking!!!!")
    }
    
    
    
    
    
    /// this method is to create a button that has an imaged
    fileprivate func createButton(image: UIImage, selector: Selector)  -> UIButton{
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    
    fileprivate func setupLayout() {
        // adding the scroll view
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        
        
        let swipingView = swipingPhotosController.view!
        
        scrollView.addSubview(swipingView)
        
        swipingPhotosController.cardViewModel = cardViewModel
        
        
        // frame
        // autolayout doesnt act correctly in the frame
        
        scrollView.addSubview(infoLabel)
        infoLabel.anchor(top: swipingView.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(top: 16, left: 15, bottom: 0, right: 16))
        
        // adding the button
        scrollView.addSubview(dimissButton)
        dimissButton.anchor(top: swipingView.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: -25, left: 0, bottom: 0, right: 24), size: .init(width: 50, height: 50))
    }
    
    
    fileprivate let extraSwippingHeight: CGFloat = 80
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // setting the width and height of the paging view controller
        let swippingView = swipingPhotosController.view!
        swippingView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width + extraSwippingHeight)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        setupLayout()
        setupVisualBlurEffectView()
        setupButtonControls()
    }
    
    fileprivate func setupButtonControls() {
        let stackview = UIStackView(arrangedSubviews: [dislikeButton, superLikeButton,likeButton])
        stackview.distribution = .fillEqually
        view.addSubview(stackview)
        stackview.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 300, height: 80))
        stackview.spacing = -32
        stackview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    /// creating the visual effect
    fileprivate func setupVisualBlurEffectView() {
        // using visual effect
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        
        // adding a visual effect view
        view.addSubview(visualEffectView)
        visualEffectView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    
    
    // review this:
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let changeY = -scrollView.contentOffset.y
        var width = view.frame.width + changeY * 2
        let imageView = swipingPhotosController.view!
        width = max(view.frame.width, width) // what does this to?
        imageView.frame = CGRect(x: min(0, -changeY), y: min(0, -changeY), width: width  , height: width + extraSwippingHeight)
        
    
    }
    
    /// handles the tap dismiss method
    @objc func handleTapDismiss() {
        
        self.dismiss(animated: true)
    }
    
    
    
    
    

}
