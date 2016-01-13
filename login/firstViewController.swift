//
//  firstViewController.swift
//  UniTrade
//
//  Created by  John Cui on 1/12/16.
//  Copyright © 2016 Sheng Zhang. All rights reserved.
//

import UIKit

class firstViewController: UIViewController {

    @IBOutlet var selfview: UIView!
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    //let tabbarsize: CGRect = UIScreen.mainScreen().
   // @IBOutlet weak var first: UIButton!
   // func tabBarView
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        var second = UIButton()
        var first = UIButton()
        var third = UIButton()
        var fourth = UIButton()
        var fifth = UIButton()
        var sixth = UIButton()
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        first.frame = CGRectMake(0, 0, screenWidth / 2  , screenHeight / 3)
        first.setTitle("second hand", forState: UIControlState.Normal)
        first.addTarget(self, action: "clickMe:", forControlEvents: UIControlEvents.TouchUpInside)
        second.frame = CGRectMake(screenWidth / 2, 0, screenWidth / 2 ,screenHeight / 3)
        second.setTitle("party", forState: UIControlState.Normal)
        second.addTarget(self, action: "clickMe:", forControlEvents: UIControlEvents.TouchUpInside)
        third.frame = CGRectMake(0, screenHeight / 3 , screenWidth / 2 ,screenHeight / 3)
        third.setTitle("study group", forState: UIControlState.Normal)
        fourth.frame = CGRectMake(screenWidth / 2 ,screenHeight / 3 , screenWidth / 2 ,screenHeight / 3)
        fourth.setTitle("ride share", forState: UIControlState.Normal)
        fifth.frame = CGRectMake(0, 2 * screenHeight / 3 ,  screenWidth / 2 ,screenHeight / 3)
        fifth.setTitle("ticket exchange", forState: UIControlState.Normal)
        sixth.frame = CGRectMake(screenWidth / 2, 2 * screenHeight / 3,  screenWidth / 2 ,screenHeight / 3)
        first.backgroundColor = UIColor(red: 73/255,green: 123/255,blue: 132/255, alpha: 1)
        self.view.addSubview(first)
        second.backgroundColor = UIColor(red: 73/255,green: 111/255,blue: 132/255, alpha: 1)
        self.view.addSubview(second)
        third.backgroundColor = UIColor(red: 73/255,green: 133/255,blue: 132/255, alpha: 1)
        self.view.addSubview(third)
        fourth.backgroundColor = UIColor(red: 73/255,green: 123/255,blue: 132/255, alpha: 1)
        self.view.addSubview(fourth)
        fifth.backgroundColor = UIColor(red: 73/255,green: 116/255,blue: 132/255, alpha: 1)
        self.view.addSubview(fifth)
        sixth.backgroundColor = UIColor(red: 78/255,green: 130/255,blue: 135/255, alpha: 1)
        self.view.addSubview(sixth)
        // Do any additional setup after loading the view.
    }
    
    
    func clickMe(sender: UIButton) {
        self.navigationController?.navigationBarHidden = false
        performSegueWithIdentifier("moveToMain", sender: sender)
        print("Button Clicked")
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
