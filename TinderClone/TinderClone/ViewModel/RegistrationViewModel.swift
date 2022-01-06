//
//  RegistrationViewModel.swift
//  TinderClone
//
//  Created by Angel Zambrano on 12/22/21.
//

import UIKit
import Firebase

// capturing the state of the form
// this reflects everything that is happening in our form
class RegistrationViewModel {
    // the image

    var bindableIsResgistering = Bindable<Bool>() //
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValid = Bindable<Bool>()
//    var image: UIImage? {
//        didSet {
//            imageObsever?(image)
//        }
//    }
    
    // 
    var imageObsever: ((UIImage?) -> () )?
    
    var fullName: String? {
        didSet {
            checkFormValidity()
        }
    }
    // email
    var email: String? {didSet{ checkFormValidity() }}
    // form
    var password: String?  {didSet{ checkFormValidity() }}
    
    
     func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false &&  bindableImage.value != nil
//        isFormValidObserver?(isFormValid)
        bindableIsFormValid.value = isFormValid
    }
    
    // when we call this
    func performRegistration(completion: @escaping (Error?) -> ()) {
        
        guard let email = email, let pass = password else {return}
        bindableIsResgistering.value = true
        
        // adding user to firebase
        Auth.auth().createUser(withEmail: email, password: pass) { res, err in // create user
            if let err = err { // check for error
//                print(err)
                completion(err)
//                self.showHUDWithError(error: err)
                return
            }
            
            print("user was registered", res?.user.uid ?? "")
            
            // save image to firebase
            self.saveImageToFirebase(completion: completion)
            
        }
    }
    
    //
    fileprivate func saveImageToFirebase(completion: @escaping (Error?) -> ()) {
        // only upload images to firebase storage once you are authorized
        let fileName = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(fileName)")
        let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
        
        ref.putData(imageData, metadata: nil, completion: {(_, err) in
            
            if let err = err {
                completion(err)
//                    self.showHUDWithError(error: err)
                return
            }
            print("finished uploading image to storage ")
            
            // checks the download url
            // retrieving the url
            ref.downloadURL(completion: {(url, err) in
                if let err = err {
                    completion(err)
//                        self.showHUDWithError(error: err)
                    return
                }
                
                self.bindableIsResgistering.value = false
                print("download url of our image:", url?.absoluteString ?? "")
                // store the download url into firesotr next lesson
                let imgUrl = url?.absoluteString ?? ""
                self.saveInfoToFirestore(imageUrl: imgUrl, completion: completion)
                completion(nil)
            })
        })
    }
    
    /// savin the info to the firestore
    fileprivate func saveInfoToFirestore(imageUrl: String, completion: @escaping (Error?) ->()) {
        let uid = Auth.auth().currentUser?.uid ?? ""
        let docData: [String : Any] = ["fullname": fullName ?? "",
                       "uid": uid,
                       "imageUrl1": imageUrl,
                       "Age": 18,
                       "minSeekingAge": SettingsController.defaultMinSeekingAge,
                       "maxSeekingAge": SettingsController.defaultMinSeekingAge
                       
        ]
            Firestore.firestore().collection("users").document(uid).setData(docData) { err in
            if let error = err {
                completion(error)
                return
            }
            
            completion(nil) // everuthing finished correctly
        }
    }
    // Reactive Programming
    // this is called whenever we modify the state of our form

   
    
}


