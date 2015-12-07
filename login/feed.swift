//
//  feed.swift
//  UniTrade
//
//  Created by Ellis on 11/24/15.
//  Copyright © 2015 Sheng Zhang. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Bolts

class feed: UITableViewController,PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate {

    // Parse setup
    var logInController = PFLogInViewController()
    var signUpViewController = PFSignUpViewController()
    var passArray = [PFObject]()
    
    // To show search bar on navigation bar
//    lazy   var searchBar:UISearchBar = UISearchBar(frame: CGRectMake(30, 0, 250, 20))

    // Table View Setup
//    @IBOutlet weak var tableView: UITableView!
//    var dataArray: NSMutableArray! = NSMutableArray() // Array of data (each cell)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // To show search bar on navigation bar
//        searchBar.placeholder = "Search UniTrade"
//        let leftNavBarButton = UIBarButtonItem(customView: searchBar)
//        self.navigationItem.leftBarButtonItem = leftNavBarButton
//        self.tableView.reloadData()
        
        //
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var retVal = 0
        do {
            retVal = try PFQuery(className:"Post").findObjects().count
        } catch {
            print("error2")
        }
        return retVal // number of posts
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("postcell", forIndexPath: indexPath) as! postTableViewCell
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.limit = 50
        var postArray : [PFObject]
        do {
            postArray = try query.findObjects()
            passArray = postArray
            let newPost = postArray[indexPath.row]
            let newImage = newPost.objectForKey("image") as! PFFile
            cell.titlename.text = newPost.objectForKey("name")?.capitalizedString
            cell.des.text = "$\(newPost.objectForKey("price")!)"
            var imageData = try newImage.getData()
            var finalizedImage = UIImage(data: imageData)
            cell.imagedis.image = finalizedImage
            
            /*
            newImage.getDataInBackgroundWithBlock({
                (imageData: NSData?, error: NSError?) -> Void in
                if(error == nil){
                    let cimage = UIImage(data: imageData!)
                    cell.imagedis.image = cimage
                   // cell.imageView!.contentMode = UIViewContentMode.ScaleAspectFit

                }
            })

            var imageToLoad = self.images[indexPath.row] as PFFile
            var imageCaption = self.imageCaptions[indexPath.row] as String
            var imageDate = self.imageDates[indexPath.row] as String
            var imageUser = self.imageUsers[indexPath.row] as String
            
            var imageData = imageToLoad.getData()
            var finalizedImage = UIImage(data: imageData!)
            cell.postImageView.image = finalizedImage
            cell.postCaption.text = imageCaption
            cell.addedBy.text = imageUser
            cell.dateLabel.text = imageDate
*/
            
            
        }catch{
            print("error")
        }
        return cell
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        
        var indexPath : NSIndexPath = self.tableView.indexPathForSelectedRow!
        
        var DestViewController = segue.destinationViewController as! single
        
        var pass = passArray[indexPath.row]
        
        DestViewController.objectId = pass.objectId!
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}