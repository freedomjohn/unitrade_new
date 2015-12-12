//
//  modify.swift
//  UniTrade
//
//  Created by sheng zhang on 12/7/15.
//  Copyright © 2015 Sheng Zhang. All rights reserved.
//

import UIKit
import Parse

class modify: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate{
   
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemPrice: UITextField!
    @IBOutlet weak var itemDescription: UITextField!
    @IBOutlet weak var myImgView: UIImageView!
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    
    
    var postID  = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Changing color of price field
        itemPrice.textColor = UIColor.orangeColor()
        itemName.font = UIFont.boldSystemFontOfSize(17.0) // bold item name
        
        
        
        imagePicker.delegate = self
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
    
    @IBAction func takePicture(sender: AnyObject) {
        let imageFromSource = UIImagePickerController()
        imageFromSource.delegate = self
        imageFromSource.allowsEditing = false
        //create alert controller
        let myAlert = UIAlertController(title: "take photo", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet )
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        myAlert.addAction(cancelAction)
        //Create and add first option action
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Take Picture using camera", style: .Default) { action -> Void in
            //Code for launching the camera
            if
                UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                    imageFromSource.sourceType = UIImagePickerControllerSourceType.Camera
            }
            else{
                imageFromSource.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            }
            self.presentViewController(imageFromSource, animated: true, completion: nil)
            
        }
        myAlert.addAction(takePictureAction)
        //Create and add a second option action
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Choose From Camera Roll", style: .Default) { action -> Void in
            //Code for picking from camera roll
            imageFromSource.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(imageFromSource, animated: true, completion: nil)
        }
        myAlert.addAction(choosePictureAction)
        
        //show the alert
        self.presentViewController(myAlert, animated: true, completion: nil)
        
        //imageFromSource.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let temp : UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        myImgView.image = temp
        self.dismissViewControllerAnimated( true , completion: {})
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
                        // moving back to root navigation controller
                        self.navigationController?.popToRootViewControllerAnimated(true)
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