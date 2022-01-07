//
//  ViewController.swift
//  TinderClone
//
//  Created by Angel Zambrano on 12/20/21.
//

import UIKit
import Firebase
import JGProgressHUD // importing progress hud

class HomeController: UIViewController, SettingsControllerDelegate, LoginControllerDelegate, CardViewDelegate {
    
   

    
    
    // conforming to the LoginControllerDelegate
    func didFinishLoggingIn() {
        // it makes a call to firebase to get the users
     fetchCurrentUser()
    }
    
   
    
    // instance properties
    let topStackView = TopNavigationStackView()
    let cardDeckView = UIView()
    let buttonControlsStackView = HomeBottomControlsStackView()
    fileprivate let hud = JGProgressHUD(style: .dark)

    
    var cardViewModels = [CardViewModel]() // empty array
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // check if the user is logged out
        if Auth.auth().currentUser == nil {
            // kick the user out when they log out
            let registrationController = RegistrationController()
            registrationController.delegate = self
            let navControler = UINavigationController(rootViewController: registrationController)
            navControler.modalPresentationStyle = .fullScreen
            present(navControler, animated: true)
        }
        
       
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        
        buttonControlsStackView.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        
        buttonControlsStackView.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        buttonControlsStackView.dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        
        
        
        
        setupLayout()
        
