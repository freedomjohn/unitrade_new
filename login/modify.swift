//
//  modify.swift
//  UniTrade
//
//  Created by sheng zhang on 12/7/15.
//  Copyright © 2015 Sheng Zhang. All rights reserved.
//

import UIKit
import Parse

class modify: UIViewController{
   
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemPrice: UITextField!
    @IBOutlet weak var itemDescription: UITextField!
    @IBOutlet weak var myImgView: UIImageView!
    var postID  = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let query = PFQuery(className:"Post")
        query.getObjectInBackgroundWithId(postID) {
            (post: PFObject?, error: NSError?) -> Void in
            if error == nil && post != nil {
                self.itemName.text = post?.objectForKey("name") as? String
                //self.category.text = post?.objectForKey("category") as? String
                self.itemPrice.text = post?.objectForKey("price") as? String
                self.itemDescription.text = post?.objectForKey("description") as? String
                let newImage = post?.objectForKey("image") as! PFFile
                newImage.getDataInBackgroundWithBlock({
                    (imageData: NSData?, error: NSError?) -> Void in
                    if(error == nil){
                        let cimage = UIImage(data:imageData!)
                        self.myImgView.image = cimage
                    }
                })
            } else {
                print(error)
            }
        }

    }
    
    @IBAction func SaveChange(sender: AnyObject) {
        let query = PFQuery(className:"Post")
        query.getObjectInBackgroundWithId(postID) {
            (post: PFObject?, error: NSError?) -> Void in
            if error == nil && post != nil {
                let imageData = UIImageJPEGRepresentation(self.myImgView.image!, 0.01)
                let imageFile = PFFile(name:"image.jpeg", data:imageData!)
                post!["image"] = imageFile
                post!["name"] = self.itemName.text
                post!["price"] = self.itemPrice.text
                post!["description"] = self.itemDescription.text
                //post["category"] = selectCategory.text
                //post!["user"] = PFUser.currentUser()?.objectId
                post!.saveInBackgroundWithBlock{
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        self.tabBarController?.selectedIndex = 0 // open the first tab bar
                        //                    self.performSegueWithIdentifier("back", sender: nil)
                        
                        // moving back to root navigation controller
                        self.navigationController?.popViewControllerAnimated(true)
                        //                    self.navigationController?.popToRootViewControllerAnimated(true)
                        
                    }
                    
                }
            } else {
                print(error)
            }
        }

    }
    
    @IBAction func DeletePost(sender: AnyObject) {
        let query = PFQuery(className:"Post")
        query.getObjectInBackgroundWithId(postID) {
            (post: PFObject?, error: NSError?) -> Void in
            if error == nil && post != nil {
                post?.deleteInBackgroundWithBlock{
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        self.tabBarController?.selectedIndex = 0 // open the first tab bar
                        //                    self.performSegueWithIdentifier("back", sender: nil)
                    
                        // moving back to root navigation controller
                        self.navigationController?.popViewControllerAnimated(true)
                    //                    self.navigationController?.popToRootViewControllerAnimated(true)
                    }
                }
            } else {
                print(error)
            }
        }

    }
}