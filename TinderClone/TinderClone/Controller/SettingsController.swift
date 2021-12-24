//
//  SettingsController.swift
//  TinderClone
//
//  Created by Angel Zambrano on 12/24/21.
//

import UIKit

class CustomImagePickerController: UIImagePickerController {
    var imageButton: UIButton?
    
}

// extensiton to our imageopicker

extension SettingsController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImage = info[.originalImage] as? UIImage // getting our selected image
        let imageButton = (picker as? CustomImagePickerController)?.imageButton // getting our image button
        
        imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal) // setting the imageButton
         
        dismiss(animated: true) // dismissing the image picker after our selecting
        
    }
}

//extension SettingsController:

class SettingsController: UITableViewController, UINavigationControllerDelegate {

    // instance properties for three buttons
    lazy var image1Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image2Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image3Button = createButton(selector: #selector(handleSelectPhoto))

    
    // here we create our handler for our buttons
    // we present an imagePicker and set the imageButon as the image selected on the image pickerview
    @objc func handleSelectPhoto(button: UIButton) {
        print("select photo with button", button)
        let imagePicker = CustomImagePickerController() // creating our imagePicker
        imagePicker.delegate = self // setting it's delegate to self
        imagePicker.imageButton = button // setting our imagepickerButton to our button
        present(imagePicker, animated: true) // presenting our imagePicker
    }
    
  
    // creating a button
    
    func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView() // gets ride of horizontal lines
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .blue
        
        // creading the imagebutton that will lay on the left side
        header.addSubview(image1Button)
        let padding: CGFloat = 16
        image1Button.anchor(top: header.topAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: nil, padding: .init(top: padding, left: padding, bottom: padding, right: 0))
        
        // using a multiplier
        image1Button.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
        
        // setting the stack view that will be on the right size
        let stackView = UIStackView(arrangedSubviews: [image2Button, image3Button])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = padding
        
        header.addSubview(stackView)
        stackView.anchor(top: header.topAnchor, leading: image1Button.trailingAnchor, bottom: header.bottomAnchor, trailing: header.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
    
        
        
        
        return header
    }
    
    //
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    
    fileprivate func setupNavigationItem() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true // gives it a large title
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleCancel)),
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleCancel))
        ]
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true, completion: nil)
    }

}
