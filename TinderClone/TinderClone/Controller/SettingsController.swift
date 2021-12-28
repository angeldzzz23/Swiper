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
     
        // uploading data
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Uploading image..."
        hud.show(in: view)
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        
        // we chose an arbitrary value
        guard let uploadData = selectedImage?.jpegData(compressionQuality: 0.75) else {return}
        
        ref.putData(uploadData, metadata: nil) { _, err in
           
            if let err = err {
                print("Failed to upload image to storage", err)
                return
            }
            print("Finished uploading image")
            // get the download url
            ref.downloadURL { url, err in
                hud.dismiss()
                if let err = err {
                    print("Failed to retrieve download URL:", err)
                    return
                }
                
                print("finished getting download url:", url?.absoluteURL ?? "")
                
                //update the correct button
                if imageButton == self.image1Button {
                    self.user?.imageUrl1 = url?.absoluteString
                } else if imageButton == self.image2Button {
                    self.user?.imageUrl2 = url?.absoluteString
                } else {
                    self.user?.imageUrl3 = url?.absoluteString
                

                }
              
                
            }
        }
        
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
    
    // TODO:
    fileprivate func loadUserPhotos() {
        if  let imgUrl = user?.imageUrl1, let url = URL(string: imgUrl)  {
//        SDWebImageDownloader.shared().loadImage
        // SDWebImageManager makes it easier to load it in our cache
        SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil, completed: {image,_,_,_,_,_ in
            self.image1Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            
        })
                
        }
        
        if  let imgUrl = user?.imageUrl2, let url = URL(string: imgUrl)  {
//        SDWebImageDownloader.shared().loadImage
        // SDWebImageManager makes it easier to load it in our cache
        SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil, completed: {image,_,_,_,_,_ in
            self.image2Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            
        })
                
        }
        
        if  let imgUrl = user?.imageUrl3, let url = URL(string: imgUrl)  {
//        SDWebImageDownloader.shared().loadImage
        // SDWebImageManager makes it easier to load it in our cache
        SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil, completed: {image,_,_,_,_,_ in
            self.image3Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            
        })
                
        }
        
                

        
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
            // handles every little change that happens
            cell.textfield.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
        case 2:
            cell.textfield.placeholder = "Enter Proffession"
            cell.textfield.text = user?.proffession
            cell.textfield.addTarget(self, action: #selector(handleProff), for: .editingChanged)
        case 3:
            cell.textfield.placeholder = "Enter Age"
            if let age = user?.age {
                cell.textfield.text = String(age)
            }
            cell.textfield.addTarget(self, action: #selector(handleAge), for: .editingChanged)
            
        default:
            cell.textfield.placeholder = "Enter Bio"
            
        }
        
        
        return cell
    }
    
    
    /// this is called every time the textfield changes
    @objc fileprivate func handleNameChange(textfield: UITextField) {
        self.user?.name = textfield.text
    }
    
    /// this is called every time the proffesion textfield changes
    @objc fileprivate func handleProff(textfield: UITextField) {
        self.user?.proffession = textfield.text
    }
    
    /// this is called every time the age textfield changes
    @objc fileprivate func handleAge(textfield: UITextField) {
        self.user?.age = Int(textfield.text ?? "")
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
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave)),
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleCancel))
        ]
    }
    
    
    /// the function that deals with saving
    /// also contains feed back hud to show when the data is done uploading
    @objc fileprivate func handleSave() {
        // persist the data
        guard let uid = Auth.auth().currentUser?.uid else {return }
        // hereteogeneous dictionary
        let docData: [String : Any] = [
            "uid" : uid,
            "fullname" : user?.name ?? "",
            "imageUrl1" : user?.imageUrl1 ?? "",
            "imageUrl2" : user?.imageUrl2 ?? "",
            "imageUrl3" : user?.imageUrl3 ?? "",
            "age" : user?.age ?? -1,
            "proffession": user?.proffession ?? ""
        ]
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving Settings"
        hud.show(in: view)
        
        // accessing the collection of users
        Firestore.firestore().collection("users").document(uid).setData(docData, merge: false) { err in
            hud.dismiss() // dimisses the the hud
            if let err = err { // checks if there was an error
                print("Failed to save user settings:", err)
                return
            }
            print("Finished saving user info")
        }
    
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true, completion: nil)
    }

}
