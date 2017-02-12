//
//  FirstViewController.swift
//  Parse Instagram Clone
//
//  Created by Atıl Samancıoğlu on 06/02/2017.
//  Copyright © 2017 Atıl Samancıoğlu. All rights reserved.
//

import UIKit
import Parse
import OneSignal

class feedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var postOwnerArray = [String]()
    var postCommentArray = [String]()
    var postUuidArray = [String]()
    var postImageArray = [PFFile]()
    
    var playerID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        getDataFromServer()
        
        OneSignal.idsAvailable { (userID, pushToken) in
            if userID != nil {
                self.playerID = userID!
            }
        }
        
        let user = PFUser.current()
        user?["playerID"] = self.playerID
        user?.saveEventually()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(feedVC.getDataFromServer), name: NSNotification.Name(rawValue: "newUpload"), object: nil)
        
    }
    
    func getDataFromServer() {
        
        let query = PFQuery(className: "Posts")
        query.addDescendingOrder("createdAt")
        
        query.findObjectsInBackground { (objects, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let button = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(button)
                self.present(alert, animated: true, completion: nil)
            } else {
                
                self.postUuidArray.removeAll(keepingCapacity: false)
                self.postOwnerArray.removeAll(keepingCapacity: false)
                self.postCommentArray.removeAll(keepingCapacity: false)
                self.postImageArray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    
                    self.postOwnerArray.append(object.object(forKey: "postowner") as! String)
                    self.postCommentArray.append(object.object(forKey: "postcomment") as! String)
                    self.postUuidArray.append(object.object(forKey: "postuuid") as! String)
                    self.postImageArray.append(object.object(forKey: "postimage") as! PFFile)
                    
                }
                
            }
            self.tableView.reloadData()
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postOwnerArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! feedCell
        
        cell.postUuidLabel.isHidden = true
        cell.usernameLabel.text = postOwnerArray[indexPath.row]
        cell.postComment.text = postCommentArray[indexPath.row]
        cell.postUuidLabel.text = postUuidArray[indexPath.row]
        
        postImageArray[indexPath.row].getDataInBackground { (data, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let button = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(button)
                self.present(alert, animated: true, completion: nil)
            } else {
                cell.postImage.image = UIImage(data: data!)
            }
        }
        
        return cell
    }
   
    @IBAction func logoutButtonClicked(_ sender: Any) {
        
        PFUser.logOutInBackground { (error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let button = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(button)
                self.present(alert, animated: true, completion: nil)
            } else {
                
                UserDefaults.standard.removeObject(forKey: "userloggedin")
                UserDefaults.standard.synchronize()
                
                let signUp = self.storyboard?.instantiateViewController(withIdentifier: "signUpVC") as! signUpVC
                
                let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                delegate.window?.rootViewController = signUp
                
                delegate.rememberLogin()
                
            }
        }
        
        
    }
    


}

