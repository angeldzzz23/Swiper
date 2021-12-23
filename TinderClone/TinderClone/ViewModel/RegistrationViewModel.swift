//
//  RegistrationViewModel.swift
//  TinderClone
//
//  Created by Angel Zambrano on 12/22/21.
//

import UIKit

// capturing the state of the form
// this reflects everything that is happening in our form
class RegistrationViewModel {
    // the image

    var bindableImage = Bindable<UIImage>()
    
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
    
    // Reactive Programming
    // this is called whenever we modify the state of our form

    var bindableIsFormValid = Bindable<Bool>()
    
    //    var isFormValidObserver: ((Bool) -> ())?
    
    
}


