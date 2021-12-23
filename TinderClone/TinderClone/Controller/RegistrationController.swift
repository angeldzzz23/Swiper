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
//        button.heightAnchor.constraint(equalToConstant: 275).isActive = true
        
        let constraint = button.heightAnchor.constraint(equalToConstant: 275)
        constraint.priority = UILayoutPriority(1000)
        constraint.isActive = true
        
        
        button.layer.cornerRadius = 16
        return button
    }()
    
    let RegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.setTitleColor(.white, for: .normal)
//        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let constraint = button.heightAnchor.constraint(equalToConstant: 50)
        constraint.priority = UILayoutPriority(999)
        constraint.isActive = true
        
        button.layer.cornerRadius = 25
//        button.backgroundColor =  #colorLiteral(red: 0.8074133396, green: 0.1035810784, blue: 0.3270690441, alpha: 1)
        // making the button look disabled
        button.backgroundColor =  .lightGray
        button.setTitleColor(.gray, for: .disabled)
        button.isEnabled = false

        return button
    }()
    
    let fullNameTextField: UITextField = {
       let tf = CustomTextfield(padding: 16)
        tf.placeholder = "enter full name"
        tf.backgroundColor = .white
//        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        let constraint = tf.heightAnchor.constraint(equalToConstant: 50)
        constraint.priority = UILayoutPriority(999)
        constraint.isActive = true
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)

        return tf
    }()
    
    
    @objc fileprivate func handleTextChange(textfield: UITextField) {
        if textfield == fullNameTextField {
            registrationViewModel.fullName = textfield.text
        } else if textfield == emailTextField {
            registrationViewModel.email = textfield.text
        } else { // this is the password textfield
            registrationViewModel.password = textfield.text
        }
        
        
    }
    
    let emailTextField: UITextField = {
        let tf = CustomTextfield(padding: 16)
        tf.placeholder = "Enter Email"
        tf.backgroundColor = .white
//        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        let constraint = tf.heightAnchor.constraint(equalToConstant: 50)
        constraint.priority = UILayoutPriority(999)
        constraint.isActive = true

        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)

        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = CustomTextfield(padding: 16)
        tf.placeholder = "Enter password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = .white
//        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        let constraint = tf.heightAnchor.constraint(equalToConstant: 50)
        constraint.priority = UILayoutPriority(999)
        constraint.isActive = true
        
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)


        return tf
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupGradientLayer()
        
        setupLayout()
        setUpNotificationObservers()
        setupTapGesture()
        setupRegistrationViewModelObserver()
        
    }
    
    let registrationViewModel = RegistrationViewModel()
    
    fileprivate func setupRegistrationViewModelObserver()  {
        
        // avoiding the reain cycle
        registrationViewModel.isFormValidObserver = { [unowned self](isFormValid) in
                print("form is changing, is it valid", isFormValid)
            
                // TODO: clean up here
                self.RegisterButton.isEnabled = isFormValid
                if isFormValid {
                    self.RegisterButton.backgroundColor = #colorLiteral(red: 0.8074133396, green: 0.1035810784, blue: 0.3270690441, alpha: 1)
                    self.RegisterButton.setTitleColor(.white, for: .normal)
                } else {
                    self.RegisterButton.backgroundColor = .lightGray
                    self.RegisterButton.setTitleColor(.gray, for: .normal)
                }
            
        }
        
        
        
    }
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        
    }
    
    @objc func handleTapDismiss() {
        self.view.endEditing(true) // dismiss keyboard
        // adding animate method
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.view.transform = .identity
        }
    
    }
    
    
    
    fileprivate func setUpNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self) // can cause a retain cycle
    }
    
    
    // handles the handling of when a keyboard hides
    @objc fileprivate func  handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.view.transform = .identity
        }
    }
    
    //
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        print("kehyboard will show.")
        // getting the height of the keyboard
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardFrame = value.cgRectValue
        
        // how tall the gap is from the register button to the bottom of the screen
        // the height of the view
        let bottomSpace = view.frame.height - pverallStackView.frame.origin.y - pverallStackView.frame.height
        
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8) // adds some padding to this

        
        
    }
    
    let gradientLayer = CAGradientLayer()
    
    
    // redraws elements in the view controller
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        gradientLayer.frame = view.bounds
    }
    
    // MARK: Helper functions
    // adding gradient
    fileprivate func  setupGradientLayer() {
        let topColor = #colorLiteral(red: 0.9826737046, green: 0.3377019167, blue: 0.3818222284, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8882574439, green: 0.1114654019, blue: 0.4571794271, alpha: 1)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0,1]
        view.layer.addSublayer(gradientLayer)
        
        gradientLayer.frame = view.bounds
    }
    
    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [ fullNameTextField,
                                                 emailTextField,
                                                 passwordTextField,
                                                 RegisterButton])
          
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    
    
    
    // variable is created after the selectPhotoButton and other variables are compiled
    lazy var pverallStackView = UIStackView(arrangedSubviews: [
        selectPhotoButton,
        verticalStackView
    ])
        
    // checks if if the trait collection changed
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.verticalSizeClass == .compact {
            pverallStackView.axis = .horizontal
            
        } else {
            pverallStackView.axis = .vertical
            
        }
    }
                                            
    
    fileprivate func setupLayout() {
        // Do any additional setup after loading the view.
        
        view.addSubview(pverallStackView)
    
        
    
        pverallStackView.axis = .vertical
        pverallStackView.spacing = 8
        
        let constraint =  selectPhotoButton.widthAnchor.constraint(equalToConstant: 275)
        constraint.priority = UILayoutPriority(999)
        constraint.isActive = true
        // The error happens whenever I add this line of code
//        selectPhotoButton.widthAnchor.constraint(equalToConstant: 275).isActive = true
     
        pverallStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        pverallStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
