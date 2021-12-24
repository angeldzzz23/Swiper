//
//  ViewController.swift
//  TinderClone
//
//  Created by Angel Zambrano on 12/20/21.
//

import UIKit
import Firebase
import JGProgressHUD // importing progress hud

class HomeController: UIViewController {
    
    // instance properties
    let topStackView = TopNavigationStackView()
    let cardDeckView = UIView()
    let buttonControlsStackView = HomeBottomControlsStackView()
    
    
    var cardViewModels = [CardViewModel]() // empty array
    
    
    
    
        
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        
        buttonControlsStackView.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        
        setupLayout()
        setupFireStoreUserCards()
            
        fetchUsersFromFirestore()
        
    }
    
    //
    @objc fileprivate func handleRefresh() {
        fetchUsersFromFirestore()
    }
    
    var lastFetchedUser: User?
    
    /// gets the users from the firestore
    fileprivate func fetchUsersFromFirestore() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching users"
        hud.show(in: view)
        // pagination to page through 2 users at a time
        let limit = 2 // the limit of users that you want paginate
        let query = Firestore.firestore().collection("users").order(by: "uid").start(after: [lastFetchedUser?.uid ?? ""]).limit(to: limit)
        
        
         query.getDocuments { snapchot, err in
             hud.dismiss()
            if let err  = err { // if there was an error
                print("Failed to fetch users:", err)
                return
            }
            // if everything was successful
            //query document sna is
            snapchot?.documents.forEach({ documentSnaphot in
                let userDictionary = documentSnaphot.data() // gets the user dictionaries
                let user = User(dictionary: userDictionary) // creating a new user
                self.cardViewModels.append(user.toCardViewModel()) // setting up our cards
                self.lastFetchedUser = user // getting the last fetched user
                self.setupCardFromUser(user: user)
            })
//            self.setupFireStoreUserCards()
            
        }
    }
    
    fileprivate func setupCardFromUser(user: User) {
        let cardView = CardView(frame: .zero) // this is just a rect with 0, 0, doesnt matter since we are using autolayout
        cardView.cardViewModel = user.toCardViewModel()
        cardDeckView.addSubview(cardView)
        cardDeckView.sendSubviewToBack(cardView) // what does this do?
        cardView.fillSuperview()
    }
    
    
    
    @objc func handleSettings() {
        let settingsnController = SettingsController()
        let navController = UINavigationController(rootViewController: settingsnController)
        present(navController, animated: true)
        
    }
    
    
    
    fileprivate func setupFireStoreUserCards()  {
        
        cardViewModels.forEach { cardVM in
            let cardView = CardView(frame: .zero) // this is just a rect with 0, 0, doesnt matter since we are using autolayout
            cardView.cardViewModel = cardVM
            cardDeckView.addSubview(cardView)
            cardView.fillSuperview()
            
        }
        
        
        
        
    
    }
    
    // MARK: setting up the layout
    fileprivate func setupLayout() {
        // setting up the background of our view
        view.backgroundColor = .white // setting the
        
        // this is the main stackview
        let overallStackView  = UIStackView(arrangedSubviews: [topStackView, cardDeckView,buttonControlsStackView])
        
        
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

