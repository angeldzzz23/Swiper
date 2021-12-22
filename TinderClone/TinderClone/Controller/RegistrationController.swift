//
//  RegistrationController.swift
//  TinderClone
//
//  Created by Angel Zambrano on 12/21/21.
//

import UIKit

class RegistrationController: UIViewController {
    
    // MARK: UI components
    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 275).isActive = true
        button.layer.cornerRadius = 16
        
        return button
    }()
    
    let fullNameTextField: UITextField = {
       let tf = CustomTextfield(padding: 16)
        tf.placeholder = "enter full name"
        tf.backgroundColor = .white
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true

        return tf
    }()
    
    let emailTextField: UITextField = {
        let tf = CustomTextfield(padding: 16)
        tf.placeholder = "Enter Email"
        tf.backgroundColor = .white
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = CustomTextfield(padding: 16)
        tf.placeholder = "Enter password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = .white
        return tf
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupGradientLayer()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .red
        
        let stackView = UIStackView(arrangedSubviews: [
            selectPhotoButton, fullNameTextField, emailTextField, passwordTextField
        ])
        
        stackView.axis = . vertical
        stackView.spacing = 8
        view.addSubview(stackView)
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
    // adding gradient
    fileprivate func  setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        let topColor = #colorLiteral(red: 0.9826737046, green: 0.3377019167, blue: 0.3818222284, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8882574439, green: 0.1114654019, blue: 0.4571794271, alpha: 1)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0,1]
        view.layer.addSublayer(gradientLayer)
        
        gradientLayer.frame = view.bounds
    }
    
}
