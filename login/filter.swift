//
//  filter.swift
//  login
//
//  Created by Ellis on 11/13/15.
//  Copyright © 2015 Sheng Zhang. All rights reserved.
//

import UIKit

class ViewController: UITableViewController{
    
    var location = ["within 0.5 miles", "within 1 miles", "within 5 miles"]
    var category = ["Electronics", "Movies, Books and Music", "Fashion and Accessories"]
    var price = ["$0 - $10", "$10 - $50", "$50 - $100"]
    var path = NSIndexPath?()
    var path2 = NSIndexPath?()
    var path3 = NSIndexPath?()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return "location"
        }else if(section == 1){
            return "category"
        }
        return "price"
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return location.count
        }else if(section == 1){
            return category.count
        }
        return price.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("filter Cell", forIndexPath: indexPath)
        if(indexPath.section == 0){
            cell.textLabel?.text = location[indexPath.row]
        }else if(indexPath.section == 1){
            cell.textLabel?.text = category[indexPath.row]
        }else{
            cell.textLabel?.text = price[indexPath.row]
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if(indexPath.section == 0){
            if(path == nil){
                path = indexPath
            }else{
                let newCell = tableView.cellForRowAtIndexPath(path!)
                newCell?.accessoryType = UITableViewCellAccessoryType.None
                path = indexPath
            }
        }else if(indexPath.section == 1){
            if(path2 == nil){
                path2 = indexPath
            }else{
                let newCell = tableView.cellForRowAtIndexPath(path2!)
                newCell?.accessoryType = UITableViewCellAccessoryType.None
                path2 = indexPath
            }
        }else if(indexPath.section == 2){
            if(path3 == nil){
                path3 = indexPath
            }else{
                let newCell = tableView.cellForRowAtIndexPath(path3!)
                newCell?.accessoryType = UITableViewCellAccessoryType.None
                path3 = indexPath
            }
        }
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if(cell?.accessoryType == UITableViewCellAccessoryType.None){
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        }else if (cell?.accessoryType == UITableViewCellAccessoryType.Checkmark){
            cell?.accessoryType = UITableViewCellAccessoryType.None
        }
    }
}

