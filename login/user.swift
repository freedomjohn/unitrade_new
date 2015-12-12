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

class user: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    let imagecrop = ImageUtil()
    var passArray = [PFObject]()
    var images = [PFFile]()
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    
    @IBOutlet weak var userface: UIImageView!
    @IBOutlet weak var userID: UILabel!
    @IBOutlet weak var numPosts: UILabel!
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBAction func LogoutBtn(sender: AnyObject) {
        // Log out and show the main page
        PFUser.logOut()
        tabBarController?.selectedIndex = 0 // open the first tab bar
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        userID.text = PFUser.currentUser()?.username
        loadData()
        var numPost = 0
        do {
            let query = PFQuery(className: "Post")
            query.whereKey("user", equalTo: (PFUser.currentUser()?.objectId)!)
            numPost = try query.findObjects().count
        } catch {
            print("error3")
        }
        numPosts.text = String(numPost)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        userface.clipsToBounds = true
        userface.layer.cornerRadius = 80
        
        do {
            let query = PFQuery(className: "Post")
            query.whereKey("user", equalTo: (PFUser.currentUser()?.objectId)!)
        } catch {
            print("error3")
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData(){
        self.images = [PFFile]()
        
        var postArray = [PFObject]()
        let query = PFQuery(className: "Post")
        query.orderByAscending("createdAt")
        query.whereKey("user", equalTo: (PFUser.currentUser()?.objectId)!)
        // Do any additional setup after loading the view.
        do{
            postArray = try query.findObjects()
            passArray = postArray
            for post in postArray{
                self.images.append(post["image"] as! PFFile)
            }
        }catch{
            print("error")
        }
        self.myCollectionView.reloadData()
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
        
        let cell: colvwCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! colvwCell
        
        let newImage = self.images[indexPath.row] as PFFile
        do{
        let imageData = try newImage.getData()
        let finalizedImage = UIImage(data: imageData)
        cell.imgCell.image = finalizedImage
        cell.imgCell.clipsToBounds = true
        cell.imgCell.layer.cornerRadius = 15

        }catch{
            print("error")
        }
        
        return cell
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
        
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let temp : UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let croppedImage: UIImage = imagecrop.cropToSquare(image: temp )
        userface.image = croppedImage
        userface.clipsToBounds = true
        userface.layer.cornerRadius = 100
        self.dismissViewControllerAnimated( true , completion: {})
        
    }

    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var indexPaths = self.myCollectionView.indexPathsForSelectedItems()
        let indexPath = indexPaths![0] as NSIndexPath
        let DestViewController = segue.destinationViewController as! modify
        let pass = passArray[indexPath.row]
        DestViewController.postID = pass.objectId!
        
        
    }
    
    
}
