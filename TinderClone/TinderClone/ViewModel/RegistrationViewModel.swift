//
//  RegistrationViewModel.swift
//  TinderClone
//
//  Created by Angel Zambrano on 12/22/21.
//

import UIKit

// capturing the state of the form
class RegistrationViewModel {
    
    var fullName: String? {
        didSet {
            checkFormValidity()
        }
    }
    var email: String? {didSet{ checkFormValidity() }}
    var password: String?  {didSet{ checkFormValidity() }}
    
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        isFormValidObserver?(isFormValid)
    }
    
    // Reactive Programming
    // this is called whenever we modify the state of our form
    var isFormValidObserver: ((Bool) -> ())?
    
    
}


