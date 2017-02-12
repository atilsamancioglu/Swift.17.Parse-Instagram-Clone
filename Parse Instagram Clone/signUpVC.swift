//
//  signUpVC.swift
//  Parse Instagram Clone
//
//  Created by Atıl Samancıoğlu on 06/02/2017.
//  Copyright © 2017 Atıl Samancıoğlu. All rights reserved.
//

import UIKit
import Parse

class signUpVC: UIViewController {

    @IBOutlet weak var userNameText: UITextField!
    
    
    @IBOutlet weak var passwordText: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    
    @IBAction func signInButtonClicked(_ sender: Any) {
        
        if userNameText.text != "" {
            if passwordText.text != "" {
                
                PFUser.logInWithUsername(inBackground: userNameText.text!, password: passwordText.text!) { (user, error) in
                    
                    if error != nil {
                        
                        let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                        let button = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                        alert.addAction(button)
                        self.present(alert, animated: true, completion: nil)
                        
                    } else {
                        
                        UserDefaults.standard.set(self.userNameText.text!, forKey: "userloggedin")
                        UserDefaults.standard.synchronize()
                        
                        
                        let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                        
                        delegate.rememberLogin()
                        
                        
                        
                    }
                    
                }
                
            }
        }
        
       
        
    }
    
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        
        let user = PFUser()
        user.username = userNameText.text
        user.password = passwordText.text
        
        user.signUpInBackground { (success, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let button = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(button)
                self.present(alert, animated: true, completion: nil)
            } else {
                
                UserDefaults.standard.set(self.userNameText.text!, forKey: "userloggedin")
                UserDefaults.standard.synchronize()
                
                
                let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                
                delegate.rememberLogin()
                
            }
        }
    
    }
    
    
}
