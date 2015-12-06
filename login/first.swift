//
//  first.swift
//  login
//
//  Created by Ellis on 11/12/15.
//  Copyright © 2015 Sheng Zhang. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class first: UIViewController, UITableViewDelegate, PFLogInViewControllerDelegate,PFSignUpViewControllerDelegate, UITableViewDataSource {
  
    // Parse setup
    var logInController = PFLogInViewController()
    var signUpViewController = PFSignUpViewController()
    
    // To show search bar on navigation bar
    lazy   var searchBars:UISearchBar = UISearchBar(frame: CGRectMake(30, 0, 250, 20))
    
    // Table View Setup
    @IBOutlet weak var tableView: UITableView!
    var dataArray: NSMutableArray! = NSMutableArray() // Array of data (each cell)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // To show search bar on navigation bar
        let leftNavBarButton = UIBarButtonItem(customView: searchBars)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        
        // Testing if it shows the items in table view
//        for (var i: Int = 0; i < 50; i++){
//            self.dataArray.addObject("Post")
//        }
//        self.tableView.reloadData()
//        
        // Hide the navigation bar on swipe
//        self.navigationController?.hidesBarsOnSwipe = true

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.limit = 50
        var postArray : [PFObject]
        
        do{
            postArray = try query.findObjects()
            let newPost = postArray[indexPath.row]
            let newImage = newPost.objectForKey("image") as! PFFile
            cell.textLabel?.text = newPost.objectForKey("name") as? String
            cell.detailTextLabel?.text = newPost.objectForKey("price") as? String
            newImage.getDataInBackgroundWithBlock({
                (imageData: NSData?, error: NSError?) -> Void in
                if(error == nil){
                    let cimage = UIImage(data:imageData!)
                    cell.imageView?.image = cimage

                }
            })
            
        }catch{
            print("error")
        }
        
        return cell
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var retVal = 0
        do {
        retVal = try PFQuery(className:"Post").findObjects().count
        } catch {
            print("error2")
        }
        return retVal // number of posts
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.logInController.fields = [PFLogInFields.UsernameAndPassword
            , PFLogInFields.LogInButton
            , PFLogInFields.SignUpButton
            , PFLogInFields.PasswordForgotten
            //, PFLogInFields.DismissButton
        ]
        let logInlogoTitle = UILabel()
        logInlogoTitle.text = "UniTrade"
        self.logInController.logInView?.logo = logInlogoTitle
        self.logInController.delegate = self
        
        let signUplogoTitle = UILabel()
        signUplogoTitle.text = "UniTrade"
        self.signUpViewController.signUpView?.logo = signUplogoTitle
        self.signUpViewController.delegate = self
        
        self.logInController.signUpController = self.signUpViewController
        
        if(PFUser.currentUser() == nil){
            self.presentViewController(self.logInController, animated:true, completion: nil)
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //log in
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        if(!username.isEmpty || !password.isEmpty){
            return true
        }else{
            return false
        }
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        //        let firstViewController:first = first()
        //        self.presentViewController(firstViewController, animated: true, completion: nil)
        
        
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        //Show the alert
        let alert = UIAlertView(title: "Fail to Login", message: nil, delegate: self, cancelButtonTitle: "OK")
        alert.show()
    }
    
    //sign up
    func signUpViewController(signUpController: PFSignUpViewController, shouldBeginSignUp info: [NSObject : AnyObject]) -> Bool {
        return true
    }
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        //Show the alert
        let alert = UIAlertView(title: "Fail to Signup", message: nil, delegate: self, cancelButtonTitle: "OK")
        alert.show()
    }
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        //Show the alert
        let alert = UIAlertView(title: "User Dismissed Signup", message: nil, delegate: self, cancelButtonTitle: "OK")
        alert.show()
    }
    @IBAction func act(sender: AnyObject) {
        self.presentViewController(self.logInController, animated:true, completion: nil)
        if(PFUser.currentUser() != nil){
            user.text = PFUser.currentUser()?.username // print the user name to label
        }
    }
    
    
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOut()
        if(PFUser.currentUser() == nil){
            user.text = "nobody"
        }
    }
    
    @IBOutlet weak var user: UILabel!
    
    
}
