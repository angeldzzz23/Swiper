//
//  SettingsController.swift
//  TinderClone
//
//  Created by Angel Zambrano on 12/24/21.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage

class CustomImagePickerController: UIImagePickerController {
    var imageButton: UIButton?
    
}
// Get 

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
        tableView.keyboardDismissMode = .interactive
//        contentView.isUserInteractionEnabled = true
//        contentView.isUserInteractionEnabled = true
        
        fetchCurrentUser()
        
        tableView.isUserInteractionEnabled = true

    }
    
    var user: User?
    
    
    /// fetches a user from the firestore
    fileprivate func fetchCurrentUser() {
        // fetch some firesotre data
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Firestore.firestore().collection("users").document(uid).getDocument { snapchot, err in
            //check if there is an error
            if let err = err {
                print(err)
                return
            }
            
            // fech the user
            guard let dictionary = snapchot?.data() else {return}
            self.user = User(dictionary: dictionary)
            self.loadUserPhotos()
            
            self.tableView.reloadData()
        }
    }
    
    
    fileprivate func loadUserPhotos() {
        guard let imgUrl = user?.imageUrl1, let url = URL(string: imgUrl) else {return}
//        SDWebImageDownloader.shared().loadImage
        // SDWebImageManager makes it easier to load it in our cache 
        SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil, completed: {image,_,_,_,_,_ in
            
            self.image1Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            
            
        })
        
        
//        self.user?.imageUrl1
        
    }
    
    

    
    lazy var header: UIView = {
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
    }()
    
    //
    class HeaderLabel: UILabel {
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.insetBy(dx: 16, dy: 0))
        }
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     
        if section == 0 {
            return header
        }
        
        let headerLabel = HeaderLabel()
        headerLabel.text = "Name"
        
        switch section {
        case 1:
            headerLabel.text = "Name"
            
        case 2:
            headerLabel.text = "Proffession"
        case 3:
            headerLabel.text = "Age"
        default:
            headerLabel.text = "Bio"
        }
        
        return headerLabel
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SettingsCell(style: .default, reuseIdentifier: nil)
        
        switch indexPath.section {
        case 1:
            cell.textfield.placeholder = "Enter Name"
            cell.textfield.text = user?.name
        case 2:
            cell.textfield.placeholder = "Enter Proffession"
            cell.textfield.text = user?.proffession
        case 3:
            cell.textfield.placeholder = "Enter Age"
            if let age = user?.age {
                cell.textfield.text = String(age)
            }
        
        default:
            cell.textfield.placeholder = "Enter Bio"
            
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        
        
        
        return (section == 0) ? 0 :  1
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    //
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 300
        }
        
        return 40
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
