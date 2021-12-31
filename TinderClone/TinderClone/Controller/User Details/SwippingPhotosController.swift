//
//  SwippingPhotosController.swift
//  TinderClone
//
//  Created by Angel Zambrano on 12/30/21.
//

import UIKit

class SwippingPhotosController: UIPageViewController, UIPageViewControllerDataSource {

    var cardViewModel: CardViewModel! {
        didSet {
            controllers = cardViewModel.imageUrls.map({ (imgUrl) -> UIViewController in
                let photoController = PhotoController(imageUrl: imgUrl)
                return photoController
            })
            
            setViewControllers([controllers.first!], direction: .forward, animated: false)
        }
    }
    
    var controllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
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
