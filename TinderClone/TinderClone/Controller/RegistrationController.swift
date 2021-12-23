//
//  RegistrationController.swift
//  TinderClone
//
//  Created by Angel Zambrano on 12/21/21.
//

import UIKit
import Firebase
import JGProgressHUD
import JGProgressHUD

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
        constraint.priority = UILayoutPriority(999)
        constraint.isActive = true
        
        button.layer.cornerRadius = 16
        
        // adding tartget
        button.addTarget(self, action: #selector(handleSelectButton), for: .touchUpInside)
        
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        return button
    }()
    
    // handles the select photo butto
    @objc func handleSelectButton() {
        print("select photo")
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    let RegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.setTitleColor(.white, for: .normal)
//        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        // adding constraint
        let constraint = button.heightAnchor.constraint(equalToConstant: 50)
        constraint.priority = UILayoutPriority(999)
        constraint.isActive = true
        
        button.layer.cornerRadius = 25
//        button.backgroundColor =  #colorLiteral(red: 0.8074133396, green: 0.1035810784, blue: 0.3270690441, alpha: 1)
        // making the button look disabled
        button.backgroundColor =  .lightGray
        button.setTitleColor(.gray, for: .disabled)
        button.isEnabled = false
        
        // add target action handling
        button.addTarget(self, action: #selector(handleTapButton), for: .touchUpInside)
        

        return button
    }()
    
    let registeringHUD = JGProgressHUD(style: .dark)
    // 4373
    @objc fileprivate func handleTapButton() {
        // dismisses the keyboard
        self.handleTapDismiss()
        
        registrationViewModel.bindableIsResgistering.value = true
        
        registrationViewModel.performRegistration { [weak self]err in
            if let err = err {
                self?.showHUDWithError(error: err)
                return
            }
        }
        
        print("Finishewd registering out user")
        
        
        
        
       
    }
    
    fileprivate func showHUDWithError(error: Error) {
        registeringHUD.dismiss()
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed Registration"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4) // dimisses after four seconds
    }
    
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
        
        registrationViewModel.bindableIsFormValid.bind { [unowned self] isFormValid in
            
            guard let isFormValid = isFormValid else {return}
            
            self.RegisterButton.isEnabled = isFormValid
            if isFormValid {
                self.RegisterButton.backgroundColor = #colorLiteral(red: 0.8074133396, green: 0.1035810784, blue: 0.3270690441, alpha: 1)
                self.RegisterButton.setTitleColor(.white, for: .normal)
            } else {
                self.RegisterButton.backgroundColor = .lightGray
                self.RegisterButton.setTitleColor(.gray, for: .normal)
            }
        }
        
        registrationViewModel.bindableImage.bind { [unowned self] img in
            self.selectPhotoButton.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        registrationViewModel.bindableIsResgistering.bind { [unowned self] isRegistering in
            // registering
            if isRegistering == true {
                self.registeringHUD.textLabel.text = "Registering"
                self.registeringHUD.show(in: self.view)
            } else {
                self.registeringHUD.dismiss()
            }
        }
        
        
        // avoiding the reain cycle
        // updates the registration model
//        registrationViewModel.isFormValidObserver = { [unowned self] (isFormValid) in
//                print("form is changing, is it valid", isFormValid)
//
//                // TODO: clean up here
//                self.RegisterButton.isEnabled = isFormValid
//                if isFormValid {
//                    self.RegisterButton.backgroundColor = #colorLiteral(red: 0.8074133396, green: 0.1035810784, blue: 0.3270690441, alpha: 1)
//                    self.RegisterButton.setTitleColor(.white, for: .normal)
//                } else {
//                    self.RegisterButton.backgroundColor = .lightGray
//                    self.RegisterButton.setTitleColor(.gray, for: .normal)
//                }
//        }
        
        // registration view is now able to track with the actual registration

        
        // updates the image observer
//        registrationViewModel.imageObsever = { [unowned self] img in
//            self.selectPhotoButton.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
//
//        }
        
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
//        NotificationCenter.default.removeObserver(self) // can cause a retain cycle, doing this latter
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


// delegate extensions for the image picker
extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true) // dimisses the picker
    }
    
    // the info parameter is the dictionary that maps to an any object
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage // gets the image from the picker view
        registrationViewModel.bindableImage.value = image
        
        dismiss(animated: true, completion: nil)
    }
}
