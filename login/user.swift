//
//  user.swift
//  login
//
//  Created by Ellis on 11/12/15.
//  Copyright © 2015 Sheng Zhang. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class user: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var userID: UILabel!
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBAction func LogoutBtn(sender: AnyObject) {
        // Log out and show the main page
        PFUser.logOut()
        tabBarController?.selectedIndex = 0 // open the first tab bar
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        myCollectionView.reloadData()

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        userID.text = PFUser.currentUser()?.username
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var retVal = 0
        do {
            let query = PFQuery(className: "Post")
            query.whereKey("user", equalTo: (PFUser.currentUser()?.objectId)!)
            retVal = try query.findObjects().count
        } catch {
            print("error2")
        }
        return retVal // number of posts
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var postArray = [PFObject]()
        let cell: colvwCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! colvwCell
        let query = PFQuery(className: "Post")
        query.orderByAscending("createdAt")
        query.whereKey("user", equalTo: (PFUser.currentUser()?.objectId)!)
        // Do any additional setup after loading the view.
        do{
            postArray = try query.findObjects()
        }catch{
            print("error")
        }
        let newPost = postArray[indexPath.row]
        let newImage = newPost.objectForKey("image") as! PFFile
        
        do{
        let imageData = try newImage.getData()
        let finalizedImage = UIImage(data: imageData)
        cell.imgCell.image = finalizedImage
        }catch{
            print("error")
        }
        
        return cell
    }
    
}
