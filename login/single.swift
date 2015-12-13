//
//  single.swift
//  UniTrade
//
//  Created by sheng zhang on 12/6/15.
//  Copyright © 2015 Sheng Zhang. All rights reserved.
//

import UIKit
import Parse

import Foundation
import MessageUI

class single: UIViewController, MFMailComposeViewControllerDelegate{
    
    @IBOutlet weak var contactbtn: UIButton!
    
    @IBOutlet weak var currentImage: UIImageView!
    
    @IBOutlet weak var itemName: UILabel!
    
    //    @IBOutlet weak var category: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var itemDescription: UITextView!
    
    @IBOutlet weak var sellerName: UILabel!
    
    
    var objectId = String()
    var userEmail = String()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Undeitable
        itemDescription.layer.borderWidth = 0.75
        itemDescription.layer.borderColor = UIColor(red: 0.4, green: 0.8, blue: 1, alpha: 0.693607).CGColor
        itemDescription.layer.cornerRadius = 5
        itemDescription.editable = false
        contactbtn.layer.cornerRadius = 5
        // Show the navigation bar and lock it
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.hidesBarsOnSwipe = false
        
        //print(objectId)
        let query = PFQuery(className:"Post")
        query.getObjectInBackgroundWithId(objectId) {
            (post: PFObject?, error: NSError?) -> Void in
            var userID = String()
            if error == nil && post != nil {
                userID = (post?.objectForKey("user") as? String)!
                //print(userID)
                do{
                    let postUser :PFUser = try PFQuery.getUserObjectWithId(userID)
                    print(postUser)
                    self.sellerName.text = postUser.objectForKey("username") as? String
                    self.userEmail = postUser.objectForKey("email") as! String
                }catch{
                    print("error")
                }

                self.itemName.text = post?.objectForKey("name") as? String
                // Bold the item name
                self.itemName.font = UIFont.boldSystemFontOfSize(17.0)
                //                self.category.text = post?.objectForKey("category") as? String
                //Customize price label
                let itemprice = post?.objectForKey("price") as! Int
                let priceString = String(itemprice)
                self.price.text = "$\(priceString)"
                self.price.textColor = UIColor.orangeColor()
                self.price.font = UIFont(name: "HelveticaNeue", size: CGFloat(20))
                self.itemDescription.text = post?.objectForKey("description") as? String
                let newImage = post?.objectForKey("image") as! PFFile
                newImage.getDataInBackgroundWithBlock({
                    (imageData: NSData?, error: NSError?) -> Void in
                    if(error == nil){
                        let cimage = UIImage(data:imageData!)
                        self.currentImage.image = cimage
                        self.currentImage.clipsToBounds = true
                        self.currentImage.layer.cornerRadius = 15

                    }
                })
                
                
            } else {
                print(error)
            }
        }
        // Swipe function
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    
    // for email
    @IBAction func contactBtn(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        //print(userEmail)
        mailComposerVC.setToRecipients([userEmail])
        mailComposerVC.setSubject("Interest about \(itemName.text!)")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }

    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {

        controller.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    // swipe to pop
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {

            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                navigationController?.popViewControllerAnimated(true)
            default:
                break
            }
        }
    }

}
