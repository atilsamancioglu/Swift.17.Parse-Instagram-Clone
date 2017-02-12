//
//  feedCell.swift
//  Parse Instagram Clone
//
//  Created by Atıl Samancıoğlu on 06/02/2017.
//  Copyright © 2017 Atıl Samancıoğlu. All rights reserved.
//

import UIKit
import Parse
import OneSignal

class feedCell: UITableViewCell {

    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var postComment: UITextView!
    
    @IBOutlet weak var postUuidLabel: UILabel!
    
    var playerIDArray = [String]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        
        let likeObject = PFObject(className: "Likes")
        likeObject["from"] = PFUser.current()!.username!
        likeObject["to"] = postUuidLabel.text
        
        likeObject.saveInBackground { (success, error) in
            if error != nil {
               
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let button = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(button)
                
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                
            } else {
                
                let query = PFQuery(className: "_User")
                query.whereKey("username", equalTo: self.usernameLabel.text!)
                query.findObjectsInBackground(block: { (objects, error) in
                    if error != nil {
                        
                    } else {
                        
                        self.playerIDArray.removeAll(keepingCapacity: false)
                        
                        for object in objects! {
                            
                            self.playerIDArray.append(object.object(forKey: "playerID") as! String)
                            
                            OneSignal.postNotification(["contents" : ["en" : "\(PFUser.current()!.username!) has liked your post!"], "include_player_ids" : ["\(self.playerIDArray.last!)"], "ios_badgeType" : "Increase", "ios_badgeCount" : "1"])
                        }
                    }
                })
               
            }
        }
        
        
        
    }
    
    
    @IBAction func commentButtonClicked(_ sender: Any) {
        
        let commentObject = PFObject(className: "Comments")
        commentObject["from"] = PFUser.current()!.username!
        commentObject["to"] = postUuidLabel.text
        
        commentObject.saveInBackground { (success, error) in
            if error != nil {
                
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let button = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(button)
                
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                
            } else {
                
                let query = PFQuery(className: "_User")
                query.whereKey("username", equalTo: self.usernameLabel.text!)
                query.findObjectsInBackground(block: { (objects, error) in
                    if error != nil {
                        
                    } else {
                        
                        self.playerIDArray.removeAll(keepingCapacity: false)
                        
                        for object in objects! {
                            
                            self.playerIDArray.append(object.object(forKey: "playerID") as! String)
                            
                            OneSignal.postNotification(["contents" : ["en" : "\(PFUser.current()!.username!) has commented on your post!"], "include_player_ids" : ["\(self.playerIDArray.last!)"], "ios_badgeType"  : "Increase", "ios_badgeCount" : "1"])
                        }
                    }
                })
                

                
            }
        }
        

        
    }
    

}
