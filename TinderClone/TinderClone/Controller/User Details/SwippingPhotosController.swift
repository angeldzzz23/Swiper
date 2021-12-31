//
//  SwippingPhotosController.swift
//  TinderClone
//
//  Created by Angel Zambrano on 12/30/21.
//

import UIKit

class SwippingPhotosController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    
    var cardViewModel: CardViewModel! {
        didSet {
            controllers = cardViewModel.imageUrls.map({ (imgUrl) -> UIViewController in
                let photoController = PhotoController(imageUrl: imgUrl)
                return photoController
            })
            
            setViewControllers([controllers.first!], direction: .forward, animated: false)
            setupBarViews()
        }
    }
    
    fileprivate let barStackView = UIStackView(arrangedSubviews: [])
    fileprivate let deselectedBarColor = UIColor(white: 0, alpha: 0.1)
    
    /// sets up the bar views
    fileprivate func setupBarViews() {
        
        
        // acceccing the img url array and creating a bar view for each image
        cardViewModel.imageUrls.forEach { (_) in
            let barView = UIView()
            barView.backgroundColor = deselectedBarColor // make sure tha all of them are deselected
            barView.layer.cornerRadius = 2
            barStackView.addArrangedSubview(barView)
        }
        // making the first barView white
        barStackView.arrangedSubviews.first?.backgroundColor = .white
        
        barStackView.spacing = 4
        barStackView.distribution = .fillEqually
        
        // adding the stackview
        //
        view.addSubview(barStackView)
            
//        let paddingTop = UIWindowScene.statusmana
        // setting up the constraints of the stackview
//        barStackView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
    }
    
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // adding the extra padding to the top 
        let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let paddingTop = statusBarHeight + 8
        barStackView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: paddingTop, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
    }
    
    // this is called right after we finish our swipe right
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        // accessing the first controller
        let currentPhotoController =  viewControllers?.first
        
        if let index = controllers.firstIndex(where: {$0 == currentPhotoController}) {

            // deselect all of the bar views
            barStackView.arrangedSubviews.forEach({$0.backgroundColor = deselectedBarColor})
            // select the barview with the index
            barStackView.arrangedSubviews[index].backgroundColor = .white
        }
        
    }
    
    var controllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        delegate = self
        dataSource = self

    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? -1 // get the index
        if index == controllers.count - 1 {return nil} // stops at the end
        return controllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0
        
        if index == 0 {return nil}
        
        return controllers[index - 1]
        
        
    }
    
}

class PhotoController: UIViewController {
    let imageView = UIImageView(image: UIImage(named: "lady5c"))
    
    
    // an initialzier with a url
    init(imageUrl: String) {
       
        if let url = URL(string: imageUrl) {
            imageView.sd_setImage(with: url)
        }
        // when makaing your own initializers
        super.init(nibName: nil, bundle: nil)
    }
    
    
  
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        imageView.fillSuperview()
        imageView.contentMode = .scaleAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
