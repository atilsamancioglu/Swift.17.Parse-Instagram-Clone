//
//  SecondViewController.swift
//  Parse Instagram Clone
//
//  Created by Atıl Samancıoğlu on 06/02/2017.
//  Copyright © 2017 Atıl Samancıoğlu. All rights reserved.
//

import UIKit
import Parse

class uploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var postCommentText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //hiding keyboard
        
        let hideKeyboardGR = UITapGestureRecognizer(target: self, action: #selector(uploadVC.hideKeyboard))
        self.view.addGestureRecognizer(hideKeyboardGR)
        
        // choosing an image

        postImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(uploadVC.selectImage))
        postImage.addGestureRecognizer(gestureRecognizer)
        
        uploadButton.isEnabled = false
        
    }
    
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func selectImage() {
        //selecting an image
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        postImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        uploadButton.isEnabled = true
        
    }
    


    @IBAction func uploadButtonClicked(_ sender: Any) {
        
        uploadButton.isEnabled = false
        
        let object = PFObject(className: "Posts")
        
        let data = UIImageJPEGRepresentation(postImage.image!, 0.5)
        let pfImage = PFFile(name: "image.jpg", data: data!)
        
        object["postimage"] = pfImage
        object["postcomment"] = postCommentText.text
        object["postowner"] = PFUser.current()!.username!
        
        let uuid = UUID().uuidString
        
        object["postuuid"] = "\(uuid) \(PFUser.current()!.username!)"
        
        object.saveInBackground { (success, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let button = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(button)
                self.present(alert, animated: true, completion: nil)
            
            } else {
                
                self.postCommentText.text = ""
                self.postImage.image = UIImage(named: "tapmegreen.png")
                self.tabBarController?.selectedIndex = 0
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newUpload"), object: nil)
                
            }
        }
        
        
    }

}

