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

class user: UIViewController{
    
    @IBAction func LogoutBtn(sender: AnyObject) {
        // Log out and show the main page
        PFUser.logOut()
        tabBarController?.selectedIndex = 0 // open the first tab bar
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
