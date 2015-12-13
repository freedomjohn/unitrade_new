//
//  post.swift
//  login
//
//  Created by Ellis on 11/12/15.
//  Copyright © 2015 Sheng Zhang. All rights reserved.
//

import UIKit
import Parse


class post: UIViewController ,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate    {
    
    // For category
    let imagecrop = ImageUtil()
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var selectCategory: UILabel!
    var category = ["Electronics","Cars and Motors", "Sports and Leisure",
        "Games and Consoles", "Movies, Books and Music", "Fashion and Accessories", "Other"]
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
        selectCategory.textColor = UIColor.whiteColor()
        picker.hidden = true
    }

    @IBAction func selectCategoryBtn(sender: AnyObject) {
        picker.hidden = false
    }
    
    var i = 0;
    var checkPhoto = false

    // var post = PFObject(className: "Post")
    
    @IBOutlet weak var ssss: UITextView!
    @IBOutlet weak var itemName: UITextField!
    
    @IBOutlet weak var Price: UITextField!
    
    @IBOutlet weak var currentImage: UIImageView!
    
    @IBOutlet weak var pictureBtn: UIButton!
    
    @IBOutlet weak var itemDescription: UITextView!
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // for description
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.whiteColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write a short description"
            textView.textColor = UIColor.lightGrayColor()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        // Edit item name first
//        itemName.becomeFirstResponder()
        
        // itemDescription place holder
        itemDescription.text = "Write a short description"
        itemDescription.textColor = UIColor.lightGrayColor()
        itemDescription.backgroundColor = UIColor.grayColor()
        itemDescription.delegate? = self
        
        
        //pictureBtn styling
        pictureBtn.layer.cornerRadius = 5
        print(pictureBtn.backgroundColor)
        //itemName
        itemName.backgroundColor = UIColor.grayColor()
        itemName.layer.borderColor = UIColor(red: 0.4, green: 0.8, blue: 1, alpha: 0.693607).CGColor
        itemName.layer.borderWidth = 0.75
        itemName.layer.cornerRadius = 5
        //Price styling
        Price.backgroundColor = UIColor.grayColor()
        Price.layer.borderColor = UIColor(red: 0.4, green: 0.8, blue: 1, alpha: 0.693607).CGColor
        Price.layer.borderWidth = 0.75
        Price.layer.cornerRadius = 5
        
        //itemDescription styling
        itemDescription.layer.borderWidth = 0.75
        itemDescription.layer.borderColor = UIColor(red: 0.4, green: 0.8, blue: 1, alpha: 0.693607).CGColor
        itemDescription.layer.cornerRadius = 5
        
        //for picker
        picker.delegate = self //category picker
        picker.dataSource = self
        picker.hidden = true
        
        picker.layer.cornerRadius = 15
        
        // Do any additional setup after loading the view.
        
        //for current image view
        currentImage.clipsToBounds = true
        currentImage.layer.cornerRadius = 15
        
        selectCategory.clipsToBounds = true
        selectCategory.backgroundColor = UIColor.grayColor()
        selectCategory.textColor = UIColor.whiteColor()
        selectCategory.layer.cornerRadius = 5
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var postBtn: UITabBarItem!
    
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
        
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let temp : UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let croppedImage: UIImage = imagecrop.cropToSquare(image: temp )
        currentImage.image = croppedImage
        currentImage.layer.cornerRadius = 15
        self.dismissViewControllerAnimated( true , completion: {})
    }
    
    
    @IBAction func addPost(sender: AnyObject) {
        //var post = PFObject(className: "Post")
        if (itemName.text == "" || Price.text == "" || itemDescription.text == "" || checkPhoto == false || selectCategory.text == "Select a category" || itemDescription.text == "Write a short description") {
            
            // Showing popup alert
            let myAlert = UIAlertController(title: "Please complete all of the required fields before continuing.", message: nil, preferredStyle: UIAlertControllerStyle.Alert )
            //add an "ok" button
            myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(myAlert, animated: true, completion: nil)
        }
            // Setting the price range
        else if (Int(Price.text!) < 0 || Int(Price.text!) > 100000){
            let myAlert = UIAlertController(title: "Price must be between $0 - $100,000", message: nil, preferredStyle: UIAlertControllerStyle.Alert )
            //add an "ok" button
            myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(myAlert, animated: true, completion: nil)
        }
            
        else {
            let post = PFObject(className: "Post")

            let imageData = UIImageJPEGRepresentation(currentImage.image!, 0.01)
            let imageFile = PFFile(name:"image.jpeg", data:imageData!)
            
            //let userPhoto = PFObject(className:"UserPhoto")
            //userPhoto["imageName"] = "\(i)"
            //userPhoto["imageFile"] = imageFile
            //userPhoto.saveInBackground()
            post["image"] = imageFile
            post["name"] = itemName.text
            post["price"] = Int(Price.text!)
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
            currentImage.image = UIImage(named: "no_image-512")
            self.checkPhoto = false
        }
        self.view.endEditing(true)
    }

        
        
}