        fetchCurrentUser()
        
//        setupFireStoreUserCards()
            
//        fetchUsersFromFirestore() //
        
    }

    
   
    
  
    
    fileprivate var user: User?
    
    /// gets the current user
    // TODO: Refactor this, so that we can use only one method =
    fileprivate func  fetchCurrentUser() {
        
        hud.textLabel.text = "Fetching users"
        hud.show(in: view)
        guard let uid = Auth.auth().currentUser?.uid else {return}
        cardDeckView.subviews.forEach({$0.removeFromSuperview()})
        Firestore.firestore().collection("users").document(uid).getDocument { snapchot, err in
            //check if there is an error
            if let err = err {
                print("Failed to fetch user:",err)
                return
            }
            
            // fech the user
            guard let dictionary = snapchot?.data() else {return}
            self.user = User(dictionary: dictionary)
            print("current user:", self.user)
            
            self.fetchSwipes()
//            self.fetchUsersFromFirestore()
        }
    }
    
    // blank dictionary
    var swipes = [String: Int]()
    
    fileprivate func fetchSwipes() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("swipes").document(uid).getDocument { snapshot, err in
            if let err = err {
                print("Failed to fetch swipes info for currently logged in user", err)
                return
            }
            print("Swipes:", snapshot?.data() ?? "")
            guard let data = snapshot?.data() as? [String: Int] else {return}
            self.swipes = data
            self.fetchUsersFromFirestore()
        }
    }
    
   
    
    @objc fileprivate func handleRefresh() {
        cardDeckView.subviews.forEach({$0.removeFromSuperview()})
        fetchUsersFromFirestore()
    }
    
    var lastFetchedUser: User?
    
    /// gets the users from the firestore
    /// uses paginagination
    fileprivate func fetchUsersFromFirestore() {
//        guard let minAge = user?.minSeekingAge, let maxAge = user?.maxSeekingAge else {
//            self.hud.dismiss()
//
//            return
//
//        }
        
        // this takes care of when a user doesnt have a minAge or maxAge 
        let minAge = user?.minSeekingAge ?? SettingsController.defaultMinSeekingAge
        let maxAge = user?.maxSeekingAge ?? SettingsController.defaultMaxSeekignAge
        
   
        // pagination to page through 2 users at a time
//        let limit = 2 // the limit of users that you want paginate
        // TODO: add pagination here
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge)
        
        topCardView = nil
        
         query.getDocuments { snapchot, err in
             self.hud.dismiss()
            if let err  = err { // if there was an error
                print("Failed to fetch users:", err)
                return
            }
             
             // we are going to set up the nextcardview realationship for all cards
             
             var previousCardView: CardView?
             
             
            // if everything was successful
            //query document sna is
            snapchot?.documents.forEach({ documentSnaphot in
                // setting up the users
                let userDictionary = documentSnaphot.data() // gets the user dictionaries
                let user = User(dictionary: userDictionary) // creating a new user
                let isNotCurrentUser = user.uid != Auth.auth().currentUser?.uid
//                let hasNotSwipedBefore = self.swipes[user.uid!] == nil
                let hasNotSwipedBefore = true // this should show us all of our cards in our screen
                
                if isNotCurrentUser && hasNotSwipedBefore {
                    let cardView = self.setupCardFromUser(user: user)
                    previousCardView?.nextCardView = cardView
                    previousCardView = cardView
                    //
                    if self.topCardView == nil {
                        self.topCardView = cardView
                    }
                }
                
//                self.cardViewModels.append(user.toCardViewModel()) // setting up our cards
//                self.lastFetchedUser = user // getting the last fetched user
            })
//            self.setupFireStoreUserCards()
            
        }
    }
    
    
    var topCardView: CardView?
    
    // here is a linked list
    
    /// deals with the like button being pressed
    @objc  func handleLike() {
        // save info to firestore
        saveSwipeToFirestore(didLike: 1)
        
       performSwipeAnimation(translation: 700, angle: 15)
    }
    
    /// deals for when the user presses the dislike button
    @objc func handleDislike() {
        saveSwipeToFirestore(didLike: 0)
        performSwipeAnimation(translation: -700, angle: -15)
        
    }
    
    fileprivate func saveSwipeToFirestore(didLike: Int) {
        // get the current user id
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let cardUID = topCardView?.cardViewModel.uid else {return}
        
        
        if didLike == 1 {
            checkIfMatchExists(cardUID: cardUID)
        }
        
        // use the id that we are swiping for
        let documentData = [cardUID: didLike]
        
        // check if it exists
        Firestore.firestore().collection("swipes").document(uid).getDocument { snapShot, err in
            if let err = err {
                print("failed to fetch swipe doucment:", err)
                return
            }
            // updating the snapshot
            if snapShot?.exists == true {
                Firestore.firestore().collection("swipes").document(uid).updateData(documentData) { err in
                    if let err =  err {
                        print("Failed to save swipe data", err)
                        return
                    }
                    
                    print("Successfully updaed swipes....")
                }
            } else {
                Firestore.firestore().collection("swipes").document(uid).setData(documentData, merge: true) { error in
                    if let error = error {
                        print("Failed to save swipe data", error)
                        return
                    }

                    print("Successfully saved swipe....")
                }
            }
        }
  
    }
    
    fileprivate func checkIfMatchExists(cardUID: String) {
        // how to detect our match between two users?
        print("Dectecting match")
        
        Firestore.firestore().collection("swipes").document(cardUID).getDocument { snapshot, err in
            if let err = err {
                print("failed to fetch document for card user:", err)
                return
            }
            guard let data = snapshot?.data() else {return}
            print(data)
            
            guard let uid = Auth.auth().currentUser?.uid else {return}
            
            let hasMatched = data[uid] as? Int == 1
            
            if hasMatched {
                print("has matched")
                self.presentMatchView(cardUID: cardUID)
              
            }
        }
    }
    
    /// presents a view whenvever there is a match
    fileprivate func presentMatchView(cardUID: String) {
        let matchView = MatchView()
        view.addSubview(matchView)
        matchView.fillSuperview()
    }
    
    
    
    fileprivate func performSwipeAnimation(translation: CGFloat, angle: CGFloat) {
        let duration = 0.5
        // using a CA basic animation
        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        translationAnimation.toValue = translation
        translationAnimation.duration = duration
        translationAnimation.fillMode = .forwards
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        translationAnimation.isRemovedOnCompletion = false
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = angle * CGFloat.pi / 180
        rotationAnimation.duration = duration
        
        
        let cardView = topCardView
        topCardView = cardView?.nextCardView
        
        CATransaction.setCompletionBlock {
            cardView?.removeFromSuperview()
            
        }
        
        cardView?.layer.add(translationAnimation, forKey: "translation")
        cardView?.layer.add(rotationAnimation, forKey: "rotation")
        
        CATransaction.commit()
    }
    
    
    // conforming to the delegate
    func didRemoveCard(cardView: CardView) {
        self.topCardView?.removeFromSuperview()
        self.topCardView = self.topCardView?.nextCardView
    }
    
    
    fileprivate func setupCardFromUser(user: User) -> CardView {
        let cardView = CardView(frame: .zero) // this is just a rect with 0, 0, doesnt matter since we are using autolayout
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardDeckView.addSubview(cardView)
        cardDeckView.sendSubviewToBack(cardView) // what does this do?
        cardView.fillSuperview()
        return cardView
    }
    
    /// conforming CardView Delegate
    /// , protocola delagate method
    func didTapMoreInfo(cardViewmode: CardViewModel) {
        print("home controller:", cardViewmode.attributedString)
        let userDetailsController = UserDetailsController()
        userDetailsController.cardViewModel = cardViewmode
        userDetailsController.modalPresentationStyle = .fullScreen
        present(userDetailsController, animated: true)
    }
    
    
    @objc func handleSettings() {
        let settingsnController = SettingsController()
        settingsnController.delegate = self
        let navController = UINavigationController(rootViewController: settingsnController)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
        
    }
    
    /// is called whenever Settings controller is dismissed
    func didSaveSettings() {
        fetchCurrentUser()
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

