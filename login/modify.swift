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
}
