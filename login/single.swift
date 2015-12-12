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
    
    
    @IBOutlet weak var currentImage: UIImageView!
    
    @IBOutlet weak var itemName: UILabel!
    
    //    @IBOutlet weak var category: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var itemDescription: UITextView!
    
    @IBOutlet weak var sellerName: UILabel!
    
    
    var objectId = String()
//    var userID = String()

    override func viewDidDisappear(animated: Bool) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Undeitable
        itemDescription.editable = false
        
        // Show the navigation bar and lock it
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.hidesBarsOnSwipe = false
        
        //print(objectId)
        let query = PFQuery(className:"Post")
        query.getObjectInBackgroundWithId(objectId) {
            (post: PFObject?, error: NSError?) -> Void in
            if error == nil && post != nil {
//                self.userID = (post?.objectForKey("user") as? String)!
//                let queryforuser = PFQuery(className:"User")
//                queryforuser.getObjectInBackgroundWithId(self.userID) {
//                    (postuser: PFObject?, error: NSError?) -> Void in
//                    if error == nil && postuser != nil {
//                        self.sellerName.text = postuser?.objectForKey("username") as? String
//                        
//                    }
//                }
                
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
                    }
                })
                
                
            } else {
                print(error)
            }
            
//            // customize text
//            //itemName
//            self.itemName.font = UIFont.boldSystemFontOfSize(17.0) // bold item name
//            self.itemName.textColor = UIColor.whiteColor()
//            self.itemName.backgroundColor = UIColor.grayColor()
//            self.itemName.layer.borderColor = UIColor(red: 0.4, green: 0.8, blue: 1, alpha: 0.693607).CGColor
//            self.itemName.layer.borderWidth = 0.75
//            self.itemName.layer.cornerRadius = 5
//            //Price styling
//            self.price.textColor = UIColor.whiteColor()
//            self.price.backgroundColor = UIColor.grayColor()
//            self.price.layer.borderColor = UIColor(red: 0.4, green: 0.8, blue: 1, alpha: 0.693607).CGColor
//            self.price.layer.borderWidth = 0.75
//            self.price.layer.cornerRadius = 5
//            
//            // Description
//            self.itemDescription.textColor = UIColor.whiteColor()
//            self.itemDescription.backgroundColor = UIColor.grayColor()
//            self.itemDescription.layer.borderWidth = 0.75
//            self.itemDescription.layer.borderColor = UIColor(red: 0.4, green: 0.8, blue: 1, alpha: 0.693607).CGColor
//            self.itemDescription.layer.cornerRadius = 5
        }
        
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
        
        mailComposerVC.setToRecipients(["dbmin@hotmail.com"])
        mailComposerVC.setSubject("Interest abouot your product - UniTrade")
        mailComposerVC.setMessageBody("Sending e-mail from UniTrade", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }

    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch result {
        case MFMailComposeResultCancelled:
            print("cancelled mail")
        case MFMailComposeResultSent:
            print("mail sent")
        default:
            break
        }
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }

}
