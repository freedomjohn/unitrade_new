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
    @IBOutlet var mytableview: UITableView!
    var logInController = PFLogInViewController()
    var signUpViewController = PFSignUpViewController()
    var passArray = [PFObject]()
    var filterPrice = String()
    var filterCate = String()
    var low = Int()
    var high = Int()
    
    var images = [PFFile]()
    var imageCaptions = [String]()
    var imagePrice = [String]()
    var userimages = [PFFile]()
    var check = 0
    // To show search bar on navigation bar
//    lazy   var searchBar:UISearchBar = UISearchBar(frame: CGRectMake(30, 0, 250, 20))

    // Table View Setup
//    @IBOutlet weak var tableView: UITableView!
//    var dataArray: NSMutableArray! = NSMutableArray() // Array of data (each cell)
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        /*if(PFUser.currentUser() != nil){
        let userface = UIImageView(image: UIImage(named: "androidlogo.jpg"))
        let imageData = UIImageJPEGRepresentation(userface.image!, 0.01)
        let imageFile = PFFile(name:"image.jpeg", data:imageData!)

        var currentuser = PFUser.currentUser()
        //currentuser!["portrait"] = imageFile
        var userID = currentuser!.objectId
        //print(userID)
        do{
            let postUser :PFUser = try PFQuery.getUserObjectWithId(userID)
            print(postUser)
            //self.sellerName.text = postUser.objectForKey("username") as? String
            //self.userEmail = postUser.objectForKey("email") as! String
        }catch{
            
            print("error")
        }
*/
        if (check == 0) {
            loadData()
            check = 1
        }
    }
    
    
     override func viewDidLoad() {
     
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
    
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        // Simply adding an object to the data source for this example
        loadData()
        refreshControl.endRefreshing()
    }
    
    
    func loadData() {
        self.images = [PFFile]()
        self.imageCaptions = [String]()
        self.imagePrice = [String]()
        self.userimages = [PFFile]()
        
        if(filterPrice == "$0 - $10"){
            low = 0
            high = 10
        }else if(filterPrice == "$10 - $50"){
            low = 10
            high = 50
        }else if(filterPrice == "$50 - $100"){
            low = 50
            high = 100
        }else if(filterPrice == "$100 and higher"){
            low = 100
            high = 100000
        }
        
        
        let query = PFQuery(className: "Post")
        
        if(filterCate != ""){
            query.whereKey("category", equalTo: filterCate)
        }
        if(filterPrice != ""){
            query.whereKey("price", greaterThanOrEqualTo: low)
            query.whereKey("price", lessThanOrEqualTo: high)
        }
        
        query.orderByDescending("createdAt")
        query.limit = 50
        var postArray : [PFObject]
        do {
            postArray = try query.findObjects()
            passArray = postArray
            for post in postArray {
                self.images.append(post["image"] as! PFFile)
                self.imageCaptions.append(post["name"] as! String)
                self.imagePrice.append(String(post["price"]))
                let userID = post["user"] as! String
                let postUser: PFUser = try PFQuery.getUserObjectWithId(userID)
                self.userimages.append(postUser.objectForKey("portrait") as! PFFile)
            }
        }
        catch {
            print("error")
        }
        self.tableView.reloadData()
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
            let query = PFQuery(className: "Post")
            
            if(filterCate != ""){
                query.whereKey("category", equalTo: filterCate)
            }
            if(filterPrice != ""){
                query.whereKey("price", greaterThanOrEqualTo: low)
                query.whereKey("price", lessThanOrEqualTo: high)
            }
            retVal = try query.findObjects().count
        } catch {
            print("error2")
        }
        return retVal // loading number of posts
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("postcell", forIndexPath: indexPath) as! postTableViewCell
        
        let imageToLoad = self.images[indexPath.row] as PFFile
        let imageCaption = self.imageCaptions[indexPath.row] as String
        let imagePrice = self.imagePrice[indexPath.row] as String
        let userImageToLoad = self.userimages[indexPath.row] as PFFile
        do {
        let imageData = try imageToLoad.getData()
        let userImageData = try userImageToLoad.getData()
        let finalizedImage = UIImage(data: imageData)
        let userfinalizedImage = UIImage(data: userImageData)
        
        
            cell.titlename.text = imageCaption.capitalizedString
            // Bold the title name
            cell.titlename.font = UIFont.boldSystemFontOfSize(17.0)
            
            if(Int(imagePrice) == 0){
                cell.des.text = "Free!"
            }
            else{
             cell.des.text = "$\(imagePrice)"
            }
            cell.des.textColor = UIColor(red:1.00, green:0.39, blue:0.41, alpha:1.0)
            cell.imagedis.image = finalizedImage
            cell.userIMG.clipsToBounds = true
            cell.userIMG.layer.cornerRadius = 37
            cell.userIMG.image = userfinalizedImage

        }
        catch {
            print("error")
        }
    
    
        return cell
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
        logInlogoTitle.font = UIFont(name: (logInlogoTitle.font?.fontName)!, size: 45)
        self.logInController.logInView?.logo = logInlogoTitle
        self.logInController.delegate = self
        let logoView = UIImageView(image: UIImage(named: "IMG_4107.jpg"))
        let logoView2 = UIImageView(image: UIImage(named: "IMG_4107.jpg"))
        self.logInController.logInView?.addSubview(logoView)
        self.logInController.logInView?.sendSubviewToBack(logoView)
        
        let signUplogoTitle = UILabel()
        signUplogoTitle.text = "UniTrade"
        signUplogoTitle.font = UIFont(name: (signUplogoTitle.font?.fontName)!, size: 45)
        self.signUpViewController.signUpView?.logo = signUplogoTitle
        self.signUpViewController.delegate = self
        self.signUpViewController.signUpView?.addSubview(logoView2)
        self.signUpViewController.signUpView?.sendSubviewToBack(logoView2)
        self.logInController.signUpController = self.signUpViewController
        
        if(PFUser.currentUser() == nil){
            self.presentViewController(self.logInController, animated:true, completion: nil)
        }
        
        // hide navigation bar on scroll
        navigationController?.hidesBarsOnSwipe = true
        
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
        
            let userface = UIImageView(image: UIImage(named: "user icon.png"))
            let imageData = UIImageJPEGRepresentation(userface.image!, 0.01)
            let imageFile = PFFile(name:"image.jpeg", data:imageData!)
            var currentuser = PFUser.currentUser()
            currentuser!["portrait"] = imageFile
            currentuser!.saveInBackground()
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
        if(segue.identifier == "decell"){
        let indexPath : NSIndexPath = self.tableView.indexPathForSelectedRow!
        
        let DestViewController = segue.destinationViewController as! single
        
        let pass = passArray[indexPath.row]
        
        DestViewController.objectId = pass.objectId!
        }
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