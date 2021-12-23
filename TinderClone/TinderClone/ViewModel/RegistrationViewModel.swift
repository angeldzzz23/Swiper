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
    
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
//        isFormValidObserver?(isFormValid)
        bindableIsFormValid.value = isFormValid
    }
    
    
    func performRegistration(completion: @escaping (Error?) -> ()) {
        
        guard let email = email, let pass = password else {return}
        bindableIsResgistering.value = true
        // adding user to firebase
        Auth.auth().createUser(withEmail: email, password: pass) { res, err in
            if let err = err {
//                print(err)
                completion(err)
//                self.showHUDWithError(error: err)
                return
            }
            
            print("user was registered", res?.user.uid ?? "")
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
                })
            })
            
        }
    }
    
    // Reactive Programming
    // this is called whenever we modify the state of our form

   
    
}


