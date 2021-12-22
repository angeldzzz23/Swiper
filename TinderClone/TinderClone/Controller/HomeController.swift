//
//  ViewController.swift
//  TinderClone
//
//  Created by Angel Zambrano on 12/20/21.
//

import UIKit

class HomeController: UIViewController {
    
    // instance properties
    let topStackView = TopNavigationStackView()
    let cardDeckView = UIView()
    let buttonStackView = HomeBottomControlsStackView()
    

    // closure that maps every produces to call cardViewModel methodb
    let cardViewModels: [CardViewModel] = {
        let producers =
            [
                User(name: "Angel", age: 22, proffession: "Coffee Drinker", imageNames: ["kelly1", "kelly2", "kelly3"]),
                Advertiser(title: "MCDIES", brandName: "I am hungry, food!!! food!!", posterPhotoName: "mcdonalds_print_aotw"),
                User(name: "Jane", age: 18, proffession: "Teacher", imageNames: ["jane1", "jane2", "jane3"])
            ] as [ProducesCardViewModel]
        
        let viewModels = producers.map({return $0.toCardViewModel()})
        
        return viewModels
        
        
    }()
        
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        
        setupLayout()
        setupDummyCards()
        
    }
    
    
    
    @objc func handleSettings() {
        print("show registration page")
        let registrationController = RegistrationController()
        
        present(registrationController, animated: true)
        
    }
    
    
    
    fileprivate func setupDummyCards()  {
        
        cardViewModels.forEach { cardVM in
            let cardView = CardView(frame: .zero) // this is just a rect with 0, 0, doesnt matter since we are using autolayout
            cardView.cardViewModel = cardVM
            cardDeckView.addSubview(cardView)
            cardView.fillSuperview()
            
        }
        
        
        
        
    
    }
    
    // MARK: setting up the layout
    fileprivate func setupLayout() {
        
        let overallStackView  = UIStackView(arrangedSubviews: [topStackView, cardDeckView,buttonStackView])
        
        overallStackView.axis = .vertical // makes it spand in the vertical axis
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        // adding margins to the left and right side of the stack view
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        // changing the z index for cardDeckView
        overallStackView.bringSubviewToFront(cardDeckView)
    }


}

