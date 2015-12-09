//
//  post.swift
//  login
//
//  Created by Ellis on 11/12/15.
//  Copyright © 2015 Sheng Zhang. All rights reserved.
//

import UIKit
import Parse


class post: UIViewController ,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource    {
    
    // For category
    let imagecrop = ImageUtil()
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var selectCategory: UILabel!
    var category = ["Electronics", "Movies, Books and Music", "Fashion and Accessories"]
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return category[row]
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return category.count
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectCategory.text = category[row]
        selectCategory.textColor = UIColor.blackColor()
        picker.hidden = true
    }

    @IBAction func selectCategoryBtn(sender: AnyObject) {
        picker.hidden = false
    }
    
    var i = 0;
    var checkPhoto = false

    // var post = PFObject(className: "Post")
    
    @IBOutlet weak var itemName: UITextField!
    
    @IBOutlet weak var Price: UITextField!
    
    @IBOutlet weak var currentImage: UIImageView!
    
    @IBOutlet weak var itemDescription: UITextField!
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        //for picker
        picker.delegate = self //category picker
        picker.dataSource = self
        picker.hidden = true
        selectCategory.textColor = UIColor.lightGrayColor()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var postBtn: UITabBarItem!
    
    @IBAction func takePicture(sender: AnyObject) {
        var imageFromSource = UIImagePickerController()
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
            self.checkPhoto = true;
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
            self.checkPhoto = true
            imageFromSource.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(imageFromSource, animated: true, completion: nil)
        }
        myAlert.addAction(choosePictureAction)
        
        //show the alert
        self.presentViewController(myAlert, animated: true, completion: nil)
        
        //imageFromSource.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var temp : UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let croppedImage: UIImage = imagecrop.cropToSquare(image: temp )
        currentImage.image = croppedImage
        self.dismissViewControllerAnimated( true , completion: {})
    }
    
    
    @IBAction func addPost(sender: AnyObject) {
        //var post = PFObject(className: "Post")
        if (itemName.text == "" || Price.text == "" || itemDescription.text == "" || checkPhoto == false || selectCategory.text == "Select a category") {
            
            // Showing popup alert
            let myAlert = UIAlertController(title: "Please complete all of the required fields before continuing.", message: nil, preferredStyle: UIAlertControllerStyle.Alert )
            //add an "ok" button
            myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(myAlert, animated: true, completion: nil)
        }
        else {
            var post = PFObject(className: "Post")

            let imageData = UIImageJPEGRepresentation(currentImage.image!, 0.01)
            let imageFile = PFFile(name:"image.jpeg", data:imageData!)
            
            var userPhoto = PFObject(className:"UserPhoto")
            userPhoto["imageName"] = "\(i)"
            userPhoto["imageFile"] = imageFile
            userPhoto.saveInBackground()
            post["image"] = imageFile
            post["name"] = itemName.text
            post["price"] = Price.text
            post["description"] = itemDescription.text
            post["category"] = selectCategory.text
            post["user"] = PFUser.currentUser()?.objectId
            itemName.text = nil
            Price.text = nil
            itemDescription.text = nil
            selectCategory.text = "Select a category"
            selectCategory.textColor = UIColor.lightGrayColor()
            post.saveInBackgroundWithBlock{
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    self.tabBarController?.selectedIndex = 0 // open the first tab bar
                    //                    self.performSegueWithIdentifier("back", sender: nil)
                    
                    // moving back to root navigation controller
//                    self.navigationController?.popViewControllerAnimated(true)
//                    self.navigationController?.popToRootViewControllerAnimated(true)
                    
                }
                
            }
            currentImage.image = nil
            self.checkPhoto = false
        }
        self.view.endEditing(true)
    }

        
        
}
